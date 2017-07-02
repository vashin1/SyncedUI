-- edited by Masil for Kronos II
-- version 3

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Ebonroc"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	wingbuffet_trigger = "Ebonroc begins to cast Wing Buffet\.",
	shadowflame_trigger = "Ebonroc begins to cast Shadow Flame\.",
	shadowcurse_trigger = "^(.+) (.+) afflicted by Shadow of Ebonroc\.",
	
	wingbuffet_message = "Wing Buffet!",
	wingbuffet_warning = "TAUNT now! Wing Buffet in 3sec!",
	wingbuffet_first_warning = "Ebonroc engaged! First Wing Buffet in 30sec!",
	
	shadowflame_warning = "Shadow Flame incoming!",
	
	shadowfcurse_message_you = "You have Shadow of Ebonroc!",
	shadowfcurse_message_taunt = "%s has Shadow of Ebonroc! TAUNT!",

	wingbuffetcast_bar = "Wing Buffet",
	wingbuffet_bar = "Next Wing Buffet",
	shadowflame_bar = "Shadow Flame",
	shadowcurse_bar = "%s - Shadow of Ebonroc",

	cmd = "Ebonroc",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn when Ebonroc casts Wing Buffet.",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn when Ebonroc casts Shadow Flame.",

	curse_cmd = "curse",
	curse_name = "Shadow of Ebonroc warnings",
	curse_desc = "Shows a timer bar and announces who gets Shadow of Ebonroc.",
	
	icon_cmd = "icon",
	icon_name = "Raid Icon",
	icon_desc = "Marks the player with Shadow of Ebonroc.\n\n(Requires assistant or higher)",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsEbonroc = BigWigs:NewModule(boss)
BigWigsEbonroc.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsEbonroc.enabletrigger = boss
BigWigsEbonroc.toggleoptions = { "curse", "wingbuffet", "shadowflame", "icon", "bosskill" }
BigWigsEbonroc.revision = tonumber(string.sub("$Revision: 18327 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsEbonroc:OnEnable()
	started = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "EbonrocWingBuffetX", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "EbonrocShadowflameX", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "EbonrocShadowX", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsEbonroc:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["shadowflame_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "EbonrocShadowflameX")
	elseif msg == L["wingbuffet_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "EbonrocWingBuffetX")
	end
end

function BigWigsEbonroc:Event(msg)
	local _, _, name, detect = string.find(msg, L["shadowcurse_trigger"])
	if name and detect then
		if detect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "EbonrocShadowX "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "EbonrocShadowX "..name)
		end
	end
end

function BigWigsEbonroc:BigWigs_RecvSync(sync, rest)
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
	elseif sync == "EbonrocWingBuffetX" and self.db.profile.wingbuffet then
		self:CancelScheduledEvent("WingBuffetSkippedWarn")
		self:CancelScheduledEvent("WingBuffetSkippedBar")
		self:TriggerEvent("BigWigs_Message", L["wingbuffet_message"], "Important")
		self:ScheduleEvent("BigWigs_Message", 27, L["wingbuffet_warning"], "Attention", nil, "Alert")
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffetcast_bar"], 1, "Interface\\Icons\\INV_Misc_MonsterScales_14", true, "Yellow")
		self:ScheduleEvent("BigWigs_StartBar", 1, self, L["wingbuffet_bar"], 29, "Interface\\Icons\\INV_Misc_MonsterScales_14")
		self:ScheduleEvent("WingBuffetSkippedWarn", "BigWigs_Message", 57, L["wingbuffet_warning"], "Attention", nil, "Alert")
		self:ScheduleEvent("WingBuffetSkippedBar", "BigWigs_StartBar", 35, self, L["wingbuffet_bar"], 25, "Interface\\Icons\\INV_Misc_MonsterScales_14")
	elseif sync == "EbonrocShadowflameX" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L["shadowflame_warning"], "Urgent", true)
		self:TriggerEvent("BigWigs_StartBar", self, L["shadowflame_bar"], 2, "Interface\\Icons\\Spell_Fire_Incinerate", true, "red")
	elseif sync == "EbonrocShadowX" and rest and self.db.profile.curse then
		if rest == UnitName("player") then
			self:TriggerEvent("BigWigs_Message", L["shadowfcurse_message_you"], "Personal", true, "Alarm")
			self:TriggerEvent("BigWigs_Message", string.format(L["shadowfcurse_message_taunt"], UnitName("player")), "Important", nil, "Alarm", true)
		else
			self:TriggerEvent("BigWigs_Message", string.format(L["shadowfcurse_message_taunt"], rest), "Important", nil, "Alarm")
		end
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["shadowcurse_bar"], rest), 8, "Interface\\Icons\\Spell_Shadow_GatherShadows", true, "white")
		if self.db.profile.icon then
			self:CancelScheduledEvent("removeicon")
			self:TriggerEvent("BigWigs_SetRaidIcon", rest)
			self:ScheduleEvent("removeicon", "BigWigs_RemoveRaidIcon", 8, rest)			
		end
	end
end