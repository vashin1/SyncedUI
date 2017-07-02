-- edited by Masil for Kronos II
-- version 1

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Gahz'ranka"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	frostbreath_trigger = "Gahz'ranka begins to perform Frost Breath\.",
	--massivegeyser_trigger = "Gahz'ranka begins to cast Massive Geyser\.",
	slam_trigger = "Gahz'ranka's Gahz'ranka Slam",
	
	frostbreathCD_bar = "Frost Breath CD",
	frostbreathcast_bar = "Frost Breath cast",
	--[[massivegeyserCD_bar = "Massive Geyser CD",
	massivegeysercast_bar = "Massive Geyser cast",]]
	slamCD_bar = "Slam CD",
	
	cmd = "Gahzranka",

	frostbreath_cmd = "frostbreath",
	frostbreath_name = "Frost Breath alert",
	frostbreath_desc = "Timer for Frost Breath.",

	--[[massivegeyser_cmd = "massivegeyser",
	massivegeyser_name = "Massive Geyser alert",
	massivegeyser_desc = "Timer for Massive Geyser.",]]
	
	slam_cmd = "slam",
	slam_name = "Gahz'ranka Slam alert",
	slam_desc = "Timer for Gahz'ranka Slam.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGahzranka = BigWigs:NewModule(boss)
BigWigsGahzranka.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
BigWigsGahzranka.enabletrigger = boss
BigWigsGahzranka.toggleoptions = {"frostbreath", --[["massivegeyser",]] "slam", "bosskill"}
BigWigsGahzranka.revision = tonumber(string.sub("$Revision: 11204 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGahzranka:OnEnable()	
	started = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")		-- slam_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")		-- slam_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")	-- slam_trigger frostbreath_trigger massivegeyser_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "GahzSlam", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "GahzBreath", 10)
	--self:TriggerEvent("BigWigs_ThrottleSync", "GahzGeyser", 15)
end

------------------------------
--      Events              --
------------------------------

function BigWigsGahzranka:Event(msg)
	if msg == L["frostbreath_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "GahzBreath")
	--[[elseif msg == L["massivegeyser_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "GahzGeyser")]]
	elseif string.find(msg, L["slam_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "GahzSlam")
	end
end

function BigWigsGahzranka:BigWigs_RecvSync(sync, rest)
	if sync == self:GetEngageSync() and rest == boss and not started then
		started = true
		if self.db.profile.slam then
			self:TriggerEvent("BigWigs_StartBar", self, L["slamCD_bar"], 3, "Interface\\Icons\\Ability_Devour", true, "Red")
		end
		if self.db.profile.frostbreath then
			self:TriggerEvent("BigWigs_StartBar", self, L["frostbreathCD_bar"], 15, "Interface\\Icons\\Spell_Frost_FrostNova", true, "cyan")
		end
		--[[if self.db.profile.massivegeyser then
			self:TriggerEvent("BigWigs_StartBar", self, L["massivegeyserCD_bar"], 20, "Interface\\Icons\\Spell_Frost_SummonWaterElemental")
		end]]
	elseif sync == "GahzSlam" and self.db.profile.slam then
		self:TriggerEvent("BigWigs_StartBar", self, L["slamCD_bar"], 10, "Interface\\Icons\\Ability_Devour", true, "Red")
	elseif sync == "GahzBreath" and self.db.profile.frostbreath then
		self:TriggerEvent("BigWigs_StartBar", self, L["frostbreathcast_bar"], 2, "Interface\\Icons\\Spell_Frost_FrostNova", true, "blue")
		self:ScheduleEvent("BigWigs_StartBar", 2, self, L["frostbreathCD_bar"], 15, "Interface\\Icons\\Spell_Frost_FrostNova", true, "cyan")
	--[[elseif sync == "GahzGeyser" and self.db.profile.massivegeyser then
		self:TriggerEvent("BigWigs_StartBar", self, L["massivegeysercast_bar"], 1.5, "Interface\\Icons\\Spell_Frost_SummonWaterElemental")
		self:ScheduleEvent("BigWigs_StartBar", 1.5, self, L["massivegeyserCD_bar"], 20, "Interface\\Icons\\Spell_Frost_SummonWaterElemental")]]
	end
end