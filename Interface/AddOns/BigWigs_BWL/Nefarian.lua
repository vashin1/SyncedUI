-- edited by Masil for Kronos II
-- version 6

------------------------------
--      Are you local?      --
------------------------------
local boss = AceLibrary("Babble-Boss-2.2")["Nefarian"]
local victor = AceLibrary("Babble-Boss-2.2")["Lord Victor Nefarius"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local warnpairs = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	engage_trigger = "In this world where time",
	landing_soon_trigger = "Well done, my minions",
	landing_trigger = "BURN! You wretches",
	zerg_trigger = "Impossible! Rise my",
	fear_trigger = "Nefarian begins to cast Bellowing Roar\.",
	shadowflame_trigger = "Nefarian begins to cast Shadow Flame\.",
	mc_trigger = "^(.+) (.+) afflicted by Shadow Command\.",
--	mcfade_trigger = "Shadow Command fades from (.*)\.",

	triggershamans	= "Shamans, show me",
	triggerdruid	= "Druids and your silly",
	triggerwarlock	= "Warlocks, you shouldn't be playing",
	triggerpriest	= "Priests! If you're going to keep",
	triggerhunter	= "Hunters and your annoying",
	triggerwarrior	= "Warriors, I know you can hit harder",
	triggerrogue	= "Rogues%? Stop hiding",
	triggerpaladin	= "Paladins",
	triggermage		= "Mages too%?",

	landing_soon_warning = "Nefarian landing in 10 seconds!",
	landing_warning = "Nefarian has landed!",
	zerg_warning = "Zerg incoming!",
	fear_warning = "Fear incoming!",
--	fear_soon_warning = "Fear in 5 sec!",
	shadowflame_warning = "Shadow Flame incoming!",
	classcall_warning = "Class call in 3 sec!",
	mindcontrol_msg = "%s is Mind Controlled!",
	mindcontrol_msg_you = "You are Mind Controlled!",
	mindcontrol_msg_me = "Mind Control on me!",

	warnshaman	= "Shamans - Totems spawned!",
	warndruid	= "Druids - Stuck in cat form!",
	warnwarlock	= "Warlocks - Incoming Infernals!",
	warnpriest	= "Priests - Heals hurt!",
	warnhunter	= "Hunters - Bows/Guns broken!",
	warnwarrior	= "Warriors - Stuck in Berserer Stance!",
	warnrogue	= "Rogues - Ported and rooted!",
	warnpaladin	= "Paladins - Blessing of Protection!",
	warnmage	= "Mages - Polymorphed!",

	start_bar = "Start",
	landing_bar = "Nefarian landing",
	classcall_bar = "Next Class Call",
	fear_bar = "Next Fear",
	fearcast_bar = "Fear cast",
	shadowflame_bar = "Next Shadow Flame",
	shadowflamecast_bar = "Shadow Flame cast",
	mindcontrol_bar = "MC: %s",

	cmd = "Nefarian",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn for Shadow Flame",

	fear_cmd = "fear",
	fear_name = "Warn for Fear",
	fear_desc = "Warn when Nefarian casts AoE Fear",

	classcall_cmd = "classcall",
	classcall_name = "Class Call alert",
	classcall_desc = "Warn for Class Calls",

	otherwarn_cmd = "otherwarn",
	otherwarn_name = "Other alerts",
	otherwarn_desc = "Landing and Zerg warnings",
	
	mindcontrol_cmd = "mindcontrol",
	mindcontrol_name = "Mind Control",
	mindcontrol_desc = "Announces who gets Mind Controlled and starts a clickable bar for easy selection.",

	mindcontrolsay_cmd = "mindcontrolsay",
	mindcontrolsay_name = "Mind Control Say",
	mindcontrolsay_desc = "Print in say when you get Mind Controlled.",

	ktm_cmd = "ktm",
	ktm_name = "Phase 2 KTM reset",
	ktm_desc = "Reset KTM when Nefarian lands.\n\n(Requires assistant or higher)",

} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsNefarian = BigWigs:NewModule(boss)
BigWigsNefarian.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsNefarian.enabletrigger = { boss, victor }
BigWigsNefarian.toggleoptions = {"shadowflame", "fear", "classcall", "otherwarn", "mindcontrol", "mindcontrolsay", "ktm", "bosskill"}
BigWigsNefarian.revision = tonumber(string.sub("$Revision: 17909 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsNefarian:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")				-- fear_trigger shadowflame_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "McStart")	-- mc_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "McStart")			-- mc_trigger
--[[self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "McEnd")					-- mcfade_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "McEnd")					-- mcfade_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "McEnd")					-- mcfade_trigger ]]

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "NefarianShadowflame", 6)
	self:TriggerEvent("BigWigs_ThrottleSync", "NefarianFear", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "NefarianMC", 5)
--	self:TriggerEvent("BigWigs_ThrottleSync", "NefarianMCEnd", 5)

	if not warnpairs then warnpairs = {
		[L["triggershamans"]] = {L["warnshaman"], true},
		[L["triggerdruid"]] = {L["warndruid"], true},
		[L["triggerwarlock"]] = {L["warnwarlock"], true},
		[L["triggerpriest"]] = {L["warnpriest"], true},
		[L["triggerhunter"]] = {L["warnhunter"], true},
		[L["triggerwarrior"]] = {L["warnwarrior"], true},
		[L["triggerrogue"]] = {L["warnrogue"], true},
		[L["triggerpaladin"]] = {L["warnpaladin"], true},
		[L["triggermage"]] = {L["warnmage"], true},
		[L["zerg_trigger"]] = {L["zerg_warning"]},
	} end
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsNefarian:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["engage_trigger"]) and self.db.profile.otherwarn then
		self:TriggerEvent("BigWigs_StartBar", self, L["start_bar"], 10, "Interface\\Icons\\Spell_Holy_PrayerOfHealing", true, "Cyan")
	elseif string.find(msg, L["landing_soon_trigger"]) and self.db.profile.otherwarn then
		self:TriggerEvent("BigWigs_StartBar", self, L["shadowflamecast_bar"], 10, "Interface\\Icons\\Spell_Fire_Incinerate", true, "Magenta")
		self:TriggerEvent("BigWigs_StartBar", self, L["landing_bar"], 12, "Interface\\Icons\\Spell_Holy_PrayerOfHealing", true, "Cyan")
		self:TriggerEvent("BigWigs_Message", L["landing_soon_warning"], "Attention")
	elseif string.find(msg, L["landing_trigger"]) then
		if self.db.profile.otherwarn then
			self:TriggerEvent("BigWigs_Message", L["landing_warning"], "Attention")
		end
		if self.db.profile.shadowflame then
			self:TriggerEvent("BigWigs_StartBar", self, L["shadowflame_bar"], 15, "Interface\\Icons\\Spell_Fire_Incinerate", true, "Yellow")
		end
		if self.db.profile.fear then
			self:TriggerEvent("BigWigs_StartBar", self, L["fear_bar"], 30, "Interface\\Icons\\Spell_Shadow_PsychicScream", true, "White")
		end
		if self.db.profile.classcall then
			self:ScheduleEvent("BigWigs_Message", 22, L["classcall_warning"], "Attention", nil, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, L["classcall_bar"], 35, "Interface\\Icons\\Spell_Shadow_Charm", true, "Green")
		end
		if self.db.profile.ktm and IsAddOnLoaded("KLHThreatMeter") and (IsRaidLeader() or IsRaidOfficer()) then
			klhtm.net.clearraidthreat()
		end
	else
		for i,v in pairs(warnpairs) do
			if string.find(msg, i) then
				if v[2] then
					if self.db.profile.classcall then
						self:TriggerEvent("BigWigs_Message", v[1], "Important")
						self:ScheduleEvent("BigWigs_Message", 27, L["classcall_warning"], "Attention", nil, "Alert")
						self:TriggerEvent("BigWigs_StartBar", self, L["classcall_bar"], 30, "Interface\\Icons\\Spell_Shadow_Charm", true, "Green")
					end
				else
					if self.db.profile.otherwarn then self:TriggerEvent("BigWigs_Message", v[1], "Attention") end
				end
				return
			end
		end
	end
end

function BigWigsNefarian:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["fear_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "NefarianFear")
	elseif msg == L["shadowflame_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "NefarianShadowflame")
	end
end

function BigWigsNefarian:McStart(msg)
	local _, _, name, detect = string.find(msg, L["mc_trigger"])
	if name and detect then
		if detect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "NefarianMC "..UnitName("player"))
			if self.db.profile.mindcontrolsay then
				SendChatMessage(L["mindcontrol_msg_me"], "SAY")
			end
		else
			self:TriggerEvent("BigWigs_SendSync", "NefarianMC "..name)
		end
	end
end

--[[function BigWigsNefarian:McEnd(msg)
	local _, _, mcfade = string.find(msg, L["mcfade_trigger"])
	if mcfade then
		if mcfade == "you" then
			self:TriggerEvent("BigWigs_SendSync", "NefarianMCEnd "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "NefarianMCEnd "..mcfade)
		end
	end
end]]

function BigWigsNefarian:BigWigs_RecvSync(sync, rest)
	if sync == "NefarianShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_StopBar", self, L["shadowflame_bar"])
		self:TriggerEvent("BigWigs_Message", L["shadowflame_warning"], "Urgent", true)
		self:TriggerEvent("BigWigs_StartBar", self, L["shadowflamecast_bar"], 2, "Interface\\Icons\\Spell_Fire_Incinerate", true, "Orange")
		self:ScheduleEvent("BigWigs_StartBar", 2, self, L["shadowflame_bar"], 10, "Interface\\Icons\\Spell_Fire_Incinerate", true, "Yellow")
	elseif sync == "NefarianFear" and self.db.profile.fear then
		self:TriggerEvent("BigWigs_StopBar", self, L["fear_bar"])
		self:TriggerEvent("BigWigs_Message", L["fear_warning"], "Important", nil, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["fearcast_bar"], 1.5, "Interface\\Icons\\Spell_Fire_Fire", true, "Red")
		self:ScheduleEvent("BigWigs_StartBar", 1.5, self, L["fear_bar"], 28.5, "Interface\\Icons\\Spell_Shadow_PsychicScream", true, "White")
--		self:ScheduleEvent("BigWigs_Message", 25, L["fear_soon_warning"], "Important", nil, "Alarm")
	elseif sync == "NefarianMC" and rest and self.db.profile.mindcontrol then
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["mindcontrol_bar"], rest), 15, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", true, "White")
		self:SetCandyBarOnClick("BigWigsBar "..string.format(L["mindcontrol_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
		if rest == UnitName("player") then
			self:TriggerEvent("BigWigs_Message", L["mindcontrol_msg_you"], "Personal", true)
			self:TriggerEvent("BigWigs_Message", string.format(L["mindcontrol_msg"], UnitName("player")), "Urgent", nil, nil, true)		
		else
			self:TriggerEvent("BigWigs_Message", string.format(L["mindcontrol_msg"], rest), "Urgent")
		end
--[[elseif sync == "NefarianMCEnd" and rest and self.db.profile.mindcontrol then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["mindcontrol_bar"], rest)) ]]
	end
end