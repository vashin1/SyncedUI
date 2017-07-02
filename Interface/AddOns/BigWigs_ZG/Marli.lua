-- edited by Masil for Kronos II
-- version 2

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Priestess Mar'li"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {

	engage_trigger = "Draw me to your web mistress Shadra",
	spiderphase_trigger = "Shadra, make of me your avatar",
	trollphase_trigger = "The brood shall not fall",
	
	charge_trigger = "High Priestess Mar'li's Charge hits",
	
	drainlife_trigger = "^(.+) (.+) afflicted by Drain Life\.",
	drainlifefade_trigger = "Drain Life fades from (.*)\.",

	drainlife_msg = "Drain Life! Interrupt/dispel it!",
	trollphase_msg = "Troll phase",
	spiderphase_msg = "Spider phase",

	spiderphase_bar = "Next Spider Phase",
	trollphase_bar = "Next Troll Phase",
	charge_bar = "Charge CD",
	drainlife_bar = "%s - Drain Life",
	
	cmd = "Marli",
	
	charge_cmd = "charge",
	charge_name = "Charge Alert",
	charge_desc = "Warn for Charge",

	drain_cmd = "drain",
	drain_name = "Drain Life Alert",
	drain_desc = "Warn for life drain",
	
	phase_cmd = "phase",
	phase_name = "Phase Notification",
	phase_desc = "Announces the boss' phase transition",
	
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMarli = BigWigs:NewModule(boss)
BigWigsMarli.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
BigWigsMarli.enabletrigger = boss
BigWigsMarli.toggleoptions = {"phase", "drain", "charge", "bosskill"}
BigWigsMarli.revision = tonumber(string.sub("$Revision: 11203 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMarli:OnEnable()
	self.chargecounter = 0
	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")										-- engage_trigger spiderphase_trigger trollphase_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "ChargeHit")		-- charge_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "ChargeHit")		-- charge_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "ChargeHit")	-- charge_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Afflict")			-- drainlife_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Afflict")			-- drainlife_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Afflict")	-- drainlife_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "AuraFade")					-- drainlifefade_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "AuraFade")				-- drainlifefade_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "AuraFade")				-- drainlifefade_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MarliTroll", 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "MarliSpider", 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "MarliCharge", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "MarliDrain", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MarliDrainStop", 5)
end

------------------------------
--      Events          --
------------------------------

function BigWigsMarli:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["engage_trigger"]) or string.find(msg, L["trollphase_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "MarliTroll")
	elseif string.find(msg, L["spiderphase_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "MarliSpider")
	end
end

function BigWigsMarli:Afflict(msg)
	local _, _, name, detect = string.find(msg, L["drainlife_trigger"])
	if name and detect then
		if detect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "MarliDrain "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "MarliDrain "..name)
		end		
	end
end

function BigWigsMarli:AuraFade(msg)
	local _, _, name = string.find(msg, L["drainlifefade_trigger"])
	if name then
		if name == "you" then
			self:TriggerEvent("BigWigs_SendSync", "MarliDrainStop "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "MarliDrainStop "..name)
		end
	end
end

function BigWigsMarli:ChargeHit(msg)
	if string.find(msg, L["charge_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "MarliCharge")
	end
end

function BigWigsMarli:BigWigs_RecvSync(sync, rest)
	if sync == "MarliTroll" and self.db.profile.phase then
		self.chargecounter = 0
		self:TriggerEvent("BigWigs_Message", L["trollphase_msg"], "Attention")
		self:TriggerEvent("BigWigs_StartBar", self, L["spiderphase_bar"], 40, "Interface\\Icons\\Spell_Nature_Web")
	elseif sync == "MarliSpider" and self.db.profile.phase then
		self:TriggerEvent("BigWigs_Message", L["spiderphase_msg"], "Attention")
		self:TriggerEvent("BigWigs_StartBar", self, L["trollphase_bar"], 45, "Interface\\Icons\\Inv_misc_head_troll_02")
	elseif sync == "MarliCharge" then
		self.chargecounter = (self.chargecounter + 1)
		if self.db.profile.charge and (self.chargecounter < 3) then
			self:TriggerEvent("BigWigs_StartBar", self, L["charge_bar"], 15, "Interface\\Icons\\Ability_Warrior_Charge", true, "Red")
		end
	elseif sync == "MarliDrain" and rest and self.db.profile.drain then
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["drainlife_bar"], rest), 7, "Interface\\Icons\\Spell_Shadow_LifeDrain02", true, "Blue")
		self:SetCandyBarOnClick("BigWigsBar "..string.format(L["drainlife_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
		self:TriggerEvent("BigWigs_Message", L["drainlife_msg"], "Important", nil, "Alert")
	elseif sync == "MarliDrainStop" and rest and self.db.profile.drain then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["drainlife_bar"], rest))
	end
end
