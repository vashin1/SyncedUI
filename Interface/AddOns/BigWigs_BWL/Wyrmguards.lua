------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Death Talon Wyrmguard"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local stompNumber
--local started
local deathCount

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Wyrmguard",
	
	warstomp_cmd = "warstomp",
	warstomp_name = "War Stomp Alert",
	warstomp_desc = "Warn for War Stomp",
	
	warstomp_trigger = "War Stomp",
	warstomp_bar = "War Stomp CD",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsWyrmguards = BigWigs:NewModule(boss)
BigWigsWyrmguards.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsWyrmguards.enabletrigger = boss
BigWigsWyrmguards.toggleoptions = { "warstomp" }
BigWigsWyrmguards.revision = tonumber(string.sub("$Revision: 19999 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsWyrmguards:OnEnable()
	stompNumber = 1
	--started = nil
	deathCount = 0
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	--self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event") --warstomp_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PLAYER_DAMAGE", "Event") --warstomp_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event") --warstomp_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "WyrmguardStomp", 0.5)
end

function BigWigsWyrmguards:BigWigs_RecvSync(sync, rest, nick)
	--if sync == self:GetEngageSync() and rest and rest == boss and not started then
	--	started = true
	--	if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
	--		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	--	end
	--	self:TriggerEvent("BigWigs_StartBar", self, L["warstomp_bar"], 4, "Interface\\Icons\\Ability_WarStomp")
	--end
	if sync == "WyrmguardStomp" and self.db.profile.warstomp then
		self:WarStomp(stompNumber)
		stompNumber = stompNumber + 1
		if stompNumber >= 4 then
			stompNumber = 1
		end
	end
end

function BigWigsWyrmguards:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if string.find(msg, L["wyrmguarddeath_trigger"]) then
		deathCount = deathCount + 1
		if deathCount >= 3 then
			self.core:ToggleModuleActive(self, false)
		end
	end
end

function BigWigsWyrmguards:Event(msg)
	if string.find(msg, L["warstomp_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "WyrmguardStomp")
	end
end

function BigWigsWyrmguards:WarStomp(number)
	self:TriggerEvent("BigWigs_StartBar", self, L["warstomp_bar"]..number, 9.5, "Interface\\Icons\\Ability_WarStomp")
end




