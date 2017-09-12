------------------------------
--		Are you local?		--
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Living Monstrosity"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Monstrosity",
	
	lightningtotem_cmd = "lightningtotem",
	lightningtotem_name = "Lightning Totem Alert",
	lightningtotem_desc = "Warn for Lightning Totem summon",
	
	lightningtotem_trigger = "Living Monstrosity begins to cast Lightning Totem",
	lightningtotem_bar = "SUMMON LIGHTNING TOTEM",
	lightningtotem_message = "LIGHTNING TOTEM INC",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsLivingMonstrosity = BigWigs:NewModule(boss)
BigWigsLivingMonstrosity.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
BigWigsLivingMonstrosity.enabletrigger = boss
BigWigsLivingMonstrosity.toggleoptions = { "lightningtotem", "bosskill" }
BigWigsLivingMonstrosity.revision = tonumber(string.sub("$Revision: 19999 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsLivingMonstrosity:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE") --lightningtotem_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsLivingMonstrosity:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, boss) then
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsLivingMonstrosity:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["lightningtotem_trigger"]) and self.db.profile.lightningtotem then
		self:TriggerEvent("BigWigs_Message", L["lightningtotem_message"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["lightningtotem_bar"], 0.5, "Interface\Icons\Spell_Nature_Lightning")
	end
end