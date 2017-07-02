------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Lord Kazzak"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local supremetime = 180

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kazzak",

	supreme_cmd = "supreme",
	supreme_name = "Supreme Alert",
	supreme_desc = "Warn for Supreme Mode",

	curse_cmd = "curse",
	curse_name = "Mark of Kazzak alert",
	curse_desc = "Warn for Mark of Kazzak",

	marktimer_cmd = "marktimer",
	marktimer_name = "Bar for when the Mark of Kazzak goes off",
	marktimer_desc = "Shows a 10 second bar for when the mark goes off at the target.",

	youbomb_cmd = "youbomb",
	youbomb_name = "You are the bomb alert",
	youbomb_desc = "Warn when you are the bomb",

	elsebomb_cmd = "elsebomb",
	elsebomb_name = "Someone else is the bomb alert",
	elsebomb_desc = "Warn when others are the bomb",

	icon_cmd = "icon",
	icon_name = "Raid Icon on Mark target",
	icon_desc = "Put a Raid Icon on the person who got Mark. (Requires promoted or higher)",

	starttrigger1 = "All mortals will perish!",
	starttrigger2 = "The Legion will conquer all!",
	trigger1 = "^([^%s]+) ([^%s]+) afflicted by Mark of Kazzak",
	trigger2 = "^Mark of Kazzak fades",

	you = "You",
	are = "are",

	engagewarn	 = "Lord Kazzak engaged, 3mins until Supreme!",
	warn1 = ">%S< CURSED!",
	mark_message_you = "You are cursed! >BOOM< in 10sec!",

	supreme1min	 = "Supreme mode in 1 minute!",
	supreme30sec = "Supreme mode in 30 seconds!",
	supreme10sec = "Supreme mode in 10 seconds!",

	bar1text = "Supreme mode",
	bar2text = "%s: Mark of Kazzak",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsKazzak = BigWigs:NewModule(boss)
BigWigsKazzak.zonename = { AceLibrary("AceLocale-2.2"):new("BigWigs")["Outdoor Raid Bosses Zone"], AceLibrary("Babble-Zone-2.2")["Blasted Lands"] }
BigWigsKazzak.enabletrigger = boss
BigWigsKazzak.toggleoptions = {"supreme", "curse", "marktimer", "icon", "youbomb", "elsebomb", "bosskill"}
BigWigsKazzak.revision = tonumber(string.sub("$Revision: 16941 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsKazzak:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Eventfade")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Eventfade")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "Kazzakmark", 1)
end

function BigWigsKazzak:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.supreme and msg == L["starttrigger1"] or msg == L["starttrigger2"] then 
		self:TriggerEvent("BigWigs_Message", L["engagewarn"], "Red")
		self:ScheduleEvent("BigWigs_Message", supremetime - 60, L["supreme1min"], "Attention")
		self:ScheduleEvent("BigWigs_Message", supremetime - 30, L["supreme30sec"], "Urgent")
		self:ScheduleEvent("BigWigs_Message", supremetime - 10, L["supreme10sec"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], supremetime, "Interface\\Icons\\Spell_Shadow_ShadowWordPain", "Green", "Yellow", "Orange", "Red")
	end
end

function BigWigsKazzak:Event(msg)
	local _, _, EPlayer, EType = string.find(msg, L["trigger1"])
	if EPlayer and EType then
		if EPlayer == L["you"] and EType == L["are"] then
			EPlayer = UnitName("player")
		end
		self:TriggerEvent("BigWigs_SendSync", "Kazzakmark "..EPlayer)
	end
end

function BigWigsKazzak:BigWigs_RecvSync(sync, rest, nick)
	if sync == "Kazzakmark" and rest then
		local player = rest
		
		if player == UnitName("player") and self.db.profile.youbomb then
			self:TriggerEvent("BigWigs_Message", L["mark_message_you"], "Personal", true, "Alert")
		        self:TriggerEvent("BigWigs_Message", string.format(L["warn1"], player), "Important")
		elseif self.db.profile.elsebomb then
		        self:TriggerEvent("BigWigs_Message", string.format(L["warn1"], player), "Important", true, "Bottle")
			self:TriggerEvent("BigWigs_SendTell", player, L["mark_message_you"])
		end

		if self.db.profile.marktimer then
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["bar2text"], player), 10, "Interface\\Icons\\Spell_Shadow_Antishadow")
		end

		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", player)
		end
	end
end

function BigWigsKazzak:Eventfade(msg)
	if string.find(msg, L["trigger1"]) and self.db.profile.marktimer then
	self:TriggerEvent("BigWigs_StopBar", self, L["bar2text"])
	end
end
