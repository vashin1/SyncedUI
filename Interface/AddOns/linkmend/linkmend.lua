local CITEMLINK_PATTERN = '%{CLINK:(%x%x%x%x%x%x%x%x):(%d*):(%d*):(%d*):(%d*):(.-)%}'

local ITEMLINK_PATTERN = '|c(%x%x%x%x%x%x%x%x)|Hitem:(%d*):(%d*):(%d*):(%d*)[:0-9]*|h%[(.-)%]|h|r'

local LINK_TEMPLATE = '|c%s|Hitem:%s:%s:%s:%s|h[%s]|h|r'

local function mend_clinks(text)
	return gsub(text, CITEMLINK_PATTERN, function(color, item_id, enchant_id, suffix_id, unique_id, name)
		return format(LINK_TEMPLATE, color, item_id, enchant_id, suffix_id, unique_id, name)
	end)
end

local function mend_links(text)
	return gsub(text, ITEMLINK_PATTERN, function(color, item_id, enchant_id, suffix_id, unique_id, name)
		local cached_name, _, quality = GetItemInfo(format('item:%s:0:%s', item_id, suffix_id))
		if cached_name then
			local color = strsub(({GetItemQualityColor(quality)})[4], 3)
			return format(LINK_TEMPLATE, color, item_id, enchant_id, suffix_id, unique_id, cached_name)
		else
			return format(LINK_TEMPLATE, color, item_id, enchant_id, suffix_id, unique_id, name)
		end
	end)
end

CreateFrame'Frame':SetScript('OnUpdate', function()
	this:SetScript('OnUpdate', nil)
	local orig = ChatFrame_OnEvent
	function ChatFrame_OnEvent(event)
		if event == 'CHAT_MSG_CHANNEL'
			or event == 'CHAT_MSG_GUILD'
			or event == 'CHAT_MSG_PARTY'
			or event == 'CHAT_MSG_RAID'
			or event == 'CHAT_MSG_RAID_LEADER'
			or event == 'CHAT_MSG_RAID_WARNING'
			or event == 'CHAT_MSG_WHISPER'
			or event == 'CHAT_MSG_SAY'
			or event == 'CHAT_MSG_YELL'
			or event == 'CHAT_MSG_BATTLEGROUND'
			or event == 'CHAT_MSG_BATTLEGROUND_LEADER'
			or event == 'CHAT_MSG_OFFICER'
			or event == 'CHAT_MSG_AFK'
			or event == 'CHAT_MSG_DND'
			or event == 'CHAT_MSG_EMOTE'
		then
			arg1 = mend_clinks(arg1)
			arg1 = mend_links(arg1)
		end
		return orig(event)
	end
end)