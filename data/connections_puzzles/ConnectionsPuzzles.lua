-- Sample Connections puzzles for World of Warcraft Classic Era
-- Format: Each puzzle has 4 groups of 4 words with themes and difficulty levels

local ConnectionsPuzzles = {
  [1] = {
    ["Title"] = "WoW Classic Connections",
    ["Description"] = "Test your knowledge of World of Warcraft Classic!",
    ["Author"] = "TriviaClassic",
    ["Puzzles"] = {
      [1] = {
        ["Groups"] = {
          { ["Theme"] = "Classic Raid Bosses", ["Difficulty"] = 1, ["Words"] = {"Ragnaros", "Onyxia", "Nefarian", "Hakkar"} },
          { ["Theme"] = "Herbs in Felwood", ["Difficulty"] = 2, ["Words"] = {"Gromsblood", "Dreamfoil", "Plaguebloom", "Arthas"} },
          { ["Theme"] = "Warlock Demons", ["Difficulty"] = 3, ["Words"] = {"Imp", "Voidwalker", "Succubus", "Felhunter"} },
          { ["Theme"] = "Alliance Capital Cities", ["Difficulty"] = 4, ["Words"] = {"Stormwind", "Ironforge", "Darnassus", "Gnomeregan"} },
        }
      },
      [2] = {
        ["Groups"] = {
          { ["Theme"] = "Blackrock Mountain Instances", ["Difficulty"] = 1, ["Words"] = {"UBRS", "LBRS", "BRD", "MC"} },
          { ["Theme"] = "Priest Spells", ["Difficulty"] = 2, ["Words"] = {"Renew", "Shield", "Flash", "Prayer"} },
          { ["Theme"] = "Horde Leaders", ["Difficulty"] = 3, ["Words"] = {"Thrall", "Cairne", "Sylvanas", "Vol'jin"} },
          { ["Theme"] = "Fishing Zones", ["Difficulty"] = 4, ["Words"] = {"Tanaris", "Azshara", "Feralas", "Stranglethorn"} },
        }
      },
      [3] = {
        ["Groups"] = {
          { ["Theme"] = "Mage Specs", ["Difficulty"] = 1, ["Words"] = {"Frost", "Fire", "Arcane", "PoM"} },
          { ["Theme"] = "Zul'Gurub Bosses", ["Difficulty"] = 2, ["Words"] = {"Mandokir", "Thekal", "Arlokk", "Venoxis"} },
          { ["Theme"] = "Rogue Abilities", ["Difficulty"] = 3, ["Words"] = {"Backstab", "Eviscerate", "Gouge", "Vanish"} },
          { ["Theme"] = "Eastern Kingdoms Zones", ["Difficulty"] = 4, ["Words"] = {"Redridge", "Duskwood", "Westfall", "Elwynn"} },
        }
      },
      [4] = {
        ["Groups"] = {
          { ["Theme"] = "Warrior Stances", ["Difficulty"] = 1, ["Words"] = {"Battle", "Defensive", "Berserker", "Arms"} },
          { ["Theme"] = "Profession Tools", ["Difficulty"] = 2, ["Words"] = {"Pickaxe", "Skinning", "Fishing", "Hammer"} },
          { ["Theme"] = "Druid Forms", ["Difficulty"] = 3, ["Words"] = {"Bear", "Cat", "Moonkin", "Travel"} },
          { ["Theme"] = "PvP Ranks", ["Difficulty"] = 4, ["Words"] = {"Marshal", "Warlord", "Commander", "General"} },
        }
      },
      [5] = {
        ["Groups"] = {
          { ["Theme"] = "Hunter Pets", ["Difficulty"] = 1, ["Words"] = {"Wolf", "Cat", "Boar", "Owl"} },
          { ["Theme"] = "Enchanting Materials", ["Difficulty"] = 2, ["Words"] = {"Dust", "Essence", "Shard", "Crystal"} },
          { ["Theme"] = "Scarlet Monastery Wings", ["Difficulty"] = 3, ["Words"] = {"Library", "Armory", "Cathedral", "Graveyard"} },
          { ["Theme"] = "Paladin Auras", ["Difficulty"] = 4, ["Words"] = {"Devotion", "Retribution", "Concentration", "Sanctity"} },
        }
      },
    }
  },
  [2] = {
    ["Title"] = "WoW Lore Connections",
    ["Description"] = "Deep dive into Warcraft lore!",
    ["Author"] = "TriviaClassic",
    ["Puzzles"] = {
      [1] = {
        ["Groups"] = {
          { ["Theme"] = "Dragon Aspects", ["Difficulty"] = 1, ["Words"] = {"Alexstrasza", "Ysera", "Nozdormu", "Malygos"} },
          { ["Theme"] = "Lich King's Lieutenants", ["Difficulty"] = 2, ["Words"] = {"Kel'Thuzad", "Anub'arak", "Sapphiron", "Heigan"} },
          { ["Theme"] = "Old Gods", ["Difficulty"] = 3, ["Words"] = {"C'Thun", "Yogg-Saron", "N'Zoth", "Y'Shaarj"} },
          { ["Theme"] = "War of the Ancients Heroes", ["Difficulty"] = 4, ["Words"] = {"Malfurion", "Tyrande", "Illidan", "Cenarius"} },
        }
      },
      [2] = {
        ["Groups"] = {
          { ["Theme"] = "Orc Clans", ["Difficulty"] = 1, ["Words"] = {"Frostwolf", "Warsong", "Blackrock", "Bleeding"} },
          { ["Theme"] = "Titan Watchers", ["Difficulty"] = 2, ["Words"] = {"Thorim", "Hodir", "Freya", "Mimiron"} },
          { ["Theme"] = "Naaru", ["Difficulty"] = 3, ["Words"] = {"A'dal", "K'ure", "M'uru", "Xe'ra"} },
          { ["Theme"] = "Bronze Dragonflight Members", ["Difficulty"] = 4, ["Words"] = {"Chromie", "Soridormi", "Anachronos", "Kairozdormu"} },
        }
      },
      [3] = {
        ["Groups"] = {
          { ["Theme"] = "Demon Hunters", ["Difficulty"] = 1, ["Words"] = {"Illidan", "Altruis", "Kayn", "Varedis"} },
          { ["Theme"] = "Windrunner Sisters", ["Difficulty"] = 2, ["Words"] = {"Sylvanas", "Alleria", "Vereesa", "Lirath"} },
          { ["Theme"] = "Eredar Lords", ["Difficulty"] = 3, ["Words"] = {"Archimonde", "Kil'jaeden", "Velen", "Sargeras"} },
          { ["Theme"] = "Mogu Emperors", ["Difficulty"] = 4, ["Words"] = {"Lei", "Qon", "Xin", "Elegon"} },
        }
      },
    }
  },
}

-- Auto-register with the repository if available
if TriviaClassic and TriviaClassic.repo and TriviaClassic.repo.RegisterConnectionsSet then
  TriviaClassic.repo:RegisterConnectionsSet("WoW Classic Connections", ConnectionsPuzzles)
elseif TriviaClassic_Repo_ImportConnectionsSet then
  -- Will be registered during addon init
  TriviaClassic_ConnectionsPuzzles = ConnectionsPuzzles
end
