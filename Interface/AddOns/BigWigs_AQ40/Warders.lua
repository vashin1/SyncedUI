------------------------------
--		Are you local?		--
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Anubisath Warder"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Warder",
	
	firenova_cmd = "firenova",
	firenova_name = "Fire Nova Alert",
	firenova_desc = "Warn for Fire Nova",
	
	root_cmd = "root",
	root_name = "Root Alert",
	root_desc = "Warn for Root",
	
	dustcloud_cmd = "dustcloud",
	dustcloud_name = "Dust Cloud Alert",
	dustcloud_desc = "Warn for Dust Cloud",
	
	silence_cmd = "silence",
	silence_name = "Silence Alert",
	silence_desc = "Warn for Silence",
	
	fear_cmd = "fear",
	fear_name = "Fear Alert",
	fear_desc = "Warn for Fear",
	
	firenova_trigger = "Fire Nova",
	firenova_bar = "Next Fire Nova",
	
	root_trigger = "begins to cast Entangling Roots",
	root_bar = "Next Entangling Roots",
	rootcast_bar = "Entangling Roots cast",
	
	dustcloud_trigger = "Dust Cloud",
	dustcloud_bar = "Next Dust Cloud",
	
	silence_trigger = "Silence",
	silence_bar = "Next Silence",
	
	fear_trigger = "begins to cast Fear",
	fear_bar = "Next Fear",
	fearcast_bar = "Fear cast",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsWarders = BigWigs:NewModule(boss)
BigWigsWarders.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
BigWigsWarders.enabletrigger = boss
BigWigsWarders.toggleoptions = { "firenova", "root", "dustcloud", "silence", "fear", "bosskill"}
BigWigsWarders.revision = tonumber(string.sub("$Revision: 19999 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsWarders:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE") --root_trigger, fear_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PLAYER_DAMAGE", "Event") --firenova_trigger, dustcloud_trigger, silence_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event") --firenova_trigger, dusctcloud_trigger, silence_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderFireNova", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderRoot", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderDustCloud", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderSilence", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderFear", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsWarders:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, boss) then
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsWarders:BigWigs_RecvSync(sync, rest, nick)
	if sync == "WarderFireNova" and self.db.profile.firenova then
		self:FireNova()
	elseif sync == "WarderRoot" and self.db.profile.root then
		self:Root()
	elseif sync == "WarderDustCloud" and self.db.profile.dustcloud then
		self:DustCloud()
	elseif sync == "WarderSilence" and self.db.profile.silence then
		self:Silence()
	elseif sync == "WarderFear" and self.db.profile.fear then
		self:Fear()
	end
end

function BigWigsWarders:Event(msg)
	if string.find(msg, L["firenova_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WarderFireNova")
	elseif string.find(msg, L["dustcloud_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WarderDustCloud")
	elseif string.find(msg, L["silence_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WarderSilence")
	end
end

function BigWigsWarders:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["root_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WarderRoot")
	elseif string.find(msg, L["fear_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WarderFear")
	end
end

function BigWigsWarders:FireNova()
	self:TriggerEvent("BigWigs_StopBar", self, L["firenova_bar"])
	self:TriggerEvent("BigWigs_StartBar", self, L["firenova_bar"], 4.3, "Interface\\Icons\\Spell_Fire_SealOfFire", true, "Orange")
end

function BigWigsWarders:Root()
	self:TriggerEvent("BigWigs_StopBar", self, L["root_bar"])
	self:TriggerEvent("BigWigs_StartBar", self, L["rootcast_bar"], 1.5, "Interface\\Icons\\Spell_Nature_StrangleVines", true, "Green")
	self:ScheduleEvent("BigWigs_StartBar", 1.5, self, L["root_bar"], 8, "Interface\\Icons\\Spell_Nature_StrangleVines", true, "Green")
end

function BigWigsWarders:DustCloud()
	self:TriggerEvent("BigWigs_StopBar", self, L["dustcloud_bar"])
	self:TriggerEvent("BigWigs_StartBar", self, L["dustcloud_bar"], 17, "Interface\\Icons\\Spell_Nature_Sleep", true, "Yellow")
end

function BigWigsWarders:Silence()
	self:TriggerEvent("BigWigs_StopBar", self, L["silence_bar"])
	self:TriggerEvent("BigWigs_StartBar", self, L["silence_bar"], 17, "Interface\\Icons\\Spell_Frost_IceShock", true, "Gray")
end

function BigWigsWarders:Fear()
	self:TriggerEvent("BigWigs_StopBar", self, L["fear_bar"])
	self:TriggerEvent("BigWigs_StartBar", self, L["fearcast_bar"], 1.5, "Interface\\Icons\\Spell_Shadow_Possession", true, "Red")
	self:ScheduleEvent("BigWigs_StartBar", 1.5, self, L["fear_bar"], 17, "Interface\\Icons\\Spell_Shadow_Possession", true, "White")
end


