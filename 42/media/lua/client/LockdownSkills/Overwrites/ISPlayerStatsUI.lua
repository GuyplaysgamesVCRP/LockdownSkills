---@diagnostic disable: need-check-nil, undefined-field, inject-field, missing-parameter

require "ISUI/PlayerStats/ISPlayerStatsUI"

ISPlayerStatsUI.loadPerks = function (self)
    local previousSelection = self.xpListBox.selected
    self.xpListBox:clear()
    local maxNameWidth = 0
    for i = 0, Perks.getMaxIndex() - 1 do
        local perk = PerkFactory.getPerk(Perks.fromIndex(i))
        if perk and perk:getParent() ~= Perks.None then
            local newPerk = {}
            newPerk.perk = Perks.fromIndex(i)

            local parent = Lockdown.Skills.FindPerkParents[perk] or nil

            if parent then
                newPerk.name = "(" .. PerkFactory.getPerkName(parent) .. ") " .. perk:getName()
            else
                newPerk.name = "(zDepreciated - DO NOT TOUCH!) " .. perk:getName()
            end

            newPerk.level = self.char:getPerkLevel(Perks.fromIndex(i))
            newPerk.xpToLevel = perk:getXpForLevel(newPerk.level + 1)
            newPerk.xp = self.char:getXp():getXP(newPerk.perk) - ISSkillProgressBar.getPreviousXpLvl(perk, newPerk.level)
            newPerk.xp = round(newPerk.xp, 2)
            local xpBoost = self.char:getXp():getPerkBoost(newPerk.perk)
            if xpBoost == 1 then
                newPerk.boost = "75%"
            elseif xpBoost == 2 then
                newPerk.boost = "100%"
            elseif xpBoost == 3 then
                newPerk.boost = "125%"
            else
                newPerk.boost = "50%"
            end
            newPerk.multiplier = self.char:getXp():getMultiplier(newPerk.perk)
            self.xpListBox:addItem(newPerk.name, newPerk)
            maxNameWidth = math.max(maxNameWidth, getTextManager():MeasureStringX(self.xpListBox.font, newPerk.name))
        end
    end

    self.xpListBox:sort()
    self.xpListBox.selected = previousSelection
    self.xpListBox.columnWidth[1] = maxNameWidth + 15
    self.xpListBox:setScrollHeight(self.xpListBox:size() * self.xpListBox.itemheight)
    self:updateColumns()
end

function ISPlayerStatsUI:drawPerk(y, item, alt)
    local a = 0.9

    self:drawRectBorder(0, (y), self:getWidth(), self.itemheight - 1, a, self.borderColor.r, self.borderColor.g,
        self.borderColor.b)

    if self.selected == item.index then
        self:drawRect(0, (y), self:getWidth(), self.itemheight - 1, 0.3, 0.7, 0.35, 0.15)
        self.mainUI.selectedPerk = item.item
    end

    self:drawRect(self.columnLeft[2], y - 1, 1, self.itemheight, 1, self.borderColor.r, self.borderColor.g,
        self.borderColor.b)
    self:drawRect(self.columnLeft[3], y - 1, 1, self.itemheight, 1, self.borderColor.r, self.borderColor.g,
        self.borderColor.b)
    self:drawRect(self.columnLeft[4], y - 1, 1, self.itemheight, 1, self.borderColor.r, self.borderColor.g,
        self.borderColor.b)
    self:drawRect(self.columnLeft[5], y - 1, 1, self.itemheight, 1, self.borderColor.r, self.borderColor.g,
        self.borderColor.b)

    local yoff = 2

    local parent = Lockdown.Skills.FindPerkParents[item.item.perk] or Perks.Depreciated
    local ParentColors = Lockdown.Skills.PerkParents[parent].Colors

    self:drawText(item.item.name, 5, y + yoff, ParentColors.r, ParentColors.g, ParentColors.b, a, self.font)

    self:drawText(item.item.level .. "", self.columnLeft[2] + 10, y + yoff, 1, 1, 1, a, self.font)
    if item.item.xpToLevel == -1 then
        self:drawText("MAX", self.columnLeft[3] + 10, y + yoff, 1, 1, 1, a, self.font)
    else
        self:drawText(item.item.xp .. "/" .. item.item.xpToLevel, self.columnLeft[3] + 10, y + yoff, 1, 1, 1, a,
            self.font)
    end
    self:drawText(item.item.boost, self.columnLeft[4] + 10, y + yoff, 1, 1, 1, a, self.font)
    self:drawText(item.item.multiplier .. "", self.columnLeft[5] + 10, y + yoff, 1, 1, 1, a, self.font)

    return y + self.itemheight
end
