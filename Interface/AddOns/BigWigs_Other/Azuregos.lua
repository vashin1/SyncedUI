-- edited by Masil for Kronos II
-- version 1

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Azuregos"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	teleport_trigger 	= "Come, little ones",							-- CHAT_MSG_MONSTER_YELL
	shieldUP_trigger 	= "Azuregos gains Reflection\.",				-- CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS
	shieldDown_trigger 	= "Reflection fades from Azuregos\.",			-- CHAT_MSG_SPELL_AURA_GONE_OTHER
	breath_trigger 		= "Azuregos begins to perform Frost Breath\.",	-- CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE
	manaStorm_trigger 	= "Manastorm",									-- CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE

	teleport_warn 		= "Teleport in 5 sec!",
	shieldUp_msg 		= "Magic Reflection up! Dispel it!",
	shieldDown_msg 		= "Magic Reflection down!",
	manaStorm_msg 		= "Move from Manastorm!",

	teleportCD_bar 		= "Next Teleport",
	shield_bar 			= "Magic Reflection",
	breathCast_bar 		= "Frost Breath cast",
	breathCD_bar 		= "Frost Breath CD",
	
	cmd = "Azuregos",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for teleport",

	shield_cmd = "shield",
	shield_name = "Magic Reflection Alert",
	shield_desc = "Warn for Magic Reflection",
	
	breath_cmd = "breath",
	breath_name = "Frost Breath Alert",
	breath_desc = "Warn for Frost Breath",
	
	manastorm_cmd = "manastorm",
	manastorm_name = "Manastorm Alert",
	manastorm_desc = "Warn when you stand in Manastorm",

} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsAzuregos = BigWigs:NewModule(boss)
BigWigsAzuregos.zonename = { AceLibrary("AceLocale-2.2"):new("BigWigs")["Outdoor Raid Bosses Zone"], AceLibrary("Babble-Zone-2.2")["Azshara"] }
BigWigsAzuregos.enabletrigger = boss
BigWigsAzuregos.toggleoptions = {"teleport", "shield", "breath", "manastorm", "bosskill"}
BigWigsAzuregos.revision = tonumber(string.sub("$Revision: 17179 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsAzuregos:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")									-- teleport_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")				-- shieldUP_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")						-- shieldDown_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")			-- breath_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")					-- manaStorm_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsAzuregos:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.teleport and string.find(msg, L["teleport_trigger"]) then
		self:TriggerEvent("BigWigs_StartBar", self, L["teleportCD_bar"], 30, "Interface\\Icons\\spell_arcane_portalironforge")
		self:ScheduleEvent("BigWigs_Message", 25, L["teleport_warn"], "Attention", nil, "Alert")
	end
end

function BigWigsAzuregos:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if self.db.profile.shield and msg == L["shieldUP_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["shieldUp_msg"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["shield_bar"], 10, "Interface\\Icons\\spell_shadow_teleport", true, "Blue")
	end
end

function BigWigsAzuregos:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if self.db.profile.shield and msg == L["shieldDown_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["shieldDown_msg"], "Positive")
		self:TriggerEvent("BigWigs_StopBar", self, L["shield_bar"])
	end
end

function BigWigsAzuregos:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if self.db.profile.breath and msg == L["breath_trigger"] then
		self:TriggerEvent("BigWigs_StartBar", self, L["breathCast_bar"], 2, "Interface\\Icons\\spell_frost_frostnova", true, "Red")
		self:ScheduleEvent("BigWigs_StartBar", 2, self, L["breathCD_bar"], 8, "Interface\\Icons\\spell_frost_frostnova", true, "Yellow")
	end
end

function BigWigsAzuregos:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if self.db.profile.manastorm and string.find(msg, L["manaStorm_trigger"]) then
		self:TriggerEvent("BigWigs_Message", L["manaStorm_msg"], "Personal", true, "Alarm")
	end
end
