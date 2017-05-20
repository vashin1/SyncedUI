local cooline = CreateFrame('Button', nil, UIParent)
cooline:SetScript('OnEvent', function()
	this[event]()
end)
cooline:RegisterEvent('VARIABLES_LOADED')

cooline_settings = { x = 0, y = -240 }

local frame_pool = {}
local cooldowns = {}

function cooline.hyperlink_name(hyperlink)
    local _, _, name = strfind(hyperlink, '|Hitem:%d+:%d+:%d+:%d+|h[[]([^]]+)[]]|h')
    return name
end

function cooline.detect_cooldowns()
	
	local function start_cooldown(name, texture, start_time, duration, is_spell)
		for _, ignored_name in cooline_ignore_list do
			if strupper(name) == strupper(ignored_name) then
				return
			end
		end
		
		local end_time = start_time + duration
			
		for _, cooldown in pairs(cooldowns) do
			if cooldown.end_time == end_time then
				return
			end
		end

		cooldowns[name] = cooldowns[name] or tremove(frame_pool) or cooline.cooldown_frame()
		local frame = cooldowns[name]
		frame:SetWidth(cooline.icon_size)
		frame:SetHeight(cooline.icon_size)
		frame.icon:SetTexture(texture)
		if is_spell then
			frame:SetBackdropColor(unpack(cooline_theme.spellcolor))
		else
			frame:SetBackdropColor(unpack(cooline_theme.nospellcolor))
		end
		frame:SetAlpha((end_time - GetTime() > 360) and 0.6 or 1)
		frame.end_time = end_time
		frame:Show()
	end
	
    for bag = 0,4 do
        if GetBagName(bag) then
            for slot = 1, GetContainerNumSlots(bag) do
				local start_time, duration, enabled = GetContainerItemCooldown(bag, slot)
				if enabled == 1 then
					local name = cooline.hyperlink_name(GetContainerItemLink(bag, slot))
					if duration > 3 and duration < 3601 then
						start_cooldown(
							name,
							GetContainerItemInfo(bag, slot),
							start_time,
							duration,
							false
						)
					elseif duration == 0 then
						cooline.clear_cooldown(name)
					end
				end
            end
        end
    end
	
	for slot=0,19 do
		local start_time, duration, enabled = GetInventoryItemCooldown('player', slot)
		if enabled == 1 then
			local name = cooline.hyperlink_name(GetInventoryItemLink('player', slot))
			if duration > 3 and duration < 3601 then
				start_cooldown(
					name,
					GetInventoryItemTexture('player', slot),
					start_time,
					duration,
					false
				)
			elseif duration == 0 then
				cooline.clear_cooldown(name)
			end
		end
	end
	
	local _, _, offset, spell_count = GetSpellTabInfo(GetNumSpellTabs())
	local total_spells = offset + spell_count
	for id=1,total_spells do
		local start_time, duration, enabled = GetSpellCooldown(id, BOOKTYPE_SPELL)
		local name = GetSpellName(id, BOOKTYPE_SPELL)
		if enabled == 1 and duration > 2.5 then
			start_cooldown(
				name,
				GetSpellTexture(id, BOOKTYPE_SPELL),
				start_time,
				duration,
				true
			)
		elseif duration == 0 then
			cooline.clear_cooldown(name)
		end
	end
	
	cooline.on_update(true)
end

function cooline.cooldown_frame()
	local frame = CreateFrame('Frame', nil, cooline.border)
	frame:SetBackdrop({ bgFile=[[Interface\AddOns\cooline\backdrop.tga]] })
	frame.icon = frame:CreateTexture(nil, 'ARTWORK')
	frame.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	frame.icon:SetPoint('TOPLEFT', 1, -1)
	frame.icon:SetPoint('BOTTOMRIGHT', -1, 1)
	return frame
end

local function place_H(this, offset, just)
	this:SetPoint(just or 'CENTER', cooline, 'LEFT', offset, 0)
end
local function place_HR(this, offset, just)
	this:SetPoint(just or 'CENTER', cooline, 'LEFT', cooline_theme.width - offset, 0)
end
local function place_V(this, offset, just)
	this:SetPoint(just or 'CENTER', cooline, 'BOTTOM', 0, offset)
end
local function place_VR(this, offset, just)
	this:SetPoint(just or 'CENTER', cooline, 'BOTTOM', 0, cooline_theme.height - offset)
end

function cooline.clear_cooldown(name)
	if cooldowns[name] then
		cooldowns[name]:Hide()
		tinsert(frame_pool, cooldowns[name])
		cooldowns[name] = nil
	end
end

local relevel, throt = false, 0

function getKeysSortedByValue(tbl, sortFunction)
	local keys = {}
	for key in pairs(tbl) do
		table.insert(keys, key)
	end

	table.sort(keys, function(a, b)
		return sortFunction(tbl[a], tbl[b])
	end)

	return keys
end

function cooline.update_cooldown(name, frame, position, tthrot, relevel)
	throt = min(throt, tthrot)
	
	if frame.end_time - GetTime() < cooline_theme.treshold then
		local sorted = getKeysSortedByValue(cooldowns, function(a, b) return a.end_time > b.end_time end)
		for i, k in ipairs(sorted) do
			if name == k then
				frame:SetFrameLevel(i+2)
			end
		end
	else
		if relevel then
			frame:SetFrameLevel(random(1,5) + 2)
		end
	end
	
	cooline.place(frame, position)
end

do
	local last_update, last_relevel = GetTime(), GetTime()
	
	function cooline.on_update(force)
		if GetTime() - last_update < throt and not force then return end
		last_update = GetTime()
		
		relevel = false
		if GetTime() - last_relevel > 0.4 then
			relevel, last_relevel = true, GetTime()
		end
		
		isactive, throt = false, 1.5
		for name, frame in pairs(cooldowns) do
			local time_left = frame.end_time - GetTime()
			isactive = isactive or time_left < 360
			
			if time_left < -1 then
				throt = min(throt, 0.2)
				isactive = true
				cooline.clear_cooldown(name)
			elseif time_left < 0 then
				cooline.update_cooldown(name, frame, 0, 0, relevel)
				frame:SetAlpha(1 + time_left)  -- fades
			elseif time_left < 0.3 then
				local size = cooline.icon_size * (0.5 - time_left) * 5  -- icon_size + icon_size * (0.3 - time_left) / 0.2
				frame:SetWidth(size)
				frame:SetHeight(size)
				cooline.update_cooldown(name, frame, cooline.section * time_left, 0, relevel)
			elseif time_left < 1 then
				cooline.update_cooldown(name, frame, cooline.section * time_left, 0, relevel)
			elseif time_left < 3 then
				cooline.update_cooldown(name, frame, cooline.section * (time_left + 1) * 0.5, 0.02, relevel)  -- 1 + (time_left - 1) / 2
			elseif time_left < 10 then
				cooline.update_cooldown(name, frame, cooline.section * (time_left + 11) * 0.14286, time_left > 4 and 0.05 or 0.02, relevel)  -- 2 + (time_left - 3) / 7
			elseif time_left < 30 then
				cooline.update_cooldown(name, frame, cooline.section * (time_left + 50) * 0.05, 0.06, relevel)  -- 3 + (time_left - 10) / 20
			elseif time_left < 120 then
				cooline.update_cooldown(name, frame, cooline.section * (time_left + 330) * 0.011111, 0.18, relevel)  -- 4 + (time_left - 30) / 90
			elseif time_left < 360 then
				cooline.update_cooldown(name, frame, cooline.section * (time_left + 1080) * 0.0041667, 1.2, relevel)  -- 5 + (time_left - 120) / 240
				frame:SetAlpha(cooline_theme.activealpha)
			else
				cooline.update_cooldown(name, frame, 6 * cooline.section, 2, relevel)
			end
		end
		cooline:SetAlpha(isactive and cooline_theme.activealpha or cooline_theme.inactivealpha)
	end
end

function cooline.label(text, offset, just)
	local fs = cooline.overlay:CreateFontString(nil, 'OVERLAY')
	fs:SetFont(cooline_theme.font, cooline_theme.fontsize)
	fs:SetTextColor(unpack(cooline_theme.fontcolor))
	fs:SetText(text)
	fs:SetWidth(cooline_theme.fontsize * 3)
	fs:SetHeight(cooline_theme.fontsize + 2)
	fs:SetShadowColor(unpack(cooline_theme.bgcolor))
	fs:SetShadowOffset(1, -1)
	if just then
		fs:ClearAllPoints()
		if cooline_theme.vertical then
			fs:SetJustifyH('CENTER')
			just = cooline_theme.reverse and ((just == 'LEFT' and 'TOP') or 'BOTTOM') or ((just == 'LEFT' and 'BOTTOM') or 'TOP')
		elseif cooline_theme.reverse then
			just = (just == 'LEFT' and 'RIGHT') or 'LEFT'
			offset = offset + ((just == 'LEFT' and 1) or -1)
			fs:SetJustifyH(just)
		else
			offset = offset + ((just == 'LEFT' and 1) or -1)
			fs:SetJustifyH(just)
		end
	else
		fs:SetJustifyH('CENTER')
	end
	cooline.place(fs, offset, just)
	return fs
end

function cooline.VARIABLES_LOADED()

	cooline:SetClampedToScreen(true)
	cooline:SetMovable(true)
	cooline:RegisterForDrag('LeftButton')
	
	function cooline:on_drag_stop()
		this:StopMovingOrSizing()
		local x, y = this:GetCenter()
		local ux, uy = UIParent:GetCenter()
		cooline_settings.x, cooline_settings.y = floor(x - ux + 0.5), floor(y - uy + 0.5)
		this.dragging = false
	end
	cooline:SetScript('OnDragStart', function()
		this.dragging = true
		this:StartMoving()
	end)
	cooline:SetScript('OnDragStop', function()
		this:on_drag_stop()
	end)
	cooline:SetScript('OnUpdate', function()
		this:EnableMouse(IsAltKeyDown())
		if not IsAltKeyDown() and this.dragging then
			this:on_drag_stop()
		end
		cooline.on_update()
	end)

	cooline:SetWidth(cooline_theme.width)
	cooline:SetHeight(cooline_theme.height)
	cooline:SetPoint('CENTER', cooline_settings.x, cooline_settings.y)
	
	cooline.bg = cooline:CreateTexture(nil, 'ARTWORK')
	cooline.bg:SetTexture(cooline_theme.statusbar)
	cooline.bg:SetVertexColor(unpack(cooline_theme.bgcolor))
	cooline.bg:SetAllPoints(cooline)
	if cooline_theme.vertical then
		cooline.bg:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1)
	else
		cooline.bg:SetTexCoord(0, 1, 0, 1)
	end

	cooline.border = CreateFrame('Frame', nil, cooline)
	cooline.border:SetPoint('TOPLEFT', -cooline_theme.borderinset, cooline_theme.borderinset)
	cooline.border:SetPoint('BOTTOMRIGHT', cooline_theme.borderinset, -cooline_theme.borderinset)
	cooline.border:SetBackdrop({
		edgeFile = cooline_theme.border,
		edgeSize = cooline_theme.bordersize,
	})
	cooline.border:SetBackdropBorderColor(unpack(cooline_theme.bordercolor))

	cooline.overlay = CreateFrame('Frame', nil, cooline.border)
	cooline.overlay:SetFrameLevel(24) -- TODO this gets changed automatically later, to 9, find out why

	cooline.section = (cooline_theme.vertical and cooline_theme.height or cooline_theme.width) / 6
	cooline.icon_size = (cooline_theme.vertical and cooline_theme.width or cooline_theme.height) + cooline_theme.iconoutset * 2
	cooline.place = cooline_theme.vertical and (cooline_theme.reverse and place_VR or place_V) or (cooline_theme.reverse and place_HR or place_H)

	cooline.tick0 = cooline.label('0', 0, 'LEFT')
	cooline.tick1 = cooline.label('1', cooline.section)
	cooline.tick3 = cooline.label('3', cooline.section * 2)
	cooline.tick10 = cooline.label('10', cooline.section * 3)
	cooline.tick30 = cooline.label('30', cooline.section * 4)
	cooline.tick120 = cooline.label('2m', cooline.section * 5)
	cooline.tick300 = cooline.label('6m', cooline.section * 6, 'RIGHT')
	
	cooline:RegisterEvent('SPELL_UPDATE_COOLDOWN')
	cooline:RegisterEvent('BAG_UPDATE_COOLDOWN')
	
	cooline.detect_cooldowns()
end

function cooline.BAG_UPDATE_COOLDOWN()
	cooline.detect_cooldowns()
end

function cooline.SPELL_UPDATE_COOLDOWN()
	cooline.detect_cooldowns()
end
