-- edited by Masil for Kronos II
-- version 1

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Priestess Arlokk"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	engage_trigger = "your priestess calls upon your might",
	mark_trigger = "Feast on (.+), my pretties!",
	ww_trigger = "High Priestess Arlokk gains Whirlwind\.",
	
	markyou_msg = "You are marked!",
	mark_msg = "%s is marked!",
	trollphase_msg = "Troll Phase",
	pantherphase_msg = "Panther Phase",
	vanishphase_msg = "Vanished!",
	vanishend_warn = "Vanish ends soon!",

	vanishnext_bar = "Next Vanish",
	vanish_bar = "Vanished",
	ww_bar = "Whirlwind",
	
	cmd = "Arlokk",
	shadowhunter = "Hakkari Shadow Hunter",

	vanish_cmd = "vanish",
	vanish_name = "Vanish alert",
	vanish_desc = "Shows timers for Vanish.",

	mark_cmd = "mark",
	mark_name = "Mark of Arlokk alert",
	mark_desc = "Warns when people are marked.",

	whirlwind_cmd = "whirlwind",
	whirlwind_name = "Whirldind alert",
	whirlwind_desc = "Shows you when the boss has Whirlwind.",
	
	phase_cmd = "phase",
	phase_name = "Phase notification",
	phase_desc = "Announces the boss' phase transitions.",
	
	puticon_cmd = "puticon",
	puticon_name = "Raid icon on marked players",
	puticon_desc = "Place a raid icon on the player with Mark of Arlokk.\n\n(Requires assistant or higher)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsArlokk = BigWigs:NewModule(boss)
BigWigsArlokk.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
BigWigsArlokk.enabletrigger = { boss, L["shadowhunter"] }
BigWigsArlokk.toggleoptions = {"phase", "whirlwind", "vanish", "mark", "puticon", "bosskill"}
BigWigsArlokk.revision = tonumber(string.sub("$Revision: 11205 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsArlokk:OnEnable()
	vanished = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")									-- engage_trigger mark_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")				-- ww_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ArlokkTroll", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "ArlokkVanish", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "ArlokkPanther", 10)
end

------------------------------
--      Events              --
------------------------------

function BigWigsArlokk:CHAT_MSG_MONSTER_YELL(msg)
    if string.find(msg,L["engage_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "ArlokkTroll")
	else
		local _,_, name = string.find(msg, L["mark_trigger"])
		if name then
			if self.db.profile.mark then
				if name == UnitName("player") then
					self:TriggerEvent("BigWigs_Message", L["markyou_msg"], "Personal", true, "Alarm")
					self:TriggerEvent("BigWigs_Message", string.format(L["mark_msg"], name), "Important", nil, "Alert", true)		
				else
					self:TriggerEvent("BigWigs_Message", string.format(L["mark_msg"], name), "Important")
				end
			end
			if self.db.profile.puticon then
				self:TriggerEvent("BigWigs_SetRaidIcon", name)
			end
		end
	end
end

function BigWigsArlokk:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["ww_trigger"] and self.db.profile.whirlwind then
		self:TriggerEvent("BigWigs_StartBar", self, L["ww_bar"], 2, "Interface\\Icons\\Ability_Whirlwind", true, "Blue")
	end
end

function BigWigsArlokk:BigWigs_RecvSync(sync, rest)
	if sync == "ArlokkTroll" then
		vanished = nil
		self:CancelScheduledEvent("checkvanish")
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["trollphase_msg"], "Attention")
		end
		if self.db.profile.vanish then
			self:TriggerEvent("BigWigs_StartBar", self, L["vanishnext_bar"], 34.7, "Interface\\Icons\\Ability_Vanish")
		end
		self:ScheduleEvent("BigWigs_SendSync", 29.7, "ArlokkPanther")
	elseif sync == "ArlokkPanther" then
		self:CancelScheduledEvent("checkunvanish")
		if self.db.profile.vanish then
			self:TriggerEvent("BigWigs_StopBar", self, L["vanish_bar"])
		end
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["pantherphase_msg"], "Attention")
		end
		if not vanished then
			self:ScheduleRepeatingEvent("checkvanish", self.CheckVanish, 0.5, self)
		end
	elseif sync == "ArlokkVanish" then
		vanished = true
		self:CancelScheduledEvent("checkvanish")
		self:CancelScheduledEvent("trollphaseinc")
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["vanishphase_msg"], "Attention")
		end
		if self.db.profile.vanish then
			self:TriggerEvent("BigWigs_StopBar", self, L["vanishnext_bar"])
			self:TriggerEvent("BigWigs_StartBar", self, L["vanish_bar"], 39.7, "Interface\\Icons\\Ability_Vanish", true, "White")
			self:ScheduleEvent("BigWigs_Message", 34.7, L["vanishend_warn"], "Urgent")
		end
		self:ScheduleRepeatingEvent("checkunvanish", self.CheckUnvanish, 0.5, self)
	end
end

function BigWigsArlokk:CheckUnvanish()
	if UnitExists("target") and UnitName("target") == boss and UnitExists("targettarget") then
		self:TriggerEvent("BigWigs_SendSync", "ArlokkPanther")
		self:ScheduleEvent("trollphaseinc", "BigWigs_SendSync", 29.7, "ArlokkTroll")
		return
	end
	local num = GetNumRaidMembers()
	for i = 1, num do
		local raidUnit = string.format("raid%starget", i)
		if UnitExists(raidUnit) and UnitName(raidUnit) == boss and UnitExists(raidUnit.."target") then
			self:TriggerEvent("BigWigs_SendSync", "ArlokkPanther")
			self:ScheduleEvent("trollphaseinc", "BigWigs_SendSync", 29.7, "ArlokkTroll")
			return
		end
	end
end

function BigWigsArlokk:CheckVanish()
	if UnitExists("target") and UnitName("target") == boss and UnitExists("targettarget") then
		return
	end
	local num = GetNumRaidMembers()
	for i = 1, num do
		local raidUnit = string.format("raid%starget", i)
		if UnitExists(raidUnit) and UnitName(raidUnit) == boss and UnitExists(raidUnit.."target") then
			return
		end
	end
	self:TriggerEvent("BigWigs_SendSync", "ArlokkVanish")
end
