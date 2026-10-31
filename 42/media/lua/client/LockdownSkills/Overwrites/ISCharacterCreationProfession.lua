---@diagnostic disable: need-check-nil

require "OptionScreens/CharacterCreationProfession"
function CharacterCreationProfession:onSelectProf(characterProfessionDefinition)
    if self.profession ~= characterProfessionDefinition then
        local removed = {}
        if self.profession then
            -- remove the previous free trait
            for i = 0, self.profession:getGrantedTraits():size() - 1 do
                local freeCharacterTraitDefinition = CharacterTraitDefinition.getCharacterTraitDefinition(self
                    .profession:getGrantedTraits():get(i))
                local label = freeCharacterTraitDefinition:getLabel()
                self.listboxTraitSelected:removeMatchingItems(label)
                table.insert(removed, freeCharacterTraitDefinition)
                self.freeTraits:remove(label)
            end
        end

        -- Remove chosen traits that are excluded by the profession's free traits.
        for i = self.listboxTraitSelected:size(), 1, -1 do
            local selectedTrait = self.listboxTraitSelected.items[i].item
            for j = 1, characterProfessionDefinition:getGrantedTraits():size() do
                local freeCharacterTraitDefinition = CharacterTraitDefinition.getCharacterTraitDefinition(
                    characterProfessionDefinition:getGrantedTraits():get(j - 1))
                if freeCharacterTraitDefinition:getMutuallyExclusiveTraits():contains(selectedTrait:getType()) then
                    self:removeTrait(i)
                end
            end
        end

        for i = self.listboxTraitSelected:size(), 1, -1 do
            local selectedTrait = self.listboxTraitSelected.items[i].item

            local TraitTable = Lockdown.Traits[tostring(selectedTrait:getType())]

            if TraitTable then
                local AllowedProfessions = TraitTable.AllowedProfessions or {}

                for j = 1, #AllowedProfessions do
                    local allowedProfession = AllowedProfessions[j]

                    if (allowedProfession ~= "ANY") and (allowedProfession ~= tostring(characterProfessionDefinition:getType())) then
                        self:removeTrait(i)
                        break
                    end
                end
            end
        end

        -- we add the free trait that our selected profession give us
        for i = 0, characterProfessionDefinition:getGrantedTraits():size() - 1 do
            local freeCharacterTraitDefinition = CharacterTraitDefinition.getCharacterTraitDefinition(
                characterProfessionDefinition:getGrantedTraits():get(i))
            local newTrait = self.listboxTraitSelected:addUniqueItem(freeCharacterTraitDefinition:getLabel(),
                freeCharacterTraitDefinition)
            if newTrait then
                newTrait.tooltip = freeCharacterTraitDefinition:getDescription()
            end
            self.freeTraits:add(freeCharacterTraitDefinition:getLabel())
            self:doTestForMutuallyExclusiveTraits(freeCharacterTraitDefinition, false)
        end

        for _, trait in pairs(removed) do
            self:doTestForMutuallyExclusiveTraits(trait, true)
        end

        self.profession = characterProfessionDefinition
        local desc = MainScreen.instance.desc
        desc:setProfessionSkills(self.profession)
        local characterProfession = self.profession:getType()
        desc:setCharacterProfession(characterProfession)
        self.cost = self.profession:getCost()
        self:changeClothes()
        self:checkXPBoost()
        CharacterCreationMain.sort(self.listboxTrait.items)
        CharacterCreationMain.invertSort(self.listboxBadTrait.items)
        CharacterCreationMain.sort(self.listboxTraitSelected.items)
        CharacterCreationMain.instance:disableBtn()

        self:repopulateTraitLists()
    end
end

function CharacterCreationProfession:populateProfessionList(list)
    local professionList = CharacterProfessionDefinition.getProfessions()
    for i = 0, professionList:size() - 1 do
        local profession = professionList:get(i)

        if Lockdown.Professions[tostring(profession:getType())] ~= nil then
            local newitem = list:addItem(profession:getUIName(), profession)
            newitem.tooltip = profession:getDescription()
        end
    end
    list:sort(function (a, b)
        if a.item:getType() == CharacterProfession.UNEMPLOYED then
            return true
        end
        if b.item:getType() == CharacterProfession.UNEMPLOYED then
            return true
        end
        return not string.sort(a.text, b.text)
    end)
end

function CharacterCreationProfession:populateTraitList(list)
    list:clear()
    local traitList = CharacterTraitDefinition.getTraits()
    for i = 0, traitList:size() - 1 do
        local trait = traitList:get(i)
        if not trait:isFree() and trait:getCost() > 0 and self:isTraitEnabled(trait) and not self:isTraitExcluded(trait) then
            local traitType = tostring(trait:getType())
            local TraitTable = Lockdown.Traits[traitType] or nil

            if TraitTable then
                local AllowedProfessions = TraitTable.AllowedProfessions or {}

                local professionType = nil
                if self.profession and self.profession:getType() then
                    professionType = tostring(self.profession:getType())
                end

                for j = 1, #AllowedProfessions do
                    if (AllowedProfessions[j] == "ANY") or (AllowedProfessions[j] == professionType) then
                        list:addItem(trait:getLabel(), trait, trait:getDescription())
                        break
                    end
                end
            end
        end
    end
end

function CharacterCreationProfession:populateBadTraitList(list)
    list:clear()
    local traitList = CharacterTraitDefinition.getTraits()
    for i = 0, traitList:size() - 1 do
        local trait = traitList:get(i)
        if not trait:isFree() and trait:getCost() < 0 and self:isTraitEnabled(trait) and not self:isTraitExcluded(trait) then
            local traitType = tostring(trait:getType())
            local TraitTable = Lockdown.Traits[traitType] or nil

            if TraitTable then
                local AllowedProfessions = TraitTable.AllowedProfessions or {}

                local professionType = nil
                if self.profession and self.profession:getType() then
                    professionType = tostring(self.profession:getType())
                end

                for j = 1, #AllowedProfessions do
                    if (AllowedProfessions[j] == "ANY") or (AllowedProfessions[j] == professionType) then
                        list:addItem(trait:getLabel(), trait, trait:getDescription())
                        break
                    end
                end
            end
        end
    end
end
