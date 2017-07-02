-- edited by Masil for Kronos II
-- version 1

------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Bloodlord Mandokir"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	ohgan = "Ohgan",
	cmd = "Mandokir",

	watch_trigger = "(.+)! I'm watching you!",
	gaze_trigger = "^(.+) (.+) afflicted by Threatening Gaze\.",
	gazeend_trigger = "Threatening Gaze fades from (.*)\.",
	death_trigger = "(.+) dies?\.",
	whirlwind_trigger = "Bloodlord Mandokir gains Whirlwind\.",
	enrage_trigger = "Bloodlord Mandokir gains Enrage\.",
	
	watchedyou_msg = "You are being watched! Stop everything!",
	watched_msg = "%s is being watched!",
	enrage_msg = "Ohgan down! Mandokir enraged!",	

	gazecast_bar = "Casting Threatening Gaze on: %s",
	gazewatched_bar = "Watching: %s",
	enrage_bar = "Enrage duration",
	whirlwind_bar = "Whirlwind",

	whisper_cmd = "whispers",
	whisper_name = "Whisper watched players",
	whisper_desc = "Sends a whisper to players targetted by Threatening Gaze.\n\n(Requires assistant or higher)",

	puticon_cmd = "puticon",
	puticon_name = "Raid icon on watched players",
	puticon_desc = "Place a raid icon on the watched person.\n\n(Requires assistant or higher)",
	
	gaze_cmd = "gaze",
	gaze_name = "Threatening Gaze alert",
	gaze_desc = "Shows bars for Threatening Gaze",

	whirlwind_cmd = "whirlwind",
	whirlwind_name = "Whirlwind Alert",
	whirlwind_desc = "Shows Whirlwind bars",

	enrage_cmd = "enrage",
	enrage_name = "Enrage alert",
	enrage_desc = "Announces the boss' Enrage",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMandokir = BigWigs:NewModule(boss)
BigWigsMandokir.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
BigWigsMandokir.enabletrigger = boss
BigWigsMandokir.wipemobs = { L["ohgan"] }
BigWigsMandokir.toggleoptions = {"gaze", "whisper", "puticon", "whirlwind", "enrage", "bosskill"}
BigWigsMandokir.revision = tonumber(string.sub("$Revision: 11206 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMandokir:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")										-- watch_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")					-- whirlwind_trigger enrage_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Afflict")			-- gaze_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Afflict")			-- gaze_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Afflict")	-- gaze_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "GazeFade")					-- gazeend_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "GazeFade")				-- gazeend_trigger
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "GazeFade")				-- gazeend_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "GazeFade")				-- death_trigger
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MandokirGazeAfflict", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "MandokirGazeEnd", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MandokirEnrage", 10)
end

------------------------------
--      Events              --
------------------------------

function BigWigsMandokir:CHAT_MSG_MONSTER_YELL(msg)
	local _, _, name = string.find(msg, L["watch_trigger"])
	if name then
		if self.db.profile.gaze then
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["gazecast_bar"], name), 2, "Interface\\Icons\\Spell_Shadow_Charm", true, "Yellow")
			if name == UnitName("player")then
				self:TriggerEvent("BigWigs_Message", L["watchedyou_msg"], "Personal", true, "Alarm")
				self:TriggerEvent("BigWigs_Message", string.format(L["watched_msg"], name), "Urgent", nil, "Alert", true)
			else
				self:TriggerEvent("BigWigs_Message", string.format(L["watched_msg"], name), "Urgent", nil, "Alert")
			end
		end
		if self.db.profile.whisper and name ~= UnitName("player") then
			self:TriggerEvent("BigWigs_SendTell", name, L["watchedyou_msg"])
		end
		if self.db.profile.puticon then
			self:TriggerEvent("BigWigs_SetRaidIcon", name)
		end		
	end
end

function BigWigsMandokir:Afflict(msg)
	local _, _, name, detect = string.find(msg, L["gaze_trigger"])
	if name and detect then
		if detect == "are" then
			self:TriggerEvent("BigWigs_SendSync", "MandokirGazeAfflict "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "MandokirGazeAfflict "..name)
		end		
	end
end

function BigWigsMandokir:GazeFade(msg)
	local _, _, name = ( string.find(msg, L["gazeend_trigger"]) or string.find(msg, L["death_trigger"]) )
	if name then
		if name == "you" or name == "You" then
			self:TriggerEvent("BigWigs_SendSync", "MandokirGazeEnd "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "MandokirGazeEnd "..name)
		end
	end	
end

function BigWigsMandokir:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["whirlwind_trigger"] and self.db.profile.whirlwind then
		self:TriggerEvent("BigWigs_StartBar", self, L["whirlwind_bar"], 2, "Interface\\Icons\\Ability_Whirlwind", true, "Blue")
	elseif msg == L["enrage_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "MandokirEnrage")
	end	
end

function BigWigsMandokir:BigWigs_RecvSync(sync, rest)
	if sync == "MandokirGazeAfflict" and rest and self.db.profile.gaze then
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["gazewatched_bar"], rest), 6, "Interface\\Icons\\Spell_Shadow_Charm", true, "Red")
	elseif sync == "MandokirGazeEnd" and rest then
		if self.db.profile.gaze then
			self:TriggerEvent("BigWigs_StopBar", self, string.format(L["gazewatched_bar"], rest))
		end
		if self.db.profile.puticon then
			self:TriggerEvent("BigWigs_RemoveRaidIcon", rest)
		end
	elseif sync == "MandokirEnrage" and self.db.profile.enrage then
		self:TriggerEvent("BigWigs_Message", L["enrage_msg"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["enrage_bar"], 90, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", true, "White")
	end
end