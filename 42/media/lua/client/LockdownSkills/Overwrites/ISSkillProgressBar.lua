---@diagnostic disable: need-check-nil, undefined-field, inject-field

require "XpSystem/ISUI/ISSkillProgressBar"

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local SKILL_POINT_HGT = math.floor((FONT_HGT_SMALL + 6) / 2)
local SKILL_POINT_SPACING = getCore():getOptionFontSizeReal()

--Good Highlight Color for newly acquired skills
local GHCr = getCore():getGoodHighlitedColor():getR()
local GHCg = getCore():getGoodHighlitedColor():getG()
local GHCb = getCore():getGoodHighlitedColor():getB()

function ISSkillProgressBar:renderPerkRect()
    local x = 0
    local y = 0

    -- perks level up automatically, update the UI
    if self.level ~= self.char:getPerkLevel(self.perk:getType()) then
        self.level = self.char:getPerkLevel(self.perk:getType())
        self.xpForLvl = ISSkillProgressBar.getXpForLvl(self.perk, self.level)
        if Lockdown.Skills.FindPerkParents[self.perk] then
            self.parent.lastLeveledUpPerk = self.perk
            self.parent.lastLevelUpTime = 1
        end
    end

    -- how much xp we already acquire for this perk
    self.xp = ISSkillProgressBar.getPerkXp(self)

    if self.xp > self.xpForLvl then
        self.xp = self.xpForLvl
    end

    -- we start to render our first rect : all the lvl we already got, we render them in a simple white rect
    -- ex : if we're lvl 3, we gonna render 2 (lvl 1 and 2) white rect
    for i = 0, self.level - 1 do
        --~ 		self:drawRect(x, y, 19, 19, 1.0, 1.0, 1.0, 1.0);
        if self.parent.lastLeveledUpPerk == self.perk then
            --this fades over time to return to the original colour

            local lastLevelUpTime = self.parent.lastLevelUpTime
            local OneMinus = 1 - lastLevelUpTime
            local lerpR = self.TARr * OneMinus + GHCr * lastLevelUpTime
            local lerpG = self.TARg * OneMinus + GHCg * lastLevelUpTime
            local lerpB = self.TARb * OneMinus + GHCb * lastLevelUpTime


            --a * (1-t) + b * t

            self:drawTextureScaled(self.SkillUnitFilled, x, y, SKILL_POINT_HGT, SKILL_POINT_HGT, 1, lerpR, lerpG, lerpB)
            self:drawTextureScaled(self.SkillUnitBorder, x, y, SKILL_POINT_HGT, SKILL_POINT_HGT, 1, lerpR, lerpG, lerpB)
        else
            self:drawTextureScaled(self.SkillUnitFilled, x, y, SKILL_POINT_HGT, SKILL_POINT_HGT, 1, self.TARr, self.TARg,
                self.TARb)
            self:drawTextureScaled(self.SkillUnitBorder, x, y, SKILL_POINT_HGT, SKILL_POINT_HGT, 1, self.TARr, self.TARg,
                self.TARb)
        end
        x = x + SKILL_POINT_HGT + SKILL_POINT_SPACING
    end

    local maxLevel = 10
    local modData = self.char:getModData()
    if modData.LDSkills_limits and modData.LDSkills_limits[self.perk:getId()] then
        maxLevel = modData.LDSkills_limits[self.perk:getId()]
    end
    maxLevel = tonumber(tostring(maxLevel)) - 1

    -- the most important square : the one in progress !
    -- for this one we got multiple choice :
    -- * In progress : light grey rect filled with light grey depending on the progress
    -- * In faster progress : if you read a book 'bout this skill or if a npc trained you, it's a light blue/filled with light blue too
    -- * Finished but no skills pts available : a white rect full filled with light grey
    -- * Finished and ready to take : a white rect that glow filled with light grey
    if self.level < 10 then
        if self.level ~= maxLevel + 1 then
            -- we gonna fill with light grey our rect, depending on the progress of our lvl (50% xp mean a rect filled at 50%)
            -- this width correspond to 1% xp progress
            local sliceWidth = (SKILL_POINT_HGT) / 100
            -- our progress into the current lvl in %
            local percentProgress = (self.xp / self.xpForLvl) * 100
            if percentProgress < 0 then percentProgress = 0 end
            -- we now draw our rect with the correct width
            -- our border, a bit darker than the filled rect or if the skill is rdy to unlock it's a white border
            if percentProgress == 100 then
                if self.perk:isPassiv() then
                    self:drawTextureScaled(self.SkillUnitFilled, x, y, SKILL_POINT_HGT, SKILL_POINT_HGT, 1, self.TARr,
                        self.TARg, self.TARb)
                else -- the skill is ready to be trained but no skill pts available, we set up just a white border
                    self:drawTextureScaled(self.SkillUnitFilled, x, y, SKILL_POINT_HGT, SKILL_POINT_HGT, 1, self.TARr,
                        self.TARg, self.TARb)
                    self:drawTextureScaled(self.SkillUnitBorder, x, y, SKILL_POINT_HGT, SKILL_POINT_HGT, 1, 1, 1, 1)
                end
            else -- skill is in progress, we set up a grey rect and fill it depending on the skill progress
                self:drawTextureScaled(self.SkillUnitBorder, x, y, SKILL_POINT_HGT, SKILL_POINT_HGT, 1, 0.4, 0.4, 0.4)
                self:drawTextureScaled(self.SkillUnitFilled, x, y, sliceWidth * percentProgress, SKILL_POINT_HGT, 1, 0.4,
                    0.4,
                    0.4)
            end
        else
            self:drawTextureScaled(self.SkillUnitBorder, x, y, SKILL_POINT_HGT, SKILL_POINT_HGT, 0.2, 0.6, 0.2, 0.2)
        end
        x = x + SKILL_POINT_HGT + SKILL_POINT_SPACING
    end

    -- our last square : the no available ones, this is just an empty dark grey rect
    for i = tonumber(tostring(self.level)) + 1, 9 do
        --~ 		self:drawRect(x, y, 19, 19, 0.5, 0.41, 0.41, 0.41);
        if i <= maxLevel then
            self:drawTextureScaled(self.SkillUnitBorder, x, y, SKILL_POINT_HGT, SKILL_POINT_HGT, 1, 0.2, 0.2, 0.2)
        else
            self:drawTextureScaled(self.SkillUnitBorder, x, y, SKILL_POINT_HGT, SKILL_POINT_HGT, 0.2, 0.6, 0.2, 0.2)
        end
        x = x + SKILL_POINT_HGT + SKILL_POINT_SPACING
    end
end

function ISSkillProgressBar:new(x, y, width, height, playerNum, perk, parent)
    local o = {}
    o = ISPanel:new(x, y, (SKILL_POINT_HGT + SKILL_POINT_SPACING) * 10, SKILL_POINT_HGT)
    setmetatable(o, self)
    self.__index = self
    o.playerNum = playerNum
    o.char = getSpecificPlayer(playerNum)
    o.perk = perk
    o.parent = parent
    o.xp = 0
    o.message = nil
    o.tooltip = nil
    o:noBackground()
    -- our current perk lvl
    o.level = o.char:getPerkLevel(perk:getType())
    -- how much xp we need for the next lvl
    o.xpForLvl = ISSkillProgressBar.getXpForLvl(perk, o.level)

    o.SkillUnitFilled = getTexture("media/ui/SkillPanel/SkillUnit_Fill.png")
    o.SkillUnitBorder = getTexture("media/ui/SkillPanel/SkillUnit_Border.png")
    --o.AddSkillBtn = getTexture("media/ui/XpSystemUI/AddSkillBtn.png")
    --o.SkillBtnEmptyBig = getTexture("media/ui/XpSystemUI/SkillBtnEmptyBig.png")
    --o.ProgressSkill = getTexture("media/ui/XpSystemUI/ProgressSkill.png")
    --o.SkillBtnEmptWhitey = getTexture("media/ui/XpSystemUI/SkillBtnEmptWhitey.png")

    local perkParent = Lockdown.Skills.FindPerkParents[perk] or Perks.Depreciated

    o.TARr = Lockdown.Skills.PerkParents[perkParent].Colors.r
    o.TARg = Lockdown.Skills.PerkParents[perkParent].Colors.g
    o.TARb = Lockdown.Skills.PerkParents[perkParent].Colors.b

    return o
end
