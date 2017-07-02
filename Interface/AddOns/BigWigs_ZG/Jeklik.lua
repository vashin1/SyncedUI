-- edited by Masil for Kronos II
-- version 3

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Priestess Jeklik"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	phaseone_trigger = "Lord Hir'eek, grant me wings of vengance!",
	phasetwo_trigger = "I command you to rain fire down upon these invaders!",
	liquidfirehitsyou_trigger = "Gurubashi Bat Rider's Blaze hits you for",
	liquidfireabsorbyou_trigger = "You absorb Gurubashi Bat Rider's Blaze\.",
	liquidfireresistyou_trigger = "Gurubashi Bat Rider's Blaze was resisted\.",
	liquidfireimmuneyou_trigger = "Gurubashi Bat Rider's Blaze failed. You are immune\.",
	mindflay_trigger = "^(.+) (.+) afflicted by Mind Flay\.",
	mindflayend_trigger = "Mind Flay fades from (.*)\.",
	fear_trigger = "afflicted by Psychic Scream\.",
	heal_trigger = "High Priestess Jeklik begins to cast Great Heal\.",
	
	greatheal_msg = "Heal! Interrupt it!",
	phaseone_msg = "Bat Phase",
	phasetwo_msg = "Troll Phase",
	fire_msg = "Move away from fire!",

	fearnext_bar = "Next Fear",
	mindflay_bar = "Mind Flay",
	greatheal_bar = "Heal",
	
	cmd = "Jeklik",

	phase_cmd = "phase",
	phase_name = "Phase Notification",
	phase_desc = "Announces the boss' phase transition",

	heal_cmd = "heal",
	heal_name = "Heal Alert",
	heal_desc = "Warn for healing",

	flay_cmd = "flay",
	flay_name = "Mind Flay Alert",
	flay_desc = "Warn for casting Mind Flay",

	fear_cmd = "fear",
	fear_name = "Fear Alert",
	fear_desc = "Warn for boss' fear",
	
	fire_cmd = "fire",
	fire_name = "Fire Warning",
	fire_desc = "Warns you when you stand in fire",
	
	ktm_cmd = "ktm",
	ktm_name = "KTM reset",
	ktm_desc = "Reset KTM when entering Phase 2",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsJeklik = BigWigs:NewModule(boss)
BigWigsJeklik.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
BigWigsJeklik.enabletrigger = boss
BigWigsJeklik.toggleoptions = {"phase", "heal", "flay", "fear", "fire", "ktm", "bosskill"}
BigWigsJeklik.revision = tonumber(string.sub("$Revision: 11212 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsJeklik:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")										-- phaseone_trigger phasetwo_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")					-- liquidfirehitsyou_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")					-- heal_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Afflict")			-- mindflay_trigger	fear_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Afflict")			-- mindflay_trigger	fear_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Afflict")	-- mindflay_trigger	fear_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "MindFlayEnd")				-- mindflayend_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "MindFlayEnd")				-- mindflayend_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "MindFlayEnd")				-- mindflayend_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "JeklikMindFlay", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "JeklikMindFlayEnd", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "JeklikFear", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "JeklikHeal", 4)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsJeklik:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["phaseone_trigger"]) and self.db.profile.phase then
		self:TriggerEvent("BigWigs_Message", L["phaseone_msg"], "Attention")
	elseif string.find(msg, L["phasetwo_trigger"]) then
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phasetwo_msg"], "Attention")					
		end
		if self.db.profile.fear then
			self:TriggerEvent("BigWigs_StartBar", self, L["fearnext_bar"], 45, "Interface\\Icons\\Spell_Shadow_PsychicScream", true, "White")
		end
		if IsAddOnLoaded("KLHThreatMeter") and self.db.profile.ktm and (IsRaidLeader() or IsRaidOfficer()) then
			klhtm.net.clearraidthreat()
		end
	end
end

function BigWigsJeklik:Afflict(msg)
	local _, _, name, detect = string.find(msg, L["mindflay_trigger"])
	if string.find(msg, L["fear_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "JeklikFear")
	elseif name and detect then
		if (detect == "are") or UnitIsInRaidByName(name) or UnitIsPetByName(name) then
			self:TriggerEvent("BigWigs_SendSync", "JeklikMindFlay")
		end
	end
end

function BigWigsJeklik:MindFlayEnd(msg)
	local _, _, name = string.find(msg, L["mindflayend_trigger"])
	if name then
		if name == "you" or UnitIsInRaidByName(name) or UnitIsPetByName(name) then
			self:TriggerEvent("BigWigs_SendSync", "JeklikMindFlayEnd")
		end
	end
end

function BigWigsJeklik:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["heal_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "JeklikHeal")
	end
end

function BigWigsJeklik:CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(msg)
	if self.db.profile.fire then
		if string.find(msg, L["liquidfirehitsyou_trigger"]) or string.find(msg, L["liquidfireabsorbyou_trigger"]) or string.find(msg, L["liquidfireresistyou_trigger"]) or string.find(msg, L["liquidfireimmuneyou_trigger"]) then
			self:TriggerEvent("BigWigs_Message", L["fire_msg"], "Personal", true, "Alarm")
		end
	end
end

function BigWigsJeklik:BigWigs_RecvSync(sync)
	if sync == "JeklikHeal" and self.db.profile.heal then
		self:TriggerEvent("BigWigs_Message", L["greatheal_msg"], "Important", "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["greatheal_bar"], 4, "Interface\\Icons\\Spell_Holy_Heal", true, "Yellow")		
	elseif sync == "JeklikFear" and self.db.profile.fear then
		self:TriggerEvent("BigWigs_StartBar", self, L["fearnext_bar"], 45, "Interface\\Icons\\Spell_Shadow_PsychicScream", true, "White")
	elseif sync == "JeklikMindFlay" then
		if self.db.profile.heal then
			self:TriggerEvent("BigWigs_StopBar", self, L["greatheal_bar"])			
		end
		if self.db.profile.flay then
			self:TriggerEvent("BigWigs_StopBar", self, L["mindflay_bar"])
			self:TriggerEvent("BigWigs_StartBar", self, L["mindflay_bar"], 10, "Interface\\Icons\\Spell_Shadow_SiphonMana", true, "Blue")
		end
	elseif sync == "JeklikMindFlayEnd" and self.db.profile.flay then
		self:TriggerEvent("BigWigs_StopBar", self, L["mindflay_bar"])
	end
end