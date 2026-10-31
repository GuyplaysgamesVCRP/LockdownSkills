local Limits = {}

Limits.ComponentToCompound = {
    --- Blacksmith2
    [Perks.Blacksmith] = {
        skill = Perks.Blacksmith2,
        efficiency = 1.00,
    },
    [Perks.MetalWelding] = {
        skill = Perks.Blacksmith2,
        efficiency = 0.50,
    },
    [Perks.Mechanics] = {
        skill = Perks.Blacksmith2,
        efficiency = 0.50,
    },

    --- Sneak2
    [Perks.Sneak] = {
        skill = Perks.Sneak2,
        efficiency = 1.00,
    },
    [Perks.Lightfoot] = {
        skill = Perks.Sneak2,
        efficiency = 1.00,
    },

    --- Trapping2
    [Perks.Trapping] = {
        skill = Perks.Trapping2,
        efficiency = 1.00,
    },
    [Perks.Tracking] = {
        skill = Perks.Trapping2,
        efficiency = 1.00,
    },

    --- Artisanry
    [Perks.Glassmaking] = {
        skill = Perks.Artisanry,
        efficiency = 1.00,
    },
    [Perks.Pottery] = {
        skill = Perks.Artisanry,
        efficiency = 1.00,
    },

    --- Butchering
    [Perks.Butchering] = {
        skill = Perks.SmallBlade,
        efficiency = 0.25,
    },
}

Limits.CompoundToComponents = {
    [Perks.Blacksmith2] = {
        Perks.Blacksmith,
        Perks.MetalWelding,
        Perks.Mechanics,
    },
    [Perks.Artisanry] = {
        Perks.Glassmaking,
        Perks.Pottery,
    },
    [Perks.Trapping2] = {
        Perks.Trapping,
        Perks.Trapping,
    },
    [Perks.Sneak2] = {
        Perks.Sneak,
        Perks.Lightfoot,
    },
}

local LVLUPs = {}

function Limits.limitSkillToLevel(character, perk, level)
    if character:getPerkLevel(perk) >= level then
        if character:getPerkLevel(perk) > level then
            HaloTextHelper.addBadText(character, perk:getName() .. " set to " .. tostring(level))
        end

        character:getXp():setXPToLevel(perk, level)
        while perk:getTotalXpForLevel(character:getPerkLevel(perk)) > character:getXp():getXP(perk) do
            character:LoseLevel(perk)
        end
    end
end

function Limits.replicateComponentXP(character, perk, amount)
    local Recipient = Limits.ComponentToCompound[perk]

    if not Recipient then return end
    if not Recipient.skill then return end

    if LVLUPs[perk] then
        LVLUPs[perk] = nil
        return
    end

    local multiplier = character:getXp():getMultiplier(Recipient.skill:getType()) or 0

    if multiplier < 1 then
        multiplier = 1
    end

    local XP = amount * multiplier * (Recipient.efficiency or 1)

    addXpNoMultiplier(character, Recipient.skill, XP)

    local recipientLevel = character:getPerkLevel(Recipient.skill)

    Limits.limitSkillToLevel(character, perk, recipientLevel)
end

function Limits.replicateCompoundLevelUp(character, perk, level, increased)
    local Components = Limits.CompoundToComponents[perk] or nil

    if not Components then return end

    local xpForCompoundLevel = perk:getTotalXpForLevel(level)

    for i = 1, #Components do
        local componentPerk = Components[i]

        local xpNeeded = xpForCompoundLevel - character:getXp():getXP(componentPerk)

        LVLUPs[componentPerk] = true
        addXpNoMultiplier(character, componentPerk, xpNeeded)
    end
end

function Limits.butchering(character, perk, level, increased)
    local ButcheringSkills = {
        [Perks.Cooking] = character:getPerkLevel(Perks.Cooking),
        [Perks.SmallBlade] = character:getPerkLevel(Perks.SmallBlade),
    }

    if character:hasTrait(Lockdown.CharacterTrait.FISHERMAN_FILLETER) then
        ButcheringSkills[Perks.Fishing] = character:getPerkLevel(Perks.Fishing)
    end

    if ButcheringSkills[perk] == nil then return end

    if not character:hasTrait(Lockdown.CharacterTrait.COOK_KEENBUTCHER) then
        if character:getPerkLevel(Perks.Butchering) >= level then
            local highest = 0
            for _, skillLevel in pairs(ButcheringSkills) do
                if skillLevel > highest then
                    highest = skillLevel
                end
            end

            Limits.limitSkillToLevel(character, Perks.Butchering, highest)

            return
        end
    else
        local sum = 0
        for _, skillLevel in pairs(ButcheringSkills) do
            sum = sum + skillLevel
        end
        level = sum

        if character:getPerkLevel(Perks.Butchering) >= level then
            Limits.limitSkillToLevel(character, Perks.Butchering, level)

            return
        end
    end

    local xpForButcheringLevel = perk:getTotalXpForLevel(level)
    local xpNeeded = xpForButcheringLevel - character:getXp():getXP(Perks.Butchering)

    LVLUPs[Perks.Butchering] = true
    addXpNoMultiplier(character, Perks.Butchering, xpNeeded)
end

function Limits.skillLimit(character, perk, amount)
    local modData = character:getModData()

    if not modData.LDSkills_limits then return end

    local limit = modData.LDSkills_limits[perk:getId()]

    if limit == nil then return end

    Limits.limitSkillToLevel(character, perk, limit)
end

Limits.Kits = {}
Limits.Kits.Professions = {
    ["GUARDSMAN"] = {
        ["Base.RippedSheets"] = 5,
        ["Base.DehydratedMeatStick"] = 10,
        ["Base.Bag_LeatherWaterBag"] = 1,
        ["Base.MetalCup"] = 1,
        ["Base.Candle"] = 10,

        ["MZ.PointedHeaterShield"] = 1,
    },
    ["RANGER"] = {
        ["Base.RippedSheets"] = 5,
        ["Base.DehydratedMeatStick"] = 10,
        ["Base.MetalCup"] = 1,
        ["Base.Candle"] = 10,

        ["Base.Bag_LeatherWaterBag"] = 1,
        ["Base.Bag_HideSlingBag"] = 1,
    },
    ["CARPENTER"] = {
        ["Base.RippedSheets"] = 5,
        ["Base.DehydratedMeatStick"] = 10,
        ["Base.MetalCup"] = 1,
        ["Base.Candle"] = 10,

        ["Base.HammerForged"] = 1,
        ["Base.NailsBox"] = 3,
        ["Base.SmallSaw"] = 1,
        ["Base.WoodAxeForged"] = 1,
        ["Base.Rope"] = 8,
        ["Base.Toolbox_Wooden"] = 1,
        ["Base.Bag_CrudeLeatherBag"] = 1,
        ["Base.Bag_HideSatchel"] = 1,
    },
    ["MASON"] = {
        ["Base.RippedSheets"] = 5,
        ["Base.DehydratedMeatStick"] = 10,
        ["Base.MetalCup"] = 1,
        ["Base.Candle"] = 10,

        ["Base.MasonsTrowel"] = 1,
        ["Base.MasonsChisel"] = 1,
        ["Base.SpadeForged"] = 1,
        ["Base.ClubHammerForged"] = 1,
        ["Base.PickAxeForged"] = 1,
        ["Base.Toolbox_Wooden"] = 1,
        ["Base.Bag_CrudeLeatherBag"] = 1,
        ["Base.Bag_HideSatchel"] = 1,
        ["Base.BucketCarved"] = 2,
        ["Base.EmptySandbag"] = 5,
    },
    ["BLACKSMITH"] = {
        ["Base.RippedSheets"] = 5,
        ["Base.DehydratedMeatStick"] = 10,
        ["Base.MetalCup"] = 1,
        ["Base.Candle"] = 10,

        ["Base.SmithingHammer"] = 1,
        ["Base.Tongs"] = 1,
        ["Base.MetalworkingPliers"] = 1,
        ["Base.MetalworkingChisel"] = 1,
        ["Base.MetalworkingPunch"] = 1,
        ["Base.Glasses_OldWeldingGoggles"] = 1,
        ["Base.BlowTorch"] = 1,
        ["Base.Apron_Black"] = 1,
        ["Base.Axe_Old"] = 1,
        ["Base.Bag_HideSatchel"] = 1,
        ["Base.Toolbox_Wooden"] = 1,
    },
    ["FISHERMAN"] = {
        ["Base.RippedSheets"] = 5,
        ["Base.DehydratedMeatStick"] = 10,
        ["Base.MetalCup"] = 1,
        ["Base.Candle"] = 10,

        ["Base.KnifeFillet"] = 1,
        ["Base.FishingRod"] = 1,
        ["Base.FishingLine"] = 3,
        ["Base.Gaffhook"] = 1,
        ["Base.FishingNet"] = 5,
        ["Base.Bag_HideSatchel"] = 1,
        ["Base.Toolbox_Wooden"] = 1,
        ["Base.Bag_Gunny"] = 1,
        ["Base.Chum"] = 10,
        ["Base.Worm"] = 20,
        ["Base.Axe_Old"] = 1,
    },
    ["CLOTHIER"] = {
        ["Base.RippedSheets"] = 35,
        ["Base.DehydratedMeatStick"] = 10,
        ["Base.MetalCup"] = 1,
        ["Base.Candle"] = 10,

        ["Base.Needle_Forged"] = 1,
        ["Base.KnittingNeedles_Wood"] = 1,
        ["Base.Thread_Sinew"] = 10,
        ["Base.WoolRaw"] = 20,
        ["Base.ScissorsForged"] = 1,
        ["Base.Bag_HideSatchel"] = 1,
        ["Base.LeatherStrips"] = 25,
        ["Base.Thimble"] = 1,
        ["Base.Bag_DoctorBag"] = 1,
    },
    ["FARMER"] = {
        ["Base.RippedSheets"] = 5,
        ["Base.DehydratedMeatStick"] = 10,
        ["Base.MetalCup"] = 1,
        ["Base.Candle"] = 10,

        ["Base.HandScytheForged"] = 1,
        ["Base.GardenHoeForged"] = 1,
        ["Base.GardenFork_Forged"] = 1,
        ["Base.HandShovel"] = 1,
        ["Base.Bag_ClothSatchel_Burlap"] = 1,
        ["Base.Hat_StrawHat"] = 1,
        ["Base.PotatoSeed"] = 80,
        ["Base.EmptySandbag"] = 5,
        ["Base.WateredCan"] = 1,
    },
    ["RANCHER"] = {
        ["Base.RippedSheets"] = 5,
        ["Base.DehydratedMeatStick"] = 10,
        ["Base.MetalCup"] = 1,
        ["Base.Candle"] = 10,

        ["Base.Rope"] = 4,
        ["Base.Axe_Old"] = 1,
        ["Base.Hat_Cowboy"] = 1,
        ["Base.MacheteForged"] = 1,
        ["Base.Bag_CrudeLeatherBag"] = 1,
        ["Base.Bag_HideSatchel"] = 1,
        ["Base.Bag_LeatherWaterBag"] = 1,
        ["Base.AnimalFeedBag"] = 3,
    },
    ["COOK"] = {
        ["Base.RippedSheets"] = 5,
        ["Base.DehydratedMeatStick"] = 10,
        ["Base.MetalCup"] = 1,
        ["Base.Candle"] = 10,

        ["Base.KitchenKnifeForged"] = 1,
        ["Base.Apron_White"] = 1,
        ["Base.Hat_ChefHat"] = 1,
        ["Base.SpoonForged"] = 5,
        ["Base.ForkForged"] = 5,
        ["Base.PotForged"] = 2,
        ["Base.ClayBowl"] = 8,
        ["Base.MacheteForged"] = 1,
        ["Base.Bag_HideSlingBag"] = 1,
        ["Base.CeramicMortarandPestle"] = 1,
        ["Base.MeatCleaverForged"] = 1,
        ["Base.CannedPotato"] = 2,
        ["Base.CannedTomato"] = 2,
        ["Base.CannedCabbage"] = 2,
        ["Base.Bag_Gunny"] = 1,
    },
    ["ARTISAN"] = {
        ["Base.RippedSheets"] = 5,
        ["Base.DehydratedMeatStick"] = 10,
        ["Base.MetalCup"] = 1,
        ["Base.Candle"] = 20,

        ["Base.SpadeForged"] = 1,
        ["Base.MetalworkingPliers"] = 1,
        ["Base.SmallSaw"] = 1,
        ["Base.HammerForged"] = 1,
        ["Base.GlassBlowingPipe"] = 1,
        ["Base.Clay"] = 40,
        ["Base.Bag_HideSlingBag"] = 1,
        ["Base.Lard"] = 15,
        ["Base.Thread_Sinew"] = 5,
        ["Base.ScissorsForged"] = 1,
        ["Base.Needle_Forged"] = 1,
    },
}

Limits.Kits.Traits = {
    ["GUARD_LONGBLADE"] = {
        ["Base.Sword"] = 1,
    },
    ["GUARD_SPEAR"] = {
        ["MZ.MedievalSpear"] = 1,
    },
    ["RANGER_ARCHER"] = {
        ["Fletcher.SimpleBow"] = 1,
        ["Fletcher.StoneArrow"] = 60,
        ["Base.HandAxeForged"] = 1,
    },
    ["RANGER_FIREARMS"] = {
        ["Gunsmithing.KentuckyRifle_Crafted"] = 1,
        ["Gunsmithing.PaperCartridge_Bullet"] = 180,
        ["Base.ShortSword"] = 1,
        ["Base.Hat_Raccoon"] = 1,
    },

}

---@param character IsoGameCharacter
function Limits.init(character)
    local modData = character:getModData()

    if not modData.LDSkills_checked then
        for perk, Components in pairs(Limits.CompoundToComponents) do
            local compoundPerkLevel = character:getPerkLevel(perk)
            local xpForCompoundLevel = perk:getTotalXpForLevel(compoundPerkLevel)
            local perkBoost = character:getXp():getPerkBoost(perk:getType())
            for i = 1, #Components do
                local componentPerk = Components[i]

                if character:getPerkLevel(componentPerk) < compoundPerkLevel then
                    local xpNeeded = xpForCompoundLevel - character:getXp():getXP(componentPerk)

                    LVLUPs[componentPerk] = true
                    addXpNoMultiplier(character, componentPerk, xpNeeded)

                    character:getXp():setPerkBoost(componentPerk, perkBoost)
                end
            end
        end

        local ButcheringSkills = {
            Perks.Cooking,
            Perks.SmallBlade,
            Perks.Fishing,
        }

        for i = 1, #ButcheringSkills do
            local butcheringSkill = ButcheringSkills[i]

            Limits.butchering(character, butcheringSkill, character:getPerkLevel(butcheringSkill), true)
        end

        modData.LDSkills_checked = true
        --print("did check")
    end
    if not modData.LDSkills_limits then
        modData.LDSkills_limits = {}
        for perk, parent in pairs(Lockdown.Skills.FindPerkParents) do
            local parentData = Lockdown.Skills.PerkParents[parent]

            if parentData and parentData.Limits then
                local limit = parentData.Limits[character:getPerkLevel(perk)]
                if limit == nil then limit = 10 end

                modData.LDSkills_limits[perk:getId()] = limit
            end
        end
    end
    --[[
    if not modData.LDSkills_gotKit then
        local profession = character:getDescriptor():getCharacterProfession()
        for occupation, kit in pairs(Limits.Kits.Professions) do
            if Lockdown.CharacterProfession[occupation] == profession then
                print("gave kit for " .. occupation)

                for item, quantity in pairs(kit) do
                    local inventory = character:getInventory()
                    for i = 1, quantity do
                        inventory:AddItem(item)
                    end
                    HaloTextHelper.addGoodText(character, item .. " x" .. tostring(quantity))
                end

                break
            end
        end

        for trait, kit in pairs(Limits.Kits.Traits) do
            if character:hasTrait(Lockdown.CharacterTrait[trait]) then
                print("gave kit for " .. trait)

                for item, quantity in pairs(kit) do
                    local inventory = character:getInventory()
                    for i = 1, quantity do
                        inventory:AddItem(item)
                    end
                    HaloTextHelper.addGoodText(character, item .. " x" .. tostring(quantity))
                end
            end
        end
        modData.LDSkills_gotKit = true
    end
    ]]
end

Events.AddXP.Add(Limits.skillLimit)
Events.AddXP.Add(Limits.replicateComponentXP)
Events.LevelPerk.Add(Limits.replicateCompoundLevelUp)
Events.LevelPerk.Add(Limits.butchering)
Events.OnPlayerMove.Add(Limits.init)
