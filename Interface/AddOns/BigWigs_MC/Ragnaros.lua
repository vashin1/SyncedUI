-- edited by Masil for Kronos II
-- version 2

------------------------------
--      Event Handlers      --
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Ragnaros"]
local domo = AceLibrary("Babble-Boss-2.2")["Majordomo Executus"]

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	start1_trigger = "^Impudent whelps",	-- 81s
	start2_trigger = "^TOO SOON",			-- 51s
	knockback_trigger = "^TASTE",
	submerge_trigger = "^COME FORTH,",
	emerge_trigger = "Ragnaros begins to cast Ragnaros Emerge\.",	-- CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF

	knockback_msg = "Knockback!",
	knockback_warn = "Knockback in 5 sec!",
	submerge_msg = "Ragnaros submerged! Incoming Sons of Flame!",
	emerge_warn = "15 sec until Ragnaros emerges!",
	emerge_msg = "Ragnaros emerged, 3 minutes until submerge!",
	submerge_warn = "Submerge in %s sec!",

	start_bar = "Start",
	knockback_bar = "Next Knockback",
	emerge_bar = "Emerge",
	submerge_bar = "Submerge",

	sonofflame_name = "Son of Flame",
	sonsdead_msg = "%d/8 Sons of Flame dead!",

	cmd = "Ragnaros",
	
	start_cmd = "start",
	start_name = "Start",
	start_desc = "Starts a bar for estimating the beginning of the fight.",

	emerge_cmd = "emerge",
	emerge_name = "Emerge alert",
	emerge_desc = "Warn for Ragnaros Emerge",

	adds_cmd = "adds",
	adds_name = "Son of Flame dies",
	adds_desc = "Warn when a son dies",

	submerge_cmd = "submerge",
	submerge_name = "Submerge alert",
	submerge_desc = "Warn for Ragnaros Submerge",

	aoeknock_cmd = "aoeknock",
	aoeknock_name = "Knockback alert",
	aoeknock_desc = "Warn for Wrath of Ragnaros knockback",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRagnaros = BigWigs:NewModule(boss)
BigWigsRagnaros.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsRagnaros.enabletrigger = { boss, domo }
BigWigsRagnaros.wipemobs = { L["sonofflame_name"] }
BigWigsRagnaros.toggleoptions = { "start", "aoeknock", "submerge", "emerge", "adds", "bosskill" }
BigWigsRagnaros.revision = tonumber(string.sub("$Revision: 11203 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRagnaros:OnEnable()
	self.started = nil
	self.sonsdead = 0
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")	-- emerge_trigger
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")						-- start1_trigger start2_trigger knockback_trigger submerge_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "RagnarosSonDeadX", 0.7)
	self:TriggerEvent("BigWigs_ThrottleSync", "RagnarosEmerge", 10)
end

function BigWigsRagnaros:VerifyEnable(unit)
	if unit == domo then
		return not UnitCanAttack("player", unit)
	else
		return true
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsRagnaros:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["knockback_trigger"]) and self.db.profile.aoeknock then
		self:TriggerEvent("BigWigs_Message", L["knockback_msg"], "Important")
		self:ScheduleEvent("KbWarn", "BigWigs_Message", 20, L["knockback_warn"], "Urgent", nil, "Alert")
		self:TriggerEvent("BigWigs_StartBar", self, L["knockback_bar"], 25, "Interface\\Icons\\Spell_Fire_SoulBurn")
	elseif string.find(msg, L["submerge_trigger"]) then
		self.sonsdead = 0
		self:CancelScheduledEvent("KbWarn")
		self:TriggerEvent("BigWigs_StopBar", self, L["knockback_bar"])
		if self.db.profile.submerge then
			self:TriggerEvent("BigWigs_Message", L["submerge_msg"], "Important")
		end
		if self.db.profile.emerge then
			self:ScheduleEvent("EmergeWarn", "BigWigs_Message", 75, L["emerge_warn"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, L["emerge_bar"], 90, "Interface\\Icons\\Spell_Fire_Volcano")
		end
	elseif string.find(msg, L["start1_trigger"]) and self.db.profile.start then
		self:TriggerEvent("BigWigs_StartBar", self, L["start_bar"], 81, "Interface\\Icons\\Spell_Holy_PrayerOfHealing", true, "Cyan")
	elseif string.find(msg, L["start2_trigger"]) and self.db.profile.start then
		self:TriggerEvent("BigWigs_StartBar", self, L["start_bar"], 51, "Interface\\Icons\\Spell_Holy_PrayerOfHealing", true, "Cyan")
	end
end

function BigWigsRagnaros:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if string.find(msg, L["sonofflame_name"]) then
		self:TriggerEvent("BigWigs_SendSync", "RagnarosSonDeadX "..tostring(self.sonsdead + 1))
	elseif string.find(msg, boss) and self.db.profile.bosskill then
		self:GenericBossDeath(msg)
	end
end

function BigWigsRagnaros:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["emerge_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "RagnarosEmerge")
	end
end

function BigWigsRagnaros:BigWigs_RecvSync(sync, rest)
	if (sync == "BossEngaged") and (rest == boss) and (not self.started) then
		self.started = true
		self:Emerge()
		if self.db.profile.aoeknock then
			self:ScheduleEvent("KbWarn", "BigWigs_Message", 20, L["knockback_warn"], "Urgent", nil, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, L["knockback_bar"], 25, "Interface\\Icons\\Spell_Fire_SoulBurn")
		end
	elseif (sync == "RagnarosSonDeadX") and rest then
		if tonumber(rest) == (self.sonsdead + 1) then
			self.sonsdead = (self.sonsdead + 1)
			if self.db.profile.adds then
				self:TriggerEvent("BigWigs_Message", string.format(L["sonsdead_msg"], self.sonsdead), "Positive")
			end
		end
	elseif (sync == "RagnarosEmerge") and self.started then
		self:Emerge()
	end
end

function BigWigsRagnaros:Emerge()
	self:CancelScheduledEvent("EmergeWarn")
	self:TriggerEvent("BigWigs_StopBar", self, L["emerge_bar"])
	if self.db.profile.emerge then
		self:TriggerEvent("BigWigs_Message", L["emerge_msg"], "Attention")
	end
	if self.db.profile.submerge then
		self:ScheduleEvent("BigWigs_Message", 120, string.format(L["submerge_warn"], 60), "Attention")
		self:ScheduleEvent("BigWigs_Message", 150, string.format(L["submerge_warn"], 30), "Attention")
		self:ScheduleEvent("BigWigs_Message", 170, string.format(L["submerge_warn"], 10), "Attention")
		self:ScheduleEvent("BigWigs_Message", 175, string.format(L["submerge_warn"], 5), "Attention")
		self:TriggerEvent("BigWigs_StartBar", self, L["submerge_bar"], 180, "Interface\\Icons\\Spell_Fire_SelfDestruct")
	end
end
