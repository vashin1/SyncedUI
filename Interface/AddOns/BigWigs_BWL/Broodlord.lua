-- edited by Masil for Kronos II
-- version 3

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Broodlord Lashlayer"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Broodlord",

	engage_trigger = "None of your kind should be here",
	ms_trigger = "^(.+) (.+) afflicted by Mortal Strike\.",
	bw_trigger = "^(.+) (.+) afflicted by Blast Wave\.",
	deathyou_trigger = "You die\.",
	deathother_trigger = "(.+) dies\.",
	ms_warn_you = "Mortal Strike on you!",
	ms_warn_other = "Mortal Strike on %s!",
	bw_warn = "Blast Wave soon!",
	bw_warn_first = "Broodlord engaged! First Blast Wave in ~10sec!",
	ms_bar = "Mortal Strike: %s",
	bw_bar = "Blast Wave CD",

	ms_cmd = "ms",
	ms_name = "Mortal Strike",
	ms_desc = "Warn when someone gets Mortal Strike and starts a clickable bar for easy selection.",

	bw_cmd = "bw",
	bw_name = "Blast Wave",
	bw_desc = "Shows a bar with the possible Blast Wave cooldown.\n\n(Disclaimer: this varies anywhere from 15 to 20 seconds. Chosen shortest interval for safety.)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBroodlord = BigWigs:NewModule(boss)
BigWigsBroodlord.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsBroodlord.enabletrigger = boss
BigWigsBroodlord.toggleoptions = {"ms", "bw", "bosskill"}
BigWigsBroodlord.revision = tonumber(string.sub("$Revision: 11206 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsBroodlord:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BroodBlastWave", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "BroodMortalStrike", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "BroodDeath", 2)

end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsBroodlord:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["engage_trigger"]) then
		if self.db.profile.bw then
			self:TriggerEvent("BigWigs_StartBar", self, L["bw_bar"], 10, "Interface\\Icons\\Spell_Holy_Excorcism_02", true, "Red")
			self:TriggerEvent("BigWigs_Message", L["bw_warn_first"], "Attention")
		end
	end
end

function BigWigsBroodlord:CHAT_MSG_COMBAT_FRIENDLY_DEATH(msg)
	local _, _, deathother = string.find(msg, L["deathother_trigger"])
	if msg == L["deathyou_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "BroodDeath "..UnitName("player"))
	elseif deathother then
		self:TriggerEvent("BigWigs_SendSync", "BroodDeath "..deathother)
	end
end

function BigWigsBroodlord:Event(msg)
	local _, _, name, detect = string.find(msg, L["ms_trigger"])
	if name and detect then
		if detect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "BroodMortalStrike "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "BroodMortalStrike "..name)
		end
	elseif string.find(msg, L["bw_trigger"])then
		self:TriggerEvent("BigWigs_SendSync", "BroodBlastWave")
	end
end

function BigWigsBroodlord:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BroodBlastWave" and self.db.profile.bw then
		self:TriggerEvent("BigWigs_StartBar", self, L["bw_bar"], 15, "Interface\\Icons\\Spell_Holy_Excorcism_02", true, "Red")
		self:ScheduleEvent("BigWigs_Message", 12, L["bw_warn"], "Attention", nil, "Alert")
	elseif sync == "BroodMortalStrike" and rest and self.db.profile.ms then
		if rest == UnitName("player") then
			self:TriggerEvent("BigWigs_Message", L["ms_warn_you"], "Personal", true, "Alarm")
			self:TriggerEvent("BigWigs_Message", string.format(L["ms_warn_other"], UnitName("player")), "Urgent", nil, "Alarm", true)
		else
			self:TriggerEvent("BigWigs_Message", string.format(L["ms_warn_other"], rest), "Urgent", nil, "Alarm")
		end
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["ms_bar"], rest), 5, "Interface\\Icons\\Ability_Warrior_SavageBlow", true, "Black")
		self:SetCandyBarOnClick("BigWigsBar "..string.format(L["ms_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
	elseif sync == "BroodDeath" and rest and self.db.profile.ms then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["ms_bar"], rest))
	end
end