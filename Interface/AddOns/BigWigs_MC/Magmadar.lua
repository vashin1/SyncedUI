-- edited by Masil for Kronos II
-- version 1

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Magmadar"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	-- Chat message triggers
	fearafflicted_trigger = "afflicted by Panic.",
	fearimmune_trigger = "Panic fail(.+) immune.",
	fearresisted_trigger = "Magmadar's Panic was resisted",
	frenzygain_trigger = "goes into a killing frenzy",
	frenzyfade_trigger = "Frenzy fades from Magmadar\.",

	-- Warnings and bar texts
	frenzy_msg = "Frenzy! Tranq now!",
	frenzy_bar = "Frenzy",
	frenzynext_bar = "Next Frenzy",

	fear_warn = "Fear in 5 sec!",
--	fear_msg = "Fear! ~30 seconds until next!",
	fearnext_bar = "Next Fear",

	-- AceConsole strings
	cmd = "Magmadar",
	
	panic_cmd = "panic",
	panic_name = "Warn for Panic",
	panic_desc = "Warn when Magmadar casts Panic",
	
	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy alert",
	frenzy_desc = "Warn when Magmadar goes into a frenzy",
} end)

L:RegisterTranslations("deDE", function() return {
	frenzygain_trigger = "goes into a killing frenzy!",
	fearafflicted_trigger = "von Panik betroffen",
	fearimmune_trigger = "Panik(.+)immun",
	fearresisted_trigger = "Panik(.+)widerstanden",
	frenzy_bar = "Wutanfall",
	frenzynext_bar = "Next Frenzy",
	frenzyfade_trigger = "Wutanfall schwindet von Magmadar.",

	frenzy_msg = "Raserei! Tranq jetzt!",
	fear_warn = "Panik in 5 Sekunden!",
--	fear_msg = "AoE Furcht! N\195\164chste in ~30 Sekunden!",
	fearnext_bar = "Panik",

	panic_cmd = "panic",
	panic_name = "Alarm f\195\188r Panik",
	panic_desc = "Warnung, wenn Magmadar AoE Furcht wirkt.",
	
	frenzy_cmd = "frenzy",
	frenzy_name = "Alarm f\195\188r Raserei",
	frenzy_desc = "Warnung, wenn Magmadar in Raserei ger\195\164t.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMagmadar = BigWigs:NewModule(boss)
BigWigsMagmadar.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsMagmadar.enabletrigger = boss
BigWigsMagmadar.toggleoptions = {"panic", "frenzy", "bosskill"}
BigWigsMagmadar.revision = tonumber(string.sub("$Revision: 11204 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMagmadar:OnEnable()
	started = nil
	self.lastFrenzy = 0
	
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")									-- frenzygain_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")							-- frenzyfade_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Afflict")			-- fearafflicted_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Afflict")			-- fearafflicted_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Afflict")	-- fearafflicted_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "FearFail")		-- fearresisted_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "FearFail")		-- fearresisted_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "FearFail")	-- fearimmune_trigger fearresisted_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MagmadarPanic", 15)
	self:TriggerEvent("BigWigs_ThrottleSync", "MagmadarFrenzyStart", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MagmadarFrenzyStop", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsMagmadar:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(arg1, L["frenzygain_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "MagmadarFrenzyStart")
	end
end

function BigWigsMagmadar:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if msg == L["frenzyfade_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "MagmadarFrenzyStop")
	end
end

function BigWigsMagmadar:Afflict(msg)
	if string.find(msg, L["fearafflicted_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "MagmadarPanic")
	end
end

function BigWigsMagmadar:FearFail(msg)
	if (string.find(msg, L["fearimmune_trigger"]) or string.find(msg, L["fearresisted_trigger"])) then
		self:TriggerEvent("BigWigs_SendSync", "MagmadarPanic")
	end
end

function BigWigsMagmadar:BigWigs_RecvSync(sync, rest)
	if sync == "BossEngaged" and rest == boss and not started then
		started = true
		if self.db.profile.panic then
			self:ScheduleEvent("BigWigs_Message", 2, L["fear_warn"], "Attention", nil, "Alert")		
			self:TriggerEvent("BigWigs_StartBar", self, L["fearnext_bar"], 7, "Interface\\Icons\\Spell_Shadow_DeathScream")
		end
		if self.db.profile.frenzy then
			self:TriggerEvent("BigWigs_StartBar", self, L["frenzynext_bar"], 30, "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "White")
		end
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	elseif sync == "MagmadarPanic" and self.db.profile.panic then
--		self:TriggerEvent("BigWigs_Message", L["fear_msg"], "Important")
		self:ScheduleEvent("BigWigs_Message", 25, L["fear_warn"], "Attention", nil, "Alert")		
		self:TriggerEvent("BigWigs_StartBar", self, L["fearnext_bar"], 30, "Interface\\Icons\\Spell_Shadow_DeathScream")
	elseif sync == "MagmadarFrenzyStart" and self.db.profile.frenzy then
		self:TriggerEvent("BigWigs_Message", L["frenzy_msg"], "Magenta", nil, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["frenzy_bar"], 8, "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "Magenta")
        self.lastFrenzy = GetTime()
	elseif sync == "MagmadarFrenzyStop" and self.db.profile.frenzy then
        self:TriggerEvent("BigWigs_StopBar", self, L["frenzy_bar"])
		if self.lastFrenzy ~= 0 then
			self:TriggerEvent("BigWigs_StartBar", self, L["frenzynext_bar"], ((self.lastFrenzy + 15) - GetTime()), "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "White")
		end
	end
end