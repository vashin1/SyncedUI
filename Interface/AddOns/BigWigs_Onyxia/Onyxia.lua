-- edited by Masil for Kronos II
-- version 5
 
------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Onyxia"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	deepbreath_trigger = "takes in a deep breath",
	flamebreath_trigger = "Onyxia begins to cast Flame Breath\.",
	wingbuffet_trigger = "Onyxia begins to cast Wing Buffet\.",
	fireball_trigger = "Onyxia begins to cast Fireball\.",
	phase1_trigger = "leave my lair",
	phase2_trigger = "from above",
	phase3_trigger = "It seems you'll need another lesson",
	firstfear_trigger = "afflicted by Bellowing Roar\.",
	fear_trigger = "Onyxia begins to cast Bellowing Roar\.",

	deepbreath_msg = "Deep Breath incoming!",
	phase1_msg = "Phase 1",
	phase2_msg = "Phase 2",
	phase3_msg = "Phase 3",
	fear_warn = "Fear in 5 sec!",

	fearcast_bar = "Fear",
	fearnext_bar = "Next Fear",
	deepbreathcast_bar = "Deep Breath",
	flamebreathcast_bar = "Flame Breath",
	wingbuffetcast_bar = "Wing Buffet",
	fireballcast_bar = "Fireball",


	cmd = "Onyxia",

	deepbreath_cmd = "deepbreath",
	deepbreath_name = "Deep Breath",
	deepbreath_desc = "Warn when Onyxia begins to cast Deep Breath.",

	flamebreath_cmd = "flamebreath",
	flamebreath_name = "Flame Breath",
	flamebreath_desc = "Warn when Onyxia begins to cast Flame Breath.",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet",
	wingbuffet_desc = "Warn for Wing Buffet.",

	fireball_cmd = "fireball",
	fireball_name = "Fireball",
	fireball_desc = "Warn for Fireball.",

	phase_cmd = "phase",
	phase_name = "Phase",
	phase_desc = "Warn for Phase Change.",

	onyfear_cmd = "onyfear",
	onyfear_name = "Fear",
	onyfear_desc = "Warn for Bellowing Roar.",
	
	ktm_cmd = "ktm",
	ktm_name = "Phase 3 KTM reset",
	ktm_desc = "Reset KTM when transitioning to phase 3.\n\n(Requires assistant or higher)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsOnyxia = BigWigs:NewModule(boss)
BigWigsOnyxia.zonename = AceLibrary("Babble-Zone-2.2")["Onyxia's Lair"]
BigWigsOnyxia.enabletrigger = boss
BigWigsOnyxia.toggleoptions = { "flamebreath", "deepbreath", "wingbuffet", "fireball", "phase", "onyfear", "ktm", "bosskill"}
BigWigsOnyxia.revision = tonumber(string.sub("$Revision: 11204 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsOnyxia:OnEnable()
	self.landed = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")							-- deepbreath_trigger
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")								-- phase1_trigger phase2_trigger phase3_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")		-- flamebreath_trigger wingbuffet_trigger fireball_trigger fear_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Afflict")			-- firstfear_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Afflict")			-- firstfear_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Afflict")	-- firstfear_trigger
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "OnyDeepBreath", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "OnyPhaseTwo", 30)
	self:TriggerEvent("BigWigs_ThrottleSync", "OnyPhaseThree", 30)
	self:TriggerEvent("BigWigs_ThrottleSync", "OnyFirstFear", 30)
	self:TriggerEvent("BigWigs_ThrottleSync", "OnyFlameBreath", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "OnyFireball", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "OnyBellowingRoar", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsOnyxia:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["deepbreath_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "OnyDeepBreath")
	end
end

function BigWigsOnyxia:CHAT_MSG_MONSTER_YELL(msg)
	if (string.find(msg, L["phase1_trigger"])) then
		self.landed = nil
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phase1_msg"], "Attention")
		end		
	elseif (string.find(msg, L["phase2_trigger"])) then
		self:TriggerEvent("BigWigs_SendSync", "OnyPhaseTwo")
	elseif (string.find(msg, L["phase3_trigger"])) then
		self:TriggerEvent("BigWigs_SendSync", "OnyPhaseThree")
	end
end

function BigWigsOnyxia:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["fear_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "OnyBellowingRoar")
	elseif msg == L["flamebreath_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "OnyFlameBreath")
	elseif msg == L["wingbuffet_trigger"] and self.db.profile.wingbuffet then
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffetcast_bar"], 1, "Interface\\Icons\\INV_Misc_MonsterScales_14", true, "blue")
	elseif msg == L["fireball_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "OnyFireball")
	end
end

function BigWigsOnyxia:Afflict(msg)
	if not self.landed and string.find(msg, L["firstfear_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "OnyFirstFear")		
	end
end

function BigWigsOnyxia:BigWigs_RecvSync(sync)
	if sync == "OnyPhaseTwo" then
		self.landed = nil
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phase2_msg"], "Attention")
		end
	elseif sync == "OnyPhaseThree" and self.db.profile.phase then
		self:TriggerEvent("BigWigs_Message", L["phase3_msg"], "Attention")
		if IsAddOnLoaded("KLHThreatMeter") and self.db.profile.ktm and (IsRaidLeader() or IsRaidOfficer()) then
			klhtm.net.clearraidthreat()
		end	
	elseif sync == "OnyFirstFear" and not self.landed then
		self.landed = true
		if self.db.profile.onyfear then
			self:ScheduleEvent("BigWigs_Message", 22, L["fear_warn"], "Urgent", nil, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, L["fearnext_bar"], 27, "Interface\\Icons\\Spell_Fire_Fire", true, "White")
		end
	elseif sync == "OnyDeepBreath" and self.db.profile.deepbreath then
		self:TriggerEvent("BigWigs_Message", L["deepbreath_msg"], "Important", nil, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["deepbreathcast_bar"], 5, "Interface\\Icons\\Spell_Fire_SelfDestruct", true, "black")
	elseif sync == "OnyFlameBreath" and self.db.profile.flamebreath then 
		self:TriggerEvent("BigWigs_StartBar", self, L["flamebreathcast_bar"], 2, "Interface\\Icons\\Spell_Fire_Fire", true, "yellow")
	elseif sync == "OnyFireball" and self.db.profile.fireball then 
		self:TriggerEvent("BigWigs_StartBar", self, L["fireballcast_bar"], 3, "Interface\\Icons\\Spell_Fire_FlameBolt", true, "red")
	elseif sync == "OnyBellowingRoar" and self.db.profile.onyfear then 
		self:TriggerEvent("BigWigs_StartBar", self, L["fearcast_bar"], 1.5, "Interface\\Icons\\Spell_Fire_Fire", true, "Red")
		self:ScheduleEvent("BigWigs_StartBar", 1.5, self, L["fearnext_bar"], 23.5, "Interface\\Icons\\Spell_Fire_Fire", true, "White")
		self:ScheduleEvent("BigWigs_Message", 20, L["fear_warn"], "Urgent", nil, "Alert")
	end
end