-- -------------------------------------------------- --
-- Minimal question set template for TriviaBot
-- This set has exactly 1 question, 1 hint, 1 answer.
-- -------------------------------------------------- --

local _, TriviaBot_Questions = ...

-- Store everything in TriviaBot_Questions[1]

TriviaBot_Questions[1] = {
  ['Categories'] = {},
  ['Question']   = {},
  ['Answers']    = {},
  ['Category']   = {},
  ['Points']     = {},
  ['Hints']      = {}
};

-- Basic info about the set
TriviaBot_Questions[1]['Title']       = "Deadliest of Azeroth"
TriviaBot_Questions[1]['Description'] = "Questionset about the different deadly creatures a player faces in Hardcore WoW and about Classic"
TriviaBot_Questions[1]['Author']      = "Aszolus-Doomhowl"

-- Add at least one category
TriviaBot_Questions[1]['Categories'][1] = "Deadly NPCs, places, and things"
TriviaBot_Questions[1]['Categories'][2] = "Alliance Trivia"
TriviaBot_Questions[1]['Categories'][3] = "Horde Trivia"
TriviaBot_Questions[1]['Categories'][4] = "Deep Lore"

TriviaBot_Questions[1]['Question'][1] = "What is the Deadliest Creature in Duskwood? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][1] = {"Stitches"}
TriviaBot_Questions[1]['Category'][1] = 1
TriviaBot_Questions[1]['Points'][1] = "1"
TriviaBot_Questions[1]['Hints'][1] = {"It's not Mor'Ladim."}

TriviaBot_Questions[1]['Question'][2] = "What is the Deadliest Creature in Dustwallow Marsh? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][2] = {"Coral Shark"}
TriviaBot_Questions[1]['Category'][2] = 1
TriviaBot_Questions[1]['Points'][2] = "1"
TriviaBot_Questions[1]['Hints'][2] = {"It swims."}

TriviaBot_Questions[1]['Question'][3] = "What is the Deadliest Creature in Westfall? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][3] = {"Defias Trapper"}
TriviaBot_Questions[1]['Category'][3] = 1
TriviaBot_Questions[1]['Points'][3] = "1"
TriviaBot_Questions[1]['Hints'][3] = {"It's not Defias Pillager."}

TriviaBot_Questions[1]['Question'][4] = "What is the Deadliest Creature in Stormwind? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][4] = {"Rift Spawn"}
TriviaBot_Questions[1]['Category'][4] = 1
TriviaBot_Questions[1]['Points'][4] = "1"
TriviaBot_Questions[1]['Hints'][4] = {"They kill mostly mages."}

TriviaBot_Questions[1]['Question'][5] = "What is the Deadliest Creature at Raven Hill? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][5] = {"Mor'Ladim"}
TriviaBot_Questions[1]['Category'][5] = 1
TriviaBot_Questions[1]['Points'][5] = "1"
TriviaBot_Questions[1]['Hints'][5] = {}

TriviaBot_Questions[1]['Question'][6] = "What is the Deadliest Creature in Mulgore?  *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][6] = {"Snagglespear"}
TriviaBot_Questions[1]['Category'][6] = 1
TriviaBot_Questions[1]['Points'][6] = "1"
TriviaBot_Questions[1]['Hints'][6] = {}

TriviaBot_Questions[1]['Question'][7] = "What is the Deadliest Creature at Stranglethorn Vale? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][7] = {"Zanzil Skeleton"}
TriviaBot_Questions[1]['Category'][7] = 1
TriviaBot_Questions[1]['Points'][7] = "1"
TriviaBot_Questions[1]['Hints'][7] = {}

TriviaBot_Questions[1]['Question'][8] = "What is the Deadliest Creature in The Deadmines? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][8] = {"Defias Squallshaper"}
TriviaBot_Questions[1]['Category'][8] = 1
TriviaBot_Questions[1]['Points'][8] = "1"
TriviaBot_Questions[1]['Hints'][8] = {}

TriviaBot_Questions[1]['Question'][9] = "What elite mob is spawned from looting Blood of Heroes?"
TriviaBot_Questions[1]['Answers'][9] = {"Fallen Hero", "fallen heroes"}
TriviaBot_Questions[1]['Category'][9] = 1
TriviaBot_Questions[1]['Points'][9] = "1"
TriviaBot_Questions[1]['Hints'][9] = {}

TriviaBot_Questions[1]['Question'][10] = "What great white tiger does Hemet Nesingwary ask you to slay for the quest Big Game Hunter? (Full NPC name)"
TriviaBot_Questions[1]['Answers'][10] = {"King Bangalash"}
TriviaBot_Questions[1]['Category'][10] = 1
TriviaBot_Questions[1]['Points'][10] = "1"
TriviaBot_Questions[1]['Hints'][10] = {}

-- Question 11
TriviaBot_Questions[1]['Question'][11] = "What is the deadliest mob in Eastern Plaguelands?  *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][11] = {"Fallen Hero", "fallen heroes"}
TriviaBot_Questions[1]['Category'][11] = 1
TriviaBot_Questions[1]['Points'][11] = "1"
TriviaBot_Questions[1]['Hints'][11] = {"It spawns from Blood of Heroes."}

-- Question 12
TriviaBot_Questions[1]['Question'][12] = "Which dragon is the final boss in Blackwing Lair?"
TriviaBot_Questions[1]['Answers'][12] = {"Nefarian", "nefarian"}
TriviaBot_Questions[1]['Category'][12] = 4
TriviaBot_Questions[1]['Points'][12] = "1"
TriviaBot_Questions[1]['Hints'][12] = {"He is a corrupted black dragon and the son of Deathwing."}

-- Question 13
TriviaBot_Questions[1]['Question'][13] = "Boss Quote: \"Now You're Making me Angry!\" "
TriviaBot_Questions[1]['Answers'][13] = {"Mr. Smite", "Mr. Smite<The Ship's First Mate>", "mr smite"}
TriviaBot_Questions[1]['Category'][13] = 4
TriviaBot_Questions[1]['Points'][13] = "1"
TriviaBot_Questions[1]['Hints'][13] = {"Located in the Deadmines dungeon."}

-- Question 14
TriviaBot_Questions[1]['Question'][14] = "Which undead elite surprises unsuspecting Alliance players by spawning in Southshore's Graveyard?"
TriviaBot_Questions[1]['Answers'][14] = {"Helcular's Remains"}
TriviaBot_Questions[1]['Category'][14] = 1
TriviaBot_Questions[1]['Points'][14] = "1"
TriviaBot_Questions[1]['Hints'][14] = {"His name in life was Helcular."}

-- Question 15
TriviaBot_Questions[1]['Question'][15] = "What is the most common way to die in HC WoW?"
TriviaBot_Questions[1]['Answers'][15] = {"Falling", "fall damage"}
TriviaBot_Questions[1]['Category'][15] = 1
TriviaBot_Questions[1]['Points'][15] = "1"
TriviaBot_Questions[1]['Hints'][15] = {"There's no achievement for it Classic."}

-- Question 16
TriviaBot_Questions[1]['Question'][16] = "What is the deadliest mob in Dun Morough? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][16] = {"Wendigo"}
TriviaBot_Questions[1]['Category'][16] = 1
TriviaBot_Questions[1]['Points'][16] = "1"
TriviaBot_Questions[1]['Hints'][16] = {}

-- Question 17
TriviaBot_Questions[1]['Question'][17] = "What is the SECOND most common way to die in HC WoW?"
TriviaBot_Questions[1]['Answers'][17] = {"Drowning"}
TriviaBot_Questions[1]['Category'][17] = 1
TriviaBot_Questions[1]['Points'][17] = "1"
TriviaBot_Questions[1]['Hints'][17] = {}

-- Question 18
TriviaBot_Questions[1]['Question'][18] = "What is the deadliest enemy found in Northern Stranglethorn Vale?  *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][18] = {"Kurzen Subchief"}
TriviaBot_Questions[1]['Category'][18] = 1
TriviaBot_Questions[1]['Points'][18] = "1"
TriviaBot_Questions[1]['Hints'][18] = {}

-- Question 19
TriviaBot_Questions[1]['Question'][19] = "Which rare mount is dropped by Baron Rivendare in Stratholme?"
TriviaBot_Questions[1]['Answers'][19] = {"Deathcharger's Reins"}
TriviaBot_Questions[1]['Category'][19] = 1
TriviaBot_Questions[1]['Points'][19] = "1"
TriviaBot_Questions[1]['Hints'][19] = {}

-- Question 20
TriviaBot_Questions[1]['Question'][20] = "Name the boss of the Scarlet Monastery's Library wing."
TriviaBot_Questions[1]['Answers'][20] = {"Arcanist Doan"}
TriviaBot_Questions[1]['Category'][20] = 1
TriviaBot_Questions[1]['Points'][20] = "1"
TriviaBot_Questions[1]['Hints'][20] = {}

-- Question 21
TriviaBot_Questions[1]['Question'][21] = "What is the name of deadly pigs escorting Princess in Elwynn Forest?"
TriviaBot_Questions[1]['Answers'][21] = {"Porcine Entourage"}
TriviaBot_Questions[1]['Category'][21] = 1
TriviaBot_Questions[1]['Points'][21] = "1"
TriviaBot_Questions[1]['Hints'][21] = {}

-- Question 22
TriviaBot_Questions[1]['Question'][22] = "Limited Invulnerability Potions (LIP) grant immunity to physical attacks for how many seconds?"
TriviaBot_Questions[1]['Answers'][22] = {"6", "six"}
TriviaBot_Questions[1]['Category'][22] = 1
TriviaBot_Questions[1]['Points'][22] = "1"
TriviaBot_Questions[1]['Hints'][22] = {}

-- Question 23
TriviaBot_Questions[1]['Question'][23] = "What is the most common cause of death in Ironforge?"
TriviaBot_Questions[1]['Answers'][23] = {"lava"}
TriviaBot_Questions[1]['Category'][23] = 1
TriviaBot_Questions[1]['Points'][23] = "1"
TriviaBot_Questions[1]['Hints'][23] = {}

-- Question 24
TriviaBot_Questions[1]['Question'][24] = "Which undead necromancer is the final boss of Naxxramas?"
TriviaBot_Questions[1]['Answers'][24] = {"Kel'Thuzad", "kel'thuzad"}
TriviaBot_Questions[1]['Category'][24] = 4
TriviaBot_Questions[1]['Points'][24] = "1"
TriviaBot_Questions[1]['Hints'][24] = {}

-- Question 25
TriviaBot_Questions[1]['Question'][25] = "What is the deadliest mob in the Wetlands? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][25] = {"Young Wetlands Crocolisk"}
TriviaBot_Questions[1]['Category'][25] = 1
TriviaBot_Questions[1]['Points'][25] = "1"
TriviaBot_Questions[1]['Hints'][25] = {}

-- Question 26
TriviaBot_Questions[1]['Question'][26] = "What is the deadliest mob in Loch Modan? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][26] = {"Stonesplinter Seer"}
TriviaBot_Questions[1]['Category'][26] = 1
TriviaBot_Questions[1]['Points'][26] = "1"
TriviaBot_Questions[1]['Hints'][26] = {}

-- Question 27
TriviaBot_Questions[1]['Question'][27] = "What non-elite quest in Stranglethorn vale spawns multiple waves of Mistvale Gorillas?"
TriviaBot_Questions[1]['Answers'][27] = {"Stranglethorn Fever"}
TriviaBot_Questions[1]['Category'][27] = 1
TriviaBot_Questions[1]['Points'][27] = "1"
TriviaBot_Questions[1]['Hints'][27] = {}

-- Question 28
TriviaBot_Questions[1]['Question'][28] = "True or False: Enemy faction guards which aggro on you cause you to become pvp flagged, even they do not hit you."
TriviaBot_Questions[1]['Answers'][28] = {"True"}
TriviaBot_Questions[1]['Category'][28] = 1
TriviaBot_Questions[1]['Points'][28] = "1"
TriviaBot_Questions[1]['Hints'][28] = {}

-- Question 29
TriviaBot_Questions[1]['Question'][29] = "What rare elite creature boasts the highest player-kill rate in the Badlands?"
TriviaBot_Questions[1]['Answers'][29] = {"Zaricotl"}
TriviaBot_Questions[1]['Category'][29] = 1
TriviaBot_Questions[1]['Points'][29] = "1"
TriviaBot_Questions[1]['Hints'][29] = {}

-- Question 30
TriviaBot_Questions[1]['Question'][30] = "What is the deadliest mob in Darkshore? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][30] = {"Greymist Coastrunner"}
TriviaBot_Questions[1]['Category'][30] = 1
TriviaBot_Questions[1]['Points'][30] = "1"
TriviaBot_Questions[1]['Hints'][30] = {"They run along the coast."}

-- Question 30
TriviaBot_Questions[1]['Question'][31] = "What is the deadliest mob in Tirisfal Glades? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][31] = {"Cursed Darkbound"}
TriviaBot_Questions[1]['Category'][31] = 1
TriviaBot_Questions[1]['Points'][31] = "1"
TriviaBot_Questions[1]['Hints'][31] = {}

TriviaBot_Questions[1]['Question'][32] = "What is the deadliest mob in Silverpine Forest? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][32] = {"Son of Arugal"}
TriviaBot_Questions[1]['Category'][32] = 1
TriviaBot_Questions[1]['Points'][32] = "1"
TriviaBot_Questions[1]['Hints'][32] = {}

TriviaBot_Questions[1]['Question'][33] = "What is the deadliest mob in The Barrens? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][33] = {"Kolkar Invader"}
TriviaBot_Questions[1]['Category'][33] = 1
TriviaBot_Questions[1]['Points'][33] = "1"
TriviaBot_Questions[1]['Hints'][33] = {}

TriviaBot_Questions[1]['Question'][34] = "What is the first wand an enchanter can make?"
TriviaBot_Questions[1]['Answers'][34] = {"Lesser Magic Wand"}
TriviaBot_Questions[1]['Category'][34] = 4
TriviaBot_Questions[1]['Points'][34] = "1"
TriviaBot_Questions[1]['Hints'][34] = {}

TriviaBot_Questions[1]['Question'][35] = "What is the deadliest mob the horde faces? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][35] = {"Voidwalker Minion"}
TriviaBot_Questions[1]['Category'][35] = 1
TriviaBot_Questions[1]['Points'][35] = "1"
TriviaBot_Questions[1]['Hints'][35] = {}

TriviaBot_Questions[1]['Question'][36] = "What is the most common way to die in Orgrimmar? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][36] = {"Gamon"}
TriviaBot_Questions[1]['Category'][36] = 1
TriviaBot_Questions[1]['Points'][36] = "1"
TriviaBot_Questions[1]['Hints'][36] = {}

TriviaBot_Questions[1]['Question'][37] = "What is the deadliest enemy in Mulgore? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][37] = {"Snagglespear"}
TriviaBot_Questions[1]['Category'][37] = 1
TriviaBot_Questions[1]['Points'][37] = "1"
TriviaBot_Questions[1]['Hints'][37] = {}

TriviaBot_Questions[1]['Question'][38] = "What is the most common way to die in Thunder Bluff? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][38] = {"Falling", "Fall damage"}
TriviaBot_Questions[1]['Category'][38] = 1
TriviaBot_Questions[1]['Points'][38] = "1"
TriviaBot_Questions[1]['Hints'][38] = {}

TriviaBot_Questions[1]['Question'][39] = "When first creating a character, you arrive in Northshire facing your very first quest giver.  What is his name?"
TriviaBot_Questions[1]['Answers'][39] = {"Deputy Willem", "Willem"}
TriviaBot_Questions[1]['Category'][39] = 2
TriviaBot_Questions[1]['Points'][39] = "1"
TriviaBot_Questions[1]['Hints'][39] = {"Deputy ..."}

TriviaBot_Questions[1]['Question'][40] = "In Northshire, there are three types of kobolds: Kobold Vermin, Kobold Worker are two.  What is the last type?"
TriviaBot_Questions[1]['Answers'][40] = {"Kobold Laborer", "Laborer"}
TriviaBot_Questions[1]['Category'][40] = 2
TriviaBot_Questions[1]['Points'][40] = "1"
TriviaBot_Questions[1]['Hints'][40] = {""}

TriviaBot_Questions[1]['Question'][41] = "Located in Northshire, this NPC is described as \"a cutthroat who's plagued our farmers and merchants for weeks.\" Who is it?"
TriviaBot_Questions[1]['Answers'][41] = {"Garrick Padfoot"}
TriviaBot_Questions[1]['Category'][41] = 2
TriviaBot_Questions[1]['Points'][42] = "1"
TriviaBot_Questions[1]['Hints'][42] = {"Defias Leader in Northshire"}

TriviaBot_Questions[1]['Question'][43] = "What is the Deadliest Creature in Stormwind? *Based on HC Kill count."
TriviaBot_Questions[1]['Answers'][43] = {"Rift Spawn"}
TriviaBot_Questions[1]['Category'][43] = 2
TriviaBot_Questions[1]['Points'][43] = "1"
TriviaBot_Questions[1]['Hints'][43] = {"They kill mostly mages."}

TriviaBot_Questions[1]['Question'][44] = "What time do the children of Goldshire despawn?"
TriviaBot_Questions[1]['Answers'][44] = {"7 pm", "7", "7:00 pm", "7pm server"}
TriviaBot_Questions[1]['Category'][44] = 2
TriviaBot_Questions[1]['Points'][44] = "1"
TriviaBot_Questions[1]['Hints'][44] = {""}

TriviaBot_Questions[1]['Question'][45] = "Which farmstead is Princess and her Porcine Entourage located?"
TriviaBot_Questions[1]['Answers'][45] = {"Brackwell Pumpkin Patch", "Brackwell", "Brackwell's"}
TriviaBot_Questions[1]['Category'][45] = 2
TriviaBot_Questions[1]['Points'][45] = "1"
TriviaBot_Questions[1]['Hints'][45] = {}

TriviaBot_Questions[1]['Question'][46] = "What NPC in Goldshire grants you a reward for completing \"Wanted: \"Hogger\"\"?"
TriviaBot_Questions[1]['Answers'][46] = {"Marshal Dughan", "Dughan"}
TriviaBot_Questions[1]['Category'][46] = 2
TriviaBot_Questions[1]['Points'][46] = "1"
TriviaBot_Questions[1]['Hints'][46] = {}

TriviaBot_Questions[1]['Question'][47] = "Who is Maybell Maclure in love with according to the quest \"Young Lovers\"?"
TriviaBot_Questions[1]['Answers'][47] = {"Tommy Joe Stonefield", "Tommy Joe"}
TriviaBot_Questions[1]['Category'][47] = 2
TriviaBot_Questions[1]['Points'][47] = "1"
TriviaBot_Questions[1]['Hints'][47] = {"He's a Stonefield"}

TriviaBot_Questions[1]['Question'][48] = "William Pestle creates an invisibility potion to unite two lovers from rival farmsteads.  What item does he have you collect in order to make it?"
TriviaBot_Questions[1]['Answers'][48] = {"Crystal Kelp Frond", "Crystal Kelp"}
TriviaBot_Questions[1]['Category'][48] = 2
TriviaBot_Questions[1]['Points'][48] = "1"
TriviaBot_Questions[1]['Hints'][48] = {"______ ____ Frond"}

TriviaBot_Questions[1]['Question'][49] = "In which mine does Goldtooth reside?"
TriviaBot_Questions[1]['Answers'][49] = {"Fargodeep", "Fargodeep mine"}
TriviaBot_Questions[1]['Category'][49] = 2
TriviaBot_Questions[1]['Points'][49] = "1"
TriviaBot_Questions[1]['Hints'][49] = {}

TriviaBot_Questions[1]['Question'][50] = "How many cats does Donni Anthania<Crazy Cat Lady> keep inside her home?"
TriviaBot_Questions[1]['Answers'][50] = {"4"}
TriviaBot_Questions[1]['Category'][50] = 2
TriviaBot_Questions[1]['Points'][50] = "1"
TriviaBot_Questions[1]['Hints'][50] = {}

TriviaBot_Questions[1]['Question'][51] = "Which NPC demands a Pork Belly Pie before he will reveal the location of \"Auntie\" Bernice Stonefield's necklace?"
TriviaBot_Questions[1]['Answers'][51] = {"Billy Maclure"}
TriviaBot_Questions[1]['Category'][51] = 2
TriviaBot_Questions[1]['Points'][51] = "1"
TriviaBot_Questions[1]['Hints'][51] = {}

TriviaBot_Questions[1]['Question'][52] = "In Northshire, what type of fruit is Millie's Harvest?"
TriviaBot_Questions[1]['Answers'][52] = {"grapes", "grape"}
TriviaBot_Questions[1]['Category'][52] = 2
TriviaBot_Questions[1]['Points'][52] = "1"
TriviaBot_Questions[1]['Hints'][52] = {}

TriviaBot_Questions[1]['Question'][53] = "What type of enemy apparently killed the two lost guards: Rolf and Malakai?"
TriviaBot_Questions[1]['Answers'][53] = {"murloc", "murlocs"}
TriviaBot_Questions[1]['Category'][53] = 2
TriviaBot_Questions[1]['Points'][53] = "1"
TriviaBot_Questions[1]['Hints'][53] = {}

TriviaBot_Questions[1]['Question'][54] = "Fill in the blank: The three lakes found in Elwynn are Crystal Lake, Stonecairn Lake, and ______?"
TriviaBot_Questions[1]['Answers'][54] = {"Mirror", "Mirror lake"}
TriviaBot_Questions[1]['Category'][54] = 2
TriviaBot_Questions[1]['Points'][54] = "1"
TriviaBot_Questions[1]['Hints'][54] = {}

TriviaBot_Questions[1]['Question'][55] = "Which profession has a trainer inside the Tower of Azora?"
TriviaBot_Questions[1]['Answers'][55] = {"Enchanting"}
TriviaBot_Questions[1]['Category'][55] = 2
TriviaBot_Questions[1]['Points'][55] = "1"
TriviaBot_Questions[1]['Hints'][55] = {}

TriviaBot_Questions[1]['Question'][56] = "What is the name of the NPC who holds the title <Mage of Tower Azora>?"
TriviaBot_Questions[1]['Answers'][56] = {"Theocritus"}
TriviaBot_Questions[1]['Category'][56] = 2
TriviaBot_Questions[1]['Points'][56] = "1"
TriviaBot_Questions[1]['Hints'][56] = {}

TriviaBot_Questions[1]['Question'][57] = "Which of the following is NOT in elwynn forest: The Stonefield farmstead, The Macclure Vineyards, or Furlbrow's Pumpkin Patch?"
TriviaBot_Questions[1]['Answers'][57] = {"Furlbrow's Pumpkin Patch", "Furlbrow", "Furlbrow's"}
TriviaBot_Questions[1]['Category'][57] = 2
TriviaBot_Questions[1]['Points'][57] = "1"
TriviaBot_Questions[1]['Hints'][57] = {}

TriviaBot_Questions[1]['Question'][58] = "Inside the Westbrook Garrison, there is an NPC selling refreshing drinks and alcohol.  Which of these is his title: Booze Baron, Refreshment Sergeant, Morale Officer, or Tactical Tipple?"
TriviaBot_Questions[1]['Answers'][58] = {"Morale Officer"}
TriviaBot_Questions[1]['Category'][58] = 2
TriviaBot_Questions[1]['Points'][58] = "1"
TriviaBot_Questions[1]['Hints'][58] = {}

TriviaBot_Questions[1]['Question'][59] = "A powerful item which is used by guilds in late game raids is a reward for collecting Gold Dust for Ramy 'Two Times.'  What is the name of the item?"
TriviaBot_Questions[1]['Answers'][59] = {"Bag of Marbles"}
TriviaBot_Questions[1]['Category'][59] = 2
TriviaBot_Questions[1]['Points'][59] = "1"
TriviaBot_Questions[1]['Hints'][59] = {}

TriviaBot_Questions[1]['Question'][60] = "What item do you turn in as proof that you have slain Hogger: Hogger's Head, Hogger's Nose Ring, Huge Gnoll Claw, or Mangy Paw?"
TriviaBot_Questions[1]['Answers'][60] = {"Huge Gnoll Claw"}
TriviaBot_Questions[1]['Category'][60] = 2
TriviaBot_Questions[1]['Points'][60] = "1"
TriviaBot_Questions[1]['Hints'][60] = {}

TriviaBot_Questions[1]['Question'][61] = "What is the name of the river which separates Elwynn Forest and Duskwood?"
TriviaBot_Questions[1]['Answers'][61] = {"The Nazferiti River", "Nazferiti"}
TriviaBot_Questions[1]['Category'][61] = 2
TriviaBot_Questions[1]['Points'][61] = "1"
TriviaBot_Questions[1]['Hints'][61] = {}

TriviaBot_Questions[1]['Question'][61] = "What is the name of the Rare spider which can spawn in the Jasperlode Mine?"
TriviaBot_Questions[1]['Answers'][61] = {"Mother Fang"}
TriviaBot_Questions[1]['Category'][61] = 2
TriviaBot_Questions[1]['Points'][61] = "1"
TriviaBot_Questions[1]['Hints'][61] = {}

TriviaBot_Questions[1]['Question'][62] = "What is the name of the Rare kobold which can spawn in the fargodeep?"
TriviaBot_Questions[1]['Answers'][62] = {"Narg the Taskmaster", "Narg"}
TriviaBot_Questions[1]['Category'][62] = 2
TriviaBot_Questions[1]['Points'][62] = "1"
TriviaBot_Questions[1]['Hints'][62] = {}

TriviaBot_Questions[1]['Question'][63] = "When entering Stormwind on foot from Elwynn forest, what is the first named area of Stormwind you enter?"
TriviaBot_Questions[1]['Answers'][63] = {"The Valley of Heroes", "Valley of Heroes"}
TriviaBot_Questions[1]['Category'][63] = 2
TriviaBot_Questions[1]['Points'][63] = "1"
TriviaBot_Questions[1]['Hints'][63] = {}

TriviaBot_Questions[1]['Question'][64] = "Who holds the title <Master of Cheese> in Stormwind?"
TriviaBot_Questions[1]['Answers'][64] = {"Elling Trias"}
TriviaBot_Questions[1]['Category'][64] = 2
TriviaBot_Questions[1]['Points'][64] = "1"
TriviaBot_Questions[1]['Hints'][64] = {}

TriviaBot_Questions[1]['Question'][65] = "What is the most expensive cheese that you can buy from Elaine Trias <Mistress of Cheese> in Stormwind?"
TriviaBot_Questions[1]['Answers'][65] = {"Alterac Swiss"}
TriviaBot_Questions[1]['Category'][65] = 2
TriviaBot_Questions[1]['Points'][65] = "1"
TriviaBot_Questions[1]['Hints'][65] = {}

TriviaBot_Questions[1]['Question'][66] = "Just outside of Eastvale Logging Camp, there is a former military leader of the Stormwind guard enjoying retirement.  What is his name?"
TriviaBot_Questions[1]['Answers'][66] = {"Marshall Haggard"}
TriviaBot_Questions[1]['Category'][66] = 2
TriviaBot_Questions[1]['Points'][66] = "1"
TriviaBot_Questions[1]['Hints'][66] = {}

TriviaBot_Questions[1]['Question'][67] = "What NPC disguised themself as Marshall Dughan by wearing a Stormwind tabard and tricked Marshall Haggard into giving him his old Stormwind Marshall's badge?"
TriviaBot_Questions[1]['Answers'][67] = {"Dead-Tooth Jack", "Deadtooth Jack", "dead tooth jack"}
TriviaBot_Questions[1]['Category'][67] = 2
TriviaBot_Questions[1]['Points'][67] = "1"
TriviaBot_Questions[1]['Hints'][67] = {"He can be found southeast of Eastvale Logging Camp."}

TriviaBot_Questions[1]['Question'][68] = "Undercity is located in the ruins of which fallen kingdom?"
TriviaBot_Questions[1]['Answers'][68] = {"Lordaeron"}
TriviaBot_Questions[1]['Category'][68] = 3
TriviaBot_Questions[1]['Points'][68] = "1"
TriviaBot_Questions[1]['Hints'][68] = {}

TriviaBot_Questions[1]['Question'][69] = "What is the racial enemy of Tauren?"
TriviaBot_Questions[1]['Answers'][69] = {"Centaur", "marauding centaur"}
TriviaBot_Questions[1]['Category'][69] = 3
TriviaBot_Questions[1]['Points'][69] = "1"
TriviaBot_Questions[1]['Hints'][69] = {}

TriviaBot_Questions[1]['Question'][70] = "What is sub-zone of Orgrimmar in which Ragefire Chasm is located called?"
TriviaBot_Questions[1]['Answers'][70] = {"Cleft of Shadow"}
TriviaBot_Questions[1]['Category'][70] = 3
TriviaBot_Questions[1]['Points'][70] = "1"
TriviaBot_Questions[1]['Hints'][70] = {}

TriviaBot_Questions[1]['Question'][71] = "What does Lok'tar Ogar mean?"
TriviaBot_Questions[1]['Answers'][71] = {"Victory or death"}
TriviaBot_Questions[1]['Category'][71] = 3
TriviaBot_Questions[1]['Points'][71] = "1"
TriviaBot_Questions[1]['Hints'][71] = {}

TriviaBot_Questions[1]['Question'][72] = "What item is used on Lazy Peons to wake them when doing the quest Lazy Peons in the Valley of Trials?"
TriviaBot_Questions[1]['Answers'][72] = {"Foreman's Blackjack"}
TriviaBot_Questions[1]['Category'][72] = 3
TriviaBot_Questions[1]['Points'][72] = "1"
TriviaBot_Questions[1]['Hints'][72] = {}

TriviaBot_Questions[1]['Question'][73] = "Name the missing troll racial ability: Beast Slaying, Berserking, Bow Specialization, Regeneration, ________ ______________."
TriviaBot_Questions[1]['Answers'][73] = {"Throwing Specialization"}
TriviaBot_Questions[1]['Category'][73] = 3
TriviaBot_Questions[1]['Points'][73] = "1"
TriviaBot_Questions[1]['Hints'][73] = {}

TriviaBot_Questions[1]['Question'][74] = "Which tribe of trolls is the only one to have ever sworn loyalty to the Horde?"
TriviaBot_Questions[1]['Answers'][74] = {"darkspear", "The darkspear tribe", "darkspear tribe"}
TriviaBot_Questions[1]['Category'][74] = 3
TriviaBot_Questions[1]['Points'][74] = "1"
TriviaBot_Questions[1]['Hints'][74] = {}

TriviaBot_Questions[1]['Question'][75] = "Which tribe of trolls is the only one to have ever sworn loyalty to the Horde?"
TriviaBot_Questions[1]['Answers'][75] = {"darkspear", "The darkspear tribe", "darkspear tribe"}
TriviaBot_Questions[1]['Category'][75] = 3
TriviaBot_Questions[1]['Points'][75] = "1"
TriviaBot_Questions[1]['Hints'][75] = {}

TriviaBot_Questions[1]['Question'][76] = "Name a class which a Troll cannot be. (excluding paladin)"
TriviaBot_Questions[1]['Answers'][76] = {"warlock", "druid"}
TriviaBot_Questions[1]['Category'][76] = 3
TriviaBot_Questions[1]['Points'][76] = "1"
TriviaBot_Questions[1]['Hints'][76] = {}

TriviaBot_Questions[1]['Question'][77] = "What is the name of the quest in which Makrik asks you locate his fallen wife's body?"
TriviaBot_Questions[1]['Answers'][77] = {"lost in battle"}
TriviaBot_Questions[1]['Category'][77] = 3
TriviaBot_Questions[1]['Points'][77] = "1"
TriviaBot_Questions[1]['Hints'][77] = {}

TriviaBot_Questions[1]['Question'][78] = "Each race of priest gets two unique racial abilities: What are troll's unique priest racial abilities?"
TriviaBot_Questions[1]['Answers'][78] = {"hex of weakness and shadowguard", "shadowguard and hex of weakness"}
TriviaBot_Questions[1]['Category'][78] = 3
TriviaBot_Questions[1]['Points'][78] = "1"
TriviaBot_Questions[1]['Hints'][78] = {}

TriviaBot_Questions[1]['Question'][79] = "A quest called \"For The Horde!\" is part of the attunement questline to gain entrance to what zone?"
TriviaBot_Questions[1]['Answers'][79] = {"Onyxia's Lair"}
TriviaBot_Questions[1]['Category'][79] = 3
TriviaBot_Questions[1]['Points'][79] = "1"
TriviaBot_Questions[1]['Hints'][79] = {}

TriviaBot_Questions[1]['Question'][80] = "What is the name of the forsaken starting area, located in tirisfal glades?"
TriviaBot_Questions[1]['Answers'][80] = {"deathknell"}
TriviaBot_Questions[1]['Category'][80] = 3
TriviaBot_Questions[1]['Points'][80] = "1"
TriviaBot_Questions[1]['Hints'][80] = {}

TriviaBot_Questions[1]['Question'][81] = "What is the name of the quest which triggers the world buff \"Warchief's Blessing?\""
TriviaBot_Questions[1]['Answers'][81] = {"For the Horde!"}
TriviaBot_Questions[1]['Category'][81] = 3
TriviaBot_Questions[1]['Points'][81] = "1"
TriviaBot_Questions[1]['Hints'][81] = {"It has an exclamation mark in it."}

TriviaBot_Questions[1]['Question'][82] = "What is the name of the camp in Stranglethorn vale which has a zeppelin tower? (full official name)"
TriviaBot_Questions[1]['Answers'][82] = {"Grom'gol Base Camp"}
TriviaBot_Questions[1]['Category'][82] = 3
TriviaBot_Questions[1]['Points'][82] = "1"
TriviaBot_Questions[1]['Hints'][82] = {}

TriviaBot_Questions[1]['Question'][83] = "What other boss level NPC is located in the Royal Quarter alongside Sylvanas Windrunner <Banshee Queen>?"
TriviaBot_Questions[1]['Answers'][83] = {"Varimathras"}
TriviaBot_Questions[1]['Category'][83] = 3
TriviaBot_Questions[1]['Points'][83] = "1"
TriviaBot_Questions[1]['Hints'][83] = {}

TriviaBot_Questions[1]['Question'][84] = "During the rogue quest Plundering the Plunderers, a hostile elite parrot spawns after looting the quest item.  What is it's name?"
TriviaBot_Questions[1]['Answers'][84] = {"Polly"}
TriviaBot_Questions[1]['Category'][84] = 3
TriviaBot_Questions[1]['Points'][84] = "1"
TriviaBot_Questions[1]['Hints'][84] = {}

TriviaBot_Questions[1]['Question'][85] = "What is the name of the river that separates Durotar from The Barrens?"
TriviaBot_Questions[1]['Answers'][85] = {"Southfury River", "The Southfury River"}
TriviaBot_Questions[1]['Category'][85] = 3
TriviaBot_Questions[1]['Points'][85] = "1"
TriviaBot_Questions[1]['Hints'][85] = {}

TriviaBot_Questions[1]['Question'][86] = "How many flight masters are located in The Barrens?"
TriviaBot_Questions[1]['Answers'][86] = {"3", "Three"}
TriviaBot_Questions[1]['Category'][86] = 3
TriviaBot_Questions[1]['Points'][86] = "1"
TriviaBot_Questions[1]['Hints'][86] = {}

TriviaBot_Questions[1]['Question'][87] = "What are the four elite alliance NPCs that patrol the barrens collectively known as?"
TriviaBot_Questions[1]['Answers'][87] = {"Alliance Outrunners", "The Alliance Outrunners"}
TriviaBot_Questions[1]['Category'][87] = 3
TriviaBot_Questions[1]['Points'][87] = "1"
TriviaBot_Questions[1]['Hints'][87] = {}

TriviaBot_Questions[1]['Question'][88] = "Name the quest in thousand needles which asks the player to leap from a plateau at a deadly height"
TriviaBot_Questions[1]['Answers'][88] = {"Test of Faith"}
TriviaBot_Questions[1]['Category'][88] = 3
TriviaBot_Questions[1]['Points'][88] = "1"
TriviaBot_Questions[1]['Hints'][88] = {}

TriviaBot_Questions[1]['Question'][89] = "What is the name of the boat which travels between Ratchet and Booty Bay?"
TriviaBot_Questions[1]['Answers'][89] = {"The Maiden's Fancy", "Maiden's Fancy"}
TriviaBot_Questions[1]['Category'][89] = 3
TriviaBot_Questions[1]['Points'][89] = "1"
TriviaBot_Questions[1]['Hints'][89] = {}

TriviaBot_Questions[1]['Question'][90] = "The quest \"Snapjaw's Mon!\" provides a horde only boon for which profession?"
TriviaBot_Questions[1]['Answers'][90] = {"fishing"}
TriviaBot_Questions[1]['Category'][90] = 3
TriviaBot_Questions[1]['Points'][90] = "1"
TriviaBot_Questions[1]['Hints'][90] = {}

TriviaBot_Questions[1]['Question'][91] = "The rank 11 PvP title for Alliance is Commander.  What is the rank 11 Horde PvP title?"
TriviaBot_Questions[1]['Answers'][91] = {"Lieutenant General", "Lt. General"}
TriviaBot_Questions[1]['Category'][91] = 3
TriviaBot_Questions[1]['Points'][91] = "1"
TriviaBot_Questions[1]['Hints'][91] = {}

TriviaBot_Questions[1]['Question'][92] = "What is the highest Horde PvP rank's title?"
TriviaBot_Questions[1]['Answers'][92] = {"High Warlord"}
TriviaBot_Questions[1]['Category'][92] = 3
TriviaBot_Questions[1]['Points'][92] = "1"
TriviaBot_Questions[1]['Hints'][92] = {}

TriviaBot_Questions[1]['Question'][92] = "In the pvp battleground Arathi Basic, which location is furthest from the Horde starting location?"
TriviaBot_Questions[1]['Answers'][92] = {"Stables"}
TriviaBot_Questions[1]['Category'][92] = 3
TriviaBot_Questions[1]['Points'][92] = "1"
TriviaBot_Questions[1]['Hints'][92] = {}

TriviaBot_Questions[1]['Question'][93] = "Zoram’gar Outpost is a small but key Horde base in which contested zone?"
TriviaBot_Questions[1]['Answers'][93] = {"Ashenvale"}
TriviaBot_Questions[1]['Category'][93] = 3
TriviaBot_Questions[1]['Points'][93] = "1"
TriviaBot_Questions[1]['Hints'][93] = {}

TriviaBot_Questions[1]['Question'][94] = "Thunder Bluff, the capital city of the Tauren, is perched atop how many major connected mesas in Mulgore?"
TriviaBot_Questions[1]['Answers'][94] = {"4", "Four"}
TriviaBot_Questions[1]['Category'][94] = 3
TriviaBot_Questions[1]['Points'][94] = "1"
TriviaBot_Questions[1]['Hints'][94] = {}

TriviaBot_Questions[1]['Question'][95] = "The Wailing Caverns instance in the Northern Barrens features a quest to help awaken a druid from a twisted dream. Name that druid."
TriviaBot_Questions[1]['Answers'][95] = {"Naralex"}
TriviaBot_Questions[1]['Category'][95] = 3
TriviaBot_Questions[1]['Points'][95] = "1"
TriviaBot_Questions[1]['Hints'][95] = {}

TriviaBot_Questions[1]['Question'][96] = "Which cultist group can be found in Skull Rock?"
TriviaBot_Questions[1]['Answers'][96] = {"The Burning Blade cultists", "Burning Blade", "Burning blade cultists", "The burning blade"}
TriviaBot_Questions[1]['Category'][96] = 3
TriviaBot_Questions[1]['Points'][96] = "1"
TriviaBot_Questions[1]['Hints'][96] = {}

TriviaBot_Questions[1]['Question'][97] = "In Thousand Needles, which tribe of hostile tauren does the Horde frequently battle as part of quest lines near Freewind Post?"
TriviaBot_Questions[1]['Answers'][97] = {"The Grimtotem tribe", "grimtotem", "grimtotem tribe"}
TriviaBot_Questions[1]['Category'][97] = 3
TriviaBot_Questions[1]['Points'][97] = "1"
TriviaBot_Questions[1]['Hints'][97] = {}

TriviaBot_Questions[1]['Question'][98] = "Forsaken are renowned for having a powerful ability that helped them break fear and other crowd-control effects. What is this signature active racial trait called?"
TriviaBot_Questions[1]['Answers'][98] = {"Will of the Forsaken"}
TriviaBot_Questions[1]['Category'][98] = 3
TriviaBot_Questions[1]['Points'][98] = "1"
TriviaBot_Questions[1]['Hints'][98] = {}

TriviaBot_Questions[1]['Question'][99] = "What is the name of the towering elevator which helps players transition between the Barrens and Thousand Needles?"
TriviaBot_Questions[1]['Answers'][99] = {"The Great Lift"}
TriviaBot_Questions[1]['Category'][99] = 3
TriviaBot_Questions[1]['Points'][99] = "1"
TriviaBot_Questions[1]['Hints'][99] = {}

TriviaBot_Questions[1]['Question'][100] = "How many creatures can Tauren's Warstomp ability potentially stun?"
TriviaBot_Questions[1]['Answers'][100] = {"5", "five"}
TriviaBot_Questions[1]['Category'][100] = 3
TriviaBot_Questions[1]['Points'][100] = "1"
TriviaBot_Questions[1]['Hints'][100] = {}

TriviaBot_Questions[1]['Question'][101] = "What is the name of the towering elevator which helps players transition between the Barrens and Thousand Needles?"
TriviaBot_Questions[1]['Answers'][101] = {"The Great Lift"}
TriviaBot_Questions[1]['Category'][101] = 3
TriviaBot_Questions[1]['Points'][101] = "1"
TriviaBot_Questions[1]['Hints'][101] = {}

TriviaBot_Questions[1]['Question'][101] = "What is the name of the quest which rewards Really Sticky Glue?"
TriviaBot_Questions[1]['Answers'][101] = {"A Solvent Spirit"}
TriviaBot_Questions[1]['Category'][101] = 3
TriviaBot_Questions[1]['Points'][101] = "1"
TriviaBot_Questions[1]['Hints'][101] = {}

TriviaBot_Questions[1]['Question'][102] = "Quote: \"You too shall serve\""
TriviaBot_Questions[1]['Answers'][102] = {"Archmage Arugal", "Arugal"}
TriviaBot_Questions[1]['Category'][102] = 3
TriviaBot_Questions[1]['Points'][102] = "1"
TriviaBot_Questions[1]['Hints'][102] = {}

TriviaBot_Questions[1]['Question'][103] = "How often will an orc warrior with 5 talent points put into [Iron Will] resist stuns?"
TriviaBot_Questions[1]['Answers'][103] = {"45", "Forty five", "45%", "Forty five Percent"}
TriviaBot_Questions[1]['Category'][103] = 3
TriviaBot_Questions[1]['Points'][103] = "1"
TriviaBot_Questions[1]['Hints'][103] = {}

TriviaBot_Questions[1]['Question'][104] = "This deadly level 12 goblin NPC can be found in Durotar surrounded by several Burning Blade cultists and an imp.  To reach him, you must pass through Thunder Lizard Gulch (or jump down a great distance)."
TriviaBot_Questions[1]['Answers'][104] = {"Fizzle Darkstorm"}
TriviaBot_Questions[1]['Category'][104] = 3
TriviaBot_Questions[1]['Points'][104] = "1"
TriviaBot_Questions[1]['Hints'][104] = {}

TriviaBot_Questions[1]['Question'][105] = "This deadly quest in Stonetalon Peaks asks the player to defend Piznik while he mines \"gold-green ore.\"  What is the name of the quest?"
TriviaBot_Questions[1]['Answers'][105] = {"Gerenzo's Orders"}
TriviaBot_Questions[1]['Category'][105] = 3
TriviaBot_Questions[1]['Points'][105] = "1"
TriviaBot_Questions[1]['Hints'][105] = {}

TriviaBot_Questions[1]['Question'][106] = "Which zone is home to Lake Everstill?"
TriviaBot_Questions[1]['Answers'][106] = {"Redridge Mountains", "Redridge"}
TriviaBot_Questions[1]['Category'][106] = 2
TriviaBot_Questions[1]['Points'][106] = "1"
TriviaBot_Questions[1]['Hints'][106] = {}

TriviaBot_Questions[1]['Question'][107] = "Which dwarven clan is primarily based in Ironforge?"
TriviaBot_Questions[1]['Answers'][107] = {"Bronzebeard", "The Bronzebeard Clan", "Bronzebeard Clan"}
TriviaBot_Questions[1]['Category'][107] = 2
TriviaBot_Questions[1]['Points'][107] = "1"
TriviaBot_Questions[1]['Hints'][107] = {}

TriviaBot_Questions[1]['Question'][108] = "Which dwarven clan can be found at Aerie Peak?"
TriviaBot_Questions[1]['Answers'][108] = {"Wildhammer", "The Wildhammer Clan", "Wildhammer Clan"}
TriviaBot_Questions[1]['Category'][108] = 2
TriviaBot_Questions[1]['Points'][108] = "1"
TriviaBot_Questions[1]['Hints'][108] = {}

TriviaBot_Questions[1]['Question'][109] = "True of False: The Wildhammer Clan is not officially part of the Alliance."
TriviaBot_Questions[1]['Answers'][109] = {"True"}
TriviaBot_Questions[1]['Category'][109] = 2
TriviaBot_Questions[1]['Points'][109] = "1"
TriviaBot_Questions[1]['Hints'][109] = {}

TriviaBot_Questions[1]['Question'][110] = "In which zone is the conclusion to the Missing Diplomat Questline?"
TriviaBot_Questions[1]['Answers'][110] = {"Dustwallow Marsh"}
TriviaBot_Questions[1]['Category'][110] = 2
TriviaBot_Questions[1]['Points'][110] = "1"
TriviaBot_Questions[1]['Hints'][110] = {}

TriviaBot_Questions[1]['Question'][111] = "Onyxia is famously disguised as which NPC in Stormwind?"
TriviaBot_Questions[1]['Answers'][111] = {"Lady Katrana Prestor"}
TriviaBot_Questions[1]['Category'][111] = 2
TriviaBot_Questions[1]['Points'][111] = "1"
TriviaBot_Questions[1]['Hints'][111] = {}

TriviaBot_Questions[1]['Question'][112] = "What is the name quest which finally reveals Onyxia's deception in Stormwind?"
TriviaBot_Questions[1]['Answers'][112] = {"The Great Masquerade"}
TriviaBot_Questions[1]['Category'][112] = 2
TriviaBot_Questions[1]['Points'][112] = "1"
TriviaBot_Questions[1]['Hints'][112] = {}

TriviaBot_Questions[1]['Question'][113] = "What Alliance-aligned group battles against the Frostwolf clan in Alterac Valley?"
TriviaBot_Questions[1]['Answers'][113] = {"The Stormpike Guard", "Stormpike Guard"}
TriviaBot_Questions[1]['Category'][113] = 2
TriviaBot_Questions[1]['Points'][113] = "1"
TriviaBot_Questions[1]['Hints'][113] = {}

TriviaBot_Questions[1]['Question'][114] = "What is the name of the quest that Alliance players must complete in Theramore in order to progress First Aid beyond level 225?"
TriviaBot_Questions[1]['Answers'][114] = {"Triage"}
TriviaBot_Questions[1]['Category'][114] = 2
TriviaBot_Questions[1]['Points'][114] = "1"
TriviaBot_Questions[1]['Hints'][114] = {}

TriviaBot_Questions[1]['Question'][115] = "Which sprawling quest chain known revolves around investigating the disappearance of the King of Stormwind?"
TriviaBot_Questions[1]['Answers'][115] = {"The Missing Diplomat"}
TriviaBot_Questions[1]['Category'][115] = 2
TriviaBot_Questions[1]['Points'][115] = "1"
TriviaBot_Questions[1]['Hints'][115] = {}

TriviaBot_Questions[1]['Question'][116] = "Rackmore's Treasure can be found in which zone?"
TriviaBot_Questions[1]['Answers'][116] = {"Desolace"}
TriviaBot_Questions[1]['Category'][116] = 2
TriviaBot_Questions[1]['Points'][116] = "1"
TriviaBot_Questions[1]['Hints'][116] = {}

TriviaBot_Questions[1]['Question'][117] = "In which zone is the final quest of Cortello's Riddle completed?"
TriviaBot_Questions[1]['Answers'][117] = {"The Hinterlands", "Hinterlands"}
TriviaBot_Questions[1]['Category'][117] = 2
TriviaBot_Questions[1]['Points'][117] = "1"
TriviaBot_Questions[1]['Hints'][117] = {}

TriviaBot_Questions[1]['Question'][118] = "What is the name of the Inn/Tavern located in Brill?"
TriviaBot_Questions[1]['Answers'][118] = {"Gallow's End Tavern", "Gallow's End"}
TriviaBot_Questions[1]['Category'][118] = 3
TriviaBot_Questions[1]['Points'][118] = "1"
TriviaBot_Questions[1]['Hints'][118] = {}

TriviaBot_Questions[1]['Question'][119] = "This server (Doomhowl) is named after a boss located in which dungeon or raid?"
TriviaBot_Questions[1]['Answers'][119] = {"Blackrock Spire", "lbrs", "Lower blackrock spire"}
TriviaBot_Questions[1]['Category'][119] = 3
TriviaBot_Questions[1]['Points'][119] = "1"
TriviaBot_Questions[1]['Hints'][119] = {}

TriviaBot_Questions[1]['Question'][120] = "Many mage quests can be found from which NPC in her hut in Duskwallow Marsh"
TriviaBot_Questions[1]['Answers'][120] = {"Tabetha"}
TriviaBot_Questions[1]['Category'][120] = 3
TriviaBot_Questions[1]['Points'][120] = "1"
TriviaBot_Questions[1]['Hints'][120] = {}

TriviaBot_Questions[1]['Question'][121] = "Orc NPC Quote: May your blades _____ ____?"
TriviaBot_Questions[1]['Answers'][121] = {"never dull"}
TriviaBot_Questions[1]['Category'][121] = 3
TriviaBot_Questions[1]['Points'][121] = "1"
TriviaBot_Questions[1]['Hints'][121] = {}

TriviaBot_Questions[1]['Question'][122] = "The Deadmines entrance is located in what town in Westfall?"
TriviaBot_Questions[1]['Answers'][122] = {"Moonbrook"}
TriviaBot_Questions[1]['Category'][122] = 2
TriviaBot_Questions[1]['Points'][122] = "1"
TriviaBot_Questions[1]['Hints'][122] = {}

TriviaBot_Questions[1]['Question'][123] = "True or False: The onyxia buff drops on all layers."
TriviaBot_Questions[1]['Answers'][123] = {"True"}
TriviaBot_Questions[1]['Category'][123] = 2
TriviaBot_Questions[1]['Points'][123] = "1"
TriviaBot_Questions[1]['Hints'][123] = {}

TriviaBot_Questions[1]['Question'][124] = "An extremely deadly rare elite devilsaur roams the western side of Un'goro Crater.  What is his name?"
TriviaBot_Questions[1]['Answers'][124] = {"King Mosh"}
TriviaBot_Questions[1]['Category'][124] = 2
TriviaBot_Questions[1]['Points'][124] = "1"
TriviaBot_Questions[1]['Hints'][124] = {}

TriviaBot_Questions[1]['Question'][125] = "A neutral Auction House, run by goblins and available to both the Horde and the Alliance, can be found in Ratchet, Booty Bay, Gadgetzan and which other town?"
TriviaBot_Questions[1]['Answers'][125] = {"Everlook"}
TriviaBot_Questions[1]['Category'][125] = 1
TriviaBot_Questions[1]['Points'][125] = "1"
TriviaBot_Questions[1]['Hints'][125] = {}

TriviaBot_Questions[1]['Question'][126] = "What is the deadliest thing in Ragefire Chasm (by HC kill count)?"
TriviaBot_Questions[1]['Answers'][126] = {"Lava"}
TriviaBot_Questions[1]['Category'][126] = 1
TriviaBot_Questions[1]['Points'][126] = "1"
TriviaBot_Questions[1]['Hints'][126] = {}

TriviaBot_Questions[1]['Question'][127] = "Who is the Warchief of the \"Dark Horde?\""
TriviaBot_Questions[1]['Answers'][127] = {"Rend Blackhand", "Dal'rend Blackhand", "Warchief Rend Blackhand", "Rend"}
TriviaBot_Questions[1]['Category'][127] = 1
TriviaBot_Questions[1]['Points'][127] = "1"
TriviaBot_Questions[1]['Hints'][127] = {}

TriviaBot_Questions[1]['Question'][128] = "Who was the last guardian of Tirasfal?"
TriviaBot_Questions[1]['Answers'][128] = {"Medivh", "Magus Medivh"}
TriviaBot_Questions[1]['Category'][128] = 4
TriviaBot_Questions[1]['Points'][128] = "1"
TriviaBot_Questions[1]['Hints'][128] = {}

TriviaBot_Questions[1]['Question'][129] = "Which blood god are the trolls in Zul'Gurub attempting to resurrect?"
TriviaBot_Questions[1]['Answers'][129] = {"Hakkar", "Hakkar the Soulflayer", "Hakkar, the Soulflayer"}
TriviaBot_Questions[1]['Category'][129] = 4
TriviaBot_Questions[1]['Points'][129] = "1"
TriviaBot_Questions[1]['Hints'][129] = {}

TriviaBot_Questions[1]['Question'][130] = "Who originally wielding Ashbringer?"
TriviaBot_Questions[1]['Answers'][130] = {"Alexandros Mograine", "Mograine", "Scarlet Highlord Mograine", "Highlord Mograine", "Highlord Alexandros Mograine"}
TriviaBot_Questions[1]['Category'][130] = 4
TriviaBot_Questions[1]['Points'][130] = "1"
TriviaBot_Questions[1]['Hints'][130] = {}

TriviaBot_Questions[1]['Question'][131] = "Name the fictional legendary sword used in a South Park episode to defeat an unspeakably powerful Alliance griefer."
TriviaBot_Questions[1]['Answers'][131] = {"The Sword of a Thousand Truths", "Sword of a Thousand Truths"}
TriviaBot_Questions[1]['Category'][131] = 4
TriviaBot_Questions[1]['Points'][131] = "1"
TriviaBot_Questions[1]['Hints'][131] = {}

TriviaBot_Questions[1]['Question'][132] = "During the War of Three Hammers, Emperor Thaurissan sought to overpower the other dwarf clans by invoking a ritual.  This ritual inadvertently summoned what being?"
TriviaBot_Questions[1]['Answers'][132] = {"Ragnaros", "Ragnaros, The Firelord"}
TriviaBot_Questions[1]['Category'][132] = 4
TriviaBot_Questions[1]['Points'][132] = "1"
TriviaBot_Questions[1]['Hints'][132] = {}

TriviaBot_Questions[1]['Question'][133] = "Which Dalaran archmage, desperate for a weapon against the Scourge, inadvertantly unleashed worgen into Azeroth?"
TriviaBot_Questions[1]['Answers'][133] = {"Arugal", "Archmage Arugal"}
TriviaBot_Questions[1]['Category'][133] = 4
TriviaBot_Questions[1]['Points'][133] = "1"
TriviaBot_Questions[1]['Hints'][133] = {}

TriviaBot_Questions[1]['Question'][134] = "What percentage of it's normal damage does a hunter's pet do when it is unhappy?"
TriviaBot_Questions[1]['Answers'][134] = {"75", "75%", "seventy-five", "seventy-five percent", "seventy five"}
TriviaBot_Questions[1]['Category'][134] = 4
TriviaBot_Questions[1]['Points'][134] = "1"
TriviaBot_Questions[1]['Hints'][134] = {}

TriviaBot_Questions[1]['Question'][135] = "The Twilight Grove in Duskwood is said to contain a portal to where?"
TriviaBot_Questions[1]['Answers'][135] = {"The Emerald Dream", "Emerald Dream"}
TriviaBot_Questions[1]['Category'][135] = 4
TriviaBot_Questions[1]['Points'][135] = "1"
TriviaBot_Questions[1]['Hints'][135] = {}

TriviaBot_Questions[1]['Question'][136] = "Caer Darrow, Brill, Southshore, and Tarren Mill previously belonged to which noble family?"
TriviaBot_Questions[1]['Answers'][136] = {"Barov", "The Barov Family", "The Barovs"}
TriviaBot_Questions[1]['Category'][136] = 4
TriviaBot_Questions[1]['Points'][136] = "1"
TriviaBot_Questions[1]['Hints'][136] = {}

TriviaBot_Questions[1]['Question'][137] = "High Tinker Mekkatorque sanctioned the use of radiation in a desparate attempt to drive out what race of invader of Gnomeregan?"
TriviaBot_Questions[1]['Answers'][137] = {"Trogg", "Troggs", "the troggs"}
TriviaBot_Questions[1]['Category'][137] = 4
TriviaBot_Questions[1]['Points'][137] = "1"
TriviaBot_Questions[1]['Hints'][137] = {}

TriviaBot_Questions[1]['Question'][138] = "Which faction in Classic WoW must you be exalted with to acquire the Winterspring Frostsaber mount?"
TriviaBot_Questions[1]['Answers'][138] = {"Wintersaber Trainers"}
TriviaBot_Questions[1]['Category'][138] = 4
TriviaBot_Questions[1]['Points'][138] = "1"
TriviaBot_Questions[1]['Hints'][138] = {}

TriviaBot_Questions[1]['Question'][139] = "Which organization is dedicated to combating the scourge in the Plaguelands?"
TriviaBot_Questions[1]['Answers'][139] = {"The Argent Dawn", "Argent Dawn"}
TriviaBot_Questions[1]['Category'][139] = 4
TriviaBot_Questions[1]['Points'][139] = "1"
TriviaBot_Questions[1]['Hints'][139] = {}

TriviaBot_Questions[1]['Question'][140] = "Which epic weapon is the reward of the quest chain involving the book 'Foror's Compendium of Dragon Slaying?'"
TriviaBot_Questions[1]['Answers'][140] = {"Quel'Serrar"}
TriviaBot_Questions[1]['Category'][140] = 4
TriviaBot_Questions[1]['Points'][140] = "1"
TriviaBot_Questions[1]['Hints'][140] = {}

TriviaBot_Questions[1]['Question'][141] = "Which troll tribe primarily inhabits Zul'Gurub?"
TriviaBot_Questions[1]['Answers'][141] = {"Gurubashi"}
TriviaBot_Questions[1]['Category'][141] = 4
TriviaBot_Questions[1]['Points'][141] = "1"
TriviaBot_Questions[1]['Hints'][141] = {}

TriviaBot_Questions[1]['Question'][142] = "How many resource points are needed to win an Arathi Basin match in Classic WoW?"
TriviaBot_Questions[1]['Answers'][142] = {"2000"}
TriviaBot_Questions[1]['Category'][142] = 4
TriviaBot_Questions[1]['Points'][142] = "1"
TriviaBot_Questions[1]['Hints'][142] = {}

TriviaBot_Questions[1]['Question'][143] = "Then-Archmage Kel'Thuzad created an organization of living beings who serve the Lich King?  What is it's name?"
TriviaBot_Questions[1]['Answers'][143] = {"Cult of the Damned", "The cult of the damned"}
TriviaBot_Questions[1]['Category'][143] = 4
TriviaBot_Questions[1]['Points'][143] = "1"
TriviaBot_Questions[1]['Hints'][143] = {"It's a cult"}

TriviaBot_Questions[1]['Question'][144] = "Which black dragon disguised herself as Lady Katrana Prestor to manipulate Stormwind's politics from within?"
TriviaBot_Questions[1]['Answers'][144] = {"Onyxia"}
TriviaBot_Questions[1]['Category'][144] = 4
TriviaBot_Questions[1]['Points'][144] = "1"
TriviaBot_Questions[1]['Hints'][144] = {}

TriviaBot_Questions[1]['Question'][145] = "Name one of the four corrupted Green Dragons that served as world bosses in Classic WoW, alongside Emeriss, Lethon, and Taerar."
TriviaBot_Questions[1]['Answers'][145] = {"Ysondre"}
TriviaBot_Questions[1]['Category'][145] = 4
TriviaBot_Questions[1]['Points'][145] = "1"
TriviaBot_Questions[1]['Hints'][145] = {}

TriviaBot_Questions[1]['Question'][146] = "Which legendary item can be crafted from sulfuron ingots and a rare drop in Molten Core?"
TriviaBot_Questions[1]['Answers'][146] = {"Sulfuras, Hand of Ragnaros", "Sulfuras"}
TriviaBot_Questions[1]['Category'][146] = 4
TriviaBot_Questions[1]['Points'][146] = "1"
TriviaBot_Questions[1]['Hints'][146] = {}

TriviaBot_Questions[1]['Question'][147] = "Who is the infamous necromancer presiding over Scholomance, serving as the final boss of the instance? (full npc name)"
TriviaBot_Questions[1]['Answers'][147] = {"Darkmaster Gandling"}
TriviaBot_Questions[1]['Category'][147] = 4
TriviaBot_Questions[1]['Points'][147] = "1"
TriviaBot_Questions[1]['Hints'][147] = {}

TriviaBot_Questions[1]['Question'][148] = "Name the ability: \"Gather information about the target beast.  The tooltip will display damage, health, armor, any special resistances, and diet.\""
TriviaBot_Questions[1]['Answers'][148] = {"Beast Lore"}
TriviaBot_Questions[1]['Category'][148] = 4
TriviaBot_Questions[1]['Points'][148] = "1"
TriviaBot_Questions[1]['Hints'][148] = {}

TriviaBot_Questions[1]['Question'][149] = "What is the highest rank of a hunter pet's loyalty?"
TriviaBot_Questions[1]['Answers'][149] = {"Best Friend"}
TriviaBot_Questions[1]['Category'][149] = 4
TriviaBot_Questions[1]['Points'][149] = "1"
TriviaBot_Questions[1]['Hints'][149] = {}

TriviaBot_Questions[1]['Question'][150] = "Name the weapon: \"Whomsoever takes up this blade shall wield power eternal. Just as the blade rends flesh, so must power scar the spirit.\""
TriviaBot_Questions[1]['Answers'][150] = {"Frostmourne"}
TriviaBot_Questions[1]['Category'][150] = 4
TriviaBot_Questions[1]['Points'][150] = "1"
TriviaBot_Questions[1]['Hints'][150] = {}

TriviaBot_Questions[1]['Question'][151] = "What is the name of the weapon, located in gnomeregan, is commonly farmed by Feral Druids?"
TriviaBot_Questions[1]['Answers'][151] = {"Manual Crowd Pummeler"}
TriviaBot_Questions[1]['Category'][151] = 4
TriviaBot_Questions[1]['Points'][151] = "1"
TriviaBot_Questions[1]['Hints'][151] = {}

TriviaBot_Questions[1]['Question'][152] = "In Classic WoW, what is the name of the corrupted Ashbringer wielder, whom Arthas transformed into a death knight?"
TriviaBot_Questions[1]['Answers'][152] = {"Highlord Mograine", "Alexandros Mograine", "Highlore Mograine <The Ashbringer>", "Highlore Mograine<The Ashbringer>"}
TriviaBot_Questions[1]['Category'][152] = 4
TriviaBot_Questions[1]['Points'][152] = "1"
TriviaBot_Questions[1]['Hints'][152] = {}

TriviaBot_Questions[1]['Question'][153] = "Which city did Arthas purge to prevent its citizens from turning into undead?"
TriviaBot_Questions[1]['Answers'][153] = {"Stratholme"}
TriviaBot_Questions[1]['Category'][153] = 4
TriviaBot_Questions[1]['Points'][153] = "1"
TriviaBot_Questions[1]['Hints'][153] = {}

TriviaBot_Questions[1]['Question'][154] = "In the Blasted Lands, what is the rarest type of crystal that can be turned in to Kum'isha the Collector for rare or even epic rewards?"
TriviaBot_Questions[1]['Answers'][154] = {"Flawless Draenethyst Sphere", "Flawless Draenethyst"}
TriviaBot_Questions[1]['Category'][154] = 4
TriviaBot_Questions[1]['Points'][154] = "1"
TriviaBot_Questions[1]['Hints'][154] = {"The crystal is a sphere."}

TriviaBot_Questions[1]['Question'][155] = "The upper class of which ogre clan can be found in Dire Maul?"
TriviaBot_Questions[1]['Answers'][155] = {"Gordunni", "The Gordunni"}
TriviaBot_Questions[1]['Category'][155] = 4
TriviaBot_Questions[1]['Points'][155] = "1"
TriviaBot_Questions[1]['Hints'][155] = {"The crystal is a sphere."}

TriviaBot_Questions[1]['Question'][156] = "Which dungeon was originally a sacred burial site for the centaur and the tomb of Zaetar, son of Cenarius?"
TriviaBot_Questions[1]['Answers'][156] = {"Maraudon"}
TriviaBot_Questions[1]['Category'][156] = 4
TriviaBot_Questions[1]['Points'][156] = "1"
TriviaBot_Questions[1]['Hints'][156] = {}

TriviaBot_Questions[1]['Question'][157] = "What is the name of the epic fire resistance cape crafted specifically for Blackwing Lair?"
TriviaBot_Questions[1]['Answers'][157] = {"Onyxia Scale Cloak"}
TriviaBot_Questions[1]['Category'][157] = 4
TriviaBot_Questions[1]['Points'][157] = "1"
TriviaBot_Questions[1]['Hints'][157] = {}

TriviaBot_Questions[1]['Question'][158] = "Name any one Zepplin Master."
TriviaBot_Questions[1]['Answers'][158] = {"Hin Dinburg", "Snurk Bucksquick", "Frezza", "Zapetta", "Squibby Overspeck", "Nez'raz"}
TriviaBot_Questions[1]['Category'][158] = 3
TriviaBot_Questions[1]['Points'][158] = "1"
TriviaBot_Questions[1]['Hints'][158] = {}

TriviaBot_Questions[1]['Question'][159] = "In Hardcore WoW, which passive Holy Priest talent can only be triggered once?"
TriviaBot_Questions[1]['Answers'][159] = {"Spirit of Redemption"}
TriviaBot_Questions[1]['Category'][159] = 4
TriviaBot_Questions[1]['Points'][159] = "1"
TriviaBot_Questions[1]['Hints'][159] = {}

TriviaBot_Questions[1]['Question'][160] = "What is the name of the largest island in Silverpine Forest?"
TriviaBot_Questions[1]['Answers'][160] = {"Fenris Isle"}
TriviaBot_Questions[1]['Category'][160] = 3
TriviaBot_Questions[1]['Points'][160] = "1"
TriviaBot_Questions[1]['Hints'][160] = {}

TriviaBot_Questions[1]['Question'][161] = "What is the name of the collection of islands in Silverpine Forest?"
TriviaBot_Questions[1]['Answers'][161] = {"Dawning Isles", "The Dawning Isles"}
TriviaBot_Questions[1]['Category'][161] = 3
TriviaBot_Questions[1]['Points'][161] = "1"
TriviaBot_Questions[1]['Hints'][161] = {}

TriviaBot_Questions[1]['Question'][162] = "What is the name of the lake in Silverpine Forest?" 
TriviaBot_Questions[1]['Answers'][162] = {"Lake Lordamere", "Lordamere Lake", "Lordamere"}
TriviaBot_Questions[1]['Category'][162] = 3
TriviaBot_Questions[1]['Points'][162] = "1"
TriviaBot_Questions[1]['Hints'][162] = {}

TriviaBot_Questions[1]['Question'][163] = "The quest Assault on Fenris Isle asks horde characters to collect which NPC's head? (Full name)"
TriviaBot_Questions[1]['Answers'][163] = {"Thule Ravenclaw"}
TriviaBot_Questions[1]['Category'][163] = 3
TriviaBot_Questions[1]['Points'][163] = "1"
TriviaBot_Questions[1]['Hints'][163] = {}

TriviaBot_Questions[1]['Question'][164] = "What is the name of the Inn in Goldshire"
TriviaBot_Questions[1]['Answers'][164] = {"Lion's Pride Inn", "Lion's Pride"}
TriviaBot_Questions[1]['Category'][164] = 2
TriviaBot_Questions[1]['Points'][164] = "1"
TriviaBot_Questions[1]['Hints'][164] = {}

TriviaBot_Questions[1]['Question'][165] = "What tool is required to cast Windfury Totem?"
TriviaBot_Questions[1]['Answers'][165] = {"Air Totem"}
TriviaBot_Questions[1]['Category'][165] = 3
TriviaBot_Questions[1]['Points'][165] = "1"
TriviaBot_Questions[1]['Hints'][165] = {}

TriviaBot_Questions[1]['Question'][166] = "The Shrine of the Fallen Warrior is a memorial to Michel Koiter, a Blizzard employee who died during the development of World of Warcraft.  In which zone is it located?"
TriviaBot_Questions[1]['Answers'][166] = {"The Barrens", "Barrens"}
TriviaBot_Questions[1]['Category'][166] = 3
TriviaBot_Questions[1]['Points'][166] = "1"
TriviaBot_Questions[1]['Hints'][166] = {}

TriviaBot_Questions[1]['Question'][167] = "A notoriously deadly named Defias member resides in a house near FurlBrow's Pumpkin Patch.  what is his name? (full NPC name)"
TriviaBot_Questions[1]['Answers'][167] = {"Benny Blaanco"}
TriviaBot_Questions[1]['Category'][167] = 2
TriviaBot_Questions[1]['Points'][167] = "1"
TriviaBot_Questions[1]['Hints'][167] = {}

TriviaBot_Questions[1]['Question'][168] = "Name the item: Use: You turn to stone, protecting you from all physical attacks and spells for 1 min, but during that time you cannot attack, move or cast spells.  You can only have the effect of one flask at a time. (3 Sec Cooldown)"
TriviaBot_Questions[1]['Answers'][168] = {"Flask of Petrification"}
TriviaBot_Questions[1]['Category'][168] = 1
TriviaBot_Questions[1]['Points'][168] = "1"
TriviaBot_Questions[1]['Hints'][168] = {}

TriviaBot_Questions[1]['Question'][169] = "How much additional damage does Enchant 2H Weapon - Superior Impact (the highest level impact enchant) provide to a weapon?"
TriviaBot_Questions[1]['Answers'][169] = {"9", "+9"}
TriviaBot_Questions[1]['Category'][169] = 1
TriviaBot_Questions[1]['Points'][169] = "1"
TriviaBot_Questions[1]['Hints'][169] = {}

TriviaBot_Questions[1]['Question'][170] = "What consumable item, usable at level 45 and above, can be applied to a weapon to increase spell damage by up to 36 and increase spell crit by 1% for 30 minutes? (full name)"
TriviaBot_Questions[1]['Answers'][170] = {"Brilliant Wizard Oil"}
TriviaBot_Questions[1]['Category'][170] = 1
TriviaBot_Questions[1]['Points'][170] = "1"
TriviaBot_Questions[1]['Hints'][170] = {}

TriviaBot_Questions[1]['Question'][170] = "Before declaring you worthy of his company, Hemet Nesingwary tests your mastery at hunting panthers, tigers, and what other type of creature?"
TriviaBot_Questions[1]['Answers'][170] = {"raptor", "raptors"}
TriviaBot_Questions[1]['Category'][170] = 1
TriviaBot_Questions[1]['Points'][170] = "1"
TriviaBot_Questions[1]['Hints'][170] = {}

TriviaBot_Questions[1]['Question'][171] = "What is the name of the docked ship at Menethil Harbor?"
TriviaBot_Questions[1]['Answers'][171] = {"The Maiden's Virtue", "Maiden's Virtue"}
TriviaBot_Questions[1]['Category'][171] = 2
TriviaBot_Questions[1]['Points'][171] = "1"
TriviaBot_Questions[1]['Hints'][171] = {}

TriviaBot_Questions[1]['Question'][172] = "To which continent did arthas pursue Malganis. (Yes, this lore existed during Vanilla)"
TriviaBot_Questions[1]['Answers'][172] = {"Northrend"}
TriviaBot_Questions[1]['Category'][172] = 4
TriviaBot_Questions[1]['Points'][172] = "1"
TriviaBot_Questions[1]['Hints'][172] = {}

TriviaBot_Questions[1]['Question'][173] = "Whose skull did Illidan consume?"
TriviaBot_Questions[1]['Answers'][173] = {"Gul'dan"}
TriviaBot_Questions[1]['Category'][173] = 4
TriviaBot_Questions[1]['Points'][173] = "1"
TriviaBot_Questions[1]['Hints'][173] = {}

TriviaBot_Questions[1]['Question'][174] = "In Warcraft III: The Frozen Throne, which orc shaman's spirit did Arthas merge with to become the Lich King?"
TriviaBot_Questions[1]['Answers'][174] = {"Ner'zhul"}
TriviaBot_Questions[1]['Category'][174] = 4
TriviaBot_Questions[1]['Points'][174] = "1"
TriviaBot_Questions[1]['Hints'][174] = {}

TriviaBot_Questions[1]['Question'][175] = "How many seconds does it take to use a hearthstone?"
TriviaBot_Questions[1]['Answers'][175] = {"10", "ten"}
TriviaBot_Questions[1]['Category'][175] = 1
TriviaBot_Questions[1]['Points'][175] = "1"
TriviaBot_Questions[1]['Hints'][175] = {}

TriviaBot_Questions[1]['Question'][176] = "The quest [In the Name of the Light] has the player travel to which group of dungeons to kill four bosses?"
TriviaBot_Questions[1]['Answers'][176] = {"Scarlet Monastery", "The Scarlet Monastery"}
TriviaBot_Questions[1]['Category'][176] = 2
TriviaBot_Questions[1]['Points'][176] = "1"
TriviaBot_Questions[1]['Hints'][176] = {}

TriviaBot_Questions[1]['Question'][177] = "Excluding rare bosses, how many bosses are there in all of the Scarlet Monastery instances combined?"
TriviaBot_Questions[1]['Answers'][177] = {"8", "Eight"}
TriviaBot_Questions[1]['Category'][177] = 2
TriviaBot_Questions[1]['Points'][177] = "1"
TriviaBot_Questions[1]['Hints'][177] = {}

TriviaBot_Questions[1]['Question'][178] = "The Stone of Remembrance is a monument dedicated to all those who have fallen in the protection of Stormwind.  In what zone does it lie?"
TriviaBot_Questions[1]['Answers'][178] = {"Elwynn Forest", "Elwynn"}
TriviaBot_Questions[1]['Category'][178] = 2
TriviaBot_Questions[1]['Points'][178] = "1"
TriviaBot_Questions[1]['Hints'][178] = {}

TriviaBot_Questions[1]['Question'][179] = "After assisting Baros Alexston and exposing the Defias Brotherhood's conspiracy, what signet does the player receive as a token of royal gratitude?"
TriviaBot_Questions[1]['Answers'][179] = {"Seal of Wrynn"}
TriviaBot_Questions[1]['Category'][179] = 2
TriviaBot_Questions[1]['Points'][179] = "1"
TriviaBot_Questions[1]['Hints'][179] = {}

TriviaBot_Questions[1]['Question'][179] = "What type of item of sentimental value does Baros Alexston ask you to retrieve from his old farm in Westfall?"
TriviaBot_Questions[1]['Answers'][179] = {"Compass", "A Simple Compass"}
TriviaBot_Questions[1]['Category'][179] = 2
TriviaBot_Questions[1]['Points'][179] = "1"
TriviaBot_Questions[1]['Hints'][179] = {}

TriviaBot_Questions[1]['Question'][180] = "What potion increases your walking speed by 50% for 15 seconds?"
TriviaBot_Questions[1]['Answers'][180] = {"Swiftness", "Swiftness Potion"}
TriviaBot_Questions[1]['Category'][180] = 1
TriviaBot_Questions[1]['Points'][180] = "1" 
TriviaBot_Questions[1]['Hints'][180] = {}

TriviaBot_Questions[1]['Question'][181] = "What is the name of the Alliance only quest reward which grants immunity to all damage and spells for 10 seconds?"
TriviaBot_Questions[1]['Answers'][181] = {"Light of Elune"}
TriviaBot_Questions[1]['Category'][181] = 2
TriviaBot_Questions[1]['Points'][181] = "1"
TriviaBot_Questions[1]['Hints'][181] = {}

TriviaBot_Questions[1]['Question'][182] = "What item is required for alchemists to be able to perform transmutations?"
TriviaBot_Questions[1]['Answers'][182] = {"Philosopher's Stone"}
TriviaBot_Questions[1]['Category'][182] = 4
TriviaBot_Questions[1]['Points'][182] = "1"
TriviaBot_Questions[1]['Hints'][182] = {"The apostrophe matters."}

TriviaBot_Questions[1]['Question'][183] = "What is the minimum level at which a Warrior can complete the quest 'Whirlwind Weapon' which rewards various powerful 'Whirlwind' weapons?"
TriviaBot_Questions[1]['Answers'][183] = {"30", "thirty"}
TriviaBot_Questions[1]['Category'][183] = 4
TriviaBot_Questions[1]['Points'][183] = "1"
TriviaBot_Questions[1]['Hints'][183] = {}

TriviaBot_Questions[1]['Question'][184] = "In what zone did Thrall put a monument to Grommash Hellscream?"
TriviaBot_Questions[1]['Answers'][184] = {"Ashenvale"}
TriviaBot_Questions[1]['Category'][184] = 3
TriviaBot_Questions[1]['Points'][184] = "1"
TriviaBot_Questions[1]['Hints'][184] = {}

TriviaBot_Questions[1]['Question'][185] = "What herb can only be found growing in places tainted by demons?"
TriviaBot_Questions[1]['Answers'][185] = {"Gromsblood"}
TriviaBot_Questions[1]['Category'][185] = 4
TriviaBot_Questions[1]['Points'][185] = "1"
TriviaBot_Questions[1]['Hints'][185] = {}

TriviaBot_Questions[1]['Question'][186] = "In Vanilla WoW, what language could only Night Elves speak?"
TriviaBot_Questions[1]['Answers'][186] = {"Darnassian"}
TriviaBot_Questions[1]['Category'][186] = 2
TriviaBot_Questions[1]['Points'][186] = "1"
TriviaBot_Questions[1]['Hints'][186] = {}

TriviaBot_Questions[1]['Question'][187] = "Who is the herb Gromsblood named after?"
TriviaBot_Questions[1]['Answers'][187] = {"Grommash Hellscream", "Grom Hellscream"}
TriviaBot_Questions[1]['Category'][187] = 3
TriviaBot_Questions[1]['Points'][187] = "1"
TriviaBot_Questions[1]['Hints'][187] = {}

TriviaBot_Questions[1]['Question'][188] = "Which elite gnoll in Elwynn Forest is notorious for killing low-level players near the Riverpaw camps?"
TriviaBot_Questions[1]['Answers'][188] = {"Hogger"}
TriviaBot_Questions[1]['Category'][188] = 1
TriviaBot_Questions[1]['Points'][188] = "1"
TriviaBot_Questions[1]['Hints'][188] = {}

TriviaBot_Questions[1]['Question'][189] = "Who created Stitches, the abomination in Duskwood, as a gift for Lord Ello Ebonlocke, the mayer of Darkshire?"
TriviaBot_Questions[1]['Answers'][189] = {"Abercrombie the Embalmer", "Abercrombie"}
TriviaBot_Questions[1]['Category'][189] = 1
TriviaBot_Questions[1]['Points'][189] = "1"
TriviaBot_Questions[1]['Hints'][189] = {}

TriviaBot_Questions[1]['Question'][190] = "How many elite worgen called \"Son of Arugal\" can be found in Silverpine Forest?"
TriviaBot_Questions[1]['Answers'][190] = {"3", "three"}
TriviaBot_Questions[1]['Category'][190] = 1
TriviaBot_Questions[1]['Points'][190] = "1"
TriviaBot_Questions[1]['Hints'][190] = {}

TriviaBot_Questions[1]['Question'][191] = "What is the name of the lava-filled raid deep inside Blackrock Mountain where players face elemental forces?"
TriviaBot_Questions[1]['Answers'][191] = {"Molten Core"}
TriviaBot_Questions[1]['Category'][191] = 1
TriviaBot_Questions[1]['Points'][191] = "1"
TriviaBot_Questions[1]['Hints'][191] = {}

TriviaBot_Questions[1]['Question'][192] = "Who is the final boss of the Molten Core raid?"
TriviaBot_Questions[1]['Answers'][192] = {"Ragnaros"}
TriviaBot_Questions[1]['Category'][192] = 1
TriviaBot_Questions[1]['Points'][192] = "1"
TriviaBot_Questions[1]['Hints'][192] = {}

TriviaBot_Questions[1]['Question'][193] = "What key item is used to open the door into Upper Blackrock Spire?"
TriviaBot_Questions[1]['Answers'][193] = {"Seal of Ascension"}
TriviaBot_Questions[1]['Category'][193] = 1
TriviaBot_Questions[1]['Points'][193] = "1"
TriviaBot_Questions[1]['Hints'][193] = {}

TriviaBot_Questions[1]['Question'][194] = "What is the name of the key required to access multiple wings of Dire Maul?"
TriviaBot_Questions[1]['Answers'][194] = {"Crescent Key"}
TriviaBot_Questions[1]['Category'][194] = 1
TriviaBot_Questions[1]['Points'][194] = "1"
TriviaBot_Questions[1]['Hints'][194] = {}

TriviaBot_Questions[1]['Question'][195] = "What is the name of the undead city dungeon in the Eastern Plaguelands that was famously attacked by Arthas Menethil?"
TriviaBot_Questions[1]['Answers'][195] = {"Stratholme"}
TriviaBot_Questions[1]['Category'][195] = 1
TriviaBot_Questions[1]['Points'][195] = "1"
TriviaBot_Questions[1]['Hints'][195] = {}

TriviaBot_Questions[1]['Question'][196] = "What is the name of the raid lair where the broodmother dragon Onyxia is fought?"
TriviaBot_Questions[1]['Answers'][196] = {"Onyxia's Lair"}
TriviaBot_Questions[1]['Category'][196] = 1
TriviaBot_Questions[1]['Points'][196] = "1"
TriviaBot_Questions[1]['Hints'][196] = {}

TriviaBot_Questions[1]['Question'][197] = "What is the name of the rare mount that can drop from Baron Rivendare in Stratholme?"
TriviaBot_Questions[1]['Answers'][197] = {"Deathcharger's Reins", "Baron's Deathcharger"}
TriviaBot_Questions[1]['Category'][197] = 1
TriviaBot_Questions[1]['Points'][197] = "1"
TriviaBot_Questions[1]['Hints'][197] = {}

TriviaBot_Questions[1]['Question'][198] = "Which elite black drake is notorious for wiping travelers as it patrols near the Blasted Lands and Swamp of Sorrows routes?"
TriviaBot_Questions[1]['Answers'][198] = {"Teremus the Devourer", "Teremus"}
TriviaBot_Questions[1]['Category'][198] = 1
TriviaBot_Questions[1]['Points'][198] = "1"
TriviaBot_Questions[1]['Hints'][198] = {}

TriviaBot_Questions[1]['Question'][199] = "Which Horde capital city is built beneath the ruins of the former human capital of Lordaeron?"
TriviaBot_Questions[1]['Answers'][199] = {"Undercity"}
TriviaBot_Questions[1]['Category'][199] = 3
TriviaBot_Questions[1]['Points'][199] = "1"
TriviaBot_Questions[1]['Hints'][199] = {}

TriviaBot_Questions[1]['Question'][200] = "What is the name of the Tauren capital city built atop mesas connected by bridges?"
TriviaBot_Questions[1]['Answers'][200] = {"Thunder Bluff"}
TriviaBot_Questions[1]['Category'][200] = 3
TriviaBot_Questions[1]['Points'][200] = "1"
TriviaBot_Questions[1]['Hints'][200] = {}

TriviaBot_Questions[1]['Question'][201] = "In which zone is the Horde capital Orgrimmar located?"
TriviaBot_Questions[1]['Answers'][201] = {"Durotar"}
TriviaBot_Questions[1]['Category'][201] = 3
TriviaBot_Questions[1]['Points'][201] = "1"
TriviaBot_Questions[1]['Hints'][201] = {}

TriviaBot_Questions[1]['Question'][202] = "What is the name of the starting zone for undead characters in Classic WoW?"
TriviaBot_Questions[1]['Answers'][202] = {"Tirisfal Glades"}
TriviaBot_Questions[1]['Category'][202] = 3
TriviaBot_Questions[1]['Points'][202] = "1"
TriviaBot_Questions[1]['Hints'][202] = {}

TriviaBot_Questions[1]['Question'][203] = "What is the name of the Horde-only dungeon located inside Orgrimmar?"
TriviaBot_Questions[1]['Answers'][203] = {"Ragefire Chasm"}
TriviaBot_Questions[1]['Category'][203] = 3
TriviaBot_Questions[1]['Points'][203] = "1"
TriviaBot_Questions[1]['Hints'][203] = {}

TriviaBot_Questions[1]['Question'][204] = "What is the name of the main Horde quest hub town in the Barrens with a central flight path?"
TriviaBot_Questions[1]['Answers'][204] = {"The Crossroads", "Crossroads"}
TriviaBot_Questions[1]['Category'][204] = 3
TriviaBot_Questions[1]['Points'][204] = "1"
TriviaBot_Questions[1]['Hints'][204] = {}

TriviaBot_Questions[1]['Question'][205] = "Which Barrens quest giver is famous for the meme about finding his missing wife?"
TriviaBot_Questions[1]['Answers'][205] = {"Mankrik"}
TriviaBot_Questions[1]['Category'][205] = 3
TriviaBot_Questions[1]['Points'][205] = "1"
TriviaBot_Questions[1]['Hints'][205] = {}

TriviaBot_Questions[1]['Question'][206] = "Which NPC at Blackrock Mountain can teleport attuned players directly into Molten Core?"
TriviaBot_Questions[1]['Answers'][206] = {"Lothos Riftwaker"}
TriviaBot_Questions[1]['Category'][206] = 1
TriviaBot_Questions[1]['Points'][206] = "1"
TriviaBot_Questions[1]['Hints'][206] = {}

TriviaBot_Questions[1]['Question'][207] = "Who is the regent lord of Stormwind during the events of Vanilla WoW?"
TriviaBot_Questions[1]['Answers'][207] = {"Bolvar Fordragon", "Bolvar"}
TriviaBot_Questions[1]['Category'][207] = 2
TriviaBot_Questions[1]['Points'][207] = "1"
TriviaBot_Questions[1]['Hints'][207] = {}

TriviaBot_Questions[1]['Question'][208] = "What is the name of the human capital city in Elwynn Forest?"
TriviaBot_Questions[1]['Answers'][208] = {"Stormwind City", "Stormwind"}
TriviaBot_Questions[1]['Category'][208] = 2
TriviaBot_Questions[1]['Points'][208] = "1"
TriviaBot_Questions[1]['Hints'][208] = {}

TriviaBot_Questions[1]['Question'][209] = "Which city is canonically higher (elevation): Thunderbluff or Darnassus?"
TriviaBot_Questions[1]['Answers'][209] = {"Darnassus"}
TriviaBot_Questions[1]['Category'][209] = 2
TriviaBot_Questions[1]['Points'][209] = "1"
TriviaBot_Questions[1]['Hints'][209] = {}

TriviaBot_Questions[1]['Question'][210] = "What is the name of the dwarven capital city carved into the mountains of Dun Morogh?"
TriviaBot_Questions[1]['Answers'][210] = {"Ironforge"}
TriviaBot_Questions[1]['Category'][210] = 2
TriviaBot_Questions[1]['Points'][210] = "1"
TriviaBot_Questions[1]['Hints'][210] = {}

TriviaBot_Questions[1]['Question'][211] = "What is the name of the irradiated gnome city that becomes a dungeon in Vanilla WoW?"
TriviaBot_Questions[1]['Answers'][211] = {"Gnomeregan"}
TriviaBot_Questions[1]['Category'][211] = 2
TriviaBot_Questions[1]['Points'][211] = "1"
TriviaBot_Questions[1]['Hints'][211] = {}

TriviaBot_Questions[1]['Question'][212] = "What is the name of the Alliance harbor town in the Wetlands that connects to Kalimdor by boat?"
TriviaBot_Questions[1]['Answers'][212] = {"Menethil Harbor", "Menethil"}
TriviaBot_Questions[1]['Category'][212] = 2
TriviaBot_Questions[1]['Points'][212] = "1"
TriviaBot_Questions[1]['Hints'][212] = {}

TriviaBot_Questions[1]['Question'][213] = "What is the night elf racial mount type called in Classic WoW?"
TriviaBot_Questions[1]['Answers'][213] = {"Nightsaber", "Nightsabers"}
TriviaBot_Questions[1]['Category'][213] = 2
TriviaBot_Questions[1]['Points'][213] = "1"
TriviaBot_Questions[1]['Hints'][213] = {}

TriviaBot_Questions[1]['Question'][214] = "Which Alliance questing zone is home to the Defias Brotherhood and the Deadmines storyline?"
TriviaBot_Questions[1]['Answers'][214] = {"Westfall"}
TriviaBot_Questions[1]['Category'][214] = 2
TriviaBot_Questions[1]['Points'][214] = "1"
TriviaBot_Questions[1]['Hints'][214] = {}

TriviaBot_Questions[1]['Question'][215] = "What is the name of Arthas Menethil's cursed runeblade in Warcraft lore?"
TriviaBot_Questions[1]['Answers'][215] = {"Frostmourne"}
TriviaBot_Questions[1]['Category'][215] = 4
TriviaBot_Questions[1]['Points'][215] = "1"
TriviaBot_Questions[1]['Hints'][215] = {}

TriviaBot_Questions[1]['Question'][216] = "Which demon lord bound Ner'zhul's spirit to create the Lich King?"
TriviaBot_Questions[1]['Answers'][216] = {"Kil'jaeden", "Kiljaeden"}
TriviaBot_Questions[1]['Category'][216] = 4
TriviaBot_Questions[1]['Points'][216] = "1"
TriviaBot_Questions[1]['Hints'][216] = {}

TriviaBot_Questions[1]['Question'][217] = "Which Old God is imprisoned beneath Ahn'Qiraj and serves as the final boss of the Temple of Ahn'Qiraj raid?"
TriviaBot_Questions[1]['Answers'][217] = {"C'Thun"}
TriviaBot_Questions[1]['Category'][217] = 4
TriviaBot_Questions[1]['Points'][217] = "1"
TriviaBot_Questions[1]['Hints'][217] = {}

TriviaBot_Questions[1]['Question'][218] = "What is the name of the red dragon Aspect known as the Life-Binder?"
TriviaBot_Questions[1]['Answers'][218] = {"Alexstrasza"}
TriviaBot_Questions[1]['Category'][218] = 4
TriviaBot_Questions[1]['Points'][218] = "1"
TriviaBot_Questions[1]['Hints'][218] = {}

TriviaBot_Questions[1]['Question'][219] = "What is the name of Deathwing's eldest son who leads Blackwing Lair?"
TriviaBot_Questions[1]['Answers'][219] = {"Nefarian", "Lord Victor Nefarius"}
TriviaBot_Questions[1]['Category'][219] = 4
TriviaBot_Questions[1]['Points'][219] = "1"
TriviaBot_Questions[1]['Hints'][219] = {}

TriviaBot_Questions[1]['Question'][220] = "What is the name of Illidan Stormrage's twin brother?"
TriviaBot_Questions[1]['Answers'][220] = {"Malfurion Stormrage", "Malfurion"}
TriviaBot_Questions[1]['Category'][220] = 4
TriviaBot_Questions[1]['Points'][220] = "1"
TriviaBot_Questions[1]['Hints'][220] = {}

TriviaBot_Questions[1]['Question'][221] = "What title is Illidan Stormrage most famously known by in Warcraft lore?"
TriviaBot_Questions[1]['Answers'][221] = {"The Betrayer"}
TriviaBot_Questions[1]['Category'][221] = 4
TriviaBot_Questions[1]['Points'][221] = "1"
TriviaBot_Questions[1]['Hints'][221] = {}

TriviaBot_Questions[1]['Question'][222] = "Who serves as the final boss of Maraudon and is also the target of the killing quest \"Corruption of Earth and Seed\"? (Full NPC Name)"
TriviaBot_Questions[1]['Answers'][222] = {"Princess Theradras"}
TriviaBot_Questions[1]['Category'][222] = 4
TriviaBot_Questions[1]['Points'][222] = "1"
TriviaBot_Questions[1]['Hints'][222] = {}

TriviaBot_Questions[1]['Question'][223] = "What is the name of the elite undead knight that stalks Raven Hill Cemetery in Duskwood?"
TriviaBot_Questions[1]['Answers'][223] = {"Mor'ladim", "Morladim"}
TriviaBot_Questions[1]['Category'][223] = 1
TriviaBot_Questions[1]['Points'][223] = "1"
TriviaBot_Questions[1]['Hints'][223] = {}

TriviaBot_Questions[1]['Question'][224] = "What is the name of the infamous cave in Durotar that is a common cause of early Hardcore deaths?"
TriviaBot_Questions[1]['Answers'][224] = {"Skull Rock"}
TriviaBot_Questions[1]['Category'][224] = 1
TriviaBot_Questions[1]['Points'][224] = "1"
TriviaBot_Questions[1]['Hints'][224] = {}

TriviaBot_Questions[1]['Question'][225] = "What is the debuff called that you receive after resurrecting at a Spirit Healer in Classic WoW?"
TriviaBot_Questions[1]['Answers'][225] = {"Resurrection Sickness"}
TriviaBot_Questions[1]['Category'][225] = 1
TriviaBot_Questions[1]['Points'][225] = "1"
TriviaBot_Questions[1]['Hints'][225] = {}

TriviaBot_Questions[1]['Question'][226] = "Which Vanilla dungeon inside Blackrock Mountain is famous for being enormous, maze-like, and full of deadly pulls?"
TriviaBot_Questions[1]['Answers'][226] = {"Blackrock Depths", "BRD"}
TriviaBot_Questions[1]['Category'][226] = 1
TriviaBot_Questions[1]['Points'][226] = "1"
TriviaBot_Questions[1]['Hints'][226] = {}

TriviaBot_Questions[1]['Question'][227] = "Who is the emperor and final boss encounter of Blackrock Depths in Vanilla WoW?"
TriviaBot_Questions[1]['Answers'][227] = {"Emperor Dagran Thaurissan", "Dagran Thaurissan"}
TriviaBot_Questions[1]['Category'][227] = 1
TriviaBot_Questions[1]['Points'][227] = "1"
TriviaBot_Questions[1]['Hints'][227] = {}

TriviaBot_Questions[1]['Question'][228] = "What is the name of the Alliance-only camp in northern Stranglethorn Vale that serves as a quest hub?"
TriviaBot_Questions[1]['Answers'][228] = {"Rebel Camp"}
TriviaBot_Questions[1]['Category'][228] = 2
TriviaBot_Questions[1]['Points'][228] = "1"
TriviaBot_Questions[1]['Hints'][228] = {}

TriviaBot_Questions[1]['Question'][229] = "What is the name of the main Horde-only quest hub in Stranglethorn Vale? (Full name)"
TriviaBot_Questions[1]['Answers'][229] = {"Grom'gol Base Camp"}
TriviaBot_Questions[1]['Category'][229] = 3
TriviaBot_Questions[1]['Points'][229] = "1"
TriviaBot_Questions[1]['Hints'][229] = {}

TriviaBot_Questions[1]['Question'][230] = "Whose spirit was bound into the Helm of Domination to become the Lich King?"
TriviaBot_Questions[1]['Answers'][230] = {"Ner'zhul", "Nerzhul"}
TriviaBot_Questions[1]['Category'][230] = 4
TriviaBot_Questions[1]['Points'][230] = "1"
TriviaBot_Questions[1]['Hints'][230] = {}

TriviaBot_Questions[1]['Question'][231] = "What item did players need to obtain (via a long quest chain) to attune themselves and gain access to Onyxia’s Lair?"
TriviaBot_Questions[1]['Answers'][231] = {"Drakefire Amulet"}
TriviaBot_Questions[1]['Category'][231] = 4
TriviaBot_Questions[1]['Points'][231] = "1"
TriviaBot_Questions[1]['Hints'][231] = {}

TriviaBot_Questions[1]['Question'][232] = "What player's name became a famous meme after he charged into battle yelling his own name in Upper Blackrock Spire?"
TriviaBot_Questions[1]['Answers'][232] = {"Leeroy Jenkins"}
TriviaBot_Questions[1]['Category'][232] = 1
TriviaBot_Questions[1]['Points'][232] = "1"
TriviaBot_Questions[1]['Hints'][232] = {}

TriviaBot_Questions[1]['Question'][233] = "Which low-level dungeon in the Barrens is a sprawling cave system with the boss Mutanus the Devourer?"
TriviaBot_Questions[1]['Answers'][233] = {"Wailing Caverns", "WC"}
TriviaBot_Questions[1]['Category'][233] = 1
TriviaBot_Questions[1]['Points'][233] = "1"
TriviaBot_Questions[1]['Hints'][233] = {}

TriviaBot_Questions[1]['Question'][234] = "What is the name of the Alliance faction in Alterac Valley?"
TriviaBot_Questions[1]['Answers'][234] = {"Stormpike Guard", "Stormpike"}
TriviaBot_Questions[1]['Category'][234] = 2
TriviaBot_Questions[1]['Points'][234] = "1"
TriviaBot_Questions[1]['Hints'][234] = {}

TriviaBot_Questions[1]['Question'][235] = "What is the name of the Horde faction in Alterac Valley?"
TriviaBot_Questions[1]['Answers'][235] = {"Frostwolf Clan", "Frostwolf"}
TriviaBot_Questions[1]['Category'][235] = 3
TriviaBot_Questions[1]['Points'][235] = "1"
TriviaBot_Questions[1]['Hints'][235] = {}

TriviaBot_Questions[1]['Question'][236] = "What is the name of the free-for-all PvP arena in Stranglethorn Vale where players battle for a treasure chest that periodically appears?"
TriviaBot_Questions[1]['Answers'][236] = {"Gurubashi Arena"}
TriviaBot_Questions[1]['Category'][236] = 4
TriviaBot_Questions[1]['Points'][236] = "1"
TriviaBot_Questions[1]['Hints'][236] = {}

TriviaBot_Questions[1]['Question'][237] = "During the Gates of Ahn’Qiraj opening event, what unique title was given to players who rang the gong to open the gates?"
TriviaBot_Questions[1]['Answers'][237] = {"Scarab Lord"}
TriviaBot_Questions[1]['Category'][237] = 4
TriviaBot_Questions[1]['Points'][237] = "1"
TriviaBot_Questions[1]['Hints'][237] = {}

TriviaBot_Questions[1]['Question'][238] = "Originally in Vanilla WoW, how many debuffs could a single enemy have on it at one time (the debuff limit)?"
TriviaBot_Questions[1]['Answers'][238] = {"8", "eight"}
TriviaBot_Questions[1]['Category'][238] = 4
TriviaBot_Questions[1]['Points'][238] = "1"
TriviaBot_Questions[1]['Hints'][238] = {}

TriviaBot_Questions[1]['Question'][239] = "Which legendary item is often jokingly spammed in chat with the phrase “Did someone say [item name]?” due to its famously long name? (Full Item Name)"
TriviaBot_Questions[1]['Answers'][239] = {"Thunderfury, Blessed Blade of the Windseeker", "[Thunderfury, Blessed Blade of the Windseeker]"}
TriviaBot_Questions[1]['Category'][239] = 4
TriviaBot_Questions[1]['Points'][239] = "1"
TriviaBot_Questions[1]['Hints'][239] = {}

TriviaBot_Questions[1]['Question'][240] = "What is the name of the zone inside the Mage Tower in Stormwind’s Mage Quarter that serves as the portal arrival point to Stormwind?"
TriviaBot_Questions[1]['Answers'][240] = {"Wizard's Sanctum"}
TriviaBot_Questions[1]['Category'][240] = 2
TriviaBot_Questions[1]['Points'][240] = "1"
TriviaBot_Questions[1]['Hints'][240] = {}


-- Ensure the global table exists and register with TriviaClassic if present
_G.TriviaBot_Questions = TriviaBot_Questions
if TriviaClassic and TriviaClassic.RegisterTriviaBotSet then
  TriviaClassic:RegisterTriviaBotSet("Deadliest of Azeroth", TriviaBot_Questions)
end
