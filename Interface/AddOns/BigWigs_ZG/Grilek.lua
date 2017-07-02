-- edited by Masil for Kronos II
-- version 1

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Gri'lek"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	avatar_trigger = "Gri'lek is afflicted by Avatar\.",
	root_trigger = "^(.+) (.+) afflicted by Entangling Roots\.",
	rootend_trigger = "Entangling Roots fades from (.+)\.",
	death_trigger = "(.+) dies?\.",

	avatar_warn = "Avatar in 5 sec! Melee get out!",
	root_msg = "%s is rooted! Dispel it!",
	rootyou_msg = "You're rooted!",

	avatarnext_bar = "Next Avatar",
	avatar_bar = "Avatar",
	root_bar = "Rooted: %s",
	
	cmd = "Grilek",
	
	avatar_cmd = "avatar",
	avatar_name = "Avatar alert",
	avatar_desc = "Announce when the boss has Avatar (enrage phase).",
	
	ktm_cmd = "ktm",
	ktm_name = "KTM reset",
	ktm_desc = "Reset KTM when Gri'lek gains Avatar",
	
	root_cmd = "root",
	root_name = "Root Alert",
	root_desc = "Warn when players get rooted.",
	
	puticon_cmd = "puticon",
	puticon_name = "Raid icon on rooted players",
	puticon_desc = "Place a raid icon on the rooted player.\n\n(Requires assistant or higher)",

} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGrilek = BigWigs:NewModule(boss)
BigWigsGrilek.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
BigWigsGrilek.enabletrigger = boss
BigWigsGrilek.toggleoptions = {"avatar", "ktm", "root", "puticon", "bosskill"}
BigWigsGrilek.revision = tonumber(string.sub("$Revision: 11208 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGrilek:OnEnable()
	self.started = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")					-- avatar_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Afflict")			-- root_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Afflict")	-- root_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Afflict")			-- root_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "AuraFade")					-- rootend_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "AuraFade")				-- rootend_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "AuraFade")				-- rootend_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "AuraFade")				-- death_trigger
	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "GrilekAvatar", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "GrilekRoot", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "GrilekRootStop", 1)
end

------------------------------
--      Events              --
------------------------------

function BigWigsGrilek:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if msg == L["avatar_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "GrilekAvatar")
	end
end

function BigWigsGrilek:Afflict(msg)
	local _, _, rootname, rootdetect = string.find(msg, L["root_trigger"])
	if rootname and rootdetect then
		if rootdetect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "GrilekRoot "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "GrilekRoot "..rootname)
		end		
	end
end

function BigWigsGrilek:AuraFade(msg)
	local _, _, name = string.find(msg, L["rootend_trigger"]) or string.find(msg, L["death_trigger"])
	if name then
		if (name == "you") or (name == "You") then
			self:TriggerEvent("BigWigs_SendSync", "GrilekRootStop "..UnitName("player"))
		else 
			self:TriggerEvent("BigWigs_SendSync", "GrilekRootStop "..name)
		end
	end	
end

function BigWigsGrilek:BigWigs_RecvSync(sync, rest)
	if (sync == "BossEngaged") and (rest == boss) and not self.started then
		self.started = true
		if self.db.profile.avatar then
			self:TriggerEvent("BigWigs_StartBar", self, L["avatarnext_bar"], 15, "Interface\\Icons\\Ability_Creature_Cursed_05")
			self:ScheduleEvent("BigWigs_Message", 10, L["avatar_warn"], "Attention", nil, "Alert")
		end
	elseif sync == "GrilekAvatar" then
		if self.db.profile.avatar then
			self:TriggerEvent("BigWigs_StartBar", self, L["avatar_bar"], 15, "Interface\\Icons\\Ability_Creature_Cursed_05", true, "red")
			self:ScheduleEvent("BigWigs_StartBar", 15, self, L["avatarnext_bar"], 25, "Interface\\Icons\\Ability_Creature_Cursed_05")
			self:ScheduleEvent("BigWigs_Message", 35, L["avatar_warn"], "Attention", nil, "Alert")
		end
		if self.db.profile.ktm and IsAddOnLoaded("KLHThreatMeter") and (IsRaidLeader() or IsRaidOfficer()) then
			klhtm.net.clearraidthreat()
		end
	elseif sync == "GrilekRoot" and rest then
		if self.db.profile.root then
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["root_bar"], rest), 10, "Interface\\Icons\\Spell_Nature_Stranglevines", true, "blue")
			self:SetCandyBarOnClick("BigWigsBar "..string.format(L["root_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
			if rest == UnitName("player") then
				self:TriggerEvent("BigWigs_Message", L["rootyou_msg"], "Personal", true, "Alarm")
				self:TriggerEvent("BigWigs_Message", string.format(L["root_msg"], UnitName("player")), "blue", nil, "Alarm", true)		
			else
				self:TriggerEvent("BigWigs_Message", string.format(L["root_msg"], rest), "blue", nil, "Alarm")
			end
		end
		if self.db.profile.puticon then 
			self:TriggerEvent("BigWigs_SetRaidIcon", rest)
		end
	elseif sync == "GrilekRootStop" and rest then
		if self.db.profile.root then
			self:TriggerEvent("BigWigs_StopBar", self, string.format(L["root_bar"], rest))
		end
		if self.db.profile.puticon then
			self:TriggerEvent("BigWigs_RemoveRaidIcon", rest)
		end		
	end
end
