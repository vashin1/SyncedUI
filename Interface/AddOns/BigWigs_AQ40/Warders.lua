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
	
	dustcloud_trigger = "afflicted by Dust Cloud",
	dustcloudresist_trigger = "Dust Cloud was resisted",
	dustcloud_bar = "Dust Cloud CD",
	
	silence_trigger = "afflicted by Silence",
	silenceresist_trigger = "Silence was resisted",
	silence_bar = "Silence CD",
	
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
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE") --root_trigger, fear_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PLAYER_DAMAGE", "Event") --firenova_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event") --firenova_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event") --silence_trigger, silenceresist_trigger, dustcloud_trigger, dustcloudresist_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event") --silence_trigger, silenceresist_trigger, dustcloud_trigger, dustcloudresist_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event") --silence_trigger, silenceresist_trigger, dustcloud_trigger, dustcloudresist_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderFireNova1", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderRoot1", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderDustCloud1", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderSilence1", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "WarderFear1", 4)
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
	if sync == "WarderFireNova1" and self.db.profile.firenova then
		self:FireNova()
	elseif sync == "WarderRoot1" and self.db.profile.root then
		self:Root()
	elseif sync == "WarderDustCloud1" and self.db.profile.dustcloud then
		self:DustCloud()
	elseif sync == "WarderSilence1" and self.db.profile.silence then
		self:Silence()
	elseif sync == "WarderFear1" and self.db.profile.fear then
		self:Fear()
	end
end

function BigWigsWarders:Event(msg)
	if string.find(msg, L["firenova_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WarderFireNova1")
	elseif (string.find(msg, L["dustcloud_trigger"]) or string.find(msg, L["dustcloudresist_trigger"])) then
		self:TriggerEvent("BigWigs_SendSync", "WarderDustCloud1")
	elseif (string.find(msg, L["silence_trigger"]) or string.find(msg, L["silenceresist_trigger"])) then
		self:TriggerEvent("BigWigs_SendSync", "WarderSilence1")
	end
end

function BigWigsWarders:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["root_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WarderRoot1")
	elseif string.find(msg, L["fear_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WarderFear1")
	end
end

function BigWigsWarders:FireNova()
	self:TriggerEvent("BigWigs_StartBar", self, L["firenova_bar"], 4.0, "Interface\\Icons\\Spell_Fire_SealOfFire", true, "Orange")
end

function BigWigsWarders:Root()
	self:TriggerEvent("BigWigs_StopBar", self, L["root_bar"])
	self:TriggerEvent("BigWigs_StartBar", self, L["rootcast_bar"], 1.5, "Interface\\Icons\\Spell_Nature_StrangleVines", true, "Green")
	self:ScheduleEvent("BigWigs_StartBar", 1.5, self, L["root_bar"], 8, "Interface\\Icons\\Spell_Nature_StrangleVines", true, "Green")
end

function BigWigsWarders:DustCloud()
	self:TriggerEvent("BigWigs_StartBar", self, L["dustcloud_bar"], 17, "Interface\\Icons\\Spell_Nature_Sleep", true, "Yellow")
end

function BigWigsWarders:Silence()
	self:TriggerEvent("BigWigs_StartBar", self, L["silence_bar"], 17, "Interface\\Icons\\Spell_Frost_IceShock", true, "Gray")
end

function BigWigsWarders:Fear()
	self:TriggerEvent("BigWigs_StopBar", self, L["fear_bar"])
	self:TriggerEvent("BigWigs_StartBar", self, L["fearcast_bar"], 1.5, "Interface\\Icons\\Spell_Shadow_Possession", true, "Red")
	self:ScheduleEvent("BigWigs_StartBar", 1.5, self, L["fear_bar"], 17, "Interface\\Icons\\Spell_Shadow_Possession", true, "White")
end


