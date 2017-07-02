-- edited by Masil for Kronos II
-- version 2

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Majordomo Executus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	disabletrigger = "Impossible",

	magic_gain = "gains Magic Reflection",
	dmg_gain = "gains Damage Shield",
	magic_fade = "Magic Reflection fades",
	dmg_fade = "Damage Shield fades",
	healdead = "Flamewaker Healer dies\.",
	elitedead = "Flamewaker Elite dies\.",
	elitename = "Flamewaker Elite",
	healername = "Flamewaker Healer",

	magic_gain_msg = "Magic Reflection for 10 seconds!",
	dmg_gain_msg = "Damage Shield for 10 seconds!",
	auras_warn = "3 seconds until new auras!",
	magic_fade_msg = "Magic Reflection down!",
	dmg_fade_msg = "Damage Shield down!",
	hdeadmsg = "%d/4 Flamewaker Healers dead!",
	edeadmsg = "%d/4 Flamewaker Elites dead!",

	magic_bar = "Magic Reflection",
	dmg_bar = "Damage Shield",
	auras_bar = "New shields",

	cmd = "Majordomo",
	
	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Healers and Elites",
	
	magic_cmd = "magic",
	magic_name = "Magic Reflection",
	magic_desc = "Warn for Magic Reflection",
	
	dmg_cmd = "dmg",
	dmg_name = "Damage Shield",
	dmg_desc = "Warn for Damage Shield",
} end)

L:RegisterTranslations("deDE", function() return {
	disabletrigger = "Impossible",

	magic_gain = "bekommt \'Magiereflexion'",
	dmg_gain = "bekommt \'Schadensschild'",
	magic_fade = "Magiereflexion schwindet von",
	dmg_fade = "Schadensschild schwindet von",
	healdead = "Flamewaker Healer stirbt",
	elitedead = "Flamewaker Elite stirbt",
	elitename = "Flamewaker Elite",
	healername = "Flamewaker Healer",

	magic_gain_msg = "Magiereflexion f\195\188r 10 Sekunden!",
	dmg_gain_msg = "Schadensschild f\195\188r 10 Sekunden!",
	auras_warn = "Neue Schilder in 3 Sekunden!",
	magic_fade_msg = "Magiereflexion beendet!",
	dmg_fade_msg = "Schadensschild beendet!",
	hdeadmsg = "%d/4 Heiler tot!",
	edeadmsg = "%d/4 Elite tot!",

	cmd = "Majordomo",
	
	magic_bar = "Magiereflexion",
	dmg_bar = "Schadensschild",
	auras_bar = "N\195\164chstes Schild",

	adds_cmd = "adds",
	adds_name = "Z\195\164hler f\195\188r tote Adds",
	adds_desc = "Verk\195\188ndet Flamewaker Healers und Flamewaker Elites Tod.",
	
	magic_cmd = "magic",
	magic_name = "Magiereflexion",
	magic_desc = "Warnung, wenn Magiereflexion aktiv.",
	
	dmg_cmd = "dmg",
	dmg_name = "Schadensschild",
	dmg_desc = "Warnung, wenn Schadensschild aktiv.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMajordomo = BigWigs:NewModule(boss)
BigWigsMajordomo.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsMajordomo.enabletrigger = boss
BigWigsMajordomo.wipemobs = { L["elitename"], L["healername"] }
BigWigsMajordomo.toggleoptions = {"magic", "dmg", "adds", "bosskill"}
BigWigsMajordomo.revision = tonumber(string.sub("$Revision: 11204 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMajordomo:OnEnable()
	hdead = 0
	edead = 0
	started = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "DomoHealerDeadX", 0.7)
	self:TriggerEvent("BigWigs_ThrottleSync", "DomoEliteDeadX", 0.7)
	self:TriggerEvent("BigWigs_ThrottleSync", "DomoAuraDamage", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "DomoAuraMagic", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "DomoAuraDamageFade", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "DomoAuraMagicFade", 2)
end

function BigWigsMajordomo:VerifyEnable(unit)
	return UnitCanAttack("player", unit)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsMajordomo:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["disabletrigger"]) then
		if self.db.profile.bosskill then
			self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s has been defeated"], self:ToString()), "Bosskill", nil, "Victory")
		end
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsMajordomo:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if string.find(msg, L["magic_gain"]) then
		self:TriggerEvent("BigWigs_SendSync", "DomoAuraMagic")
	elseif string.find(msg, L["dmg_gain"]) then
		self:TriggerEvent("BigWigs_SendSync", "DomoAuraDamage")
	end
end

function BigWigsMajordomo:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if string.find(msg, L["magic_fade"]) then
		self:TriggerEvent("BigWigs_SendSync", "DomoAuraMagicFade")
	elseif string.find(msg, L["dmg_fade"]) then
		self:TriggerEvent("BigWigs_SendSync", "DomoAuraDamageFade")
	end
end

function BigWigsMajordomo:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == L["healdead"] then
		self:TriggerEvent("BigWigs_SendSync", "DomoHealerDeadX "..tostring(hdead + 1))
	elseif msg == L["elitedead"] then
		self:TriggerEvent("BigWigs_SendSync", "DomoEliteDeadX "..tostring(edead + 1))
	end
end

function BigWigsMajordomo:BigWigs_RecvSync(sync, rest)
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		if self.db.profile.magic or self.db.profile.dmg then
			self:TriggerEvent("BigWigs_StartBar", self, L["auras_bar"], 10, "Interface\\Icons\\Spell_Frost_Wisp")
			self:ScheduleEvent("BigWigs_Message", 7, L["auras_warn"], "Attention")
		end
	elseif sync == "DomoHealerDeadX" and rest and self.db.profile.adds then
		if tonumber(rest) == (hdead + 1) then
			hdead = (hdead + 1)
			self:TriggerEvent("BigWigs_Message", string.format(L["hdeadmsg"], hdead), "Positive")
		end
	elseif sync == "DomoEliteDeadX" and rest and self.db.profile.adds then
		if tonumber(rest) == (edead + 1) then
			edead = (edead + 1)
			self:TriggerEvent("BigWigs_Message", string.format(L["edeadmsg"], edead), "Positive")
		end
	elseif sync == "DomoAuraMagic" then
		if self.db.profile.magic then
			self:TriggerEvent("BigWigs_Message", L["magic_gain_msg"], "Urgent", nil, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, L["magic_bar"], 10, "Interface\\Icons\\Spell_Frost_FrostShock")
		end
		if (self.db.profile.magic or self.db.profile.dmg) then
			self:TriggerEvent("BigWigs_StartBar", self, L["auras_bar"], 30, "Interface\\Icons\\Spell_Frost_Wisp")
			self:ScheduleEvent("BigWigs_Message", 27, L["auras_warn"], "Attention")
		end
	elseif sync == "DomoAuraMagicFade" then
		if self.db.profile.magic then
			self:TriggerEvent("BigWigs_Message", L["magic_fade_msg"], "Positive")
		end
	elseif sync == "DomoAuraDamage" then
		if self.db.profile.dmg then
			self:TriggerEvent("BigWigs_Message", L["dmg_gain_msg"], "Urgent", nil, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, L["dmg_bar"], 10, "Interface\\Icons\\Spell_Shadow_AntiShadow")
		end
		if (self.db.profile.magic or self.db.profile.dmg) then
			self:TriggerEvent("BigWigs_StartBar", self, L["auras_bar"], 30, "Interface\\Icons\\Spell_Frost_Wisp")
			self:ScheduleEvent("BigWigs_Message", 27, L["auras_warn"], "Attention")
		end
	elseif sync == "DomoAuraDamageFade" then
		if self.db.profile.magic then
			self:TriggerEvent("BigWigs_Message", L["dmg_fade_msg"], "Positive")
		end
	end
end
