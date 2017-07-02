-- edited by Masil for Kronos II
-- version 2

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Jin'do the Hexxer"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	mc_trigger = "^(.+) (.+) afflicted by Brain Wash\.",
	mcend_trigger = "Brain Wash fades from (.*)\.",
	heal_trigger = "Jin'do the Hexxer casts Powerful Healing Ward\.",
	healend_trigger = "Powerful Healing Ward is destroyed\.",
	curse_trigger = "^(.+) (.+) afflicted by Delusions of Jin'do\.",
	hex_trigger = "^(.+) (.+) afflicted by Hex\.",
	hexend_trigger = "Hex fades from (.*)\.",
	death_trigger = "(.+) dies?\.",
	jindo_death = "Jin'do the Hexxer dies\.",
	
	mc_msg = "Brain Wash Totem!",
	heal_msg = "Healing Totem!",
	curse_msg = "%s is cursed!",
	curseyou_msg = "You are cursed! Kill the Shades!",
	hex_msg = "%s is hexed! Dispel it!",
	hexyou_msg = "You are hexed!",
	
	mc_bar = "MC: %s",
	heal_bar = "Powerful Healing Ward",
	hex_bar = "Hex: %s",
	
	cmd = "Jindo",

	brainwash_cmd = "brainwash",
	brainwash_name = "Brain Wash Totem Alert",
	brainwash_desc = "Warn when Jin'do summons Brain Wash Totems.",

	healingward_cmd = "healingward",
	healingward_name = "Healing Totem Alert",
	healingward_desc = "Warn when Jin'do summons Powerful Healing Wards.",

	curse_cmd = "curse",
	curse_name = "Curse Alert",
	curse_desc = "Warn when players get Delusions of Jin'do.",
	
	hex_cmd = "hex",
	hex_name = "Hex Alert",
	hex_desc = "Warn when players get Hex.",

	puticon_cmd = "puticon",
	puticon_name = "Raid icon on cursed players",
	puticon_desc = "Place a raid icon on the player with Delusions of Jin'do.\n\n(Requires assistant or higher)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsJindo = BigWigs:NewModule(boss)
BigWigsJindo.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
BigWigsJindo.enabletrigger = boss
BigWigsJindo.toggleoptions = {"curse", "hex", "brainwash", "healingward", "puticon", "bosskill"}
BigWigsJindo.revision = tonumber(string.sub("$Revision: 11206 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsJindo:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")					-- heal_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")								-- healend_trigger	jindo_death
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Afflict")			-- mc_trigger		hex_trigger		curse_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Afflict")	-- 					hex_trigger		curse_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Afflict")			-- 					hex_trigger		curse_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "Afflict")	-- mc_trigger		hex_trigger		curse_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "AuraFade")					-- mcend_trigger	hexend_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "AuraFade")				-- mcend_trigger	hexend_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "AuraFade")				-- mcend_trigger	hexend_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "AuraFade")				-- death_trigger
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "JindoMC", 7)
	self:TriggerEvent("BigWigs_ThrottleSync", "JindoMCEnd", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "JindoHeal", 7)
	self:TriggerEvent("BigWigs_ThrottleSync", "JindoHealEnd", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "JindoCurse", 7)
	self:TriggerEvent("BigWigs_ThrottleSync", "JindoHexStart", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "JindoHexStop", 2)
end

------------------------------
--      Events              --
------------------------------

function BigWigsJindo:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["heal_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "JindoHeal")
	end
end

function BigWigsJindo:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == L["healend_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "JindoHealEnd")
	elseif msg == L["jindo_death"] then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s has been defeated"], self:ToString()), "Bosskill", nil, "Victory") end
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsJindo:Afflict(msg)
	local _, _, cursename, cursedetect = string.find(msg, L["curse_trigger"])
	local _, _, mcname, mcdetect = string.find(msg, L["mc_trigger"])
	local _, _, hexname, hexdetect = string.find(msg, L["hex_trigger"])
	if cursename and cursedetect then
		if cursedetect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "JindoCurse "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "JindoCurse "..cursename)
		end		
	elseif mcname and mcdetect then
		if mcdetect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "JindoMC "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "JindoMC "..mcname)
		end		
	elseif hexname and hexdetect then
		if hexdetect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "JindoHexStart "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "JindoHexStart "..hexname)
		end		
	end
end

function BigWigsJindo:AuraFade(msg)
	local _, _, mcname = string.find(msg, L["mcend_trigger"])
	local _, _, hexname = string.find(msg, L["hexend_trigger"])
	local _, _, deadname = string.find(msg, L["death_trigger"])
	if deadname then
		if deadname == "You" then
			deadname = UnitName("player")
		end
		self:TriggerEvent("BigWigs_SendSync", "JindoMCEnd "..deadname)
		self:TriggerEvent("BigWigs_SendSync", "JindoHexStop "..deadname)
	elseif mcname then
		if mcname == "you" then
			self:TriggerEvent("BigWigs_SendSync", "JindoMCEnd "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "JindoMCEnd "..mcname)
		end
	elseif hexname then
		if hexname == "you" then
			self:TriggerEvent("BigWigs_SendSync", "JindoHexStop "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "JindoHexStop "..hexname)
		end
	end	
end

function BigWigsJindo:BigWigs_RecvSync(sync, rest)
	if sync == "JindoMC" and self.db.profile.brainwash and rest then
		self:TriggerEvent("BigWigs_Message", L["mc_msg"], "Attention", true, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["mc_bar"], rest), 240, "Interface\\Icons\\Spell_Totem_WardOfDraining", true, "White")
	elseif sync == "JindoMCEnd" and self.db.profile.brainwash and rest then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["mc_bar"], rest))
	elseif sync == "JindoHeal" and self.db.profile.healingward then
		self:TriggerEvent("BigWigs_Message", L["heal_msg"], "Attention", true, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["heal_bar"], 240, "Interface\\Icons\\Spell_Holy_LayOnHands", true, "Yellow")
	elseif sync == "JindoHealEnd" and self.db.profile.healingward then
		self:TriggerEvent("BigWigs_StopBar", self, L["heal_bar"])
	elseif sync == "JindoCurse" and rest then
		if self.db.profile.curse then
			if rest == UnitName("player") then
				self:TriggerEvent("BigWigs_Message", L["curseyou_msg"], "Personal", true, "Alert")
				self:TriggerEvent("BigWigs_Message", string.format(L["curse_msg"], UnitName("player")), "Important", nil, nil, true)		
			else
				self:TriggerEvent("BigWigs_Message", string.format(L["curse_msg"], rest), "Important")
			end			
		end
		if self.db.profile.puticon then 
			self:TriggerEvent("BigWigs_SetRaidIcon", rest)
		end
	elseif sync == "JindoHexStart" and self.db.profile.hex and rest then
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["hex_bar"], rest), 5, "Interface\\Icons\\Spell_Nature_Polymorph", true, "Magenta")
		self:SetCandyBarOnClick("BigWigsBar "..string.format(L["hex_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
		if rest == UnitName("player") then
			self:TriggerEvent("BigWigs_Message", L["hexyou_msg"], "Personal", true, "Alarm")
			self:TriggerEvent("BigWigs_Message", string.format(L["hex_msg"], UnitName("player")), "Magenta", nil, "Alert", true)		
		else
			self:TriggerEvent("BigWigs_Message", string.format(L["hex_msg"], rest), "Magenta", nil, "Alert")
		end	
	elseif sync == "JindoHexStop" and self.db.profile.hex and rest then
		self:TriggerEvent("BigWigs_StopBar", self, string.format(L["hex_bar"], rest))
	end
end