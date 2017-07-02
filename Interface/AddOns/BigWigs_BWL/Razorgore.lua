-- edited by Masil for Kronos II
-- version 4

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Razorgore the Untamed"]
local controller = AceLibrary("Babble-Boss-2.2")["Grethok the Controller"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Razorgore",

	mage_name = "Blackwing Mage",
	legion_name = "Blackwing Legionnaire",
	dragon_name = "Death Talon Dragonspawn",
	
	start_message = "Razorgore engaged!",
	phase2_message = "All eggs destroyed! Razorgore is loose!",

	mobs_soon = "First wave in 5sec!",
	mobs_bar = "First wave",

	mc_trigger = "^(.+) (.+) afflicted by Dominate Mind\.",
	mindcontrol_message = "%s is Mind Controlled!",
	mindcontrol_message_you = "You are Mind Controlled!",
	mindcontrol_message_me = "Mind Control on me!",
	mindcontrol_bar = "MC: %s",
	mcfade_trigger = "Dominate Mind fades from (.*)\.",

	poly_trigger = "^(.+) (.+) afflicted by Greater Polymorph\.",
	polymorph_message = "%s is polymorphed!",
	polymorph_message_you = "You are polymorphed!",
	polymorph_bar = "Polymorph: %s",
	polyfade_trigger = "Greater Polymorph fades from (.*)\.",

	deathyou_trigger = "You die\.",
	deathother_trigger = "(.+) dies\.",
	
	orbcontrol_trigger = "^(.+) (.+) afflicted by Mind Exhaustion\.",
	orb_bar = "Orb control: %s",

	destroyegg_yell1 = "You'll pay for forcing me to do this\.",
	destroyegg_yell2 = "Fools! These eggs are more precious than you know!",
	destroyegg_yell3 = "No - not another one! I'll have your heads for this atrocity!",
	
	egg_trigger = "Razorgore the Untamed begins to cast Destroy Egg\.",
	egg_message = "%d/30 eggs destroyed!",
	egg_bar = "Destroy Egg",

	volley_trigger = "Razorgore the Untamed begins to cast Fireball Volley\.",
	volley_bar = "Fireball Volley",
	volleynext_bar = "Next Fireball Volley",
	volley_message = "Hide!",

	conflagration_trigger = "^(.+) (.+) afflicted by Conflagration\.",
	conflagration_bar = "Conflagration: %s",

	mc_cmd = "mindcontrol",
	mc_name = "Mind Control",
	mc_desc = "Announces who gets mind controlled and starts a clickable bar for easy selection.",
	
	mcsay_cmd = "mindcontrolsay",
	mcsay_name = "Mind Control Say",
	mcsay_desc = "Print in say when you get Mind Controlled.",

	polymorph_cmd = "polymorph",
	polymorph_name = "Greater Polymorph",
	polymorph_desc = "Tells you who got polymorphed by Grethok the Controller and starts a clickable bar for easy selection.",
	
	eggs_cmd = "eggs",
	eggs_name = "Eggs",
	eggs_desc = "Does a counter for Black Dragon Eggs destroyed.",

	phase_cmd = "phase",
	phase_name = "Phase",
	phase_desc = "Warn for Phase Change.",

	mobs_cmd = "mobs",
	mobs_name = "First wave",
	mobs_desc = "Shows you when the first wave spawns.",

	orb_cmd = "orb",
	orb_name = "Orb Control",
	orb_desc = "Shows you who is controlling the boss and starts a clickable bar for easy selection.",

	ktm_cmd = "ktm",
	ktm_name = "Phase 2 KTM reset",
	ktm_desc = "Reset KTM when transitioning to phase 2.\n\n(Requires assistant or higher)",

	fireballvolley_cmd = "fireballvolley",
	fireballvolley_name = "Fireball Volley",
	fireballvolley_desc = "Announces when the boss is casting Fireball Volley.",

	conflagration_cmd = "conflagration",
	conflagration_name = "Conflagration",
	conflagration_desc = "Starts a bar with the duration of the Conflagration.",
	
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRazorgore = BigWigs:NewModule(boss)
BigWigsRazorgore.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsRazorgore.enabletrigger = { boss, controller }
BigWigsRazorgore.wipemobs = { L["mage_name"], L["legion_name"], L["dragon_name"] }
BigWigsRazorgore.toggleoptions = { "phase", "mobs", "eggs", "polymorph", "mc", "mcsay", "orb", "fireballvolley", "conflagration", "ktm", "bosskill" }
BigWigsRazorgore.revision = tonumber(string.sub("$Revision: 11212 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRazorgore:OnEnable()
	self.started = nil
	self.previousorb = nil
	self.eggs = 0
	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")										-- destroyegg_yell1 destroyegg_yell2 destroyegg_yell3
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF")						-- egg_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Afflict")			-- mc_trigger poly_trigger conflagration_trigger orbcontrolyou_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Afflict")			-- mc_trigger poly_trigger conflagration_trigger orbcontrolother_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Afflict")	-- mc_trigger poly_trigger conflagration_trigger orbcontrolother_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "Afflict")	-- ??? conflagration_trigger when friendly player mind controlled? ???
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "AuraGone")					-- mcfade_trigger polyfade_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "AuraGone")				-- mcfade_trigger polyfade_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "AuraGone")				-- mcfade_trigger polyfade_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")							-- deathyou_trigger deathother_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")				-- volley_trigger in phase 2
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE")						-- volley_trigger when controlled
	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")	
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	
	self:RegisterEvent("BigWigs_RecvSync")	
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgoreEgg", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgoreOrbStart", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgoreOrbStop", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgorePhase2", 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgoreVolleyCast", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgoreMC", 1)
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgoreMCEnd", 1)
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgorePoly", 1)
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgorePolyEnd", 1)
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgoreConflag", 3)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsRazorgore:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["destroyegg_yell1"] or msg == L["destroyegg_yell2"] or msg == L["destroyegg_yell3"] then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreEgg "..tostring(self.eggs + 1))
	end
end

function BigWigsRazorgore:CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF(msg)
	if string.find(msg, L["egg_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreEggStart")
	end
end

function BigWigsRazorgore:Afflict(msg)
	local _, _, mcname, mcdetect = string.find(msg, L["mc_trigger"])
	local _, _, polyname, polydetect = string.find(msg, L["poly_trigger"])
	local _, _, orbname, orbdetect = string.find(msg, L["orbcontrol_trigger"])
	local _, _, conflagname, conflagdetect = string.find(msg, L["conflagration_trigger"])
	if mcname and mcdetect then
		if mcdetect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "RazorgoreMC "..UnitName("player"))
			if self.db.profile.mcsay then
				SendChatMessage(L["mindcontrol_message_me"], "SAY")
			end
		else
			self:TriggerEvent("BigWigs_SendSync", "RazorgoreMC "..mcname)
		end		
	elseif polyname and polydetect then
		if polydetect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "RazorgorePoly "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "RazorgorePoly "..polyname)
		end		
	elseif orbname and orbdetect then
		if orbdetect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "RazorgoreOrbStart "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "RazorgoreOrbStart "..orbname)
		end		
	elseif conflagname and conflagdetect then
		if conflagdetect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "RazorgoreConflag "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "RazorgoreConflag "..conflagname)
		end		
	end
end

function BigWigsRazorgore:AuraGone(msg)
	local _, _, mcfade = string.find(msg, L["mcfade_trigger"])
	local _, _, polyfade = string.find(msg, L["polyfade_trigger"])
	if mcfade == "you" then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreMCEnd "..UnitName("player"))
	elseif mcfade then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreMCEnd "..mcfade)
	elseif polyfade == "you" then
		self:TriggerEvent("BigWigs_SendSync", "RazorgorePolyEnd "..UnitName("player"))
	elseif polyfade then
		self:TriggerEvent("BigWigs_SendSync", "RazorgorePolyEnd "..polyfade)
	end
end

function BigWigsRazorgore:CHAT_MSG_COMBAT_FRIENDLY_DEATH(msg)
	local _, _, dead = string.find(msg, L["deathother_trigger"])
	if msg == L["deathyou_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreMCEnd "..UnitName("player"))
		self:TriggerEvent("BigWigs_SendSync", "RazorgorePolyEnd "..UnitName("player"))
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreOrbStop "..UnitName("player"))
	elseif dead then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreMCEnd "..dead)
		self:TriggerEvent("BigWigs_SendSync", "RazorgorePolyEnd "..dead)
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreOrbStop "..dead)
	end
end


function BigWigsRazorgore:CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE(msg)
	if self.db.profile.fireballvolley and msg == L["volley_trigger"] then
		self:TriggerEvent("BigWigs_StartBar", self, L["volley_bar"], 2, "Interface\\Icons\\Spell_Fire_FlameBolt", true, "blue")
	end
end

function BigWigsRazorgore:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["volley_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreVolleyCast")
	end
end

function BigWigsRazorgore:PLAYER_REGEN_ENABLED()
	local bosscontrol = false
	for i = 1, GetNumRaidMembers() do
		if UnitName("raidpet"..i) == boss then
			bosscontrol = true
			break
		end
	end
	if not bosscontrol then
		self:CheckForWipe()
	end
end

function BigWigsRazorgore:BigWigs_RecvSync(sync, rest)
	------------
	-- Engage --
	------------
	if sync == self:GetEngageSync() and not self.started and rest == boss then
		self.started = true
		self:SafeUnregister("PLAYER_REGEN_DISABLED")
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["start_message"], "Attention")
		end
		if self.db.profile.mobs then
			self:TriggerEvent("BigWigs_StartBar", self, L["mobs_bar"], 46, "Interface\\Icons\\Spell_Holy_PrayerOfHealing")
			self:ScheduleEvent("BigWigs_Message", 41, L["mobs_soon"], "Attention")
		end
	------------------------
	-- Phase 2 transition --
	------------------------
	elseif sync == "RazorgorePhase2" then
		self:CancelScheduledEvent("destroyegg_check")
		self:CancelScheduledEvent("orbcontrol_check")
		self:SafeUnregister("CHAT_MSG_MONSTER_YELL")
		self:SafeUnregister("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF")
		self:SafeUnregister("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
		self:SafeUnregister("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE")
		if self.previousorb and self.db.profile.orb then
			self:TriggerEvent("BigWigs_StopBar", self, string.format(L["orb_bar"], self.previousorb))
		end
		if self.db.profile.eggs then
			self:TriggerEvent("BigWigs_StopBar", self, L["egg_bar"])
		end
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phase2_message"], "Urgent", nil, "Alert")
		end
		if IsAddOnLoaded("KLHThreatMeter") and self.db.profile.ktm and (IsRaidLeader() or IsRaidOfficer()) then
			klhtm.net.clearraidthreat()
		end	
	----------------------
	-- Volley & Conflag --
	----------------------
	elseif sync == "RazorgoreVolleyCast" and self.db.profile.fireballvolley then
		self:TriggerEvent("BigWigs_Message", L["volley_message"], "Important", nil, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["volley_bar"], 2, "Interface\\Icons\\Spell_Fire_FlameBolt", true, "red")
		self:ScheduleEvent("BigWigs_StartBar", 2, self, L["volleynext_bar"], 13, "Interface\\Icons\\Spell_Fire_FlameBolt", true, "Yellow")
	elseif sync == "RazorgoreConflag" and rest and self.db.profile.conflagration then
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["conflagration_bar"], rest), 10, "Interface\\Icons\\Spell_Fire_Incinerate", true, "Orange")		
		self:SetCandyBarOnClick("BigWigsBar "..string.format(L["conflagration_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
	---------------
	-- MC & Poly --
	---------------
	elseif sync == "RazorgoreMC" and rest and self.db.profile.mc then
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["mindcontrol_bar"], rest), 15, "Interface\\Icons\\Spell_Shadow_ShadowWordDominate", true, "black")
		self:SetCandyBarOnClick("BigWigsBar "..string.format(L["mindcontrol_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
		if rest == UnitName("player") then
			self:TriggerEvent("BigWigs_Message", L["mindcontrol_message_you"], "Personal", true)
			self:TriggerEvent("BigWigs_Message", string.format(L["mindcontrol_message"], UnitName("player")), "Urgent", nil, nil, true)		
		else
			self:TriggerEvent("BigWigs_Message", string.format(L["mindcontrol_message"], rest), "Urgent")
		end
	elseif sync == "RazorgoreMCEnd" and rest and self.db.profile.mc then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["mindcontrol_bar"], rest))
	elseif sync == "RazorgorePoly" and rest and self.db.profile.polymorph then
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["polymorph_bar"], rest), 20, "Interface\\Icons\\Spell_Nature_Brilliance", true, "cyan")
		self:SetCandyBarOnClick("BigWigsBar "..string.format(L["polymorph_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
		if rest == UnitName("player") then
			self:TriggerEvent("BigWigs_Message", L["polymorph_message_you"], "Personal", true)
			self:TriggerEvent("BigWigs_Message", string.format(L["polymorph_message"], UnitName("player")), "Urgent", nil, nil, true)		
		else
			self:TriggerEvent("BigWigs_Message", string.format(L["polymorph_message"], rest), "Urgent")
		end
	elseif sync == "RazorgorePolyEnd" and rest and self.db.profile.polymorph then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["polymorph_bar"], rest))
	------------------
	-- Egg counting --
	------------------
	elseif sync == "RazorgoreEgg" and rest then
		if tonumber(rest) == (self.eggs + 1) then
			self.eggs = (self.eggs + 1)
			if self.eggs == 30 then	-- phase 2 transition
				self:TriggerEvent("BigWigs_SendSync", "RazorgorePhase2")
			elseif self.db.profile.eggs then
				self:TriggerEvent("BigWigs_Message", string.format(L["egg_message"], self.eggs), "Positive")
			end
			if self.eggs == 5 then	-- some optimization
				self:SafeUnregister("CHAT_MSG_SPELL_AURA_GONE_SELF")
				self:SafeUnregister("CHAT_MSG_SPELL_AURA_GONE_PARTY")
				self:SafeUnregister("CHAT_MSG_SPELL_AURA_GONE_OTHER")
				self:SafeUnregister("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
			end
		end
	elseif sync == "RazorgoreEggStart" then
		self:CancelScheduledEvent("destroyegg_check")
		self:ScheduleEvent("destroyegg_check", self.DestroyEggCheck, 3, self)
		if self.db.profile.eggs then
			self:TriggerEvent("BigWigs_StartBar", self, L["egg_bar"], 3, "Interface\\Icons\\INV_Misc_MonsterClaw_02", true, "purple")
		end
	-----------------
	-- Orb control --
	-----------------
	elseif sync == "RazorgoreOrbStart" and rest then
		self:CancelScheduledEvent("destroyegg_check")
		self:CancelScheduledEvent("orbcontrol_check")
		if self.db.profile.orb then
			if self.previousorb then
				self:TriggerEvent("BigWigs_StopBar", self, string.format(L["orb_bar"], self.previousorb))
			end
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["orb_bar"], rest), 90, "Interface\\Icons\\INV_Misc_Gem_Pearl_03", true, "white")
			self:SetCandyBarOnClick("BigWigsBar "..string.format(L["orb_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
		end
		self:ScheduleEvent("orbcontrol_check", self.OrbControlCheck, 1, self)
		self.previousorb = rest
	elseif sync == "RazorgoreOrbStop" then
		self:CancelScheduledEvent("destroyegg_check")
		self:CancelScheduledEvent("orbcontrol_check")
		if self.db.profile.orb and rest then
			self:TriggerEvent("BigWigs_StopBar", self, string.format(L["orb_bar"], rest))
		end
		if self.db.profile.fireballvolley then
			self:TriggerEvent("BigWigs_StopBar", self, L["volley_bar"])
		end
		if self.db.profile.eggs then
			self:TriggerEvent("BigWigs_StopBar", self, L["egg_bar"])
		end
	end
end

-----------------------------
--     Other Functions     --
-----------------------------

function BigWigsRazorgore:SafeUnregister(event)
	if self:IsEventRegistered(event) then
		self:UnregisterEvent(event)
	end
end

function BigWigsRazorgore:OrbControlCheck()
	local bosscontrol = false
	for i = 1, GetNumRaidMembers() do
		if UnitName("raidpet"..i) == boss then
			bosscontrol = true
			break
		end
	end
	if bosscontrol then
		self:ScheduleEvent("orbcontrol_check", self.OrbControlCheck, 1, self)
	elseif GetRealZoneText() == "Blackwing Lair" then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreOrbStop "..self.previousorb)
	end
end

function BigWigsRazorgore:DestroyEggCheck()
	local bosscontrol = false
	for i = 1, GetNumRaidMembers() do
		if UnitName("raidpet"..i) == boss then
			bosscontrol = true
			break
		end
	end
	if bosscontrol then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreEgg "..tostring(self.eggs + 1))
	end
end