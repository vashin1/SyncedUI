-- edited by Masil for Kronos II
-- version 2

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Priest Venoxis"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	add_name = "Razzashi Cobra",
	renew_trigger = "High Priest Venoxis gains Renew\.",
	renewend_trigger = "Renew fades from High Priest Venoxis\.",
	enrage_trigger = "High Priest Venoxis gains Enrage\.",
	holyfire_trigger = "High Priest Venoxis begins to cast Holy Fire\.",
	phase2_trigger = "Let the coils of hate unfurl",
	poisoncloudhitsyou_trigger = "You suffer (.+) Nature damage from High Priest Venoxis's Poison Cloud.",
	poisoncloudabsorbyou_trigger = "You absorb High Priest Venoxis's Poison Cloud\.",
	poisoncloudresistyou_trigger = "High Priest Venoxis's Poison Cloud was resisted\.",
	poisoncloudimmuneyou_trigger = "High Priest Venoxis's Poison Cloud failed. You are immune\.",
	deadaddtrigger = "Razzashi Cobra dies",
	deadbosstrigger = "High Priest Venoxis dies",

	holyfirecast_bar = "Holy Fire cast",
	holyfirenext_bar = "Next Holy Fire",
	renew_bar = "Renew",
	renew_msg = "Renew! Dispel it!",
	phase1_msg = "Troll Phase",
	phase2_msg = "Snake Phase",
	enrage_msg = "Venoxis is enraged!",
	poison_msg = "Move away from poison cloud!",
	add_msg = "%d/4 Razzashi Cobras dead!",
	
	cmd = "Venoxis",

	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Razzashi Cobras",
	
	renew_cmd = "renew",
	renew_name = "Renew Alert",
	renew_desc = "Warn for Renew",

	holyfire_cmd = "holyfire",
	holyfire_name = "Holy Fire Alert",
	holyfire_desc = "Warn for Holy Fire",

	phase_cmd = "phase",
	phase_name = "Phase Notification",
	phase_desc = "Announces the boss' phase transition",

	cloud_cmd = "cloud",
	cloud_name = "Poison Cloud Warning",
	cloud_desc = "Warning and timer for Poison Cloud",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",
	
	ktm_cmd = "ktm",
	ktm_name = "KTM reset",
	ktm_desc = "Reset KTM when entering Phase 2",

} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsVenoxis = BigWigs:NewModule(boss)
BigWigsVenoxis.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
BigWigsVenoxis.enabletrigger = boss
BigWigsVenoxis.wipemobs = { L["add_name"] }
BigWigsVenoxis.toggleoptions = {"phase", "adds", "renew", "holyfire", "enrage", "cloud", "ktm", "bosskill"}
BigWigsVenoxis.revision = tonumber(string.sub("$Revision: 11205 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsVenoxis:OnEnable()
	self.started = nil
	self.cobra = 0
	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")									-- phase2_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")				-- renew_trigger enrage_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")					-- poisoncloudhitsyou_trigger poisoncloudabsorbyou_trigger poisoncloudresistyou_trigger poisoncloudimmuneyou_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")			-- holyfire_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")							-- deadaddtrigger deadbosstrigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")						-- renewend_trigger
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "VenoxisPhaseTwo", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "VenoxisRenewStart", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "VenoxisRenewStop", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "VenoxisHolyFireStart", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "VenoxisEnrage", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "VenoxisAddDead", 0.7)
	self:TriggerEvent("BigWigs_ThrottleSync", "VenoxisVenoxisDead", 3)
end

------------------------------
--      Events              --
------------------------------

function BigWigsVenoxis:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if string.find(msg, L["renew_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "VenoxisRenewStart")
	elseif string.find(msg, L["enrage_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "VenoxisEnrage")
	end
end

function BigWigsVenoxis:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if string.find(msg, L["poisoncloudhitsyou_trigger"]) or string.find(msg, L["poisoncloudabsorbyou_trigger"]) or string.find(msg, L["poisoncloudresistyou_trigger"]) or string.find(msg, L["poisoncloudimmuneyou_trigger"]) then
		self:TriggerEvent("BigWigs_Message", L["poison_msg"], "Personal", true, "Alarm")
	end
end

function BigWigsVenoxis:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["holyfire_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "VenoxisHolyFireStart")
	end
end

function BigWigsVenoxis:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["phase2_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "VenoxisPhaseTwo")
	end
end

function BigWigsVenoxis:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if string.find(msg, L["renewend_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "VenoxisRenewStop")
	end
end

function BigWigsVenoxis:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if string.find(msg, L["deadaddtrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "VenoxisAddDead")
	elseif string.find(msg, L["deadbosstrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "VenoxisVenoxisDead")
	end
end

function BigWigsVenoxis:BigWigs_RecvSync(sync, rest)
	if (sync == "BossEngaged") and (rest == boss) and not self.started then
		self.started = true
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phase1_msg"], "Attention")
		end
		if self.db.profile.holyfire then
			self:TriggerEvent("BigWigs_StartBar", self, L["holyfirenext_bar"], 10, "Interface\\Icons\\Spell_Holy_SearingLight")
		end
	elseif sync == "VenoxisPhaseTwo" then
		if IsAddOnLoaded("KLHThreatMeter") and self.db.profile.ktm and (IsRaidLeader() or IsRaidOfficer()) then
			klhtm.net.clearraidthreat()
		end
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phase2_msg"], "Attention")
		end
		if self.db.profile.holyfire then
			self:TriggerEvent("BigWigs_StopBar", self, L["holyfirecast_bar"])
			self:TriggerEvent("BigWigs_StopBar", self, L["holyfirenext_bar"])
		end
	elseif sync == "VenoxisRenewStart" and self.db.profile.renew then
		self:TriggerEvent("BigWigs_Message", L["renew_msg"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["renew_bar"], 15, "Interface\\Icons\\Spell_Holy_Renew", true, "Green")
	elseif sync == "VenoxisRenewStop" and self.db.profile.renew then
		self:TriggerEvent("BigWigs_StopBar", self, L["renew_bar"])
	elseif sync == "VenoxisHolyFireStart" and self.db.profile.holyfire then
		self:TriggerEvent("BigWigs_StartBar", self, L["holyfirecast_bar"], 3.5, "Interface\\Icons\\Spell_Holy_SearingLight", true, "Red")
		self:ScheduleEvent("BigWigs_StartBar", 3.5, self, L["holyfirenext_bar"], 11.5, "Interface\\Icons\\Spell_Holy_SearingLight")
	elseif sync == "VenoxisEnrage" and self.db.profile.enrage then
		self:TriggerEvent("BigWigs_Message", L["enrage_msg"], "Attention")
	elseif sync == "VenoxisAddDead" then
		self.cobra = self.cobra + 1
		if self.db.profile.adds then
			self:TriggerEvent("BigWigs_Message", string.format(L["add_msg"], self.cobra), "Positive")
		end
	elseif sync == "VenoxisVenoxisDead" then
		if self.db.profile.bosskill then
			self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s has been defeated"], self:ToString()), "Bosskill", nil, "Victory")
		end
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
		self.core:ToggleModuleActive(self, false)
	end
end
