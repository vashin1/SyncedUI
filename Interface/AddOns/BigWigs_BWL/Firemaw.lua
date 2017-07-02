-- edited by Masil for Kronos II
-- version 4

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Firemaw"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	wingbuffet_trigger = "Firemaw begins to cast Wing Buffet\.",
	shadowflame_trigger = "Firemaw begins to cast Shadow Flame\.",
	
	flamebuffethit_trigger = "Firemaw(.+) Flame Buffet hits",
	flamebuffetafflicted_trigger = "afflicted by Flame Buffet",
	flamebuffetresisted_trigger = "Firemaw(.+) Flame Buffet was resisted",
	flamebuffetimmune_trigger = "Firemaw(.+) Flame Buffet fail(.+) immune\.",
	flamebuffetabsorb1_trigger = "You absorb Firemaw(.+) Flame Buffet",
	flamebuffetabsorb2_trigger = "Firemaw(.+) Flame Buffet is absorbed",

	wingbuffet_message = "Wing Buffet!",
	wingbuffet_warning = "TAUNT now! Wing Buffet in 3sec!",
	wingbuffet_first_warning = "Firemaw engaged! First Wing Buffet in 30sec!",
	shadowflame_warning = "Shadow Flame incoming!",

	wingbuffetcast_bar = "Wing Buffet",
	wingbuffet_bar = "Next Wing Buffet",
	shadowflame_bar = "Shadow Flame",
	flamebuffet_bar = "Next Flame Buffet",

	cmd = "Firemaw",

	flamebuffet_cmd = "flamebuffet",
	flamebuffet_name = "Flame Buffet alert",
	flamebuffet_desc = "Warn when Flamegor casts Flame Buffet.",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn when Flamegor casts Wing Buffet.",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn when Flamegor casts Shadow Flame.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFiremaw = BigWigs:NewModule(boss)
BigWigsFiremaw.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsFiremaw.enabletrigger = boss
BigWigsFiremaw.toggleoptions = {"wingbuffet", "shadowflame", "flamebuffet", "bosskill"}
BigWigsFiremaw.revision = tonumber(string.sub("$Revision: 11202 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFiremaw:OnEnable()
	started = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")		-- flamebuffethit_trigger flamebuffetabsorb1_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")		-- flamebuffethit_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")	-- flamebuffethit_trigger flamebuffetresisted_trigger flamebuffetabsorb2_trigger wingbuffet_trigger shadowflame_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")			-- flamebuffetafflicted_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")			-- flamebuffetafflicted_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")-- flamebuffetafflicted_trigger
	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "FiremawWingBuffetX", 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "FiremawShadowflameX", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsFiremaw:Event(msg)
	if msg == L["wingbuffet_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "FiremawWingBuffetX")
	elseif msg == L["shadowflame_trigger"] then 
		self:TriggerEvent("BigWigs_SendSync", "FiremawShadowflameX")
	elseif (string.find(msg, L["flamebuffethit_trigger"]) or string.find(msg, L["flamebuffetafflicted_trigger"]) or string.find(msg, L["flamebuffetresisted_trigger"]) or string.find(msg, L["flamebuffetimmune_trigger"]) or string.find(msg, L["flamebuffetabsorb1_trigger"]) or string.find(msg, L["flamebuffetabsorb2_trigger"])) and self.db.profile.flamebuffet and started then
		self:TriggerEvent("BigWigs_StartBar", self, L["flamebuffet_bar"], 5, "Interface\\Icons\\Spell_Fire_Fireball", true, "White")
	end
end

function BigWigsFiremaw:BigWigs_RecvSync(sync, rest)
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
	elseif sync == "FiremawWingBuffetX" and self.db.profile.wingbuffet then
		self:CancelScheduledEvent("WingBuffetSkippedWarn")
		self:CancelScheduledEvent("WingBuffetSkippedBar")
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffetcast_bar"], 1, "Interface\\Icons\\INV_Misc_MonsterScales_14", true, "Yellow")
		self:TriggerEvent("BigWigs_Message", L["wingbuffet_message"], "Important")
		self:ScheduleEvent("BigWigs_Message", 27, L["wingbuffet_warning"], "Attention", nil, "Alert")
		self:ScheduleEvent("BigWigs_StartBar", 1, self, L["wingbuffet_bar"], 29, "Interface\\Icons\\INV_Misc_MonsterScales_14")
		self:ScheduleEvent("WingBuffetSkippedWarn", "BigWigs_Message", 57, L["wingbuffet_warning"], "Attention", nil, "Alert")
		self:ScheduleEvent("WingBuffetSkippedBar", "BigWigs_StartBar", 35, self, L["wingbuffet_bar"], 25, "Interface\\Icons\\INV_Misc_MonsterScales_14")
	elseif sync == "FiremawShadowflameX" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L["shadowflame_warning"], "Urgent", true)
		self:TriggerEvent("BigWigs_StartBar", self, L["shadowflame_bar"], 2, "Interface\\Icons\\Spell_Fire_Incinerate", true, "Red")
	end
end