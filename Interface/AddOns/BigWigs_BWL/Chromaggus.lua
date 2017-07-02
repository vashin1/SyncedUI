-- edited by Masil for Kronos II
-- version 2

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Chromaggus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local BreathCache = {}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd 				= "Chromaggus",

	enrage_cmd 			= "enrage",
	enrage_name 		= "Enrage",
	enrage_desc 		= "Warn for Enrage phase at 20%.",

	frenzy_cmd 			= "frenzy",
	frenzy_name 		= "Frenzy",
	frenzy_desc 		= "Warn for Frenzy.",

	breath_cmd 			= "breath",
	breath_name 		= "Breaths",
	breath_desc 		= "Warn for Breaths.",

	vulnerability_cmd 	= "vulnerability",
	vulnerability_name 	= "Vulnerability",
	vulnerability_desc 	= "Warn for Vulnerability changes.",

	Breath_Trigger 		= "Chromaggus begins to cast (.+)\.",
	VulnShift_Trigger 	= "flinches as its skin shimmers.",
	Vuln_Trigger 		= "^[%w']+ [%w' ]+ ([%w]+) Chromaggus for ([%d]+) ([%w ]+) damage%..*",
	Frenzy_Trigger 		= "goes into a killing frenzy",
	FrenzyFade_Trigger 	= "Frenzy fades from Chromaggus\.",
	Enrage_Trigger 		= "Chromaggus gains Enrage\.",

	hit 				= "hits",
	crit 				= "crits",

	FirstBreaths_Warn 	= "Breath in 5 seconds!",
	Breath_Warn 		= "%s in 5 seconds!",
	BreathCast_Msg 		= "%s is casting!",
	Vuln_Msg 			= "Vulnerability: %s!",
	VulnShift_Msg 		= "Spell vulnerability changed!",
	Frenzy_Msg 			= "Frenzy! TRANQ NOW!",
	Enrage_Msg 			= "Chromaggus is enraged!",

	breath1 			= "Time Lapse",
	breath2 			= "Corrosive Acid",
	breath3 			= "Ignite Flesh",
	breath4 			= "Incinerate",
	breath5 			= "Frost Burn",

	breathcolor1 		= "black",
	breathcolor2 		= "green",
	breathcolor3 		= "orange",
	breathcolor4 		= "red",
	breathcolor5 		= "blue",

	icon1 				= "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar",
	icon2 				= "Interface\\Icons\\Spell_Nature_Acid_01",
	icon3 				= "Interface\\Icons\\Spell_Fire_Fire",
	icon4 				= "Interface\\Icons\\Spell_Shadow_ChillTouch",
	icon5 				= "Interface\\Icons\\Spell_Frost_ChillingBlast",

	FirstBreath_Bar 	= "First Breath",
	SecondBreath_Bar 	= "Second Breath",
	BreathCast_Bar 		= "Cast %s",
	Frenzy_Bar 			= "Frenzy",
	FrenzyNext_Bar 		= "Next frenzy",
    Vuln_Bar 			= "%s Vulnerability",
} end )

L:RegisterTranslations("deDE", function() return {
	enrage_name = "Wutanfall",
	enrage_desc = "Warn for Enrage phase at 20%.", -- needs translation

	frenzy_name = "Raserei",
	frenzy_desc = "Warnung, wenn Chromaggus in Raserei ger\195\164t.",

	breath_name = "Atem",
	breath_desc = "Warnung, wenn Chromaggus seinen Atem wirkt.",

	vulnerability_name = "Zauber-Verwundbarkeiten",
	vulnerability_desc = "Warnung, wenn Chromagguss Zauber-Verwundbarkeit sich \195\164ndert.",

	Breath_Trigger = "^Chromaggus beginnt (.+) zu wirken\.",
	Vuln_Trigger = "^[^%s]+ .* trifft Chromaggus(.+)f\195\188r ([%d]+) ([%w ]+)'schaden%..*", -- ?
	Frenzy_Trigger = "goes into a killing frenzy",
	FrenzyFade_Trigger = "Raserei schwindet von Chromaggus\.",
	VulnShift_Trigger = "flinches as its skin shimmers.",
	Enrage_Trigger = "Chromaggus gains Enrage\.", -- needs translation

	hit = "trifft",
	crit = "kritisch",

	FirstBreaths_Warn = "Atem in 5 Sekunden!",
	Breath_Warn = "%s in 5 Sekunden!",
	BreathCast_Msg = "Chromaggus wirkt: %s Atem!",
	Vuln_Msg = "Zauber-Verwundbarkeit: %s",
	VulnShift_Msg = "Zauber-Verwundbarkeit ge\195\164ndert!",
	Frenzy_Msg = "Raserei - Einlullender Schuss!",
	Enrage_Msg = "Chromaggus is enraged!", -- needs translation

	breath1 = "Zeitraffer",
	breath2 = "\195\132tzende S\195\164ure",
	breath3 = "Fleisch entz\195\188nden",
	breath4 = "Verbrennen",
	breath5 = "Frostbeulen",

	breathcolor1 = "black",
	breathcolor2 = "green",
	breathcolor3 = "orange",
	breathcolor4 = "red",
	breathcolor5 = "blue",

	icon1 = "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar",
	icon2 = "Interface\\Icons\\Spell_Nature_Acid_01",
	icon3 = "Interface\\Icons\\Spell_Fire_Fire",
	icon4 = "Interface\\Icons\\Spell_Shadow_ChillTouch",
	icon5 = "Interface\\Icons\\Spell_Frost_ChillingBlast",

	BreathCast_Bar = "Wirkt %s",
	Frenzy_Bar = "Raserei",
	FrenzyNext_Bar = "Next frenzy", -- needs translation
	FirstBreath_Bar = "Erster Atem",
	SecondBreath_Bar = "Zweite Atem",
    Vuln_Bar = "%s Vulnerability", -- needs translation
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsChromaggus = BigWigs:NewModule(boss)
BigWigsChromaggus.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsChromaggus.enabletrigger = boss
BigWigsChromaggus.toggleoptions = { "enrage", "frenzy", "breath", "vulnerability", "bosskill"}
BigWigsChromaggus.revision = tonumber(string.sub("$Revision: 11211 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsChromaggus:OnEnable()
	self.vulnerability = nil
	self.started = nil
	self.lastVuln = 0
	self.lastFrenzy = 0
	
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")					-- Breath_Trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")								-- FrenzyFade_Trigger
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")										-- Frenzy_Trigger VulnShift_Trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")						-- Enrage_Trigger
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents")				-- Vuln_Trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents")				-- Vuln_Trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents")				-- Vuln_Trigger
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")	-- Vuln_Trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ChromaggusBreath", 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "ChromaggusFrenzyStart", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "ChromaggusFrenzyStop", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsChromaggus:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["Enrage_Trigger"] and self.db.profile.enrage then
		self:TriggerEvent("BigWigs_Message", L["Enrage_Msg"], "Important")
	end
end

function BigWigsChromaggus:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
	local _,_, spellName = string.find(msg, L["Breath_Trigger"])
	if spellName then
		local breath = L:HasReverseTranslation(spellName) and L:GetReverseTranslation(spellName) or nil
		if not breath then return end
		breath = string.sub(breath, -1)
		self:TriggerEvent("BigWigs_SendSync", "ChromaggusBreath "..breath)
	end
end

function BigWigsChromaggus:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BossEngaged" and rest == boss and not self.started then
		self.started = true
		if self.db.profile.breath then
            local LocalFirstBreath_Warn 	= L["FirstBreaths_Warn"]
            local LocalFirstBreath_Bar 		= L["FirstBreath_Bar"]
			local LocalFirstIcon			= "Interface\\Icons\\INV_Misc_QuestionMark"
			local LocalFirstColor			= "Cyan"
            local LocalSecondBreath_Warn	= L["FirstBreaths_Warn"]
            local LocalSecondBreath_Bar 	= L["SecondBreath_Bar"]
			local LocalSecondIcon			= "Interface\\Icons\\INV_Misc_QuestionMark"
			local LocalSecondColor			= "Cyan"
            if table.getn(BreathCache) >= 1 then
				local breath1st 			= L:HasReverseTranslation(BreathCache[1]) and L:GetReverseTranslation(BreathCache[1]) or nil
				if breath1st then
					breath1st 				= string.sub(breath1st, -1)
					LocalFirstIcon			= L["icon"..breath1st]
					LocalFirstColor			= L["breathcolor"..breath1st]
				end
                LocalFirstBreath_Warn   	= string.format(L["Breath_Warn"], BreathCache[1])
                LocalFirstBreath_Bar  		= BreathCache[1]
				if table.getn(BreathCache) == 2 then
					local breath2nd 		= L:HasReverseTranslation(BreathCache[2]) and L:GetReverseTranslation(BreathCache[2]) or nil
					if breath2nd then
						breath2nd 			= string.sub(breath2nd, -1)
						LocalSecondIcon		= L["icon"..breath2nd]
						LocalSecondColor	= L["breathcolor"..breath2nd]
					end
					LocalSecondBreath_Warn 	= string.format(L["Breath_Warn"], BreathCache[2])
					LocalSecondBreath_Bar 	= BreathCache[2]
				end
            end
			self:ScheduleEvent("BigWigs_Message", 25, LocalFirstBreath_Warn, "Attention", nil, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, LocalFirstBreath_Bar, 30, LocalFirstIcon, true, LocalFirstColor)
			self:ScheduleEvent("BigWigs_Message", 55, LocalSecondBreath_Warn, "Attention", nil, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, LocalSecondBreath_Bar, 60, LocalSecondIcon, true, LocalSecondColor)
		end
		if self.db.profile.frenzy then
			self:TriggerEvent("BigWigs_StartBar", self, L["FrenzyNext_Bar"], 15, "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "White")
		end
	elseif sync == "ChromaggusBreath" and self.db.profile.breath then
		local spellName = L:HasTranslation("breath"..rest) and L["breath"..rest] or nil
		if not spellName then return end
        if table.getn(BreathCache) < 2 then
            BreathCache[table.getn(BreathCache)+1] = spellName
        end
		self:TriggerEvent("BigWigs_StartBar", self, string.format( L["BreathCast_Bar"], spellName), 2, L["icon"..rest])
		self:TriggerEvent("BigWigs_Message", string.format(L["BreathCast_Msg"], spellName), "Urgent")
		self:ScheduleEvent("bwchromaggusbreath"..spellName, "BigWigs_Message", 55, string.format(L["Breath_Warn"], spellName), "Attention", nil, "Alert")
		self:ScheduleEvent("BigWigs_StartBar", 2, self, spellName, 58, L["icon"..rest], true, L["breathcolor"..rest])
	elseif sync == "ChromaggusFrenzyStart" and self.db.profile.frenzy then
		self:TriggerEvent("BigWigs_Message", L["Frenzy_Msg"], "Magenta", nil, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["Frenzy_Bar"], 8, "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "Magenta")
        self.lastFrenzy = GetTime()
	elseif sync == "ChromaggusFrenzyStop" and self.db.profile.frenzy then
		self:TriggerEvent("BigWigs_StopBar", self, L["Frenzy_Bar"])
		if self.lastFrenzy ~= 0 then
			self:TriggerEvent("BigWigs_StartBar", self, L["FrenzyNext_Bar"], ((self.lastFrenzy + 15) - GetTime()), "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "White")
		end
	end
end

function BigWigsChromaggus:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["Frenzy_Trigger"]) and arg2 == boss then
		self:TriggerEvent("BigWigs_SendSync", "ChromaggusFrenzyStart")
	elseif string.find(msg, L["VulnShift_Trigger"]) and self.db.profile.vulnerability then
		self:TriggerEvent("BigWigs_Message", L["VulnShift_Msg"], "Positive")
		if self.vulnerability then
			self:TriggerEvent("BigWigs_StopBar", self, format(L["Vuln_Bar"], self.vulnerability))
		end
		self:TriggerEvent("BigWigs_StartBar", self, format(L["Vuln_Bar"], "???"), 45, "Interface\\Icons\\INV_Misc_QuestionMark", true, "Yellow")
        self.lastVuln = GetTime()
		self.vulnerability = nil
	end
end

function BigWigsChromaggus:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if msg == L["FrenzyFade_Trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "ChromaggusFrenzyStop")
	end
end

function BigWigsChromaggus:PlayerDamageEvents(msg)
	if not self.db.profile.vulnerability then return end
	if (not self.vulnerability) then
		local _,_, type, dmg, school = string.find(msg, L["Vuln_Trigger"])
		if ( type == L["hit"] or type == L["crit"] ) and tonumber(dmg or "") and school then
			if (tonumber(dmg) >= 550 and type == L["hit"]) or (tonumber(dmg) >= 1100 and type == L["crit"]) then
				self.vulnerability = school
				self:TriggerEvent("BigWigs_Message", format(L["Vuln_Msg"], school), "Positive")
				self:TriggerEvent("BigWigs_StopBar", self, format(L["Vuln_Bar"], "???"))
				if self.lastVuln then
					self:TriggerEvent("BigWigs_StartBar", self, format(L["Vuln_Bar"], school), (self.lastVuln + 45) - GetTime(), "Interface\\Icons\\Spell_Shadow_BlackPlague", true, "Yellow")
				end
			end
		end
	end
end