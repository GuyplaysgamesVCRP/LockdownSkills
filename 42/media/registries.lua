---@class Lockdown
---@field Professions table<string, boolean>
---@field Traits table<string, table<string, boolean|string[]>>
---@field CharacterProfession CharacterProfession[]
---@field CharacterTrait CharacterTrait[]
---@field Skills Skills
Lockdown = Lockdown or {}

Lockdown.Professions = {
    ["lockdown:guardsman"] = true,
    ["lockdown:student"] = true,
    ["lockdown:carpenter"] = true,
    ["lockdown:blacksmith"] = true,
    ["lockdown:mason"] = true,
    ["lockdown:ranger"] = true,
    ["lockdown:clothier"] = true,
    ["lockdown:farmer"] = true,
    ["lockdown:artisan"] = true,
    ["lockdown:rancher"] = true,
    ["lockdown:fisherman"] = true,
    ["lockdown:cook"] = true,
    ["stm:guildapprentice"] = false,
    ["stm:gatetouched"] = false,
}

local ANY = "ANY"

Lockdown.Traits = {
    ["lockdown:guard_longblade"] = {
        shouldRegister = true,
        AllowedProfessions = {
            "lockdown:guardsman",
        },
    },
    ["lockdown:guard_spear"] = {
        shouldRegister = true,
        AllowedProfessions = {
            "lockdown:guardsman",
        },
    },
    ["lockdown:ranger_firearms"] = {
        shouldRegister = true,
        AllowedProfessions = {
            "lockdown:ranger",
        },
    },
    ["lockdown:ranger_archer"] = {
        shouldRegister = true,
        AllowedProfessions = {
            "lockdown:ranger",
        },
    },


    ["lockdown:fisherman_filleter"] = {
        shouldRegister = true,
        AllowedProfessions = {
            "lockdown:fisherman",
        },
    },

    ["lockdown:cook_keenbutcher"] = {
        shouldRegister = true,
        AllowedProfessions = {
            "lockdown:cook",
        },
    },

    --- ANY

    --- Artisan
    ["lockdown:artisan"] = {
        shouldRegister = true,
        AllowedProfessions = {
            ANY,
        },
    },

    ---

    --- Adrenaline Junkie
    ["base:adrenalinejunkie"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Angler
    ["base:fishing"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Athletic
    ["base:athletic"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Blacksmith Knowledge
    ["base:blacksmith"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Brave
    ["base:brave"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Brawler
    ["base:brawler"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Cat Eyes
    ["base:nightvision"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Dextrous
    ["base:dextrous"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Eagle Eyed
    ["base:eagleeyed"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Fast Healer
    ["base:fasthealer"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Fast Reader
    ["base:fastreader"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- First Aider
    ["base:firstaid"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Fit
    ["base:fit"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Former Scout
    ["base:formerscout"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Gardener
    ["base:gardener"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Graceful
    ["base:graceful"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Gymnast
    ["base:gymnast"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Handy
    ["base:handy"] = {
        shouldRegister = false,
        AllowedProfessions = {
            "lockdown:carpenter",
            "lockdown:mason",
        },
    },
    --- Herbalist
    ["base:herbalist"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Hiker
    ["lockdown:hiker"] = {
        shouldRegister = true,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Inconspicuous
    ["base:inconspicuous"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Keen Cook
    ["lockdown:cook"] = {
        shouldRegister = true,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Keen Hearing
    ["base:keenhearing"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Light Eater
    ["base:lighteater"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Low Thirst
    ["base:lowthirst"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Mason
    ["base:mason"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Nutritionist
    ["base:nutritionist"] = {
        shouldRegister = false,
        AllowedProfessions = {
            "lockdown:cook",
        },
    },
    --- Organized
    ["base:organized"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Outdoorsy
    ["base:outdoorsman"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Runner
    ["base:jogger"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Sewer
    ["base:tailor"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Stout
    ["base:stout"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Strong
    ["base:strong"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Target Shooter
    ["base:target_shooter"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Thicked Skinned
    ["base:thickedskinned"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Whittler
    ["base:whittler"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Wilderness Knowledge
    ["base:wildernessknowledge"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },

    --- NEGATIVE

    --- Agoraphobic
    ["base:agoraphobic"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- All Thumbs
    ["base:allthumbs"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Claustrophobic
    ["base:claustrophobic"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Clumsy
    ["base:clumsy"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Conspicuous
    ["base:conspicuous"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Cowardly
    ["base:cowardly"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Deaf
    ["base:deaf"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Disorganized
    ["base:disorganized"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Hemophobic
    ["base:hemophobic"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Hard of Hearing
    ["base:hardofhearing"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Hearty Appetite
    ["base:heartyappetite"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- High Thirst
    ["base:highthirst"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Illiterate
    ["base:illiterate"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Out of Shape
    ["base:outofshape"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Puny
    ["base:weak"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Short of breath
    ["base:asthmatic"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Shortsighted
    ["base:shortsighted"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Slow Healer
    ["base:slowhealer"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Slow Reader
    ["base:slowreader"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Smoker
    ["base:smoker"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Thin Skinned
    ["base:thinskinned"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Unfit
    ["base:unfit"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
    --- Weak
    ["base:feeble"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },

    --- MAGIC

    --- Smudged
    ["stm:smudged"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },

    ["stm:caster"] = {
        shouldRegister = false,
        AllowedProfessions = {
            ANY,
        },
    },
}

local function getTextAfterColon(text)
    return text:match(":(.*)") or ""
end

if not Lockdown.CharacterProfession then
    Lockdown.CharacterProfession = {}
    for occupation, value in pairs(Lockdown.Professions) do
        if value == true then
            local cutName = getTextAfterColon(string.upper(occupation))
            Lockdown.CharacterProfession[cutName] = CharacterProfession.register(occupation)
        end
    end
end

if not Lockdown.CharacterTrait then
    Lockdown.CharacterTrait = {}
    for trait, ValueTable in pairs(Lockdown.Traits) do
        if ValueTable.shouldRegister == true then
            local cutName = getTextAfterColon(string.upper(trait))
            Lockdown.CharacterTrait[cutName] = CharacterTrait.register(trait)
        end
    end
end

---@class Skills
---@field FindPerkParents table<PerkFactory.Perk, PerkFactory.Perk|nil>
---@field PerkParents table<PerkFactory.Perk, PerkData>
local Skills = {}

Lockdown.Skills = Skills

Lockdown.Skills.FindPerkParents = {
    --- Body
    [Perks.Strength] = Perks.Body,
    [Perks.Fitness] = Perks.Body,

    --- Agility
    [Perks.Sneak2] = Perks.PhysicalCategory,
    [Perks.Nimble] = Perks.PhysicalCategory,
    [Perks.Sprinting] = Perks.PhysicalCategory,

    --- Crafting
    [Perks.Blacksmith2] = Perks.Crafting,
    [Perks.Woodwork] = Perks.Crafting,
    [Perks.Artisanry] = Perks.Crafting,
    [Perks.Masonry] = Perks.Crafting,
    [Perks.Tailoring] = Perks.Crafting,

    --- Farming
    [Perks.Farming] = Perks.FarmingCategory,
    [Perks.Husbandry] = Perks.FarmingCategory,

    --- Melee
    [Perks.Axe] = Perks.Combat,
    [Perks.LongBlade] = Perks.Combat,
    [Perks.SmallBlade] = Perks.Combat,
    [Perks.Blunt] = Perks.Combat,
    [Perks.SmallBlunt] = Perks.Combat,
    [Perks.Spear] = Perks.Combat,
    [Perks.Maintenance] = Perks.Combat,

    --- Ranged
    [Perks.Archery] = Perks.Firearm,
    [Perks.Aiming] = Perks.Firearm,
    [Perks.Reloading] = Perks.Firearm,

    --- Survival
    [Perks.Doctor] = Perks.Survivalist,
    [Perks.Cooking] = Perks.Survivalist,
    [Perks.Carving] = Perks.Survivalist,
    [Perks.FlintKnapping] = Perks.Survivalist,
    [Perks.PlantScavenging] = Perks.Survivalist,
    [Perks.Fishing] = Perks.Survivalist,
    [Perks.Trapping2] = Perks.Survivalist,

    --- Arcane
    [Perks.Magic] = Perks.Arcane,
}

---@class PerkColors
---@field r number
---@field g number
---@field b number

---@class PerkData
---@field Colors PerkColors
---@field Limits? table<integer, integer>
---@field icon? Texture

Lockdown.Skills.PerkParents = {
    --- Body
    [Perks.Body] = {
        Colors = {
            r = 0.71,
            g = 0.24,
            b = 0.19,
        },
        Limits = {
            [0] = 9,
            [1] = 10,
        },
        icon = getTexture("media/ui/CategoryIcon_Body.png"),
    },
    --- Agility
    [Perks.PhysicalCategory] = {
        Colors = {
            r = 0.62, --r = 1.00,
            g = 0.50, --g = 0.89,
            b = 0.24, --b = 0.38,
        },
        Limits = {
            [0] = 9,
            [1] = 10,
        },
        icon = getTexture("media/ui/CategoryIcon_Agility.png"),
    },
    --- Crafting
    [Perks.Crafting] = {
        Colors = {
            r = 0.22,
            g = 0.36,
            b = 0.65,
        },
        Limits = {
            [0] = 4,
            [1] = 6,
            [2] = 8,
            [3] = 10,
        },
        icon = getTexture("media/ui/CategoryIcon_Crafting.png"),
    },
    --- Farming
    [Perks.FarmingCategory] = {
        Colors = {
            r = 0.71,
            g = 0.40,
            b = 0.19,
        },
        Limits = {
            [0] = 4,
            [1] = 6,
            [2] = 8,
            [3] = 10,
        },
        icon = getTexture("media/ui/CategoryIcon_Farming.png"),
    },
    --- Melee
    [Perks.Combat] = {
        Colors = {
            r = 0.78,
            g = 0.72,
            b = 0.72,
        },
        Limits = {
            [0] = 7,
            [1] = 9,
            [2] = 10,
        },
        icon = getTexture("media/ui/CategoryIcon_Combat.png"),
    },
    --- Ranged
    [Perks.Firearm] = {
        Colors = {
            r = 0.39,
            g = 0.51,
            b = 0.52,
        },
        Limits = {
            [0] = 4,
            [1] = 6,
            [2] = 8,
            [3] = 10,
        },
        icon = getTexture("media/ui/CategoryIcon_Ranged.png"),
    },
    --- Survival
    [Perks.Survivalist] = {
        Colors = {
            r = 0.39,
            g = 0.54,
            b = 0.35,
        },
        Limits = {
            [0] = 5,
            [1] = 7,
            [2] = 9,
            [3] = 10,
        },
        icon = getTexture("media/ui/CategoryIcon_Survivalist.png"),
    },
    --- Arcane
    [Perks.Arcane] = {
        Colors = {
            r = 0.55,
            g = 0.32,
            b = 0.42,
        },
        icon = getTexture("media/ui/CategoryIcon_Arcane.png"),
    },
    --- Occupation
    [Perks.Occupation] = {
        Colors = {
            r = 0.47,
            g = 0.83,
            b = 0.93,
        },
        icon = getTexture("media/ui/CategoryIcon_Occupation.png"),
    },
    --- Depreciated
    [Perks.Depreciated] = {
        Colors = {
            r = 0.5,
            g = 0.2,
            b = 0.2,
        },
        icon = getTexture("media/ui/CategoryIcon_Depreciated.png")
    }
}
