-- -------------------------------------------------- --
-- Minimal question set template for TriviaBot
-- This set has exactly 1 question, 1 hint, 1 answer.
-- -------------------------------------------------- --

local _, TriviaBot_Questions = ...
TriviaBot_Questions = TriviaBot_Questions or {}

local setIndex = #TriviaBot_Questions + 1
TriviaBot_Questions[setIndex] = {
  ['Categories'] = {},
  ['Questions'] = {},
}

-- Basic info about the set
TriviaBot_Questions[1]['Title']       = "Deadliest of Azeroth"
TriviaBot_Questions[1]['Description'] = "Questionset about the different deadly creatures a player faces in Hardcore WoW and about Classic"
TriviaBot_Questions[1]['Author']      = "Aszolus-Doomhowl"

-- Add at least one category
table.insert(TriviaBot_Questions[1]['Categories'], "Deadly NPCs, places, and things")
table.insert(TriviaBot_Questions[1]['Categories'], "Alliance Trivia")
table.insert(TriviaBot_Questions[1]['Categories'], "Horde Trivia")
table.insert(TriviaBot_Questions[1]['Categories'], "Deep Lore")
table.insert(TriviaBot_Questions[1]['Categories'], "General Knowledge")
table.insert(TriviaBot_Questions[1]['Categories'], "Professions")
table.insert(TriviaBot_Questions[1]['Categories'], "Geography")

local CAT_HC = 1
local CAT_ALLY = 2
local CAT_HORDE = 3
local CAT_LORE = 4
local CAT_GENERAL = 5
local CAT_PROF = 6
local CAT_GEO = 7

-- Questions
local function addQuestion(entry)
  table.insert(TriviaBot_Questions[1]['Questions'], entry)
end

addQuestion({
  ['Question'] = "What is the Deadliest Creature in Duskwood? *Based on HC Kill count.",
  ['Answers'] = {"Stitches"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {"It's not Mor'Ladim."},
})

addQuestion({
  ['Question'] = "What is the Deadliest Creature in Dustwallow Marsh? *Based on HC Kill count.",
  ['Answers'] = {"Coral Shark"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {"It swims."},
})

addQuestion({
  ['Question'] = "What is the Deadliest Creature in Westfall? *Based on HC Kill count.",
  ['Answers'] = {"Defias Trapper"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {"It's not Defias Pillager."},
})

addQuestion({
  ['Question'] = "What is the Deadliest Creature in Stormwind? *Based on HC Kill count.",
  ['Answers'] = {"Rift Spawn"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {"They kill mostly mages."},
})

addQuestion({
  ['Question'] = "What is the Deadliest Creature at Raven Hill? *Based on HC Kill count.",
  ['Answers'] = {"Mor'Ladim"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the Deadliest Creature in Mulgore?  *Based on HC Kill count.",
  ['Answers'] = {"Snagglespear"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {"It's a rare spawn."},
})

addQuestion({
  ['Question'] = "What is the Deadliest Creature in Stranglethorn Vale? *Based on HC Kill count.",
  ['Answers'] = {"Zanzil Skeleton"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {"It's already dead itself."},
})

addQuestion({
  ['Question'] = "What is the Deadliest Creature in The Deadmines? *Based on HC Kill count.",
  ['Answers'] = {"Defias Squallshaper"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What elite mob is spawned from looting Blood of Heroes?",
  ['Answers'] = {"Fallen Hero", "fallen heroes"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What great white tiger does Hemet Nesingwary ask you to slay for the quest Big Game Hunter? (Full NPC name)",
  ['Answers'] = {"King Bangalash"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the deadliest mob in Eastern Plaguelands?  *Based on HC Kill count.",
  ['Answers'] = {"Fallen Hero", "fallen heroes"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {"It spawns from Blood of Heroes."},
})

addQuestion({
  ['Question'] = "Which dragon is the final boss in Blackwing Lair?",
  ['Answers'] = {"Nefarian", "nefarian"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"He is a corrupted black dragon and the son of Deathwing."},
})

addQuestion({
  ['Question'] = "Boss Quote: \"Now You're Making me Angry!\" ",
  ['Answers'] = {"Mr. Smite", "Mr. Smite<The Ship's First Mate>", "mr smite"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"Located in the Deadmines dungeon."},
})

addQuestion({
  ['Question'] = "Which undead elite surprises unsuspecting Alliance players by spawning in Southshore's Graveyard?",
  ['Answers'] = {"Helcular's Remains"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {"His name in life was Helcular."},
})

addQuestion({
  ['Question'] = "What is the most common way to die in HC WoW?",
  ['Answers'] = {"Falling", "fall damage", "fall"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {"There's no achievement for it Classic."},
})

addQuestion({
  ['Question'] = "What is the deadliest mob in Dun Morough? *Based on HC Kill count.",
  ['Answers'] = {"Wendigo"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the SECOND most common way to die in HC WoW?",
  ['Answers'] = {"Drowning"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the deadliest enemy found in Northern Stranglethorn Vale?  *Based on HC Kill count.",
  ['Answers'] = {"Kurzen Subchief"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which rare mount is dropped by Baron Rivendare in Stratholme?",
  ['Answers'] = {"Deathcharger's Reins"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Name the boss of the Scarlet Monastery's Library wing.",
  ['Answers'] = {"Arcanist Doan"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of deadly pigs escorting Princess in Elwynn Forest?",
  ['Answers'] = {"Porcine Entourage"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Limited Invulnerability Potions (LIP) grant immunity to physical attacks for how many seconds?",
  ['Answers'] = {"6", "six"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the most common cause of death in Ironforge?",
  ['Answers'] = {"lava"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which undead necromancer is the final boss of Naxxramas?",
  ['Answers'] = {"Kel'Thuzad", "kel'thuzad"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the deadliest mob in the Wetlands? *Based on HC Kill count.",
  ['Answers'] = {"Young Wetlands Crocolisk"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the deadliest mob in Loch Modan? *Based on HC Kill count.",
  ['Answers'] = {"Stonesplinter Seer"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What non-elite quest in Stranglethorn vale spawns multiple waves of Mistvale Gorillas?",
  ['Answers'] = {"Stranglethorn Fever"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "True or False: Enemy faction guards which aggro on you cause you to become pvp flagged, even they do not hit you.",
  ['Answers'] = {"True"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What rare elite creature boasts the highest player-kill rate in the Badlands?",
  ['Answers'] = {"Zaricotl"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the deadliest mob in Darkshore? *Based on HC Kill count.",
  ['Answers'] = {"Greymist Coastrunner"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {"They run along the coast."},
})

addQuestion({
  ['Question'] = "What is the deadliest mob in Tirisfal Glades? *Based on HC Kill count.",
  ['Answers'] = {"Cursed Darkbound"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the deadliest mob in Silverpine Forest? *Based on HC Kill count.",
  ['Answers'] = {"Son of Arugal"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the first wand an enchanter can make?",
  ['Answers'] = {"Lesser Magic Wand"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the deadliest mob the horde faces? *Based on HC Kill count.",
  ['Answers'] = {"Voidwalker Minion"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the most common way to die in Orgrimmar? *Based on HC Kill count.",
  ['Answers'] = {"Gamon"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the most common way to die in Thunder Bluff? *Based on HC Kill count.",
  ['Answers'] = {"Falling", "Fall damage", "fall"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "When first creating a character, you arrive in Northshire facing your very first quest giver.  What is his name?",
  ['Answers'] = {"Deputy Willem", "Willem"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {"Deputy ..."},
})

addQuestion({
  ['Question'] = "In Northshire, there are three types of kobolds: Kobold Vermin, Kobold Worker are two.  What is the last type?",
  ['Answers'] = {"Kobold Laborer", "Laborer"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {""},
})

addQuestion({
  ['Question'] = "Located in Northshire, this NPC is described as \"a cutthroat who's plagued our farmers and merchants for weeks.\" Who is it?",
  ['Answers'] = {"Garrick Padfoot"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {""},
})

addQuestion({
  ['Question'] = "What is the Deadliest Creature in Stormwind? *Based on HC Kill count.",
  ['Answers'] = {"Rift Spawn"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {"They kill mostly mages."},
})

addQuestion({
  ['Question'] = "What time do the children of Goldshire despawn?",
  ['Answers'] = {"7 pm", "7", "7:00 pm", "7pm server"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {""},
})

addQuestion({
  ['Question'] = "Which farmstead is Princess and her Porcine Entourage located?",
  ['Answers'] = {"Brackwell Pumpkin Patch", "Brackwell", "Brackwell's"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What NPC in Goldshire grants you a reward for completing \"Wanted: \"Hogger\"\"?",
  ['Answers'] = {"Marshal Dughan", "Dughan"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Who is Maybell Maclure in love with according to the quest \"Young Lovers\"?",
  ['Answers'] = {"Tommy Joe Stonefield", "Tommy Joe"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {"He's a Stonefield"},
})

addQuestion({
  ['Question'] = "In which mine does Goldtooth reside?",
  ['Answers'] = {"Fargodeep", "Fargodeep mine"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "How many cats does Donni Anthania<Crazy Cat Lady> keep inside her home?",
  ['Answers'] = {"4"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which NPC demands a Pork Belly Pie before he will reveal the location of \"Auntie\" Bernice Stonefield's necklace?",
  ['Answers'] = {"Billy Maclure"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "In Northshire, what type of fruit is Millie's Harvest?",
  ['Answers'] = {"grapes", "grape"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What type of enemy apparently killed the two lost guards: Rolf and Malakai?",
  ['Answers'] = {"murloc", "murlocs"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Fill in the blank: The three lakes found in Elwynn are Crystal Lake, Stonecairn Lake, and ______?",
  ['Answers'] = {"Mirror", "Mirror lake"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which profession has a trainer inside the Tower of Azora?",
  ['Answers'] = {"Enchanting"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the NPC who holds the title <Mage of Tower Azora>?",
  ['Answers'] = {"Theocritus"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which of the following is NOT in elwynn forest: The Stonefield farmstead, The Macclure Vineyards, or Furlbrow's Pumpkin Patch?",
  ['Answers'] = {"Furlbrow's Pumpkin Patch", "Furlbrow", "Furlbrow's"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Inside the Westbrook Garrison, there is an NPC selling refreshing drinks and alcohol.  Which of these is his title: Booze Baron, Refreshment Sergeant, Morale Officer, or Tactical Tipple?",
  ['Answers'] = {"Morale Officer"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "A powerful item which is used by guilds in late game raids is a reward for collecting Gold Dust for Ramy 'Two Times.'  What is the name of the item?",
  ['Answers'] = {"Bag of Marbles"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What item do you turn in as proof that you have slain Hogger: Hogger's Head, Hogger's Nose Ring, Huge Gnoll Claw, or Mangy Paw?",
  ['Answers'] = {"Huge Gnoll Claw"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the Rare spider which can spawn in the Jasperlode Mine?",
  ['Answers'] = {"Mother Fang"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the Rare kobold which can spawn in the fargodeep?",
  ['Answers'] = {"Narg the Taskmaster", "Narg"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "When entering Stormwind on foot from Elwynn forest, what is the first named area of Stormwind you enter?",
  ['Answers'] = {"The Valley of Heroes", "Valley of Heroes"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Who holds the title <Master of Cheese> in Stormwind?",
  ['Answers'] = {"Elling Trias"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the most expensive cheese that you can buy from Elaine Trias <Mistress of Cheese> in Stormwind?",
  ['Answers'] = {"Alterac Swiss"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Just outside of Eastvale Logging Camp, there is a former military leader of the Stormwind guard enjoying retirement.  What is his name?",
  ['Answers'] = {"Marshall Haggard"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Undercity is located in the ruins of which fallen kingdom?",
  ['Answers'] = {"Lordaeron"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the racial enemy of Tauren?",
  ['Answers'] = {"Centaur", "marauding centaur"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is sub-zone of Orgrimmar in which Ragefire Chasm is located called?",
  ['Answers'] = {"Cleft of Shadow"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What does Lok'tar Ogar mean?",
  ['Answers'] = {"Victory or death"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What item is used on Lazy Peons to wake them when doing the quest Lazy Peons in the Valley of Trials?",
  ['Answers'] = {"Foreman's Blackjack"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Name the missing troll racial ability: Beast Slaying, Berserking, Bow Specialization, Regeneration, ________ ______________.",
  ['Answers'] = {"Throwing Specialization"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which tribe of trolls is the only one to have ever sworn loyalty to the Horde?",
  ['Answers'] = {"darkspear", "The darkspear tribe", "darkspear tribe"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which tribe of trolls is the only one to have ever sworn loyalty to the Horde?",
  ['Answers'] = {"darkspear", "The darkspear tribe", "darkspear tribe"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Name a class which a Troll cannot be. (excluding paladin)",
  ['Answers'] = {"warlock", "druid"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the quest in which Makrik asks you locate his fallen wife's body?",
  ['Answers'] = {"lost in battle"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Each race of priest gets two unique racial abilities: Name one of troll's unique priest racial abilities?",
  ['Answers'] = {"hex of weakness", "shadowguard"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "A quest called \"For The Horde!\" is part of the attunement questline to gain entrance to what zone?",
  ['Answers'] = {"Onyxia's Lair"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the forsaken starting area, located in tirisfal glades?",
  ['Answers'] = {"deathknell"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the quest which triggers the world buff \"Warchief's Blessing?\"",
  ['Answers'] = {"For the Horde!"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {"It has an exclamation mark in it."},
})

addQuestion({
  ['Question'] = "What is the name of the camp in Stranglethorn vale which has a zeppelin tower? (full official name)",
  ['Answers'] = {"Grom'gol Base Camp"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What other boss level NPC is located in the Royal Quarter alongside Sylvanas Windrunner <Banshee Queen>?",
  ['Answers'] = {"Varimathras"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "During the rogue quest Plundering the Plunderers, a hostile elite parrot spawns after looting the quest item.  What is it's name?",
  ['Answers'] = {"Polly"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the river that separates Durotar from The Barrens?",
  ['Answers'] = {"Southfury River", "The Southfury River"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "How many flight masters are located in The Barrens?",
  ['Answers'] = {"3", "Three"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What are the four elite alliance NPCs that patrol the barrens collectively known as?",
  ['Answers'] = {"Alliance Outrunners", "The Alliance Outrunners"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Name the quest in thousand needles which asks the player to leap from a plateau at a deadly height",
  ['Answers'] = {"Test of Faith"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the boat which travels between Ratchet and Booty Bay?",
  ['Answers'] = {"The Maiden's Fancy", "Maiden's Fancy"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "The quest \"Snapjaw's Mon!\" provides a horde only boon for which profession?",
  ['Answers'] = {"fishing"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "The rank 11 PvP title for Alliance is Commander.  What is the rank 11 Horde PvP title?",
  ['Answers'] = {"Lieutenant General", "Lt. General"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "In the pvp battleground Arathi Basic, which location is furthest from the Horde starting location?",
  ['Answers'] = {"Stables"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Zoram’gar Outpost is a small but key Horde base in which contested zone?",
  ['Answers'] = {"Ashenvale"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Thunder Bluff, the capital city of the Tauren, is perched atop how many major connected mesas in Mulgore?",
  ['Answers'] = {"4", "Four"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "The Wailing Caverns instance in the Northern Barrens features a quest to help awaken a druid from a twisted dream. Name that druid.",
  ['Answers'] = {"Naralex"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which cultist group can be found in Skull Rock?",
  ['Answers'] = {"The Burning Blade cultists", "Burning Blade", "Burning blade cultists", "The burning blade"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "In Thousand Needles, which tribe of hostile tauren does the Horde frequently battle as part of quest lines near Freewind Post?",
  ['Answers'] = {"The Grimtotem tribe", "grimtotem", "grimtotem tribe"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Forsaken are renowned for having a powerful ability that helped them break fear and other crowd-control effects. What is this signature active racial trait called?",
  ['Answers'] = {"Will of the Forsaken"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the towering elevator which helps players transition between the Barrens and Thousand Needles?",
  ['Answers'] = {"The Great Lift"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "How many creatures can Tauren's Warstomp ability potentially stun?",
  ['Answers'] = {"5", "five"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the quest which rewards Really Sticky Glue?",
  ['Answers'] = {"A Solvent Spirit"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Quote: \"You too shall serve\"",
  ['Answers'] = {"Archmage Arugal", "Arugal"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "How often will an orc warrior with 5 talent points put into [Iron Will] resist stuns?",
  ['Answers'] = {"45", "Forty five", "45%", "Forty five Percent"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "This deadly level 12 goblin NPC can be found in Durotar surrounded by several Burning Blade cultists and an imp.  To reach him, you must pass through Thunder Lizard Gulch (or jump down a great distance).",
  ['Answers'] = {"Fizzle Darkstorm"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "This deadly quest in Stonetalon Peaks asks the player to defend Piznik while he mines \"gold-green ore.\"  What is the name of the quest?",
  ['Answers'] = {"Gerenzo's Orders"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which zone is home to Lake Everstill?",
  ['Answers'] = {"Redridge Mountains", "Redridge"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which dwarven clan is primarily based in Ironforge?",
  ['Answers'] = {"Bronzebeard", "The Bronzebeard Clan", "Bronzebeard Clan"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which dwarven clan can be found at Aerie Peak?",
  ['Answers'] = {"Wildhammer", "The Wildhammer Clan", "Wildhammer Clan"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "True of False: The Wildhammer Clan is not officially part of the Alliance.",
  ['Answers'] = {"True"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "In which zone is the conclusion to the Missing Diplomat Questline?",
  ['Answers'] = {"Dustwallow Marsh"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Onyxia is famously disguised as which NPC in Stormwind?",
  ['Answers'] = {"Lady Katrana Prestor"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name quest which finally reveals Onyxia's deception in Stormwind?",
  ['Answers'] = {"The Great Masquerade"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What Alliance-aligned group battles against the Frostwolf clan in Alterac Valley?",
  ['Answers'] = {"The Stormpike Guard", "Stormpike Guard"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the quest that Alliance players must complete in Theramore in order to progress First Aid beyond level 225?",
  ['Answers'] = {"Triage"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which sprawling quest chain known revolves around investigating the disappearance of the King of Stormwind?",
  ['Answers'] = {"The Missing Diplomat", "missing diplomat"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Rackmore's Treasure can be found in which zone?",
  ['Answers'] = {"Desolace"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "In which zone is the final quest of Cortello's Riddle completed?",
  ['Answers'] = {"The Hinterlands", "Hinterlands"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the Inn/Tavern located in Brill?",
  ['Answers'] = {"Gallow's End Tavern", "Gallow's End"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "This server (Doomhowl) is named after a boss located in which dungeon or raid?",
  ['Answers'] = {"Blackrock Spire", "lbrs", "Lower blackrock spire"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Many mage quests can be found from which NPC in her hut in Duskwallow Marsh",
  ['Answers'] = {"Tabetha"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Orc NPC Quote: May your blades _____ ____?",
  ['Answers'] = {"never dull"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "The Deadmines entrance is located in what town in Westfall?",
  ['Answers'] = {"Moonbrook"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "True or False: The onyxia buff drops on all layers.",
  ['Answers'] = {"True"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "An extremely deadly rare elite devilsaur roams the western side of Un'goro Crater.  What is his name?",
  ['Answers'] = {"King Mosh"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "A neutral Auction House, run by goblins and available to both the Horde and the Alliance, can be found in Ratchet, Booty Bay, Gadgetzan and which other town?",
  ['Answers'] = {"Everlook"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the deadliest thing in Ragefire Chasm (by HC kill count)?",
  ['Answers'] = {"Lava"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Who is the Warchief of the \"Dark Horde?\"",
  ['Answers'] = {"Rend Blackhand", "Dal'rend Blackhand", "Warchief Rend Blackhand", "Rend"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Who was the last guardian of Tirasfal?",
  ['Answers'] = {"Medivh", "Magus Medivh"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which blood god are the trolls in Zul'Gurub attempting to resurrect?",
  ['Answers'] = {"Hakkar", "Hakkar the Soulflayer", "Hakkar, the Soulflayer"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Who originally wielded Ashbringer?",
  ['Answers'] = {"Alexandros Mograine", "Mograine", "Scarlet Highlord Mograine", "Highlord Mograine", "Highlord Alexandros Mograine"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Name the fictional legendary sword used in a South Park episode to defeat an unspeakably powerful Alliance griefer.",
  ['Answers'] = {"The Sword of a Thousand Truths", "Sword of a Thousand Truths"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "During the War of Three Hammers, Emperor Thaurissan sought to overpower the other dwarf clans by invoking a ritual.  This ritual inadvertently summoned what being?",
  ['Answers'] = {"Ragnaros", "Ragnaros, The Firelord"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which Dalaran archmage, desperate for a weapon against the Scourge, inadvertantly unleashed worgen into Azeroth?",
  ['Answers'] = {"Arugal", "Archmage Arugal"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What percentage of it's normal damage does a hunter's pet do when it is unhappy?",
  ['Answers'] = {"75", "75%", "seventy-five", "seventy-five percent", "seventy five"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "The Twilight Grove in Duskwood is said to contain a portal to where?",
  ['Answers'] = {"The Emerald Dream", "Emerald Dream"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Caer Darrow, Brill, Southshore, and Tarren Mill previously belonged to which noble family?",
  ['Answers'] = {"Barov", "The Barov Family", "The Barovs"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "High Tinker Mekkatorque sanctioned the use of radiation in a desparate attempt to drive out what race of invader of Gnomeregan?",
  ['Answers'] = {"Trogg", "Troggs", "the troggs"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which faction in Classic WoW must you be exalted with to acquire the Winterspring Frostsaber mount?",
  ['Answers'] = {"Wintersaber Trainers"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which organization is dedicated to combatting the scourge in the Plaguelands?",
  ['Answers'] = {"The Argent Dawn", "Argent Dawn"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which epic weapon is the reward of the quest chain involving the book 'Foror's Compendium of Dragon Slaying?'",
  ['Answers'] = {"Quel'Serrar"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which troll tribe primarily inhabits Zul'Gurub?",
  ['Answers'] = {"Gurubashi"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "How many resource points are needed to win an Arathi Basin match in Classic WoW?",
  ['Answers'] = {"2000"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Then-Archmage Kel'Thuzad created an organization of living beings who serve the Lich King?  What is it's name?",
  ['Answers'] = {"Cult of the Damned", "The cult of the damned"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"It's a cult"},
})

addQuestion({
  ['Question'] = "Which black dragon disguised herself as Lady Katrana Prestor to manipulate Stormwind's politics from within?",
  ['Answers'] = {"Onyxia"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Name one of the four corrupted Green Dragons that served as world bosses in Classic WoW, alongside Emeriss, Lethon, and Taerar.",
  ['Answers'] = {"Ysondre"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which legendary item can be crafted from sulfuron ingots and a rare drop in Molten Core?",
  ['Answers'] = {"Sulfuras, Hand of Ragnaros", "Sulfuras"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Who is the infamous necromancer presiding over Scholomance, serving as the final boss of the instance? (full npc name)",
  ['Answers'] = {"Darkmaster Gandling"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Name the ability: \"Gather information about the target beast.  The tooltip will display damage, health, armor, any special resistances, and diet.\"",
  ['Answers'] = {"Beast Lore"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the highest rank of a hunter pet's loyalty?",
  ['Answers'] = {"Best Friend"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Name the weapon: \"Whomsoever takes up this blade shall wield power eternal. Just as the blade rends flesh, so must power scar the spirit.\"",
  ['Answers'] = {"Frostmourne"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the weapon, located in gnomeregan, which is commonly farmed by Feral Druids?",
  ['Answers'] = {"Manual Crowd Pummeler", "[Manual Crowd Pummeler]"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "In Classic WoW, what is the name of the corrupted Ashbringer wielder, whom Arthas transformed into a death knight?",
  ['Answers'] = {"Highlord Mograine", "Alexandros Mograine", "Highlore Mograine <The Ashbringer>", "Highlore Mograine<The Ashbringer>"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which city did Arthas purge to prevent its citizens from turning into undead?",
  ['Answers'] = {"Stratholme"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "In the Blasted Lands, what is the rarest type of crystal that can be turned in to Kum'isha the Collector for rare or even epic rewards?",
  ['Answers'] = {"Flawless Draenethyst Sphere", "Flawless Draenethyst"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"The crystal is a sphere."},
})

addQuestion({
  ['Question'] = "The upper class of which ogre clan can be found in Dire Maul?",
  ['Answers'] = {"Gordunni", "The Gordunni"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"The crystal is a sphere."},
})

addQuestion({
  ['Question'] = "Which dungeon was originally a sacred burial site for the centaur and the tomb of Zaetar, son of Cenarius?",
  ['Answers'] = {"Maraudon"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the epic fire resistance cape crafted specifically for Blackwing Lair?",
  ['Answers'] = {"Onyxia Scale Cloak"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Name any one Zepplin Master.",
  ['Answers'] = {"Hin Dinburg", "Snurk Bucksquick", "Frezza", "Zapetta", "Squibby Overspeck", "Nez'raz"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "In Hardcore WoW, which passive Holy Priest talent can only be triggered once?",
  ['Answers'] = {"Spirit of Redemption"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the largest island in Silverpine Forest?",
  ['Answers'] = {"Fenris Isle"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the collection of islands in Silverpine Forest?",
  ['Answers'] = {"Dawning Isles", "The Dawning Isles"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the lake in Silverpine Forest?" ,
  ['Answers'] = {"Lake Lordamere", "Lordamere Lake", "Lordamere"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "The quest Assault on Fenris Isle asks horde characters to collect which NPC's head? (Full name)",
  ['Answers'] = {"Thule Ravenclaw"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the Inn in Goldshire",
  ['Answers'] = {"Lion's Pride Inn", "Lion's Pride"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What tool is required to cast Windfury Totem?",
  ['Answers'] = {"Air Totem"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "The Shrine of the Fallen Warrior is a memorial to Michel Koiter, a Blizzard employee who died during the development of World of Warcraft.  In which zone is it located?",
  ['Answers'] = {"The Barrens", "Barrens"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "A notoriously deadly named Defias member resides in a house near FurlBrow's Pumpkin Patch.  what is his name? (full NPC name)",
  ['Answers'] = {"Benny Blaanco"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Name the item: Use: You turn to stone, protecting you from all physical attacks and spells for 1 min, but during that time you cannot attack, move or cast spells.  You can only have the effect of one flask at a time. (3 Sec Cooldown)",
  ['Answers'] = {"Flask of Petrification"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "How much additional damage does Enchant 2H Weapon - Superior Impact (the highest level impact enchant) provide to a weapon?",
  ['Answers'] = {"9", "+9"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Before declaring you worthy of his company, Hemet Nesingwary tests your mastery at hunting panthers, tigers, and what other type of creature?",
  ['Answers'] = {"raptor", "raptors"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the docked ship at Menethil Harbor?",
  ['Answers'] = {"The Maiden's Virtue", "Maiden's Virtue"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "To which continent did arthas pursue Malganis. (Yes, this lore existed during Vanilla)",
  ['Answers'] = {"Northrend"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Whose skull did Illidan consume?",
  ['Answers'] = {"Gul'dan"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "In Warcraft III: The Frozen Throne, which orc shaman's spirit did Arthas merge with to become the Lich King?",
  ['Answers'] = {"Ner'zhul"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "How many seconds does it take to use a hearthstone?",
  ['Answers'] = {"10", "ten"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "The quest [In the Name of the Light] has the player travel to which group of dungeons to kill four bosses?",
  ['Answers'] = {"Scarlet Monastery", "The Scarlet Monastery"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Excluding rare bosses, how many bosses are there in all of the Scarlet Monastery instances combined?",
  ['Answers'] = {"8", "Eight"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "The Stone of Remembrance is a monument dedicated to all those who have fallen in the protection of Stormwind.  In what zone does it lie?",
  ['Answers'] = {"Elwynn Forest", "Elwynn"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What type of item of sentimental value does Baros Alexston ask you to retrieve from his old farm in Westfall?",
  ['Answers'] = {"Compass", "A Simple Compass"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What potion increases your walking speed by 50% for 15 seconds?",
  ['Answers'] = {"Swiftness", "Swiftness Potion"},
  ['Category'] = CAT_HC,
  ['Points'] = "1" ,
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the Alliance only quest reward which grants immunity to all damage and spells for 10 seconds?",
  ['Answers'] = {"Light of Elune"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What item is required for alchemists to be able to perform transmutations?",
  ['Answers'] = {"Philosopher's Stone"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"The apostrophe matters."},
})

addQuestion({
  ['Question'] = "What is the minimum level at which a Warrior can complete the quest 'Whirlwind Weapon' which rewards various powerful 'Whirlwind' weapons?",
  ['Answers'] = {"30", "thirty"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "In what zone did Thrall put a monument to Grommash Hellscream?",
  ['Answers'] = {"Ashenvale"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What herb can only be found growing in places tainted by demons?",
  ['Answers'] = {"Gromsblood"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "In Vanilla WoW, what language could only Night Elves speak?",
  ['Answers'] = {"Darnassian"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Who is the herb Gromsblood named after?",
  ['Answers'] = {"Grommash Hellscream", "Grom Hellscream"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which elite gnoll in Elwynn Forest is notorious for killing low-level players near the Riverpaw camps?",
  ['Answers'] = {"Hogger"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Who created Stitches, the abomination in Duskwood, as a gift for Lord Ello Ebonlocke, the mayor of Darkshire?",
  ['Answers'] = {"Abercrombie the Embalmer", "Abercrombie"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "How many elite worgen called \"Son of Arugal\" can be found in Silverpine Forest?",
  ['Answers'] = {"3", "three"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the lava-filled raid deep inside Blackrock Mountain where players face elemental forces?",
  ['Answers'] = {"Molten Core"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Who is the final boss of the Molten Core raid?",
  ['Answers'] = {"Ragnaros"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What key item is used to open the door into Upper Blackrock Spire?",
  ['Answers'] = {"Seal of Ascension"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the key required to access multiple wings of Dire Maul?",
  ['Answers'] = {"Crescent Key"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the undead city dungeon in the Eastern Plaguelands that was famously attacked by Arthas Menethil?",
  ['Answers'] = {"Stratholme"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the raid lair where the broodmother dragon Onyxia is fought?",
  ['Answers'] = {"Onyxia's Lair"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which elite black drake is notorious for wiping travelers as it patrols near the Blasted Lands and Swamp of Sorrows routes?",
  ['Answers'] = {"Teremus the Devourer", "Teremus"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which Horde capital city is built beneath the ruins of the former human capital of Lordaeron?",
  ['Answers'] = {"Undercity"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the Tauren capital city built atop mesas connected by bridges?",
  ['Answers'] = {"Thunder Bluff"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "In which zone is the Horde capital Orgrimmar located?",
  ['Answers'] = {"Durotar"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the starting zone for undead characters in Classic WoW?",
  ['Answers'] = {"Tirisfal Glades"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the Horde-only dungeon located inside Orgrimmar?",
  ['Answers'] = {"Ragefire Chasm"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the main Horde quest hub town in the Barrens with a central flight path?",
  ['Answers'] = {"The Crossroads", "Crossroads"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which Barrens quest giver is famous for the meme about finding his missing wife?",
  ['Answers'] = {"Mankrik"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which NPC at Blackrock Mountain can teleport attuned players directly into Molten Core? (Full NPC Name)",
  ['Answers'] = {"Lothos Riftwaker"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Who is the regent lord of Stormwind during the events of Vanilla WoW?",
  ['Answers'] = {"Bolvar Fordragon", "Bolvar"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the irradiated gnome city that becomes a dungeon in Vanilla WoW?",
  ['Answers'] = {"Gnomeregan"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the Alliance harbor town in the Wetlands that connects to Kalimdor by boat?",
  ['Answers'] = {"Menethil Harbor", "Menethil"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the night elf racial mount type called in Classic WoW?",
  ['Answers'] = {"Nightsaber", "Nightsabers"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of Arthas Menethil's cursed runeblade in Warcraft lore?",
  ['Answers'] = {"Frostmourne"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which demon lord bound Ner'zhul's spirit to create the Lich King?",
  ['Answers'] = {"Kil'jaeden", "Kiljaeden"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which Old God is imprisoned beneath Ahn'Qiraj and serves as the final boss of the Temple of Ahn'Qiraj raid?",
  ['Answers'] = {"C'Thun"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the red dragon Aspect known as the Life-Binder?",
  ['Answers'] = {"Alexstrasza"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of Deathwing's eldest son who leads Blackwing Lair?",
  ['Answers'] = {"Nefarian", "Lord Victor Nefarius"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of Illidan Stormrage's twin brother?",
  ['Answers'] = {"Malfurion Stormrage", "Malfurion"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What title is Illidan Stormrage most famously known by in Warcraft lore?",
  ['Answers'] = {"The Betrayer"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Who serves as the final boss of Maraudon and is also the target of the killing quest \"Corruption of Earth and Seed\"? (Full NPC Name)",
  ['Answers'] = {"Princess Theradras"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the elite undead knight that stalks Raven Hill Cemetery in Duskwood?",
  ['Answers'] = {"Mor'ladim"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the infamous cave in Durotar that is a common cause of early Hardcore deaths?",
  ['Answers'] = {"Skull Rock"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the debuff called that you receive after resurrecting at a Spirit Healer in Classic WoW?",
  ['Answers'] = {"Resurrection Sickness"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which Vanilla dungeon inside Blackrock Mountain is famous for being enormous, maze-like, and full of deadly pulls?",
  ['Answers'] = {"Blackrock Depths", "BRD"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Who is the emperor and final boss encounter of Blackrock Depths in Vanilla WoW?",
  ['Answers'] = {"Emperor Dagran Thaurissan", "Dagran Thaurissan", "Thaurissan"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the Alliance-only camp in northern Stranglethorn Vale that serves as a quest hub?",
  ['Answers'] = {"Rebel Camp"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the main Horde-only quest hub in Stranglethorn Vale? (Full name)",
  ['Answers'] = {"Grom'gol Base Camp"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Whose spirit was bound into the Helm of Domination to become the Lich King?",
  ['Answers'] = {"Ner'zhul", "Nerzhul"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What item did players need to obtain (via a long quest chain) to attune themselves and gain access to Onyxia’s Lair?",
  ['Answers'] = {"Drakefire Amulet"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What player's name became a famous meme after he charged into battle yelling his own name in Upper Blackrock Spire?",
  ['Answers'] = {"Leeroy Jenkins"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which low-level dungeon in the Barrens is a sprawling cave system with the boss Mutanus the Devourer?",
  ['Answers'] = {"Wailing Caverns", "WC"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the Alliance faction in Alterac Valley?",
  ['Answers'] = {"Stormpike Guard", "Stormpike"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the Horde faction in Alterac Valley?",
  ['Answers'] = {"Frostwolf Clan", "Frostwolf"},
  ['Category'] = CAT_HORDE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the free-for-all PvP arena in Stranglethorn Vale where players battle for a treasure chest that periodically appears?",
  ['Answers'] = {"Gurubashi Arena"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "During the Gates of Ahn’Qiraj opening event, what unique title was given to players who rang the gong to open the gates?",
  ['Answers'] = {"Scarab Lord"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Originally in Vanilla WoW, how many debuffs could a single enemy have on it at one time (the debuff limit)?",
  ['Answers'] = {"8", "eight"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Which legendary item is often jokingly spammed in chat with the phrase “Did someone say [item name]?” due to its famously long name? (Full Item Name)",
  ['Answers'] = {"Thunderfury, Blessed Blade of the Windseeker", "[Thunderfury, Blessed Blade of the Windseeker]"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the zone inside the Mage Tower in Stormwind’s Mage Quarter that serves as the portal arrival point to Stormwind?",
  ['Answers'] = {"Wizard's Sanctum"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the world buff granted in Stormwind or Orgrimmar after turning in Onyxia's Head?",
  ['Answers'] = {"Rallying Cry of the Dragonslayer"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Onyxia's Head turn-in"},
})

addQuestion({
  ['Question'] = "What is the name of the world buff granted after turning in Nefarian's Head?",
  ['Answers'] = {"Rallying Cry of the Dragonslayer"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Blackwing Lair head turn-in"},
})

addQuestion({
  ['Question'] = "What is the name of the Zandalar Tribe world buff gained from turning in the Heart of Hakkar on Yojamba Isle?",
  ['Answers'] = {"Spirit of Zandalar"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Zul'Gurub", "Yojamba Isle"},
})

addQuestion({
  ['Question'] = "What is the name of the Dire Maul tribute buff that increases stamina by 15%?",
  ['Answers'] = {"Mol'dar's Moxie"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Dire Maul tribute", "Ogre king"},
})

addQuestion({
  ['Question'] = "What is the name of the Dire Maul tribute buff that increases attack power by 200?",
  ['Answers'] = {"Fengus' Ferocity"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Dire Maul tribute", "Ferocity"},
})

addQuestion({
  ['Question'] = "What is the name of the Dire Maul tribute buff that increases spell critical chance by 3%?",
  ['Answers'] = {"Slip'kik's Savvy", "Slip'kik's Savvy"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Dire Maul tribute", "Ogre mage"},
})

addQuestion({
  ['Question'] = "What is the name of the priest buff that increases stamina? (Either one)",
  ['Answers'] = {"Power Word: Fortitude", "Prayer of Fortitude"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Priest", "Stamina"},
})

addQuestion({
  ['Question'] = "What is the name of the priest buff that increases spirit? (Exact Name)",
  ['Answers'] = {"Divine Spirit"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Priest", "Spirit"},
})

addQuestion({
  ['Question'] = "What is the name of the druid buff that increases stats and resistances? (Exact Name)",
  ['Answers'] = {"Mark of the Wild", "Gift of the Wild"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the mage buff that increases intellect? (Exact Name)",
  ['Answers'] = {"Arcane Intellect", "Arcane Brilliance"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "Excluding Greater blessings, how many different types of blessings does the paladin class have to grant to allies?",
  ['Answers'] = {"Nine", "9"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"You're probably forgetting the ones with long cooldowns..."},
})

addQuestion({
  ['Question'] = "What is the name of the rogue self-buff that increases attack speed by consuming combo points?",
  ['Answers'] = {"Slice and Dice"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Rogue", "Combo points"},
})

addQuestion({
  ['Question'] = "What is the name of the hunter aspect that increases ranged attack power? (full ability name)",
  ['Answers'] = {"Aspect of the Hawk"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Hunter", "Hawk"},
})

addQuestion({
  ['Question'] = "What is the name of the shaman totem buff which gives a chance for extra melee attacks?",
  ['Answers'] = {"Windfury Totem", "Windfury"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the flask that increases maximum health in Classic WoW? (Exact item name)",
  ['Answers'] = {"Flask of the Titans"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Flask", "Health"},
})

addQuestion({
  ['Question'] = "What is the name of the flask that increases maximum mana in Classic WoW? (Exact item name)",
  ['Answers'] = {"Flask of Distilled Wisdom"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Flask", "Mana"},
})

addQuestion({
  ['Question'] = "What is the name of the flask that increases spell power in Classic WoW? (Exact item name)",
  ['Answers'] = {"Flask of Supreme Power"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Flask", "Casters love it"},
})

addQuestion({
  ['Question'] = "What is the name of the elixir that increases agility and critical strike chance for melee classes? (Exact item name)",
  ['Answers'] = {"Elixir of the Mongoose"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {"Elixir", "Agility"},
})

addQuestion({
  ['Question'] = "How many slots are provided by the largest general purpose bag that you can by in Classic WoW?",
  ['Answers'] = {"18", "Eighteen"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What was the original name for the Duel to the Death feature in hardcore WoW? (Exact name)",
  ['Answers'] = {"Mak'gora"},
  ['Category'] = CAT_HC,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the buff which displays how many trophies you've gathered from victories while Dueling to the Death? (Exact Buff Name)",
  ['Answers'] = {"String of Ears"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What was the name of the Southpark episode which featured World of Warcraft?",
  ['Answers'] = {"Make Love, Not Warcraft", "Make Love Not Warcraft"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {},
})

-- Gathering Professions (Classic Era)

-- Herbalism

addQuestion({
  ['Question'] = "What Herbalism skill is required to gather Black Lotus?",
  ['Answers'] = {"300"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"The famous flask herb."},
})

addQuestion({
  ['Question'] = "What special forge is required to smelt Dark Iron Ore?",
  ['Answers'] = {"black forge"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"It's inside Blackrock Depths."},
})

-- Fishing / debris pools
addQuestion({
  ['Question'] = "What Fishing skill is required to use 'Expert Fishing - The Bass and You'?",
  ['Answers'] = {"125"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"It raises your fishing cap to 225."},
})

addQuestion({
  ['Question'] = "What character level is required to use 'Expert Fishing - The Bass and You'?",
  ['Answers'] = {"20"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"Book requirement."},
})

addQuestion({
  ['Question'] = "What Fishing skill is required to accept 'Nat Pagle, Angler Extreme'?",
  ['Answers'] = {"225"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"This unlocks Artisan Fishing (300 cap)."},
})

addQuestion({
  ['Question'] = "What character level is required to accept 'Nat Pagle, Angler Extreme'?",
  ['Answers'] = {"35"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"Artisan Fishing questline requirement."},
})

addQuestion({
  ['Question'] = "Which fishing pool primarily contains Tightly Sealed Trunks?",
  ['Answers'] = {"floating debris"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"Low level pool."},
})

addQuestion({
  ['Question'] = "Which fishing pool is most associated with catching Mithril Bound Trunks?",
  ['Answers'] = {"floating wreckage"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"Think shipwrecks."},
})

addQuestion({
  ['Question'] = "Which capital city in WoW Classic does not contain an anvil?",
  ['Answers'] = {"Darnassus"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {""},
})

addQuestion({
  ['Question'] = "Which herb is associated with breathing underwater?",
  ['Answers'] = {"Stranglekelp"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {""},
})

addQuestion({
  ['Question'] = "What Skinning skill is required to skin The Beast in Upper Blackrock Spire?",
  ['Answers'] = {"310"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"You’ll need a little bonus skill."},
})

addQuestion({
  ['Question'] = "What +10 Skinning dagger drops from The Beast in Upper Blackrock Spire?",
  ['Answers'] = {"finkle's skinner"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"The mob that needs extra skill… drops the tool."},
})

addQuestion({
  ['Question'] = "What item must be in your inventory for Bloodvine to show up while herbing in Zul'Gurub?",
  ['Answers'] = {"blood scythe"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"You loot it from hoodoo piles."},
})

addQuestion({
  ['Question'] = "What item teaches 'Find Fish' (the ability that shows fishing pools on your minimap)?",
  ['Answers'] = {"weather-beaten journal", "weather beaten journal"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"It’s a book, and it’s not from a trainer."},
})

addQuestion({
  ['Question'] = "What is the name of the special forge that is required to smelt Dark Iron Ore into bars?",
  ['Answers'] = {"black forge", "the black forge"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {""},
})

addQuestion({
  ['Question'] = "How many Dark Iron Ore are required to smelt ONE Dark Iron Bar in Classic?",
  ['Answers'] = {"8", "eight"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"It’s way more than other bars."},
})

addQuestion({
  ['Question'] = "What type of bars are created from smelting tin bars and copper bars together?",
  ['Answers'] = {"bronze", "bronze bars", "bronze bar"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {""},
})

addQuestion({
  ['Question'] = "How long does the Stranglethorn Fishing Extravaganza run for once it starts?",
  ['Answers'] = {"2 hours", "two hours", "120 minutes"},
  ['Category'] = CAT_PROF,
  ['Points'] = "1",
  ['Hints'] = {"2pm to 4pm realm time."},
})

addQuestion({
  ['Question'] = "Eldre'Thalas was the capital of Queen Azshara's Highborne servitors, but serves as a dungeon in Classic WoW.  What is it known by now?",
  ['Answers'] = {"Dire Maul"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "In which zone lies \"The Twin Colossals\"?",
  ['Answers'] = {"feralas"},
  ['Category'] = CAT_GEO,
  ['Points'] = "1",
  ['Hints'] = {"Two huge rock pillars with a road between them."},
})

addQuestion({
  ['Question'] = "The Shen'dralar were the revered arcanists of which Night Elf queen?",
  ['Answers'] = {"queen azshara", "azshara"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"Pre-Sundering royalty."},
})

addQuestion({
  ['Question'] = "What demon was imprisoned in Dire Maul so the Shen'dralar could siphon its power?",
  ['Answers'] = {"immol'thar", "immolthar"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"You power down pylons to reach it."},
})

addQuestion({
  ['Question'] = "Which satyr is the final boss of Dire Maul East?",
  ['Answers'] = {"alzzin the wildshaper", "alzzin"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"Old Ironbark gets involved."},
})

addQuestion({
  ['Question'] = "Who founded the Defias Brotherhood after being denied payment for rebuilding Stormwind?",
  ['Answers'] = {"edwin vancleef", "vancleef", "van cleef"},
  ['Category'] = CAT_LORE,
  ['Points'] = "3",
  ['Hints'] = {"End boss of the Deadmines."},
})

addQuestion({
  ['Question'] = "Before becoming a crime lord, Edwin VanCleef led what guild of builders?",
  ['Answers'] = {"stonemasons guild", "stonemason guild", "the stonemasons guild", "stonemasons"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"They rebuilt Stormwind after the First War."},
})

addQuestion({
  ['Question'] = "Scholomance was created under the influence of which necromancer?",
  ['Answers'] = {"kel'thuzad", "kelthuzad", "kel thuzad"},
  ['Category'] = CAT_LORE,
  ['Points'] = "3",
  ['Hints'] = {"Cult of the Damned recruiter."},
})

addQuestion({
  ['Question'] = "What noble family originally owned Caer Darrow before it became tied to Scholomance?",
  ['Answers'] = {"barov", "the barov family", "barov family"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"You see their name on multiple quests."},
})

addQuestion({
  ['Question'] = "Kel'Thuzad’s followers were part of what cult that served the Lich King?",
  ['Answers'] = {"cult of the damned", "the cult of the damned"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"Recruiting pitch: immortality."},
})

addQuestion({
  ['Question'] = "What Old God cult has a major presence in Blackfathom Deeps, performing sacrifices?",
  ['Answers'] = {"twilight's hammer", "twilights hammer", "twilight hammer"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"You’ll see them again in other classic content."},
})

addQuestion({
  ['Question'] = "What is the name of the monstrous entity worshipped in Blackfathom Deeps?",
  ['Answers'] = {"aku'mai", "akumai"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"‘Devourer’ vibes."},
})

-- Blackrock Spire / Black Dragonflight manipulation
addQuestion({
  ['Question'] = "What name does Nefarian go by when using his human identity, the 'Lord of Blackrock'? (First and last name)",
  ['Answers'] = {"victor nefarius", "lord victor nefarius"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"Not the same dragon as his sister."},
})

addQuestion({
  ['Question'] = "Who is the general of the dragonspawn armies of Nefarian, and oversaw his forces in their war to drive out the Dark Iron dwarves from the bowels of Blackrock Mountain.",
  ['Answers'] = {"Drakkisath", "General Drakkisath"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"Top of UBRS."},
})

addQuestion({
  ['Question'] = "What is the name of the death knight who ruled Stratholme for the Scourge in classic?",
  ['Answers'] = {"baron rivendare", "rivendare", "baron titus rivendare", "titus rivendare"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"Famous mount drop."},
})

addQuestion({
  ['Question'] = "Who is the High Inquisitor directing Scarlet Crusade activities from the Scarlet Monastery Cathedral?",
  ['Answers'] = {"sally whitemane", "whitemane", "high inquisitor whitemane"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"She can resurrect her ally in the fight."},
})

addQuestion({
  ['Question'] = "What is the name of the NPC who, when attacked by ooze creatures in the wetlands, threw her bag at them to escape?",
  ['Answers'] = {"Sida"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {"The player gets a quest to retrieve her bag from the oozes."},
})

addQuestion({
  ['Question'] = "What is name of the little girl whose ghosts gives the player a quest to find a doll in the ruins of Darrowshire? (First and Last name)",
  ['Answers'] = {"Pamela Redpath"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {"Her relatives are: 	Joseph (father), Jessica (older sister), Carlin (uncle), and Marlene (aunt)"},
})

addQuestion({
  ['Question'] = "Barnil Stonepot was entrusted to proofread the manuscript of Hemet Nesingwary's yet-to-be-released novel.  What is the name of the Novel?",
  ['Answers'] = {"Green Hills of Stranglethorn"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"The pages are found all over Stranglethorn Vale."},
})

addQuestion({
  ['Question'] = "The Prophecy of Mosh'aru speaks of a relic that has the power to hold the essence of Hakkar.  What type of item is the relic?",
  ['Answers'] = {"egg", "ancient egg"},
  ['Category'] = CAT_LORE,
  ['Points'] = "1",
  ['Hints'] = {"You use the relic's power to stir dead god in The Sunken Temple."},
})

addQuestion({
  ['Question'] = "What is the name of the item that the Priest Staff 'Benediction' can transform into?",
  ['Answers'] = {"Anathema"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the item that the Priest Staff 'Benediction' can transform into?",
  ['Answers'] = {"Anathema"},
  ['Category'] = CAT_GENERAL,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "After consulting the cards and seeing “Death” stare back, what name comes to Madam Eva as the key clue to Alyssa’s danger?",
  ['Answers'] = {"Stalvan"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the name of the NPC rescued from a prison cell in Blackrock Depths during the quest 'Jail Break!'? (Exact NPC Name)",
  ['Answers'] = {"Marshall Windsor"},
  ['Category'] = CAT_ALLY,
  ['Points'] = "1",
  ['Hints'] = {},
})


-- Ensure the global table exists and register with TriviaClassic if present
_G.TriviaBot_Questions = TriviaBot_Questions
if TriviaClassic and TriviaClassic.RegisterTriviaBotSet then
  TriviaClassic:RegisterTriviaBotSet("Deadliest of Azeroth", TriviaBot_Questions)
end
