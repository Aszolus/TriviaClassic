local function push(t, v)
    t[#t + 1] = v
    return v
end

local function requireString(name, v)
    if type(v) ~= "string" or v == "" then
        error(("Expected %s to be a non-empty string"):format(name), 3)
    end
end

local function requireTable(name, v)
    if type(v) ~= "table" then
        error(("Expected %s to be a table"):format(name), 3)
    end
end

-- ---------- group builder ----------
local function Group(theme, difficulty, words)
    requireString("theme", theme)
    if type(difficulty) ~= "number" then error("Expected difficulty to be a number", 2) end
    requireTable("words", words)

    return {
        ["Theme"] = theme,
        ["Difficulty"] = difficulty,
        ["Words"] = words,
    }
end

-- ---------- puzzle builder ----------
local function Puzzle(groups)
    requireTable("groups", groups)
    return { ["Groups"] = groups }
end

-- ---------- pack builder ----------
local function Pack(title, description, author)
    requireString("title", title)
    requireString("description", description)
    requireString("author", author)

    local pack = {
        ["Title"] = title,
        ["Description"] = description,
        ["Author"] = author,
        ["Puzzles"] = {},
    }

    -- fluent helpers
    function pack:addPuzzle(groups)
        push(self["Puzzles"], Puzzle(groups))
        return self
    end

    function pack:addPuzzleFromGroups(...)
        -- pack:addPuzzleFromGroups(Group(...), Group(...), ...)
        local groups = { ... }
        return self:addPuzzle(groups)
    end

    return pack
end

-- ---------- root collection builder ----------
local function ConnectionsPacks()
    local root = {}

    function root:addPack(title, description, author)
        local pack = Pack(title, description, author)
        push(self, pack)
        return pack
    end

    function root:toArray()
        -- Ensures numeric keys [1],[2],... (already true, but keeps intent explicit)
        local arr = {}
        for i = 1, #self do arr[i] = self[i] end
        return arr
    end

    return root
end

-- =========================================================================
-- Example usage: your wow packs rewritten in a way that’s easy to extend
-- =========================================================================

local packs = ConnectionsPacks()

packs
    :addPack(
        "WoW Classic Connections — Deep Cuts",
        "WoW Classic only, but with trickier links and more misdirection.",
        "TriviaClassic"
    )
    :addPuzzleFromGroups(
        Group("World buffs people coordinate around", 1, { "Rend", "Onyxia", "Nefarian", "Zandalar" }),
        Group("Escort quests", 2, { "Chicken", "A-me", "Kaya", "Tooga" }),
        Group("“Feels like a trap” pull-ruiners", 3, { "Patrol", "Runner", "Fear", "Linked" }),
        Group("Classic meme/name magnets", 4, { "Mankrik", "Jenkins", "Thunderfury", "Anal" })
    )
    :addPuzzleFromGroups(
        Group("DM vibe words (but still accurate)", 4, { "Satyrs", "Ogres", "Demons", "Books" }),
        Group("Things associated with Ony attunement chain steps", 2, { "BRD", "UBRS", "Drakkisath", "Windsor" }),
        Group("Words that mean “this run is about to go sideways”", 3, { "Overpull", "Resist", "Respawn", "Roach" }),
        Group("“Items that start something”", 4, { "Head of Onyxia", "Blood of Heroes", "Cenarion Beacon", "Damp Note" })
    )
    :addPuzzleFromGroups(
        Group("Blackrock Mountain instances (not all raids)", 1, { "BRD", "LBRS", "UBRS", "MC" }),
        Group("Scourge-related zones in Classic", 2, { "WPL", "EPL", "Stratholme", "Scholomance" }),
        Group("Common raid-calling shorthand", 3, { "LoS", "MT", "OT", "AGGRO" }),
        Group("Names tied to “don’t click that / don’t open that” moments", 4,
            { "Baron", "Garr", "Suppression", "Whelp" })
    )
    :addPuzzleFromGroups(
        Group("“You’re flagged now” places/things", 1, { "Gurubashi", "SS/TM", "Blackrock", "Yojamba" }),
        Group("Infamous quest items people forget (then regret)", 2,
            { "Hinterlands Mallet", "Carrot on a Stick", "Gnomeregan Card", "Mithril Casing" }),
        Group("Classic consumables you notice when they’re missing", 3,
            { "Sharpening Stone", "Wizard Oil", "Free Action", "Restorative" }),
        Group("NPCs that feel like they have a “reputation” outside the game", 4,
            { "Stitches", "Hogger", "Kazzak", "Mor'zul" })
    )
    :addPuzzleFromGroups(
        Group("BWL bosses (not the obvious first/last)", 1, { "Vaelastrasz", "Broodlord", "Chromaggus", "Razorgore" }),
        Group("AQ40 “words that instantly place you there”", 2, { "Huhuran", "Twin Emps", "Bug Trio", "Skeram" }),
        Group("Things you “dispel or die” in Classic", 3, { "Curse", "Magic", "Poison", "Disease" }),
        Group("Items/phrases linked to Classic’s biggest flex moments", 4,
            { "Scarab Lord", "Hand of Ragnaros", "Atiesh", "Lok'delar" })
    )

packs
    :addPack(
        "WoW Classic Connections — Lore & Quests (Cryptic)",
        "More lore/quest/NPC-driven groupings with intentional overlap bait.",
        "TriviaClassic"
    )
    :addPuzzleFromGroups(
        Group("The “Four Horsemen”", 1, { "Mograine", "Zeliek", "Thane", "Blaumeux" }),
        Group("Scarlet Monastery wing words", 2, { "Graveyard", "Library", "Armory", "Cathedral" }),
        Group("Cults/sects you repeatedly fight", 3, { "Twilight", "Scarlet", "Defias", "Blackrock" }),
        Group("Names tied to “who even is that?” lore rabbit holes", 4,
            { "Korialstrasz", "Anachronos", "Medivh", "Dagran" })
    )
    :addPuzzleFromGroups(
        Group("Quest hubs that define a leveling bracket vibe", 1, { "Hillsbrad", "STV", "Tanaris", "Un'Goro" }),
        Group("Dungeon keys/attunements people mess up", 2, { "Shadowforge", "Scepter", "Crescent", "Seal" }),
        Group("“Classic arguments” topics", 3, { "Loot", "Threat", "Spec", "Parsing" }),
        Group("Characters tied to big plot threads (but not endgame villains)", 4,
            { "Bolvar", "Onyxia", "Stalvan", "Arugal" })
    )
    :addPuzzleFromGroups(
        Group("Places with a giant “entrance moment”", 1, { "Blackrock", "Maraudon", "Uldaman", "Deadmines" }),
        Group("Notorious “don’t fall” segments", 2, { "BRD Ledge", "Gnomeregan", "Wailing Caverns", "Undercity" }),
        Group("Classic “elite” names many players recognize", 3, { "Humar", "Tethis", "Ravagore", "Broken Tooth" }),
        Group("Words that secretly point at a single zone’s identity", 4,
            { "Salt", "Pirates", "Gadgetzan", "Wastewander" })
    )


packs
    :addPack(
        "WoW Classic Quest Connections — NYT Style",
        "16 words, 4 groups. Each group ties to a quest/chain, but the words are clues (not just quest titles).",
        "TriviaClassic"
    )
    :addPuzzleFromGroups(
        Group("Clues to: The Missing Diplomat", 1, { "Jaina", "Theramore", "Dustwallow", "Lady Prestor" }),
        Group("Clues to: The Legend of Stalvan", 2, { "Duskwood", "Moonbrook", "Town Hall", "Stalvan" }),
        Group("Clues to: Linken’s Adventure", 3, { "Linken", "Un'Goro", "Dinos", "Jadefire" }),
        Group("Words that follow 'Thunder'", 4, { "BLUFF", "CLAP", "BREW", "FURY" })
    )
    :addPuzzleFromGroups(
        Group("Iconic low-level elite quest targets", 1, { "Hogger", "Stitches", "Mor'Ladim", "Stalvan" }),
        Group("Animal body parts collected for quests", 2, { "Gizzard", "Snout", "Hoof", "Liver" }),
        Group("Quest rewards with unique utility", 3, { "Carrot", "Glue", "Boomerang", "Stopwatch" }),
        Group("Words following “Silver-”", 4, { "Pine", "Wing", "Hand", "Rod" })
    )
    :addPuzzleFromGroups(
        Group("Factions requiring a reputation grind", 1, {"Cenarion", "Argent", "Timbermaw", "Thorium"}),
        Group("Common beast types hunted for quests", 2, {"Goretusk", "Zhevra", "Strider", "Crawler"}),
        Group("World objects interacted with for quests", 3, {"Mound", "Egg", "Crate", "Pylon"}),
        Group("Anagrams of WoW classes or terms", 4, {"Game", "Rouge", "Stripe", "Arid"})
      )

-- Final output in the same “array-of-packs” form as your original code:
local ConnectionsPuzzles = packs:toArray()

-- Auto-register with the repository if available
if TriviaClassic and TriviaClassic.repo and TriviaClassic.repo.RegisterConnectionsSet then
    TriviaClassic.repo:RegisterConnectionsSet("WoW Classic Connections", ConnectionsPuzzles)
elseif TriviaClassic_Repo_ImportConnectionsSet then
    -- Will be registered during addon init
    TriviaClassic_ConnectionsPuzzles = ConnectionsPuzzles
end
