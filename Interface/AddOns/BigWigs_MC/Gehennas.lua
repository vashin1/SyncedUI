-- edited by Masil for Kronos II
-- version 3

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Gehennas"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	curse_trigger1 = "afflicted by Gehennas",
	curse_trigger2 = "Gehennas' Curse was resisted",
	rainoffire_trigger = "You are afflicted by Rain of Fire",
	adddead_trigger = "Flamewaker dies\.",
	bossdead_trigger = "Gehennas dies\.",
	flamewaker_name = "Flamewaker",

	curse_warn = "5 seconds until Gehennas' Curse!",
	curse_msg = "Gehennas' Curse - Decurse NOW!",
	rainoffire_msg = "Move from FIRE!",
	adddead_msg = "%d/2 Flamewakers dead!",

	curse_bar = "Gehennas' Curse",

	cmd = "Gehennas",
	
	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Flamewakers",
	
	curse_cmd = "curse",
	curse_name = "Gehennas' Curse alert",
	curse_desc = "Warn for Gehennas' Curse",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGehennas = BigWigs:NewModule(boss)
BigWigsGehennas.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsGehennas.enabletrigger = boss
BigWigsGehennas.wipemobs = { L["flamewaker_name"] }
BigWigsGehennas.toggleoptions = {"adds", "curse", "bosskill"}
BigWigsGehennas.revision = tonumber(string.sub("$Revision: 11204 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGehennas:OnEnable()
	flamewaker = 0
	started = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")		-- curse
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")	-- curse
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")		-- curse, rain of fire
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "GehennasCurse", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "GehennasAddDeadX", 0.7)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsGehennas:Event(msg)
	if ((string.find(msg, L["curse_trigger1"])) or (string.find(msg, L["curse_trigger2"]))) then
		self:TriggerEvent("BigWigs_SendSync", "GehennasCurse")
	elseif (string.find(msg, L["rainoffire_trigger"])) then
		self:TriggerEvent("BigWigs_Message", L["rainoffire_msg"], "Personal", true, "Alarm")
	end
end

function BigWigsGehennas:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == L["adddead_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "GehennasAddDeadX "..tostring(flamewaker + 1))
	elseif msg == L["bossdead_trigger"] then
		self:GenericBossDeath(msg)
	end
end

function BigWigsGehennas:BigWigs_RecvSync(sync, rest)
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end 
		if self.db.profile.curse then
			self:ScheduleEvent("cursewarn", "BigWigs_Message", 7, L["curse_warn"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, L["curse_bar"], 12, "Interface\\Icons\\Spell_Shadow_BlackPlague")
		end
	elseif sync == "GehennasCurse" and self.db.profile.curse then
		self:ScheduleEvent("cursewarn", "BigWigs_Message", 25, L["curse_warn"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["curse_bar"], 30, "Interface\\Icons\\Spell_Shadow_BlackPlague")
		self:TriggerEvent("BigWigs_Message", L["curse_msg"], "Important", nil, "Alarm")
	elseif sync == "GehennasAddDeadX" and rest and self.db.profile.adds then
		if tonumber(rest) == (flamewaker + 1) then
			flamewaker = (flamewaker + 1)
			self:TriggerEvent("BigWigs_Message", string.format(L["adddead_msg"], flamewaker), "Positive")
		end
	end
end