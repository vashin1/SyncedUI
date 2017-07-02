-- edited by Masil for Kronos II
-- version 3

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Shazzrah"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cs_trigger1 = "Shazzrah casts Counterspell",	-- doesn't work
	cs_trigger2 = "Shazzrah interrupts",			-- unreliable, somebody has to get interrupted for timer to appear
	curse_trigger1 = "afflicted by Shazzrah",
	curse_trigger2 = "Shazzrah(.+) Curse was resisted",
	deaden_gain_trigger = "Shazzrah gains Deaden Magic\.",	-- first after 25s, subsequent every 35s, no bar to avoid confusion
	deaden_fade_trigger = "Deaden Magic fades from Shazzrah\.",
	blink_trigger = "casts Gate of Shazzrah",

	cs_message = "Counterspell!",
	cs_warning = "Counterspell soon!",
	curse_message = "Shazzrah's Curse! Decurse NOW!",
	deaden_message = "Deaden Magic is up! Dispel it!",
	blink_message = "Blink!",
	blink_warning = "Blink in 5sec!",

	cs_bar = "Next Counterspell",
	curse_bar = "Next Shazzrah's Curse",
	deaden_bar = "Deaden Magic",
	blink_bar = "Next Blink",

	cmd = "Shazzrah",
	
	counterspell_cmd = "counterspell",
	counterspell_name = "Counterspell alert",
	counterspell_desc = "Warn for Shazzrah's Counterspell",
	
	curse_cmd = "curse",
	curse_name = "Shazzrah's Curse alert",
	curse_desc = "Warn for Shazzrah's Curse",
	
	deaden_cmd = "deaden",
	deaden_name = "Deaden Magic alert",
	deaden_desc = "Warn when Shazzrah has Deaden Magic",
	
	blink_cmd = "blink",
	blink_name = "Blink alert",
	blink_desc = "Warn when Shazzrah Blinks",
	
	ktm_cmd = "ktm",
	ktm_name = "Blink KTM reset",
	ktm_desc = "Reset KTM when Shazzrah Blinks.\n\n(Requires assistant or higher)",

} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsShazzrah = BigWigs:NewModule(boss)
BigWigsShazzrah.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsShazzrah.enabletrigger = boss
BigWigsShazzrah.toggleoptions = {"counterspell", "curse", "deaden", "blink", "ktm", "bosskill"}
BigWigsShazzrah.revision = tonumber(string.sub("$Revision: 11203 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsShazzrah:OnEnable()
	started = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Afflict")			-- curse_trigger1
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Afflict")	-- curse_trigger1
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Afflict")			-- curse_trigger1
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")			-- cs_trigger2
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")			-- cs_trigger2
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")		-- cs_trigger2 curse_trigger2 blink_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "DeadenMagic")		-- deaden_gain_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "DeadenMagic")				-- deaden_fade_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ShazzrahBlinkX", 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "ShazzrahCurseX", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "ShazzrahDeadenMagicOn", 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "ShazzrahDeadenMagicOff", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "ShazzrahCS", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsShazzrah:Afflict(msg)
	if (string.find(msg, L["curse_trigger1"])) then
		self:TriggerEvent("BigWigs_SendSync", "ShazzrahCurseX")
	end
end

function BigWigsShazzrah:DeadenMagic(msg)
	if msg == L["deaden_gain_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "ShazzrahDeadenMagicOn")
	elseif msg == L["deaden_fade_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "ShazzrahDeadenMagicOff")
	end
end

function BigWigsShazzrah:Event(msg)
	if (string.find(msg, L["cs_trigger1"]) or string.find(msg, L["cs_trigger2"])) then
		self:TriggerEvent("BigWigs_SendSync", "ShazzrahCounterspellX")
	elseif (string.find(msg, L["curse_trigger2"])) then
		self:TriggerEvent("BigWigs_SendSync", "ShazzrahCurseX")
	elseif (string.find(msg, L["blink_trigger"])) then
		self:TriggerEvent("BigWigs_SendSync", "ShazzrahBlinkX")
	end
end

function BigWigsShazzrah:BigWigs_RecvSync(sync, rest)
	if sync == self:GetEngageSync() and rest == boss and not started then
		started = true
		if self.db.profile.counterspell then
			self:TriggerEvent("BigWigs_StartBar", self, L["cs_bar"], 15, "Interface\\Icons\\Spell_Frost_IceShock", true, "Blue")
			self:ScheduleEvent("BigWigs_Message", 13, L["cs_warning"], "Blue", nil, "Alert")
		end
		if self.db.profile.curse then
			self:TriggerEvent("BigWigs_StartBar", self, L["curse_bar"], 10, "Interface\\Icons\\Spell_Shadow_AntiShadow", true, "Magenta")
		end
		if self.db.profile.blink then
			self:ScheduleEvent("BigWigs_Message", 25, L["blink_warning"], "White")
			self:TriggerEvent("BigWigs_StartBar", self, L["blink_bar"], 30, "Interface\\Icons\\Spell_Arcane_Blink", true, "White")
		end
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	elseif sync == "ShazzrahCounterspellX" and self.db.profile.counterspell then
		self:TriggerEvent("BigWigs_Message", L["cs_message"], "Attention")		
		self:TriggerEvent("BigWigs_StartBar", self, L["cs_bar"], 15, "Interface\\Icons\\Spell_Frost_IceShock", true, "Blue")
		self:ScheduleEvent("BigWigs_Message", 13, L["cs_warning"], "Blue", nil, "Alert")
	elseif sync == "ShazzrahCurseX" and self.db.profile.curse then
		self:TriggerEvent("BigWigs_Message", L["curse_message"], "Magenta", nil, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["curse_bar"], 20, "Interface\\Icons\\Spell_Shadow_AntiShadow", true, "Magenta")
	elseif sync == "ShazzrahDeadenMagicOn" and self.db.profile.deaden then
		self:TriggerEvent("BigWigs_Message", L["deaden_message"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["deaden_bar"], 30, "Interface\\Icons\\Spell_Holy_SealOfSalvation", true, "Red")
	elseif sync == "ShazzrahDeadenMagicOff" and self.db.profile.deaden then
		self:TriggerEvent("BigWigs_StopBar", self, L["deaden_bar"])
	elseif sync == "ShazzrahBlinkX" and self.db.profile.blink then
		self:TriggerEvent("BigWigs_Message", L["blink_message"], "Important")
		self:ScheduleEvent("BigWigs_Message", 40, L["blink_warning"], "White")
		self:TriggerEvent("BigWigs_StartBar", self, L["blink_bar"], 45, "Interface\\Icons\\Spell_Arcane_Blink", true, "White")
		if IsAddOnLoaded("KLHThreatMeter") and self.db.profile.ktm and (IsRaidLeader() or IsRaidOfficer()) then
			klhtm.net.clearraidthreat()
		end
	end
end