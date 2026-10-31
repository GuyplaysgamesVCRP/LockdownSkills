---@diagnostic disable: undefined-field

LockdownOnCreate = {}

---@param craftRecipeData CraftRecipeData
---@param character IsoGameCharacter
function LockdownOnCreate.craftCandles(craftRecipeData, character)
    local level = character:getPerkLevel(Perks.Artisanry)

    local modifier = 0.17 * (level + 1)

    if modifier > 1 then
        modifier = 1
    end

    local bonusCandles = level - 5

    if level == 10 then
        bonusCandles = bonusCandles + 3
    end

    if bonusCandles < 0 then
        bonusCandles = 0
    end

    local results = craftRecipeData:getAllCreatedItems()

    for i = 0, results:size() - 1 do
        local item = results:get(i)

        item:setUsedDelta(modifier)
    end

    for i = 1, bonusCandles do
        local item = instanceItem("Base.Candle")

        character:getInventory():AddItem(item)
        sendAddItemToContainer(character:getInventory(), item)
    end
end
