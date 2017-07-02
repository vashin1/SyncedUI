-- edited by Masil for Kronos II
-- version 2

------------------------------
--      Are you local?      --
------------------------------

local boss = "Twilight Corrupter"
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	engage_trigger = "The Nightmare cannot be stopped",
	corruption_trigger1 = "afflicted by Soul Corruption",
	corruption_trigger2 = "Soul Corruption was resisted by",
	mindcontrol_trigger = "^(.+) (.+) afflicted by Creature of Nightmare\.",
	mcfade_trigger = "Creature of Nightmare fades from (.*)\.",

	mindcontrol_msg = "%s is Mind Controlled!",
	mindcontrol_msg_you = "You are Mind Controlled!",
	mindcontrol_msg_me = "Mind Control on me!",
	
	corruption_bar = "Knockback CD",
	mindcontrolCD_bar = "Mind Control CD",
	mindcontrol_bar = "MC: %s",
	
	cmd = "Corrupter",

	corruption_cmd = "corruption",
	corruption_name = "Soul Corruption alert",
	corruption_desc = "Warn for Soul Corruption",

	mindcontrol_cmd = "mindcontrol",
	mindcontrol_name = "Mind Control alert",
	mindcontrol_desc = "Warn for Mind Control",
	
	mindcontrolsay_cmd = "mindcontrolsay",
	mindcontrolsay_name = "Mind Control Say",
	mindcontrolsay_desc = "Print in say when you get Mind Controlled.",

	icon_cmd = "icon",
	icon_name = "Raid Icon on Mind Control",
	icon_desc = "Put a raid Icon on the person who's mind controlled.\n(Requires assistant or higher)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsCorrupter = BigWigs:NewModule(boss)
BigWigsCorrupter.zonename = {
	AceLibrary("AceLocale-2.2"):new("BigWigs")["Outdoor Raid Bosses Zone"],
	AceLibrary("Babble-Zone-2.2")["Duskwood"],
}
BigWigsCorrupter.enabletrigger = boss
BigWigsCorrupter.synctoken = "Corrupter"
BigWigsCorrupter.toggleoptions = {"corruption", "mindcontrol", "mindcontrolsay", "icon", "bosskill"}
BigWigsCorrupter.revision = tonumber(string.sub("$Revision: 16941 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsCorrupter:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")										-- engage_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "Afflict")	-- mindcontrol_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Afflict")			-- corruption_trigger1 mindcontrol_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Afflict")			-- corruption_trigger1
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Afflict")	-- corruption_trigger1
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")				-- corruption_trigger2
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Aurafade")					-- mcfade_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Aurafade")				-- mcfade_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Aurafade")				-- mcfade_trigger
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "CorrupterKnockback", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "CorrupterMC", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "CorrupterMCEnd", 5)
end

------------------------------
--      Event Handlers      --
------------------------------


function BigWigsCorrupter:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["engage_trigger"]) then
		if self.db.profile.corruption then
			self:TriggerEvent("BigWigs_StartBar", self, L["corruption_bar"], 10, "Interface\\Icons\\spell_shadow_fumble", true, "Green")
		end
		if self.db.profile.mindcontrol then
			self:TriggerEvent("BigWigs_StartBar", self, L["mindcontrolCD_bar"], 15, "Interface\\Icons\\spell_shadow_shadowworddominate")
		end
	end
end

function BigWigsCorrupter:Afflict(msg)
	local _, _, name, detect = string.find(msg, L["mindcontrol_trigger"])
	if string.find(msg, L["corruption_trigger1"]) then
		self:TriggerEvent("BigWigs_SendSync", "CorrupterKnockback")		
	elseif name and detect then
		if detect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "CorrupterMC "..UnitName("player"))
			if self.db.profile.mindcontrolsay then
				SendChatMessage(L["mindcontrol_msg_me"], "SAY")
			end
		else
			self:TriggerEvent("BigWigs_SendSync", "CorrupterMC "..name)
		end		
	end
end

function BigWigsCorrupter:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["corruption_trigger2"]) then
		self:TriggerEvent("BigWigs_SendSync", "CorrupterKnockback")		
	end
end

function BigWigsCorrupter:Aurafade(msg)
	local _, _, name = string.find(msg, L["mcfade_trigger"])
	if name then
		if name == "you" then
			self:TriggerEvent("BigWigs_SendSync", "CorrupterMCEnd "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "CorrupterMCEnd "..name)
		end
	end	
end

function BigWigsCorrupter:BigWigs_RecvSync(sync, rest)
	if sync == "CorrupterKnockback" and self.db.profile.corruption then
		self:TriggerEvent("BigWigs_StartBar", self, L["corruption_bar"], 5, "Interface\\Icons\\spell_shadow_fumble", true, "Green")
	elseif sync == "CorrupterMC" and rest then
		if self.db.profile.mindcontrol then
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["mindcontrol_bar"], rest), 30, "Interface\\Icons\\spell_shadow_shadowworddominate", true, "White")
			self:SetCandyBarOnClick("BigWigsBar "..string.format(L["mindcontrol_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
			self:TriggerEvent("BigWigs_StartBar", self, L["mindcontrolCD_bar"], 40, "Interface\\Icons\\spell_shadow_shadowworddominate")
			if rest == UnitName("player") then
				self:TriggerEvent("BigWigs_Message", L["mindcontrol_msg_you"], "Personal", true, "Alarm")
				self:TriggerEvent("BigWigs_Message", string.format(L["mindcontrol_msg"], UnitName("player")), "Important", nil, "Alert", true)		
			else
				self:TriggerEvent("BigWigs_Message", string.format(L["mindcontrol_msg"], rest), "Important", nil, "Alert")
			end
		end
		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", rest)
		end
	elseif sync == "CorrupterMCEnd" and rest then
		if self.db.profile.mindcontrol then
			self:TriggerEvent("BigWigs_StopBar", self, string.format(L["mindcontrol_bar"], rest))
		end
		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_RemoveRaidIcon", rest)
		end
	end
end