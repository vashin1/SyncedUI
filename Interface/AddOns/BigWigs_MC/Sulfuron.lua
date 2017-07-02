-- edited by Masil for Kronos II
-- version 2

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Sulfuron Harbinger"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	flamewakerpriest_name = "Flamewaker Priest",
	
	adddead_trigger = "Flamewaker Priest dies\.",
	bossdead_trigger = "Sulfuron Harbinger dies\.",
	heal_trigger = "begins to cast Dark Mending",

	adddead_msg = "%d/4 Flamewaker Priests dead!",
	heal_msg = "Healing!",

	heal_bar = "Dark Mending",

	cmd = "Sulfuron",
	
	heal_cmd = "heal",
	heal_name = "Adds' heals",
	heal_desc = "Announces Flamewaker Priests' heals",
	
	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Flamewaker Priests",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSulfuron = BigWigs:NewModule(boss)
BigWigsSulfuron.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsSulfuron.enabletrigger = boss
BigWigsSulfuron.wipemobs = { L["flamewakerpriest_name"] }
BigWigsSulfuron.toggleoptions = {"heal", "adds", "bosskill"}
BigWigsSulfuron.revision = tonumber(string.sub("$Revision: 11203 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsSulfuron:OnEnable()
	deadpriests = 0
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SulfuronAddHeal", 0.7)
	self:TriggerEvent("BigWigs_ThrottleSync", "SulfuronAddDeadX", 0.7)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsSulfuron:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == L["adddead_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "SulfuronAddDeadX "..tostring(deadpriests + 1))
	elseif msg == L["bossdead_trigger"] then
		self:GenericBossDeath(msg)
	end
end

function BigWigsSulfuron:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if string.find(msg, L["heal_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "SulfuronAddHeal")
	end
end

function BigWigsSulfuron:BigWigs_RecvSync(sync, rest)
	if sync == "SulfuronAddHeal" and self.db.profile.heal then		
		self:TriggerEvent("BigWigs_Message", L["heal_msg"], "Urgent", true, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["heal_bar"], 2 , "Interface\\Icons\\Spell_Shadow_ChillTouch")
	elseif sync == "SulfuronAddDeadX" and rest and self.db.profile.adds then
		if tonumber(rest) == (deadpriests + 1) then
			deadpriests = deadpriests + 1
			self:TriggerEvent("BigWigs_Message", string.format(L["adddead_msg"], deadpriests), "Positive")
		end
	end
end