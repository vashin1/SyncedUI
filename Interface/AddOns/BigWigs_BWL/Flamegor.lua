-- edited by Masil for Kronos II
-- version 4

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Flamegor"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	wingbuffet_trigger = "Flamegor begins to cast Wing Buffet\.",
	shadowflame_trigger = "Flamegor begins to cast Shadow Flame\.",
	frenzygain_trigger = "Flamegor gains Frenzy\.",
	frenzyend_trigger = "Frenzy fades from Flamegor\.",

	wingbuffet_message = "Wing Buffet!",
	wingbuffet_warning = "TAUNT now! Wing Buffet in 3sec!",
	wingbuffet_first_warning = "Flamegor engaged! First Wing Buffet in 30sec!",
	shadowflame_warning = "Shadow Flame incoming!",
	frenzy_message = "Frenzy! Tranq now!",
	frenzy_bar = "Frenzy",

	wingbuffetcast_bar = "Wing Buffet",
	wingbuffet_bar = "Next Wing Buffet",
	shadowflame_bar = "Shadow Flame",

	cmd = "Flamegor",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn when Flamegor casts Wing Buffet.",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn when Flamegor casts Shadow Flame.",

	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy alert",
	frenzy_desc = "Warn when Flamegor is frenzied.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFlamegor = BigWigs:NewModule(boss)
BigWigsFlamegor.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsFlamegor.enabletrigger = boss
BigWigsFlamegor.toggleoptions = {"wingbuffet", "shadowflame", "frenzy", "bosskill"}
BigWigsFlamegor.revision = tonumber(string.sub("$Revision: 18327 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFlamegor:OnEnable()
	started = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "FlamegorWingBuffetX", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "FlamegorShadowflameX", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "FlamegorFrenzyStart", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsFlamegor:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["wingbuffet_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorWingBuffetX")
	elseif msg == L["shadowflame_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorShadowflameX")
	end
end

function BigWigsFlamegor:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["frenzygain_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorFrenzyStart")
	end
end

function BigWigsFlamegor:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if msg == L["frenzyend_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorFrenzyEnd")
	end
end

function BigWigsFlamegor:BigWigs_RecvSync(sync, rest)
	if sync == self:GetEngageSync() and rest == boss and not started then
		started = true
		if self.db.profile.wingbuffet then
			self:TriggerEvent("BigWigs_Message", L["wingbuffet_first_warning"], "Important")
			self:ScheduleEvent("BigWigs_Message", 27, L["wingbuffet_warning"], "Attention", nil, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffet_bar"], 30, "Interface\\Icons\\INV_Misc_MonsterScales_14")
			self:ScheduleEvent("WingBuffetSkippedWarn", "BigWigs_Message", 57, L["wingbuffet_warning"], "Attention", nil, "Alert")
			self:ScheduleEvent("WingBuffetSkippedBar", "BigWigs_StartBar", 35, self, L["wingbuffet_bar"], 25, "Interface\\Icons\\INV_Misc_MonsterScales_14")
		end
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	elseif sync == "FlamegorWingBuffetX" and self.db.profile.wingbuffet then
		self:CancelScheduledEvent("WingBuffetSkippedWarn")
		self:CancelScheduledEvent("WingBuffetSkippedBar")
		self:TriggerEvent("BigWigs_Message", L["wingbuffet_message"], "Important")
		self:ScheduleEvent("BigWigs_Message", 27, L["wingbuffet_warning"], "Attention", nil, "Alert")
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffetcast_bar"], 1, "Interface\\Icons\\INV_Misc_MonsterScales_14", true, "Yellow")
		self:ScheduleEvent("BigWigs_StartBar", 1, self, L["wingbuffet_bar"], 29, "Interface\\Icons\\INV_Misc_MonsterScales_14")
		self:ScheduleEvent("WingBuffetSkippedWarn", "BigWigs_Message", 57, L["wingbuffet_warning"], "Attention", nil, "Alert")
		self:ScheduleEvent("WingBuffetSkippedBar", "BigWigs_StartBar", 35, self, L["wingbuffet_bar"], 25, "Interface\\Icons\\INV_Misc_MonsterScales_14")
	elseif sync == "FlamegorShadowflameX" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L["shadowflame_warning"], "Urgent", true)
		self:TriggerEvent("BigWigs_StartBar", self, L["shadowflame_bar"], 2, "Interface\\Icons\\Spell_Fire_Incinerate", true, "red")
	elseif sync == "FlamegorFrenzyStart" and self.db.profile.frenzy then
		self:TriggerEvent("BigWigs_Message", L["frenzy_message"], "Magenta", nil, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["frenzy_bar"], 10, "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "Magenta")
	elseif sync == "FlamegorFrenzyEnd" and self.db.profile.frenzy then
        self:TriggerEvent("BigWigs_StopBar", self, L["frenzy_bar"])
	end
end