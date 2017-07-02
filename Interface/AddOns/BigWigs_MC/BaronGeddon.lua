-- edited by Masil for Kronos II
-- version 2

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Baron Geddon"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	inferno_trigger = "Baron Geddon is afflicted by Inferno\.",
	infernoend_trigger = "Inferno fades from Baron Geddon\.",
	ignitemana_trigger = "^(.+) (.+) afflicted by Ignite Mana\.",
	bomb_trigger = "^(.+) (.+) afflicted by Living Bomb\.",
	bombend_trigger = "Living Bomb fades from (.*)\.",
	deathyou_trigger = "You die\.",
	deathother_trigger = "(.+) dies",
	service_trigger1 = "performs one last service for Ragnaros",
	service_trigger2 = "Baron Geddon is afflicted by Armageddon\.",

	inferno_bar = "Next Inferno",
	inferno_channel = "Inferno",
	ignitemana_bar = "Next Ignite Mana",
	nextbomb_bar = "Possible Living Bomb",
	bomb_bar = "%s - Living Bomb",
	service_bar = "Last Service",
	
	inferno_warn = "Inferno soon!",
	inferno_msg = "Inferno!",
	ignitemana_msg = "Ignite Mana! Dispel NOW!",
	bomb_msg_you = "You are the bomb!",
	bomb_msg_other = "%s is the bomb!",
	service_msg = "Last Service! Baron Geddon exploding in 8 seconds!",
	

	cmd = "Baron",

	inferno_cmd = "inferno",
	inferno_name = "Inferno alert",
	inferno_desc = "Timer bar for Geddon's Inferno.",

	mana_cmd = "mana",
	mana_name = "Ignite Mana alert",
	mana_desc = "Shows timers for Ignite Mana and announce to dispel it",

	bomb_cmd = "bomb",
	bomb_name = "Living Bomb alert",
	bomb_desc = "Warn when players are the bomb",

	whisper_cmd = "whisper",
	whisper_name = "Whisper to Bomb targets",
	whisper_desc = "Sends a whisper to players targetted by Living Bomb.\n(Requires assistant or higher)",

	icon_cmd = "icon",
	icon_name = "Raid Icon on bomb",
	icon_desc = "Put a Raid Icon on the person who's the bomb.\n(Requires assistant or higher)",

	service_cmd = "service",
	service_name = "Last Service warning",
	service_desc = "Timer bar for Geddon's last service.",

} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBaronGeddon = BigWigs:NewModule(boss)
BigWigsBaronGeddon.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsBaronGeddon.enabletrigger = boss
BigWigsBaronGeddon.toggleoptions = {"inferno", "mana", "bomb", "whisper", "icon", "service", "bosskill"}
BigWigsBaronGeddon.revision = tonumber(string.sub("$Revision: 11203 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsBaronGeddon:OnEnable()
	started = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Afflict")	-- ignitemana_trigger bomb_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Afflict")			-- ignitemana_trigger bomb_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Afflict")			-- ignitemana_trigger bomb_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")					-- inferno_trigger service_trigger2
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Aurafade")					-- bombend_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Aurafade")				-- bombend_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Aurafade")				-- bombend_trigger infernoend_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")							-- deathyou_trigger deathother_trigger
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")									-- service_trigger1
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonBombX", 15)
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonBombStop", 15)
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonServiceX", 15)
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonManaIgniteX", 15)
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonInfernoX", 15)
	self:TriggerEvent("BigWigs_ThrottleSync", "GeddonInfernoStop", 15)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsBaronGeddon:CHAT_MSG_COMBAT_FRIENDLY_DEATH(msg)
	local _, _, name = string.find(msg, L["deathother_trigger"])
	if msg == L["deathyou_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "GeddonBombStop "..UnitName("player"))
	elseif name then
		self:TriggerEvent("BigWigs_SendSync", "GeddonBombStop "..name)
	end
end

function BigWigsBaronGeddon:Aurafade(msg)
	local _, _, name = string.find(msg, L["bombend_trigger"])
	if name then
		if name == "you" then
			self:TriggerEvent("BigWigs_SendSync", "GeddonBombStop "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "GeddonBombStop "..name)
		end
	elseif msg == L["infernoend_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "GeddonInfernoStop")
	end	
end

function BigWigsBaronGeddon:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if msg == L["inferno_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "GeddonInfernoX")
	elseif msg == L["service_trigger2"] then
		self:TriggerEvent("BigWigs_SendSync", "GeddonServiceX")
	end	
end

function BigWigsBaronGeddon:Afflict(msg)
	local _, _, name, detect = string.find(msg, L["bomb_trigger"])
	if string.find(msg, L["ignitemana_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "GeddonManaIgniteX")		
	elseif name and detect then
		if detect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "GeddonBombX "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "GeddonBombX "..name)
		end		
	end
end

function BigWigsBaronGeddon:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["service_trigger1"]) then
		self:TriggerEvent("BigWigs_SendSync", "GeddonServiceX")
	end
end

function BigWigsBaronGeddon:BigWigs_RecvSync(sync, rest, nick)
	if sync == self:GetEngageSync() and rest == boss and not started then
		started = true
		if self.db.profile.mana then
			self:TriggerEvent("BigWigs_StartBar", self, L["ignitemana_bar"], 30, "Interface\\Icons\\Spell_Fire_Incinerate", true, "Blue")	
		end
		if self.db.profile.bomb then
			self:TriggerEvent("BigWigs_StartBar", self, L["nextbomb_bar"], 35, "Interface\\Icons\\Inv_Enchant_EssenceAstralSmall", true, "White")			
			self:ScheduleEvent("bombskipped", "BigWigs_StartBar", 40, self, L["nextbomb_bar"], 30, "Interface\\Icons\\Inv_Enchant_EssenceAstralSmall", true, "White")
		end
		if self.db.profile.inferno then
			self:TriggerEvent("BigWigs_StartBar", self, L["inferno_bar"], 45, "Interface\\Icons\\Spell_Fire_Incinerate", true, "Orange")
			self:ScheduleEvent("BigWigs_Message", 40, L["inferno_warn"], "Attention")
		end
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	elseif sync == "GeddonManaIgniteX" and self.db.profile.mana then
		self:TriggerEvent("BigWigs_StartBar", self, L["ignitemana_bar"], 30, "Interface\\Icons\\Spell_Fire_Incinerate", true, "Blue")		
		self:TriggerEvent("BigWigs_Message", L["ignitemana_msg"], "Blue")
	elseif sync == "GeddonBombX" and rest and self.db.profile.bomb then
		self:CancelScheduledEvent("bombskipped")
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["bomb_bar"], rest), 8, "Interface\\Icons\\Inv_Enchant_EssenceAstralSmall", true, "Red")
		self:SetCandyBarOnClick("BigWigsBar "..string.format(L["bomb_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
		self:TriggerEvent("BigWigs_StartBar", self, L["nextbomb_bar"], 35, "Interface\\Icons\\Inv_Enchant_EssenceAstralSmall", true, "White")
		if rest == UnitName("player") then
			self:TriggerEvent("BigWigs_Message", L["bomb_msg_you"], "Personal", true, "Alarm")
			self:TriggerEvent("BigWigs_Message", string.format(L["bomb_msg_other"], UnitName("player")), "Important", nil, "Alert", true)		
		else
			self:TriggerEvent("BigWigs_Message", string.format(L["bomb_msg_other"], rest), "Important", nil, "Alert")
			if self.db.profile.whisper then
				self:TriggerEvent("BigWigs_SendTell", rest, L["bomb_msg_you"])
			end
		end
		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", rest)
		end
		self:ScheduleEvent("bombskipped", "BigWigs_StartBar", 40, self, L["nextbomb_bar"], 30, "Interface\\Icons\\Inv_Enchant_EssenceAstralSmall", true, "White")
	elseif sync == "GeddonBombStop" and rest and self.db.profile.bomb then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["bomb_bar"], rest))
		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_RemoveRaidIcon", rest)
		end	
	elseif sync == "GeddonInfernoX" and self.db.profile.inferno then
		self:TriggerEvent("BigWigs_StartBar", self, L["inferno_channel"], 8, "Interface\\Icons\\Spell_Fire_Incinerate", true, "Red")
		self:TriggerEvent("BigWigs_Message", L["inferno_msg"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["inferno_bar"], 45, "Interface\\Icons\\Spell_Fire_Incinerate", true, "Orange")
		self:ScheduleEvent("BigWigs_Message", 40, L["inferno_warn"], "Attention")
	elseif sync == "GeddonInfernoStop" and self.db.profile.inferno then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["inferno_channel"]))
	elseif sync == "GeddonServiceX" and self.db.profile.service then
		self:TriggerEvent("BigWigs_StartBar", self, L["service_bar"], 8, "Interface\\Icons\\Spell_Fire_SelfDestruct", true, "Red")
		self:TriggerEvent("BigWigs_Message", L["service_msg"], "Important")
	end
end