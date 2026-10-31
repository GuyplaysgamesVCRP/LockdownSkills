---@diagnostic disable: need-check-nil, undefined-field, assign-type-mismatch

require "XpSystem/ISUI/ISCharacterInfo"

local UI_BORDER_SPACING = 10
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local BUTTON_HGT = FONT_HGT_SMALL + 6
local SCROLL_BAR_WIDTH = 13

function ISCharacterInfo:render()
    local y = UI_BORDER_SPACING

    if self.lastLevelUpTime > 0 then
        self.lastLevelUpTime = self.lastLevelUpTime - 0.0025
    elseif self.lastLevelUpTime < 0 then
        self.lastLevelUpTime = 0
    end

    ISSkillProgressBar.updateAlpha() -- FIXME: do this once per frame, not for each player
    -- how much skills pts we got ?
    if self.reloadSkillBar then
        self.progressBarLoaded = false
        self.reloadSkillBar = false
        for i, v in pairs(self.progressBars) do
            self:removeChild(v)
        end
        self.progressBars = {}
    end

    local top = y

    -- if we got a multiplier, we gonna anim that with ">, >>, >>>"
    -- FIXME: do this once per frame, not for each player
    local ms = UIManager.getMillisSinceLastRender()
    ISCharacterInfo.timerMultiplierAnim = ISCharacterInfo.timerMultiplierAnim + ms
    if ISCharacterInfo.timerMultiplierAnim <= 500 then
        ISCharacterInfo.animOffset = -1
    elseif ISCharacterInfo.timerMultiplierAnim <= 1000 then
        ISCharacterInfo.animOffset = 0
    elseif ISCharacterInfo.timerMultiplierAnim <= 1500 then
        ISCharacterInfo.animOffset = 15
    elseif ISCharacterInfo.timerMultiplierAnim <= 2000 then
        ISCharacterInfo.animOffset = 30
    else
        ISCharacterInfo.timerMultiplierAnim = 0
    end

    local left = UI_BORDER_SPACING * 2 + BUTTON_HGT + 1
    local maxY = y
    local fontOffset = (BUTTON_HGT - FONT_HGT_SMALL) / 2
    local rowHgt = BUTTON_HGT
    for i, parentPerk in ipairs(self.sorted) do
        -- local perkList = self.perks[parentPerk:getType()]

        local PerkData = Lockdown.Skills.PerkParents[parentPerk]

        local icon = PerkData.icon or nil
        local parent_r = PerkData.Colors.r
        local parent_g = PerkData.Colors.g
        local parent_b = PerkData.Colors.b

        --local perkList = {}
        local perkList = self.perks[parentPerk:getType()]

        -- we first draw our parent name
        if icon then
            self:drawTexture(icon, left, y + fontOffset - 3, 1, parent_r, parent_g, parent_b)
            self:drawText(parentPerk:getName(), left + 20, y + fontOffset, parent_r, parent_g, parent_b, 1, UIFont.Small)
        else
            self:drawText(parentPerk:getName(), left, y + fontOffset, parent_r, parent_g, parent_b, 1, UIFont.Small)
        end
        self.buttonList[i]:setY(y)
        y = y + math.max(BUTTON_HGT)
        -- then all the skills with their progress bar
        if not self.collapse[i] then
            self:drawTexture(self.SkillBarSeparator, 0, y + UI_BORDER_SPACING, 1, 1, 1, 1)
            y = y + UI_BORDER_SPACING

            for ind, perk in ipairs(perkList) do
                local xpBoost = self.char:getXp():getPerkBoost(perk:getType())
                local r = 1
                local g = 1
                local b = 1

                if xpBoost == 0 then
                    r = 0.54
                    g = 0.54
                    b = 0.54
                elseif xpBoost == 1 then
                    r = 0.8
                    g = 0.8
                    b = 0.8
                elseif xpBoost == 3 then
                    r = 1
                    g = 0.83
                    b = 0
                end

                self:drawText(perk:getName(), left + UI_BORDER_SPACING * 2, y + fontOffset, r, g, b, 1, UIFont.Small)

                if self.char:getXp():getMultiplier(perk:getType()) > 0 then
                    local arrowPixelOffset = 2
                    local arrowHeight = self.arrow:getHeight()
                    local arrowOffset = math.floor((BUTTON_HGT - arrowHeight) / 2) - arrowPixelOffset

                    self:drawTexture(self.disabledArrow, UI_BORDER_SPACING + 1 - arrowPixelOffset, y + arrowOffset, 1,
                        1, 1, 1)
                    self:drawTexture(self.disabledArrow, UI_BORDER_SPACING + 1 + 15 - arrowPixelOffset,
                        y + arrowOffset, 1, 1, 1, 1)
                    self:drawTexture(self.disabledArrow, UI_BORDER_SPACING + 1 + 30 - arrowPixelOffset,
                        y + arrowOffset, 1, 1, 1, 1)

                    if ISCharacterInfo.animOffset > -1 then
                        self:drawTexture(self.arrow,
                            UI_BORDER_SPACING + 1 + ISCharacterInfo.animOffset - arrowPixelOffset, y + arrowOffset, 1,
                            1, 1, 1)
                    end
                end

                if not self.progressBarLoaded then
                    local skillPointSize = math.floor((FONT_HGT_SMALL + 6) / 2)
                    local skillPointOffset = (BUTTON_HGT - skillPointSize) / 2
                    local progressBar = ISSkillProgressBar:new(left + UI_BORDER_SPACING * 3 + self.txtLen,
                        y + skillPointOffset, 0, 0, self.playerNum, perk, self)
                    progressBar:initialise()

                    self:addChild(progressBar)
                    table.insert(self.progressBars, progressBar)
                end

                y = y + rowHgt
            end
        end
        y = y + UI_BORDER_SPACING
        maxY = math.max(maxY, y)
    end
    y = y + 1

    local skillPointSize = math.floor((FONT_HGT_SMALL + 6) / 2)
    local skillPointSpacing = getCore():getOptionFontSizeReal()

    self:setWidthAndParentWidth(math.max(self.width,
        left + UI_BORDER_SPACING * 4 + self.txtLen + skillPointSize * 10 + skillPointSpacing * 9 + SCROLL_BAR_WIDTH + 1))
    self:setHeightAndParentHeight(math.min(y, 800))

    self:setScrollHeight(y)

    self.progressBarLoaded = true

    if self.joyfocus then
        if self.joypadIndex and self.joypadIndex >= 1 and self.joypadIndex <= #self.progressBars then
            local bar = self.progressBars[self.joypadIndex]
            local left = bar:getX() - (self.txtLen + 45)
            local right = bar:getX() + bar:getWidth()
            self:drawRectBorder(left - 2, bar:getY() - 2, (right - left) + 2, bar:getHeight() + 3, 0.4, 0.2, 1.0, 1.0)
            if bar.tooltip then
                bar.tooltip.followMouse = false
                bar.tooltip:setX(bar:getAbsoluteX())
                local tty = bar:getAbsoluteY() + bar:getHeight() + 1
                if tty + bar.tooltip:getHeight() > getCore():getScreenHeight() then
                    tty = bar:getAbsoluteY() - bar.tooltip:getHeight() - 1
                end
                bar.tooltip:setY(tty)
            end
        end
    end

    self:clearStencilRect()
end

ISCharacterInfo.loadPerk = function (self)
    local perks = {}
    -- we start to fetch all our perks
    for i = 0, PerkFactory.PerkList:size() - 1 do
        local perk = PerkFactory.PerkList:get(i)
        local parentPerk = Lockdown.Skills.FindPerkParents[perk] or Perks.Depreciated

        -- we only add in our list the child perk
        -- here we just display the active skill, not the passive ones (they are in another tab)
        -- parentPerk ~= Perks.Depreciated
        if parentPerk and parentPerk ~= Perks.Depreciated and perk:getParent() ~= Perks.None then
            -- we take the longest skill's name as width reference
            local pixLen = getTextManager():MeasureStringX(UIFont.Small, perk:getName())
            if pixLen > self.txtLen then
                self.txtLen = pixLen
            end
            if not perks[parentPerk] then
                perks[parentPerk] = {}
            end
            table.insert(perks[parentPerk], perk)
        end
    end
    return perks
end
