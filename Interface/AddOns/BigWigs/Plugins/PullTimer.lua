assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsPullTimer")
local timeToPlayOne --time for scheduling 1sec sound
local timetoPlayTwo --time for scheduling 2sec sound
local timeToPlayThree --time for scheduling 3sec sound
local timeToPlayFour --time for scheduling 4sec sound
local timeToPlayFive --time for scheduling 5sec sound
local timerDuration --duration of pull timer
local timerOffset --offset for sounds to line them up better in-game
local started

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Pull Timer"] = true,
	
	["pulltimer"] = true,
	["Options for Pull Timer"] = true,
	
	--moved the option to enable/disable countdown voice into the Sound plugin
	--["countdownvoice"] = true,
	--["Countdown Voice"] = true,
	--["Play a sound file when counting down."] = true,
	
	pullstart_message = "Pull in ",
	pull1_message = "Pull in 1",
	pull2_message = "Pull in 2",
	pull3_message = "Pull in 3",
	pull4_message = "Pull in 4",
	pull5_message = "Pull in 5",
	pull0_message = "Pull!",
	
	pull_bar = "Pull",
	slashpull_cmd = "/bwpt",
	slashpull2_cmd = "duration",
	slashpull2_desc = "Pull timer duration",
	["<duration>"] = true,
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsPullTimer = BigWigs:NewModule(L["Pull Timer"], "AceConsole-2.0")
BigWigsPullTimer.defaultDB = {
	--moved the option to enable/disable countdown voice into the Sound plugin
	--countdownvoice = true,
}

BigWigsPullTimer.consoleCmd = L["pulltimer"]
BigWigsPullTimer.consoleOptions = {
	type = "group",
	name = L["Pull Timer"],
	desc = L["Options for Pull Timer"],
	args = {
		--moved the option to enable/disable countdown voice into the Sound plugin
		--[L["countdownvoice"]] = {
		--[[	type = "toggle",
			name = L["Countdown Voice"],
			desc = L["Play a sound file when counting down."],
			get = function() return BigWigsPullTimer.db.profile.countdownvoice end,
			set = function(v) BigWigsPullTimer.db.profile.countdownvoice = v end,
		},
		--]]
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsPullTimer:OnRegister()
	self:RegisterChatCommand({ L["slashpull_cmd"] }, {
		type = "group",
		args = {
			pull = {
				type = "text", name = L["slashpull2_cmd"],
				desc = L["slashpull2_desc"],
				set = function(v) self:BigWigs_PullCommand(v) end,
				get = false,
				usage = L["<duration>"],
			},
		},
	})
end

function BigWigsPullTimer:OnEnable()
	self:RegisterEvent("BigWigs_PullTimer")
	self:RegisterEvent("BigWigs_PullCommand")
	self:RegisterEvent("BigWigs_RecvSync")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:TriggerEvent("BigWigs_ThrottleSync", "PullTimerSync", 0.5)
	self:TriggerEvent("BigWigs_ThrottleSync", "PullTimerCombatSync", 5)
	
	started = nil
	
	timeToPlayOne = 0
	timetoPlayTwo = 0
	timeToPlayThree = 0
	timeToPlayFour = 0
	timeToPlayFive = 0
	timerOffset = 0.1
	timerDuration = 0
end

function BigWigsPullTimer:BigWigs_RecvSync(sync, duration, nick)
	--we want to cancel all ongoing pulltimer related things (timer, countdown voice, countdown messages) when we enter combat
	if sync == "PullTimerCombatSync" and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe") --moved this event here so pulltimer won't reset if a warrior drops combat due to bloodrage during an ongoing pulltimer
		self:BigWigs_StopPullTimer()
	end
	if sync == "PullTimerSync" then
		self:BigWigs_PullTimer(duration)
	end
	if sync == "PullTimerStopSync" then
		self:BigWigs_StopPullTimer()
	end
end

function BigWigsPullTimer:PLAYER_REGEN_DISABLED()
	if UnitExists("target") and UnitAffectingCombat("target") and (UnitLevel("target") == -1 or UnitLevel("target") == 62) then
		self:TriggerEvent("BigWigs_SendSync", "PullTimerCombatSync")
	end
end

function BigWigsPullTimer:BigWigs_PullCommand(msg)
	if (IsRaidLeader() or IsRaidOfficer()) then
		if tonumber(msg) then
			timerDuration = tonumber(msg)
		else
			self:TriggerEvent("BigWigs_SendSync", "PullTimerStopSync")
			return
		end
		if  timerDuration == 0 then
			self:TriggerEvent("BigWigs_SendSync", "PullTimerStopSync")
			return
		elseif ((timerDuration > 63) or (timerDuration < 1))  then
			return
		end
		self:TriggerEvent("BigWigs_SendSync", "BWCustomBar "..timerDuration.." ".."bwPullTimer")	--[[This triggers a pull timer for older versions of bigwigs.
																										Modified CustomBar.lua RecvSync to ignore sync calls with "bwPullTimer" string in them.
																									--]]
		self:TriggerEvent("BigWigs_SendSync", "PullTimerSync "..timerDuration)
	end
end

function BigWigsPullTimer:BigWigs_StopPullTimer()
	self:TriggerEvent("BigWigs_StopBar", self, L["pull_bar"])
	self:CancelScheduledEvent("bwpulltimerplayone")
	self:CancelScheduledEvent("bwpulltimerplaytwo")
	self:CancelScheduledEvent("bwpulltimerplaythree")
	self:CancelScheduledEvent("bwpulltimerplayfour")
	self:CancelScheduledEvent("bwpulltimerplayfive")
	self:CancelScheduledEvent("bwpulltimermessageone")
	self:CancelScheduledEvent("bwpulltimermessagetwo")
	self:CancelScheduledEvent("bwpulltimermessagethree")
	self:CancelScheduledEvent("bwpulltimermessagefour")
	self:CancelScheduledEvent("bwpulltimermessagefive")
	self:CancelScheduledEvent("bwpulltimermessagezero")
end

function BigWigsPullTimer:BigWigs_PullTimer(duration)
	--cancel events from an ongoing pull timer in case a new one is initiated
	self:BigWigs_StopPullTimer()
	
	if tonumber(duration) then
		timerDuration = tonumber(duration)
	else
		return
	end
	
	timeToPlayOne = timerDuration - 1 - timerOffset
	timeToPlayTwo = timerDuration - 2 - timerOffset
	timeToPlayThree = timerDuration - 3 - timerOffset
	timeToPlayFour = timerDuration - 4 - timerOffset
	timeToPlayFive = timerDuration - 5 - timerOffset
	
	self:TriggerEvent("BigWigs_Message", L["pullstart_message"]..timerDuration, "Attention", true, false)
	self:TriggerEvent("BigWigs_StartBar", self, L["pull_bar"], timerDuration, "Interface\\Icons\\RACIAL_ORC_BERSERKERSTRENGTH")
	self:ScheduleEvent("bwpulltimerplayone", "BigWigs_Sound", timeToPlayOne, "OneCorsica")
	self:ScheduleEvent("bwpulltimermessageone", "BigWigs_Message", timeToPlayOne, L["pull1_message"], "Attention", true, false)
	self:ScheduleEvent("bwpulltimermessagezero", "BigWigs_Message", timerDuration, L["pull0_message"], "Attention", true, false)
	if not (timerDuration < 2.2) then
		self:ScheduleEvent("bwpulltimerplaytwo", "BigWigs_Sound", timeToPlayTwo, "TwoCorsica")
		self:ScheduleEvent("bwpulltimermessagetwo", "BigWigs_Message", timeToPlayTwo, L["pull2_message"], "Attention", true, false)
	end
	if not (timerDuration < 3.2) then
		self:ScheduleEvent("bwpulltimerplaythree", "BigWigs_Sound", timeToPlayThree, "ThreeCorsica")
		self:ScheduleEvent("bwpulltimermessagethree", "BigWigs_Message", timeToPlayThree, L["pull3_message"], "Attention", true, false)
	end
	if not (timerDuration < 4.2) then
		self:ScheduleEvent("bwpulltimerplayfour", "BigWigs_Sound", timeToPlayFour, "FourCorsica")
		self:ScheduleEvent("bwpulltimermessagefour", "BigWigs_Message", timeToPlayFour, L["pull4_message"], "Attention", true, false)
	end
	if not (timerDuration < 5.2) then
		self:ScheduleEvent("bwpulltimerplayfive", "BigWigs_Sound", timeToPlayFive, "FiveCorsica")
		self:ScheduleEvent("bwpulltimermessagefive", "BigWigs_Message", timeToPlayFive, L["pull5_message"], "Attention", true, false)
	end
end

