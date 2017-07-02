-- edited by Masil for Kronos II
-- version 1

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Priest Thekal"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	bloodlustgain_trigger = "(.+) gains Bloodlust\.",
	bloodlustend_trigger = "Bloodlust fades from (.+)\.",
	heal_trigger = "Zealot Lor'Khan begins to cast Great Heal\.",
	rescast_trigger = "begins to cast Resurrection\.",
	phasetwo_trigger = "fill me with your RAGE",
	forcepunch_trigger = "High Priest Thekal begins to perform Force Punch\.",
	frenzygain_trigger = "High Priest Thekal gains Frenzy\.",
	frenzyend_trigger = "Frenzy fades from High Priest Thekal\.",
	enrage_trigger = "High Priest Thekal gains Enrage\.",
	death_trigger = "(.+) dies?\.",

	phaseone_msg = "Troll Phase",
	phasetwo_msg = "Tiger Phase",
	bloodlustgain_msg = "Dispel Bloodlust from %s!",
	heal_msg = "Zealot Lor'Khan is Healing! Interrupt it!",
	forcepunch_warn = "Force Punch soon!",
	frenzy_msg = "Frenzy! TRANQ NOW!",
	enrage_message = "Thekal is enraged!",
	
	bloodlust_bar = "Bloodlust: %s",
	heal_bar = "Great Heal cast",
	rescast_bar = "Resurrection cast",
	forcepunchCD_bar = "Force Punch CD",
	forcepunchcast_bar = "Force Punch cast",
	frenzynext_bar = "Next Frenzy",
	frenzy_bar = "Frenzy",
	
	roguename = "Zealot Zath",
	shamanname = "Zealot Lor'Khan",
	cmd = "Thekal",
			
	heal_cmd = "heal",
	heal_name = "Heal alert",
	heal_desc = "Warn for Lor'Khan's heals.",

	bloodlust_cmd = "bloodlust",
	bloodlust_name = "Bloodlust alert",
	bloodlust_desc = "Announces which boss gets Bloodlust, for easy dispel announce.",
	
	punch_cmd = "punch",
	punch_name = "Force Punch alert",
	punch_desc = "Show timers and warning for Force Punch",
	
	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy announce",
	frenzy_desc = "Warn when High Priest Thekal goes into a frenzy.",
	
	enraged_cmd = "enraged",
	enraged_name = "Enrage alert",
	enraged_desc = "Lets you know when the boss is enraged.",
	
	phase_cmd = "phase",
	phase_name = "Phase notification",
	phase_desc = "Announces the boss' phase transitions and Resurrections.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsThekal = BigWigs:NewModule(boss)
BigWigsThekal.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
BigWigsThekal.enabletrigger = boss
BigWigsThekal.wipemobs = { L["roguename"], L["shamanname"] }
BigWigsThekal.toggleoptions = {"bloodlust", "heal", -1, "phase", "punch", "frenzy", "enraged", "bosskill"}
BigWigsThekal.revision = tonumber(string.sub("$Revision: 11206 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsThekal:OnEnable()
	self.started = nil
	self.tigerphase = nil
	self.lastFrenzy = 0
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")									-- phasetwo_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")				-- bloodlustgain_trigger frenzygain_trigger enrage_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")						-- bloodlustend_trigger  frenzyend_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")				-- heal_trigger rescast_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")			-- forcepunch_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")							-- death_trigger
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ThekalBloodlustStart", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "ThekalBloodlustStop", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "ThekalLorkhanHeal", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "ThekalRes", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "ThekalPhaseTwo", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "ThekalPunch", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "ThekalFrenzyStart", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "ThekalFrenzyStop", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "ThekalEnrage", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "ThekalDead", 10)
end

------------------------------
--      Events              --
------------------------------

function BigWigsThekal:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["phasetwo_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "ThekalPhaseTwo")
	end
end

function BigWigsThekal:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	local _, _, name = string.find(msg, L["bloodlustgain_trigger"])
	if msg == L["frenzygain_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "ThekalFrenzyStart")
	elseif msg == L["enrage_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "ThekalEnrage")
	elseif name then
		self:TriggerEvent("BigWigs_SendSync", "ThekalBloodlustStart "..name)
	end
end

function BigWigsThekal:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	local _, _, name = string.find(msg, L["bloodlustend_trigger"])
	if msg == L["frenzyend_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "ThekalFrenzyStop")
	elseif name then
		self:TriggerEvent("BigWigs_SendSync", "ThekalBloodlustStop "..name)
	end
end

function BigWigsThekal:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["heal_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "ThekalLorkhanHeal")
	elseif string.find(msg, L["rescast_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "ThekalRes")
	end
end

function BigWigsThekal:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["forcepunch_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "ThekalPunch")
	end
end

function BigWigsThekal:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	local _, _, name = string.find(msg, L["death_trigger"])
	if name then 
		if name == boss then
			self:TriggerEvent("BigWigs_SendSync", "ThekalDead")		
		elseif name == L["shamanname"] then
			if self.db.profile.heal then
				self:TriggerEvent("BigWigs_StopBar", L["heal_bar"])
			end
		end
		if self.db.profile.bloodlust then
			self:TriggerEvent("BigWigs_StopBar", string.format(L["bloodlust_bar"], name))
		end		
	end
end

function BigWigsThekal:BigWigs_RecvSync(sync, rest)
	if sync == "BossEngaged" and rest == boss and not self.started then
		self.started = true
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phaseone_msg"], "Attention")
		end
	elseif sync == "ThekalBloodlustStart" and rest and self.db.profile.bloodlust then
		self:TriggerEvent("BigWigs_Message", string.format(L["bloodlustgain_msg"], rest), "Attention")
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["bloodlust_bar"], rest), 30, "Interface\\Icons\\Spell_Nature_BloodLust", true, "Red")
		self:SetCandyBarOnClick("BigWigsBar "..string.format(L["bloodlust_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
	elseif sync == "ThekalBloodlustStop" and rest and self.db.profile.bloodlust then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["bloodlust_bar"], rest))
	elseif sync == "ThekalLorkhanHeal" and self.db.profile.heal then
		self:TriggerEvent("BigWigs_Message", L["heal_msg"], "Attention", nil, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["heal_bar"], 4, "Interface\\Icons\\Spell_Holy_Heal", true, "Green")
		self:SetCandyBarOnClick("BigWigsBar "..L["heal_bar"], function(name, button, extra) TargetByName(extra, true) end, shamanname)
	elseif sync == "ThekalRes" and self.db.profile.phase then
		self:TriggerEvent("BigWigs_StartBar", self, L["rescast_bar"], 2, "Interface\\Icons\\Spell_Holy_Resurrection", true, "Blue")
	elseif sync == "ThekalPhaseTwo" then
		self.tigerphase = true
		if self.db.profile.frenzy then
			self:TriggerEvent("BigWigs_StartBar", self, L["frenzynext_bar"], 30, "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "White")
		end
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phasetwo_msg"], "Attention")
		end
	elseif sync == "ThekalPunch" and self.db.profile.punch then
		self:TriggerEvent("BigWigs_StartBar", self, L["forcepunchcast_bar"], 1, "Interface\\Icons\\inv_gauntlets_31", true, "Red")
		self:ScheduleEvent("BigWigs_Message", 17, L["forcepunch_warn"], "Attention", true, "Alert")
		self:ScheduleEvent("BigWigs_StartBar", 1, self, L["forcepunchCD_bar"], 19, "Interface\\Icons\\inv_gauntlets_31", true, "Yellow")
	elseif sync == "ThekalFrenzyStart" and self.db.profile.frenzy then
		self:TriggerEvent("BigWigs_Message", L["frenzy_msg"], "Magenta", nil, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["frenzy_bar"], 8, "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "Magenta")
        self.lastFrenzy = GetTime()
	elseif sync == "ThekalFrenzyStop" and self.db.profile.frenzy then
		self:TriggerEvent("BigWigs_StopBar", self, L["frenzy_bar"])
		if self.lastFrenzy ~= 0 then
			self:TriggerEvent("BigWigs_StartBar", self, L["frenzynext_bar"], ((self.lastFrenzy + 30) - GetTime()), "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "White")
		end
	elseif sync == "ThekalEnrage" and self.db.profile.enraged then
		self:TriggerEvent("BigWigs_Message", L["enrage_message"], "Urgent")
	elseif (sync == "ThekalDead") and (self.tigerphase == true) then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s has been defeated"], self:ToString()), "Bosskill", nil, "Victory") end
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
		self.core:ToggleModuleActive(self, false)	
	end
end
