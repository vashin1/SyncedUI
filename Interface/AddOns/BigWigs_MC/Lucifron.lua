-- edited by Masil for Kronos II
-- version 4

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Lucifron"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	mc_trigger = "^(.+) (.+) afflicted by Dominate Mind\.",
	mcfade_trigger = "Dominate Mind fades from (.*)\.",
	mc_msg = "%s is Mind Controlled!",
	mc_msg_you = "You are Mind Controlled!",
	mc_msg_me = "Mind Control on me!",
	mc_bar = "MC: %s",

	deathyou_trigger = "You die\.",
	deathother_trigger = "(.+) dies\.",

	add_name = "Flamewaker Protector",
	adddead_trigger = "Flamewaker Protector dies\.",
	adddead_msg = "%d/2 Flamewaker Protectors dead!",

	bossdead_trigger = "Lucifron dies\.",

	curse_trigger1 = "afflicted by Lucifron",
	curse_trigger2 = " Lucifron(.*) Curse was resisted",
	curse_msg = "Lucifron's Curse - 20 seconds until next!",
	curse_bar = "Lucifron's Curse",

	doom_trigger1 = "afflicted by Impending Doom",
	doom_trigger2 = "s Impending Doom was resisted",
	doom_msg = "Impending Doom - 20 seconds until next!",
	doom_bar = "Impending Doom",

	cmd = "Lucifron",
	
	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Flamewaker Protectors",
	
	mc_cmd = "mc",
	mc_name = "Dominate Mind",
	mc_desc = "Alert when someone is Mind Controlled",

	mcsay_cmd = "mcsay",
	mcsay_name = "Dominate Mind Say",
	mcsay_desc = "Print in say when you are Mind Controlled",
	
	curse_cmd = "curse",
	curse_name = "Lucifron's Curse alert",
	curse_desc = "Warn for Lucifron's Curse",
	
	doom_cmd = "doom",
	doom_name = "Impending Doom alert",
	doom_desc = "Warn for Impending Doom",

} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsLucifron = BigWigs:NewModule(boss)
BigWigsLucifron.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsLucifron.enabletrigger = boss
BigWigsLucifron.wipemobs = { L["add_name"] }
BigWigsLucifron.toggleoptions = { "mc", "mcsay", "adds", "curse", "doom", "bosskill"}
BigWigsLucifron.revision = tonumber(string.sub("$Revision: 11204 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsLucifron:OnEnable()
	protector = 0
	started = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "MCEnd")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "MCEnd")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "MCEnd")
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "MCEnd")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "LucifronMC", 0.7)
	self:TriggerEvent("BigWigs_ThrottleSync", "LucifronMCEnd", 0.7)
	self:TriggerEvent("BigWigs_ThrottleSync", "LucifronCurseRep", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "LucifronDoomRep", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "LucifronAddDeadX", 0.7)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsLucifron:Event(msg)
	local _, _, name, detect = string.find(msg, L["mc_trigger"])
	if (string.find(msg, L["curse_trigger1"]) or string.find(msg, L["curse_trigger2"])) then
		self:TriggerEvent("BigWigs_SendSync", "LucifronCurseRep")
	elseif (string.find(msg, L["doom_trigger1"]) or string.find(msg, L["doom_trigger2"])) then
		self:TriggerEvent("BigWigs_SendSync", "LucifronDoomRep")
	elseif name and detect then
		if detect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "LucifronMC "..UnitName("player"))
			if self.db.profile.mcsay then
				SendChatMessage(L["mc_msg_me"], "SAY")
			end
		else
			self:TriggerEvent("BigWigs_SendSync", "LucifronMC "..name)
		end		
	end
end

function BigWigsLucifron:MCEnd(msg)
	local _, _, fade = string.find(msg, L["mcfade_trigger"])
	local _, _, dead = string.find(msg, L["deathother_trigger"])
	if (msg == L["deathyou_trigger"]) or (fade == "you") then
		self:TriggerEvent("BigWigs_SendSync", "LucifronMCEnd "..UnitName("player"))
	elseif fade or dead then
		self:TriggerEvent("BigWigs_SendSync", "LucifronMCEnd "..(fade or dead))
	end
end

function BigWigsLucifron:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == L["adddead_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "LucifronAddDeadX "..tostring(protector + 1))
	elseif msg == L["bossdead_trigger"] then
		self:GenericBossDeath(msg)
	end
end

function BigWigsLucifron:BigWigs_RecvSync(sync, rest)
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		if self.db.profile.curse then
			self:TriggerEvent("BigWigs_StartBar", self, L["curse_bar"], 20, "Interface\\Icons\\Spell_Shadow_BlackPlague")
		end
		if self.db.profile.doom then
			self:TriggerEvent("BigWigs_StartBar", self, L["doom_bar"], 10, "Interface\\Icons\\Spell_Shadow_NightOfTheDead")
		end
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end 
	elseif sync == "LucifronCurseRep" and self.db.profile.curse then
		self:TriggerEvent("BigWigs_Message", L["curse_msg"], "Important", nil, "Alert")
		self:TriggerEvent("BigWigs_StartBar", self, L["curse_bar"], 20, "Interface\\Icons\\Spell_Shadow_BlackPlague")
	elseif sync == "LucifronDoomRep" and self.db.profile.doom then
		self:TriggerEvent("BigWigs_Message", L["doom_msg"], "Important", nil, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["doom_bar"], 20, "Interface\\Icons\\Spell_Shadow_NightOfTheDead")
	elseif sync == "LucifronMC" and rest and self.db.profile.mc then
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["mc_bar"], rest), 15, "Interface\\Icons\\Spell_Shadow_ShadowWordDominate", true, "White")
		self:SetCandyBarOnClick("BigWigsBar "..string.format(L["mc_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
		if rest == UnitName("player") then
			self:TriggerEvent("BigWigs_Message", L["mc_msg_you"], "Personal", true, "Alarm")
			self:TriggerEvent("BigWigs_Message", string.format(L["mc_msg"], UnitName("player")), "Urgent", nil, nil, true)		
		else
			self:TriggerEvent("BigWigs_Message", string.format(L["mc_msg"], rest), "Urgent")
		end
	elseif sync == "LucifronMCEnd" and rest and self.db.profile.mc then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["mc_bar"], rest))
	elseif sync == "LucifronAddDeadX" and rest and self.db.profile.adds then
		if tonumber(rest) == (protector + 1) then
			protector = (protector + 1)
			self:TriggerEvent("BigWigs_Message", string.format(L["adddead_msg"], protector), "Positive")
		end
	end
end