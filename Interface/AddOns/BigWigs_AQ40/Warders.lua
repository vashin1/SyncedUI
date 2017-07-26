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
	firenova_bar = "Fire Nova CD",
	
	root_trigger = "begins to cast Entangling Roots",
	root_bar = "Entangling Roots CD",
	rootcast_bar = "Entangling Roots cast",
	
	dustcloud_trigger = "begins to perform Dust Cloud",
	dustcloud_bar = "Dust Cloud CD",
	dustcloudcast_bar = "Dust Cloud cast",
	
	silence_trigger = "begins to cast Silence",
	silence_bar = "Silence CD",
	silencecast_bar = "Silence cast",
	
	fear_trigger = "begins to cast Fear",
	fear_bar = "Fear CD",
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
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE") --root_trigger, fear_trigger, silence_trigger, dustcloud_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PLAYER_DAMAGE", "Event") --firenova_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event") --firenova_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderFireNova2", 1)
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderRoot2", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderDustCloud2", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderSilence2", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderFear2", 4)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsWarders:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, boss) then
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsWarders:BigWigs_RecvSync(sync, rest)
	if sync == "WarderFireNova2" and self.db.profile.firenova then
		self:FireNova()
	elseif sync == "WarderRoot2" and self.db.profile.root then
		self:Root()
	elseif sync == "WarderDustCloud2" and self.db.profile.dustcloud then
		self:DustCloud()
	elseif sync == "WarderSilence2" and self.db.profile.silence then
		self:Silence()
	elseif sync == "WarderFear2" and self.db.profile.fear then
		self:Fear()
	end
end

function BigWigsWarders:Event(msg)
	if string.find(msg, L["firenova_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WarderFireNova2")
	end
end

function BigWigsWarders:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["root_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WarderRoot2")
	elseif string.find(msg, L["fear_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WarderFear2")
	elseif string.find(msg, L["silence_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WarderSilence2")
	elseif string.find(msg, L["dustcloud_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WarderDustCloud2")
	end
end

function BigWigsWarders:FireNova()
	self:TriggerEvent("BigWigs_StartBar", self, L["firenova_bar"], 2.9, "Interface\\Icons\\Spell_Fire_SealOfFire", true, "Orange")
end

function BigWigsWarders:Root()
	self:TriggerEvent("BigWigs_StopBar", self, L["root_bar"])
	self:TriggerEvent("BigWigs_StartBar", self, L["rootcast_bar"], 1.5, "Interface\\Icons\\Spell_Nature_StrangleVines", true, "Green")
	self:ScheduleEvent("BigWigs_StartBar", 1.5, self, L["root_bar"], 7.9, "Interface\\Icons\\Spell_Nature_StrangleVines", true, "Green")
end

function BigWigsWarders:DustCloud()
	self:TriggerEvent("BigWigs_StopBar", self, L["dustcloud_bar"])
	self:TriggerEvent("BigWigs_StartBar", self, L["dustcloudcast_bar"], 1.5, "Interface\\Icons\\Spell_Nature_Sleep", true, "Yellow")
	self:ScheduleEvent("BigWigs_StartBar", 1.5, self, L["dustcloud_bar"], 13.8, "Interface\\Icons\\Spell_Nature_Sleep", true, "Yellow")
end

function BigWigsWarders:Silence()
	self:TriggerEvent("BigWigs_StopBar", self, L["silence_bar"])
	self:TriggerEvent("BigWigs_StartBar", self, L["silencecast_bar"], 1.5, "Interface\\Icons\\Spell_Frost_IceShock", true, "Gray")
	self:ScheduleEvent("BigWigs_StartBar", 1.5, self, L["silence_bar"], 15.7, "Interface\\Icons\\Spell_Frost_IceShock", true, "Gray")
end

function BigWigsWarders:Fear()
	self:TriggerEvent("BigWigs_StopBar", self, L["fear_bar"])
	self:TriggerEvent("BigWigs_StartBar", self, L["fearcast_bar"], 1.5, "Interface\\Icons\\Spell_Shadow_Possession", true, "Red")
	self:ScheduleEvent("BigWigs_StartBar", 1.5, self, L["fear_bar"], 16.4, "Interface\\Icons\\Spell_Shadow_Possession", true, "White")
end


