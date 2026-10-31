---@diagnostic disable: need-check-nil, undefined-field, inject-field, assign-type-mismatch, param-type-mismatch

require "Definitions/animal/ButcheringUtil"

-- Add an animal part in the player's inventory
-- If the part is a food we gonna modify it
function ButcheringUtil.addAnimalPart(part, player, carcass, fromGround)
    local skill = player:getPerkLevel(Perks.Butchering)
    local text = ""
    -- if you're doing it from ground but animal can't go on a hook, it's all ok
    if fromGround then
        if not AnimalAvatarDefinition[carcass:getModData()["AnimalType"]] or not AnimalAvatarDefinition[carcass:getModData()["AnimalType"]].hook then
            fromGround = false
        end
    end

    -- if animal was pregnant add a dead baby on the ground, i'm sorry, i had to...
    if carcass:getModData()["wasPregnant"] and carcass:getModData()["pregnancyTime"] > 0.3 then
        local def = AnimalDefinitions.animals[carcass:getModData()["AnimalType"]]
        if def then
            for i = 0, carcass:getModData()["babiesNbr"] - 1 do
                local baby = IsoAnimal.new(getCell(), carcass:getSquare():getX(), carcass:getSquare():getY(),
                    carcass:getSquare():getZ(), def.babyType, carcass:getModData()["AnimalBreed"])
                baby:getData():setSizeForced(carcass:getModData()["pregnancyTime"] / 2)
                local corpse = IsoDeadBody.new(baby, false)
                carcass:getSquare():addCorpse(corpse, false)
                corpse:invalidateCorpse()
                corpse:setInvalidateNextRender(true)
                baby:remove()

                sendCorpse(corpse)
            end
        end
        carcass:getModData()["wasPregnant"] = false
        carcass:getModData()["pregnancyTime"] = 0
        carcass:transmitModData()
    end

    --print("do animal part", part.item, part.minNb, part.maxNb)
    if not part.minNb then part.minNb = -1; end
    if not part.maxNb then part.maxNb = -1; end
    if not part.nb then part.nb = -1; end
    -- number of parts depend on size
    local minNb = part.minNb * carcass:getAnimalSize()
    local maxNb = part.maxNb * carcass:getAnimalSize()
    local nb = part.nb
    -- lower parts gathered if from the ground
    if fromGround then
        minNb = minNb * 0.6
        maxNb = maxNb * 0.6
    else
        minNb = minNb * 2.8
        maxNb = maxNb * 2.8
    end

    -- every 2 pts in butchering gives * 1.1 max meat ratio
    local skillIndex = (math.floor(skill / 2) / 10) + 1
    maxNb = maxNb * skillIndex


    local meatRatio = carcass:getModData()["meatRatio"]
    if meatRatio <= 0 then
        meatRatio = 1
    end

    local item = instanceItem(part.item)
    if instanceof(item, "Food") then
        -- We add more or less meat depending on its meatRatio
        minNb = meatRatio * minNb
        maxNb = meatRatio * maxNb
    end

    --print("meat ratio", meatRatio, minNb, maxNb, nb, carcass:getAnimalSize())

    if carcass:getModData()["roadKill"] then
        minNb = minNb / 2
        maxNb = maxNb / 2
        meatRatio = ZombRandFloat(0.2, 0.4)
    end

    local rotten = false
    -- depending on the time passed since death we lower the food nb/ratio
    local deathAge = carcass:getModData()["deathAge"] or 0
    if deathAge > 12 then -- give 12h before starting to lower it
        local delta = deathAge / 13
        minNb = minNb / delta
        maxNb = maxNb / delta
        meatRatio = meatRatio / delta
        if carcass:getModData()["animalRotStage"] > 0 then -- corpse has rotten
            rotten = true
        end
    end

    if nb == -1 then
        nb = ZombRand(minNb, maxNb)
    end

    if nb < 1 then
        nb = 1
    end

    -- meat can be modified to give prime cut/medium cut etc.
    if AnimalPartsDefinitions.meat[part.item] then
        --- Fat Stuff
        local fatAmount = math.ceil(nb * 0.2)
        local animalName = getText("IGUI_AnimalType_" .. carcass:getModData()["AnimalType"]) or "Animal"

        for i = 1, fatAmount do
            local fat = instanceItem("Base.Lard")
            fat:setName(animalName .. " Fat")

            player:getInventory():AddItem(fat)
            sendAddItemToContainer(player:getInventory(), fat)
        end

        text = text ..
            ButcheringUtil.giveMeatModified(AnimalPartsDefinitions.meat[part.item], nb, player, meatRatio, carcass,
                fromGround, rotten, deathAge)
        return text
    end

    local animalDef = ButcheringUtil.getAnimalDef(ButcheringUtil.getCarcassName(carcass))
    for i = 0, nb - 1 do
        item = instanceItem(part.item)

        -- If the item is a food we alter its hunger depending on the size of animal
        if instanceof(item, "Food") then
            text = text .. ButcheringUtil.modifyMeat(item, carcass:getAnimalSize(), meatRatio, 1, rotten, deathAge)
        else
            text = text .. item:getDisplayName()
        end

        player:getInventory():AddItem(item)
        sendAddItemToContainer(player:getInventory(), item)
        addXp(player, Perks.Butchering, animalDef.xpPerItem)
    end

    return text
end
