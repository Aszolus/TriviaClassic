local _,TriviaBot_Questions = ...
-- -------------------------------------------------- --
 --[[ DO NOT EDIT OR REMOVE ANYTHING ABOVE THIS LINE ]]
-- -------------------------------------------------- --

-- Initialize arrays
TriviaBot_Questions[1] = {['Categories'] = {}, ['Question'] = {}, ['Answers'] = {}, ['Category'] = {}, ['Points'] = {}, ['Hints'] = {}};

TriviaBot_Questions[1]['Title'] = "Lorewalkers of Silvermoon question set";
TriviaBot_Questions[1]['Description'] = "WoW Questions";
TriviaBot_Questions[1]['Author'] = "Lorewalkers of Silvermoon-EU";

-- NEW (in Triviabot-NG) Contributors array, that optionally tie in to every question
-- This SHOULD be backwards compatible with older TriviaBot versions
-- array item should be REGION, REALM and CHARNAME to generate armory links

--TriviaBot_Questions[1]['Contributors'] = {};
--TriviaBot_Questions[1]['Contributors'][1] = { "eu", "silvermoon", "Noxaeterna" };
--TriviaBot_Questions[1]['Contributors'][2] = { "eu", "silvermoon", "Illìdone" };
--TriviaBot_Questions[1]['Contributors'][3] = { "eu", "silvermoon", "Admantium" };
--TriviaBot_Questions[1]['Contributors'][4] = { "eu", "silvermoon", "Diarah" };


-- Add categories
TriviaBot_Questions[1]['Categories'][1] = "Lore"; -- Lore questions
TriviaBot_Questions[1]['Categories'][2] = "Lists"; -- Lists ("fill in the blank"-lists of items, classes, specs, skills etc.)
TriviaBot_Questions[1]['Categories'][3] = "NPCs"; -- NPCs
TriviaBot_Questions[1]['Categories'][4] = "Geography"; -- Geography of the world
TriviaBot_Questions[1]['Categories'][5] = "Misc"; -- Misc

-- Missing questions START. --
-- Adding blanks to avoid nil errors in TriviaBot.
-- If a quiz author ever edits this file to add more questions
-- use these first before going to the end of file to add more.
-- local TriviaBot_Questions = {};


TriviaBot_Questions[1]['Question'] = {
"Who was the last elven king of Quel'thalas?","Who was the last true descendant of the Arathi bloodline?",
"Who is King Varian's son named after?","Which gatherable material is named after a famous archmage?",
"Who built Karazhan?","Who started the Sunstrider dynasty and founded Quel'thalas?","Who is the mother of Medivh?",
"Who is featured in the giant statue on Janeiro Isle?","Who is the current (BfA) leader of the Tauren",
"Who is the current (Legion) leader of the Forsaken","Who is the current (Legion) warchief of the Horde?",
"Who is the current (Legion) leader of the Bronzebeard clan?","Who is the current (Legion) leader of the Wildhammer clan?",
"Who is the current (Legion) leader of the Dark Iron clan?","What is the name of Emperor Dagran Thaurissan and Moira Bronzebeard's child, seemingly unaging through the years?",
"The Council of Three Hammers is comprised of the Wildhammer, Dark Iron and ___________ clans",
"The Council of Three Hammers is comprised of the Bronzebeard, Wildhammer and ____ ____ clans",
"Name one of the Dragons of Nightmare","Who created Mardum, the Shattered Abyss, the Demon Hunter class hall?",
"Who was the last descendant in Xe'ra's line?","What is Eldre'thalas commonly known as?",
"Before patch 2.3, where would you go train for an Enchanting skill of 300?","Among Night Elves, which facial characteristic is considered to bear potential for greatness?",
"The Thunder King's realm lasted __ thousand years.","In which zone can you find several types of E'ko on creatures?",
"Zone that contains a mechanism resembling a ski lift","Who holds the key to the Grim Guzzler?",
"Who is the son of Alleria and Turalyon?","Sylvanas Windrunner, the former Ranger-General of ___________",
"Whom did the heroes rescue during a jailbreak quest in Blackrock Depths?","Who was the sole resident of Marris Stead up until the Cataclysm?",
"Who is the Champion of the Banshee Queen?","Who was the original fourth Horseman in Naxxramas?",
"During the events of the Second War, this historical figure came across the dark orb that would later be part of the Ashbringer.",
"Who created the original Death Knights?","Who is the eldest son of Cenarius?","What creatures were the offspring of Princess Theradras and Zaetar?",
"Name one of the centaur tribes apart from the Kolkar or Magram.","Name the sister of Jarod Shadowsong?",
"Name a Kaldorei Resistance leader during the War of the Ancients","What is the common tongue meaning of 'Zin-Azshari' ?",
"What is the name of the fishing-pole artifact?","What is the name of the legendary healing mace obtained during Wrath of the Lich King?",
"What is the name of the legendary staff obtained during Cataclysm?","Complete the WotLK daily dungeon achievement name: '______ Foresees'",
"Name the Horde warrior historically notorious for his ability to wipe Alliance raids. He would be found guarding the Valley of Strength in Orgrimmar.",
"What mounts are related to the Kurenai faction?","What mounts are related to the Outland Mag'har faction?",
"What does 'Kurenai' mean to the Draenei?","Turning in [Mark of Kil'jaeden] improves your reputation with what faction?",
"Turning in [Fel Armament] improves your reputation with what faction?","Turning in [Firewing Signet]s improves your reputation with what faction?",
"Turning in [Arcane Tome]s improves your reputation with what faction?","Renowned group of pirates, enemies of the Blackwater Raiders",
"Which race was the 'defective by-product' of the Forge of Wills before the Earthen were created?",
"The Engine of the Makers in Storm Peaks is a part of which greater machine?","This race was created from a 'Subterranean being matrix' and were precursors to modern dwarves. Which race was that?",
"Name a Titan city the Earthen retreated to following the Sundering.","The Wildhammer Clan worked on the sculpture of Aerie Peak. Which animal's head does it represent?",
"After the War of the Three Hammers, where did the Wildhammer intend to head to?","Which is the home planet of the infernal Dreadsteeds?",
"Which is the home planet of the Ethereals?","Which is the primary language of the Old Gods?",
"Who was the Blood God of the Gurubashi Trolls?","Who is the mother of Merithra the Green?",
"Little Jimmy Vishas, found in the Old Hillsbrad Foothills tavern, grew up to be which character?",
"Name one of the Lesser Dragonflights","Where was Alexstrasza the Red imprisoned during the Second War?",
"Who was the head of the Wyrmrest Accord during the war effort against Malygos?","Which king backed Isiden Perenolde in his claim to the throne of Alterac?",
"Which was the only Gilnean detachment that supported the Alliance during the Third War?",
"This Qiraji kingdom is sealed and protected by the Scarab Wall found in its perimeter.",
"Kar\'sis, or \'Hand of the Earth\', is the qiraji name for which famous night elf?",
"As a means of proving loyalty to the Horde, the Bilgewater Cartel shaped which area to resemble the Horde sigil?",
"Where did Tyrande Whisperwind, Illidan and Malfurion Stormrage grow up?","Which tauren historian was given immortality by Nozdormu in order to become an agent of the Bronze Dragonflight?",
"What is the Qiraji War also known as?","Which weapon was wielded by Thoradin, the barbarian warlord?",
"Where was the Scythe of Elune at the time the human Jitters discovered its existence?",
"Name a faction based in Sholazar Basin","Which keeper was famously corrupt by Yogg-Saron in Ulduar?",
"What did 'Khadgar' used to mean among the dwarves?","Which demon-worshipping clan pushed the Magram centaurs from southern Desolace?",
"A prominent member of the Cenarion Circle, she was ambushed and killed during a meeting of both Alliance and Horde druids in Ashenvale.",
"Where would you find Elerethe Renferal before the heroes came across her in the Emerald Nightmare?",
"The ___________ were Queen Azshara's most revered arcanists.","Where did the Paragons of the Klaxxi take up guard after allying with Garrosh Hellscream?",
"If you drank the [Videre Elixir], in which area's graveyard would you wake up at?",
"In which area did you help a traditional dwarvish wedding take place by defending the ritual from the Twilight's Hammer?",
"This great feat of dwarven engineering, partially damaged by the Scourge during the Third War, connects Lordaeron to Khaz Modan. What is it called?",
"Name one of the two moons of Azeroth.","The White Lady and the ____ _____.","What does 'Modan' mean in the dwarven tongue?",
"Which Titan shaped the mountains of Azeroth?","What race is Algalon the Observer?","Which race was originally meant to have an ability similar to the Worgens' 'Running Wild', but it was never implemented?",
"The Titans handed Val'anyr to an ancient king. Which king was that?","This massive hammer was crafted by Khaz'goroth himself and was subsequently enchanted by Aman'Thul and Norgannon.",
"Who was the very first Val'kyr?","Which Perenolde family heirloom was held by Grel'borg the Miser?",
"When Ati'esh, Greatstaff of the Guardian was wielded by a druid, what colour would its ribbon be?",
"When Ati'esh, Greatstaff of the Guardian was wielded by a priest, what colour would its ribbon be?",
"When Ati'esh, Greatstaff of the Guardian was wielded by a mage, what colour would its ribbon be?",
"When Ati'esh, Greatstaff of the Guardian was wielded by a warlock, what colour would its ribbon be?",
"NPC: 'It was with the aid of the tauren that my flesh was made wood, my skin made into leaves, and my wisdom made eternal.'",
"Where would you come across the crafting schematics for the Field Repair Bot 74A?",
"What does Dranosh Saurfang's first name mean in the Orcish tongue?","Lord Gregor Lescovar, member of the House of Nobles of Stormwind, secretly worked with which faction?",
"Brann Bronzebeard used to steal notes off whom, back in Archaeology school?","Who was the last queen of the Mogu?",
"Caruk Bloodwind, the first Leatherworker of Highmountain, discovered which famous method for improving animal hides?",
"Name a Furbolg Tribe that has so far remained uncorrupted (as of Legion).","Where would you come across a Disconcerting Bookshelf that, when pushed, would reveal a secret passage behind it?",
"What is High Priestess Arlokk's sister called?","Name the Lordaeron noble that was in fact a member of the Black Dragonflight, in disguise, in Stormwind Keep.",
"Who was the architect responsible for designing the Stonewrought Dam and the Dark Iron fortress of Blackrock Spire?",
"Who was the last living consort of Malygos?","Name a legendary blacksmith of Black Rook Hold.",
"What class was Illysanna Ravencrest trained to be during her lifetime?","The first of the moonwells of Teldrassil used to lie under the boughs of which tree?",
"Historically, through which town was the grain of Lordaeron distributed through?","Skylord Omnuron leads which traditional druidic organisation which is now part of the Cenarion Circle?",
"Lea Stonepaw leads which druidic organisation?","Sylendra Gladesong leads which druidic organisation?",
"Which druid was responsible for protecting Alterac Valley, while a member of the Stormpike Guard as well as the Cenarion Circle?",
"The druid Naralex lead which druidic organisation?","Which druidic organisation represents the Balance specialisation?",
"When killed in the physical world, where do Wild Gods return before being able to be brought back into the world?",
"Master Bu was revealed to be which entity, during the events of Legion?","The Dreadlord Balnazzar impersonated ______ _________ after possessing his body, allowing him to manipulate the Scarlet Crusade from within.",
"Name a traditional Amani loa.","Name a traditional totemic spirit of the Bloodscalp tribe.",
"Name a traditional Gurubashi loa.","Name a traditional Drakkari loa.","Name a traditional Zandalari loa.",
"Who created the Grummles and the Saurok?","In Draenor, where do engineers go when visiting a 'jagged landscape' ?",
"In Draenor, where do engineers go when visiting a 'redding-orange forest' ?","In Draenor, where do engineers go when visiting the 'grassy plains' ?",
"In Draenor, where do engineers go when visiting a 'primal forest' ?","King Mrgl-Mrgl is really a secret agent of which organisation?",
"Who is the present leader of D.E.H.T.A.?","After the events of the Elemental Sundering, where was Thunderaan the Windlord's remaining essence stored?",
"Where would you find Storm dragons, also known as Storm wyrms?","Name one of the Pillars of Creation.",
"Name a member of the Pantheon.","Where was the Black City, stronghold of the Burning Legion, located?",
"What was the Broken Shore originally known as?","Yor'sahj the Unsleeping is a member of which race?",
"What is Deathwing called in Shath'yar?","Who was the first lord of Drustvar?","The Troll city of Jintha'Alor is the namesake of which famous Troll warrior?",
"During the quest chain 'The Battle of ___________', you are requested to bring closure to the daughter of a Lordaeron warrior who fell in that battle.",
"Seething Shore is located off the coast of ________","This city's name means 'dwelling of light'.",
"This group of naaru arrived into Outland to fight the Burning Legion.","What is the meaning of 'The Sha\'tar' ?",
"When The Sha'tar first arrived in Outland, they came across this group of draenei priesthood who had remained in Shattrath, after the city had fallen to the orcs.",
"Many of the brightest scholars and magisters in Kael'thas' armies defected and joined the Sha'tar. What was this group of blood elves called?",
"Where would you come across Cohlien Frostweaver, Battle-Mage Dathric, Abjurist Belmara and Conjurer Luminrath?",
"Name a war zone where High Warlord Volrath could be found commanding Horde troops.",
"What was the name of Mankrik's wife?","Umbranse the Spiritspeaker took over this cave in hope of enhancing his own powers, by collecting dragon essences of the Blue Dragonflight.",
"Compassion, patience, bravery-- these things mean as much to a _______ as strength in battle.",
"Name one of the Three Virtues described in the original philosophy of the Holy Light.",
"As the most powerful Twilight's Hammer cultists to be twisted into elemental beings, the _________ _______ [...] oversee the selection of new ascension candidates.",
"Who created Kologarn?","____, Prime Designate, leader of the titan-forged on Azeroth, chief jailor of Yogg-Saron and maintainer of the Forge of Wills.",
"_____, Prime Designate, leader of the titan-forged on Azeroth, chief jailor of Yogg-Saron and maintainer of the Forge of Wills.",
"The _____, crafted with material sourced from Azeroth's crust by the Pantheon, serving to carry out their will against the Black Empire.",
"_____________ is the weapon wielded by High Tinker Gelbin Mekkatorque.","Zin-Azshari was the ancient capital of the Kaldorei. What was it originally known as?",
"Vol'jin once tried to recruit _________ to aid him in the fight against Zalazane.",
"________ _____, a good friend of Vol'jin, appeared secretly at his funeral ceremony and vowed to avenge his death.",
"Where was Vol'jin's funeral ceremony held?","The loa _____ was slain by the Blood Trolls.",
"The drakkari loa ________ used his own spirit to commit suicide, thus vanquishing his spirit as well as his physical manifestation.",
"The loa __________, worshipped by the sethrak as well as the Zandalari, sacrificed herself to stop Mythrax from assaulting Zandalar.",
"Name one of the locations where a seal was built to keep G'huun imprisoned.","Men as far as Kul Tiras spoke of the legendary ____ _____'s premium tobacco-- a delicacy enjoyed, among other persons of importance, by King Terenas, Uther the Lightbringer and Highlord Fordring.",
"'______ brings de lightning, ______ brings de thunder. De faithless be afraid, de brave be full of wonder.'",
"'_________ guards our spirits well, He makes death most inviting. Ya think he be a trickster, his humor often biting.'",
"'____, ____, loa of trash, tell me where to find your cache! Richmon, poormon, he don't mind. What's inside? He knows ya kind.'",
"'_______, Loa, Guardian strong. _______, Father, May ya live forever long.'","'_____ is de one, with de glory of de sun. He stands strong, he stands tall, he's de greatest of dem all!'",
"'Kingly, sharp, and honor bound. A more noble loa will not be found. He is de son, de morning star. He is de pride of Zandalar.'",
"'I've seen things that would scare you __________!'","What do the initials M.O.T.H.E.R. stand for?",
"Name the most revered shipwright in Kul Tiras?","Where would a member of the Alliance find a barber in the island of Kul Tiras?",
"Where would a member of the Horde find a barber in the island of Zuldazar?","'I am tall when I am young, and short when I am old. What am I?'",
"'If I drink, I die. If I eat, I live. What am I?'","'If I have it, I don't share it. If I share it, I don't have it. What is it?'",
"'What is always coming, but never leaves?'","'What has a head but never weeps? Has a bed but never sleeps? Can run but never walks? Has a bank but no money?'",
"'You bury me when I'm alive, and dig me up when I'm dead. What am I?'","'Sometimes I walk in front of you. Sometimes I walk behind you. Only in darkness do I ever leave you. Who am I?'",
"'What can always be measured, but can never be seen?'","What is Eitrigg afraid of?","'Drustvar has witches, and apparently Nazmir has ______.'",
"What was Duskwood formerly known as?","Teldrassil was created by the combined powers of the druids and The ______ __ ___ ________.",
"_________ became corrupted as its roots reached deep to the subterranean prison of Yogg-Saron.",
"Meaning of 'Andrassil'","_________ is a great tree inside the Emerald Dream, known for its ability to calm enraged beings.",
"Invincible was born to the mare __________.","This school of magic combines the powers of all known elemental schools, benefitting from all relevant magic school buffs.",
"What is the Horde equivalent to Stormshield?","What is the Alliance equivalent to Warspear?",
"Name a son of Cenarius.","Wher can you find the Crystal Caverns of Terramok, the ancient vault of the Titans?",
"Name an item that you need to gain access to the Chamber of Khaz'mul in Uldaman.","Where would you find ...vampirates?",
"What was Warden Moi'bff Jill originally known as, until a secret vote took place for his name to be changed?",
"Who does the statue inside the Gates of Ironforge represent?","In a trade session, how many of the parties involved are allowed to deposit gold as part of the transaction?",
"What is currently the most fun class to play?","What is currently the most OP class?",
"Complete the set (legacy tier tokens): Rogue, Mage, Death Knight, _____","Complete the set (legacy tier tokens): Druid, Death Knight, Rogue, ____",
"Complete the set (legacy tier tokens): Warrior, Hunter, ______","Complete the set (legacy tier tokens): Shaman, Warrior, ______",
"Complete the set (legacy tier tokens): Paladin, Priest, _______","Complete the set (legacy tier tokens): Warlock, Paladin, ______",
"Complete the talent set: Mighty Bash, Mass Entanglement, _______","Complete the talent set: Photosynthesis, Flourish, ___________",
"Complete the talent set: Benediction, ______ ____, Halo","Complete the talent set: Divine Judgment, Wake of Ashes, ____________",
"Complete the talent set: Spirit Wolf, _____ ______, Static Charge","Complete the talent set: High Tide, __________, Ascendance",
"Complete the talent set: Meat Cleaver, Dragon Roar, __________","Complete the talent set: Mirror Image, Rune of Power, __________ ____",
"Complete the talent set: Born to be Wild, _________, Binding Shot","Complete the talent set: Cycle of Hatred, _____ _____, Dark Slash",
"Complete the talent set: Inexorable Assault, ___ ______, Cold Heart","Complete the talent set: Vigor, ______ _________, Marked for Death",
"Complete the talent set: Demon Skin, Burning Rush, ____ ____","Complete the talent set: Volley, Careful Aim, _________ ____",
"Complete the talent set: Celerity, ___ _______, Tiger's Lust","Complete the set: Explorer's League, The Frostborn, The Silver Covenant and ________ __________",
"Complete the set: Explorer's League, The Frostborn, Valiance Expedition and ___ ______ ________",
"Complete the set: Alterac, Dalaran, Gilneas, Kul Tiras, Lordaeron, Stromgarde and _________",
"Complete the set: Dalaran, Gilneas, Kul Tiras, Lordaeron, Stromgarde, Stormwind and _______",
"Complete the set: Alterac, Gilneas, Kul Tiras, Lordaeron, Stormwind, Stromgarde and _______",
"Complete the set: Alterac, Dalaran, Stromgarde, Gilneas, Lordaeron, Stormwind and _________",
"Complete the set: Anger, Hatred, Violence, Fear, Doubt, Despair and _____","Complete the set: Hatred, Violence, Fear, Doubt, Despair, Pride and _____",
"Complete the set: Anger, Hatred, Violence, Fear, Doubt, Pride and _______","Complete the set: Anger, Hatred, Fear, Doubt, Despair, Pride and ________",
"Complete the set: Sylvanas, Vereesa and _______","Complete the set: Sylvanas, Alleria and _______",
"Complete the set: Bough Shadow, Dream Bough, Seradane and ________ _____","Complete the set: Dream Bough, Seradane, Twilight Grove and _____ ______",
"Complete the set: Bough Shadow, Dream Bough, Twilight Grove and ________","Complete the set: Val'sharah, Eye of Azshara, Broken Shore, Suramar, Azsuna, Highmountain, _________",
"Complete the set: Val'sharah, Broken Shore, Suramar, Azsuna, Stormheim, Highmountain, ___ __ _______",
"Complete the set: Eye of Azshara, Broken Shore, Stormheim, Suramar, Azsuna, Highmountain, __________",
"Complete the pair: Valiona and _________","Complete the pair: _______ and Turalyon","Complete the pair: _____ and Thrall",
"Complete the pair: Draka and _______","Name a class that could exchange [Vanquisher's Mark of Sanctification] for Tier gear?",
"Name a class that could exchange [Conqueror's Mark of Sanctification] for Tier gear?",
"Name a class that could exchange [Protector's Mark of Sanctification] for Tier gear?",
"Name a class that can *only* perform as melee, caster as well as a healer.","Name a class that can *only* perform the duties of melee, tank and healer.",
"Name a class that can perform the duties of a melee, caster, healer and tank.","Complete the set: Heroism, Bloodlust, ______ ____, Time Warp",
"Complete the set: Heroism, ____ ____, Bloodlust, Primal Rage","Complete the set: Uther, Turalyon, Tirion, Gavinrad and ......",
"Complete the set: Saidan, Uther, Tirion, Turalyon and ......","Complete the set: Gavinrad, Saidan, Turalyon, Tirion and .....",
"Complete the set: Saidan, Gavinrad, Tirion, Uther and .....","Meaning of acronym: 'GBoM'",
"Meaning of acronym: 'PST'","Meaning of acronym: 'BoT'","Meaning of acronym: 'BWD'","Meaning of acronym: 'BWL'",
"Meaning of acronym: 'TotGC'","Meaning of acronym: 'BRC'","Meaning of acronym: 'BRD'","Meaning of acronym: 'LBRS'",
"Meaning of acronym: 'UBRS'","Meaning of acronym: 'TotFW'","Meaning of acronym: 'ToT'","Meaning of acronym: 'HoO'",
"Meaning of acronym: 'HoL'","Meaning of acronym: 'SoO'","Meaning of acronym: 'HK'","Legacy: Meaning of acronym 'DK' (apart from 'Death Knight')",
"Meaning of acronym: 'IMHO'","Meaning of: 'A/S/L'","Race having the racial trait 'Every Man for Himself'",
"Race having the racial trait 'Quickness'","Race having the racial trait 'Elusiveness'",
"Race having the racial trait 'Arcane Acuity'","Race having the racial trait 'Stoneform'",
"Race having the racial trait 'Might of the Mountain'","Race having the racial trait 'Expansive Mind'",
"Race having the racial trait 'Nimble Fingers'","Race having the racial trait 'Heroic Presence'",
"Race having the racial trait 'Gift of the Naaru'","Race having the racial trait 'Viciousness'",
"Race having the racial trait 'Hardiness'","Race having the racial trait 'Brawn'","Race having the racial trait 'Endurance'",
"Race having the racial trait 'Berserking'","Race having the racial trait 'Rocket Jump'",
"Race having the racial trait 'Time is Money'","Race having the racial trait 'Cannibalize'",
"Race having the racial trait 'Touch of the Grave'","Which race is quoted as saying: 'Anaria Shola'",
"Which race is quoted as saying: 'An\'u belore delen\'na'","Which race is quoted as saying: 'Shorel\'aran'",
"Which race is quoted as saying: 'Shadows gather'","Which race is quoted as saying: 'Archenon poros' ('good fortune')",
"Which race is quoted as saying: 'Krona ki kristorr' ('the Legion will fall')","Which race is quoted as saying: 'Belaya doros'",
"Which race is quoted as saying: 'I foresee a mutually beneficial transaction'","Which race is quoted as saying: 'What\'s your luckydo?'",
"Which race is quoted as saying: 'It is said: Never swim upstream, when downstream are the hozen'",
"Which race is quoted as saying: 'Preserve the cycle'","Which race is quoted as saying: 'Ishnu-alah'",
"Which race is quoted as saying: 'Del-nadres'","Which race is quoted as saying: 'Yes, shalashka?'",
"The Helarjar are a tribe of which race?","Which Specialisation is related to the talent [Stellar Drift] ?",
"Which Specialisation is related to the talent [Blade of Wrath] ?","Which Specialisation is related to the talent [Blinding Light] ?",
"Which Specialisation is related to the talent [Abundance] ?","Which Specialisation is related to the skill [Ironfur] ?",
"Mythic+ affix: 'When any non-boss enemy dies, its death cry empowers nearby allies, increasing their maximum health and damage by 20%.'",
"Mythic+ affix: 'When slain, non-boss enemies explode, causing all players to suffer 5% of their max health in damage over 4 sec. This effect stacks.'",
"Mythic+ affix: 'While in combat, enemies periodically summon Explosive Orbs that will detonate if not destroyed.'",
"Mythic+ affix: 'Non-boss enemies have 20% more health and inflict up to 30% increased damage.'",
"Mythic+ affix: 'When injured below 90% health, players will suffer increasing damage over time until healed above 90% health.'",
"Mythic+ affix: 'Some non-boss enemies have been infested with a Spawn of G\'huun.'",
"Mythic+ affix: 'All enemies\' melee attacks apply a stacking blight that inflicts damage over time and reduces healing received.'",
"Mythic+ affix: 'Healing in excess of a target\'s maximum health is instead converted to a heal absorption effect.'",
"Mythic+ affix: 'Periodically, all players emit a shockwave, inflicting damage and interrupting nearby allies.'",
"Mythic+ affix: 'Non-boss enemies enrage at 30% health remaining, dealing 100% increased damage until defeated.'",
"Mythic+ affix: 'Non-boss enemies are empowered by Bwonsamdi and periodically seek vengeance from beyond the grave.'",
"Mythic+ affix: 'When slain, non-boss enemies leave behind a lingering pool of ichor that heals their allies and damages players.'",
"Mythic+ affix: 'Enemies pay far less attention to threat generated by tanks.'","Mythic+ affix: 'Additional non-boss enemies are present throughout the dungeon.'",
"Mythic+ affix: 'Boss enemies have 40% more health and inflict up to 15% increased damage.'",
"Mythic+ affix: 'While in combat, enemies periodically cause gouts of flame to erupt beneath the feet of distant players.'",
"'--+-- BOSS +++++ Being unique doesn't make you special' - which boss could the sketch be referring to?",
"[Safety Dance] is an achievement earned in which boss fight?","Boss using [Flash Freeze], [Biting Cold] and [Frozen Blows].",
"The name of the second rank in the Alliance PVP Honor system","The name of the second rank in the Horde PVP Honor system",
"The name of the seventh rank in the Alliance PVP Honor system","The name of the seventh rank in the Horde PVP Honor system",
"The name of the eleventh rank in the Alliance PVP Honor system","The name of the eleventh rank in the Horde PVP Honor system",
"The name of the thirteenth rank in the Alliance PVP Honor system","The name of the thirteenth rank in the Horde PVP Honor system",
"Title awarded for slaying the 10-man version of Algalon the Observer","Title awarded for slaying the 25-man version of Algalon the Observer",
"Title awarded for slaying the 10-man version of Algalon the Observer at level 80, wearing a maximum of ilvl 226 armor and ilvl 232 weapon(s)",
"Title awarded for slaying the 10-man version of the Lich King in heroic mode","Title awarded for slaying the 25-man version of the Lich King in heroic mode",
"Title awarded for completing 'Veteran of the Molten Front'","Title awarded for completing the meta-achievement on the Isle of Thunder",
"Title awarded for acquiring 2000 [Bloody Coin]s in Timeless Isle","Title given to players that participate in the yearly Arena Tournament Realm who rank in the top 1000 after the first qualifier",
"Which title was awarded for completing 3000 quests?","Title: 'Within one raid lockout, defeat every boss in Naxxramas without allowing any member to die during any of the boss encounters in 10-player mode.'",
"Title: 'Within one raid lockout, defeat every boss in Naxxramas without allowing any member to die during any of the boss encounters in 25-player mode.'",
"Title awarded by the achievement 'Accomplished Angler'","CRZ (Cross-Realm Zones) were introduced with this patch.",
"Challenge Modes were introduced with this patch.","The Raid Finder difficulty was introduced in this patch (number, patch title or relevant raid name)",
"Mythic raid difficulty was introduced in this patch (number, patch title or relevant raid name)",
"At which patch was Flexible raid difficulty introduced? (patch number, title or relevant raid name)",
"At which patch was Mythic dungeon difficulty introduced? (patch number, title or raid name)",
"Boss quote: 'Translocation complete'","Boss quote: 'Perhaps it is your imperfections... that which grants you free will... that allows you to persevere against all cosmically calculated odds. You prevail where the Titan\'s own perfect creations have failed.'",
"Boss quote: 'The black blood of Yogg-Saron... through me!'","Boss quote: 'I am the lucid dream / the monster in your nightmares...'",
"Boss quote: 'Blades of light!'","Boss quote: 'Death be a doorway, an\' time a window.'",
"Boss quote: 'You were FOOLS to have come to this place! The icy winds of Northrend will consume your soul!'",
"Quote: 'At long last... no king rules forever my son'","Boss quote: 'You overstepped your bounds, Jin\'do. You toy with powers that are beyond you. Have you forgotten who I am? Have you forgotten what I can do?'",
"Boss quote: 'I beg you Mortals, flee! Flee before I lose all sense of control. The Black Fire rages within my heart. I must release it! FLAME! DEATH! DESTRUCTION!'",
"Which boss uses the ability 'Mark of the Fallen Champion'","Which boss uses the ability 'Create Concoction'",
"Boss quote: 'We span the universe, as countless as the stars'","Boss quote: 'It is a small matter to control the mind of the weak... for I bear allegiance to powers untouched by time, unmoved by fate.'",
"Boss quote: 'No force on this world or beyond harbors the strength to bend our knee... not even the mighty Legion!'",
"Which boss whispers: 'Your friends will abandon you'","Quote: 'Who's bad, who's bad? That's right; we bad!'",
"Quote: 'Shadows gather... ____ ___ _____ _______ ___ ___'","Who is the most famous trifling gnome whose arrogance would be his undoing?",
"Boss quote: 'Fools! These eggs are more precious than you know!'","Boss quote: 'Misery, confusion, mistrust... depravity, hatred, chaos... These are the hallmarks, these are the pillars.'",
"Boss quote: 'Men, women, and children... None were spared the master's wrath. Your death will be no different.'",
"Boss quote: 'Yes... Run... Run to meet your destiny... Its bitter, cold embrace, awaits you.'",
"Boss quote: 'I... welcome... the void's... embrace.'","Boss: 'The cavern trembles violently... an ancient beast stirs within the mists!'",
"Boss quote: 'This twisted world is beyond redemption, beyond the reach of deluded heroes. The only answer to corruption is destruction. And that begins... now.'",
"Boss quote: 'The eternal fire will never be extinguished'","Boss quote: 'Soon, mortal, soon you too shall have a blade for a prison.",
"Quote: 'Ardonsha kaikaldos; in the light, we triumph!'","Quote: 'Peace is but a fleeting dream! LET THE NIGHTMARE REIGN!",
"Quote: 'Would you kindly show me the way back to Kunlai? (sic)","Quote: 'Goodbye nearby living beings! My unique presence is requested in another dimension.'",
"Boss quote: 'What are we if not slaves in this torment?'","Quote: 'I will not forget this kindness. I thank you, Highness.'",
"Boss quote: 'Now I stand, the lion before the lambs... and they do not fear.","Quote: 'You are a treasure of Azeroth.'",
"Quote: 'Citizens of Dalaran! Raise your eyes to the skies and observe!'","Scarletleaf, once a night elf druid, came to be known as which dungeon boss?",
"The night elf warrior/druid Aryn, came to be known as which dungeon boss?","Jarlaxla, once a renowned druid of the Cenarion Circle, came to be known as which dungeon boss?",
"Complete the item name (reputation reward): ________ of the Timbermaw","Where does [Grim Toll] drop?",
"Where does [Forethought Talisman] drop?","Where does [Betrayer of Humanity] drop?","[Blood of Heroes] was needed to create which consumable?",
"There are __ slots on an Hexweave Bag","There are __ slots on a Royal Satchel","There are __ slots on an Illusionary Bag",
"There are __ slots on an Abyssal Bag","There are __ slots on a Netherweave Bag","There are __ slots on a Traveler's Backpack",
"There are __ slots on a Frostweave Bag","The Penny Pouch is a _ slot bag","Which Toy allows you to see players without clothing and armor?",
"Which Toy transforms you to an Iron Dwarf?","Which Toy transforms the caster to a member of the opposite faction?",
"Which Toy transforms the caster to a Blood Elf for a short period of time?","Where can you come across a mesmerising fruit hat that inspires you to dance even while walking?",
"The Swift Zulian Tiger used to drop from ______, High Priest of Shirvallah.","(Legacy) title: Jin'do the ______",
"Title: _____ _____ Faerlina","Title: _______ Nobundo","Title: __________ Boros","Title: _______ Taylor",
"Title: ____ Grayson Shadowbreaker","Title: _____ ________ Thalyssra","Title: Ordos, ____-___ __ ___ _______",
"Title: Chi-Ji, The ___ _____","Title: Yu'lon, The ____ _______","Title: Niuzao, The _____ __",
"Title: Xuen, The _____ _____","Title: Baristolth of ___ ________ _____","Who was Aggramar's mentor and commander?",
"Who created the Twilight's Hammer cult?","Nefarian's most powerful chromatic dragonkin minion",
"Where can you find Hazzas and Morphaz?","Jin'do the Hexxer was a high ranking member of which Troll tribe?",
"Lord Itharius is a member of which Dragonflight?","For him, 'the wheel of death has spun so many times...'",
"What race is Chromaggus?","Grizzlemaw is in which zone?","Grizzleweald is in which zone?",
"Shal'Aran is in which zone?","Shal'Aran is in which continent?","Bashal'Aran was in which zone?",
"Bashal'Aran was in which continent?","Ameth'Aran is in which zone?","Ameth'Aran is in which continent?",
"The Suntouched Pillar is in which zone?","Jintha'Alor is in which zone?","Shadowfang Keep is in which zone?",
"The Deadmines are in which zone?","In which zone is Windrunner Village?","Where is Thoradin's Wall?",
"'Faol\'s Rest' in Tirisfal Glades is a tribute to which famous character? (full name)",
"'Galen\'s Fall' in Arathi Highlands is a tribute to which famous character? (full name)",
"Thoradin\'s Wall is a tribute to the warlord of which human kingdom?","Bael\'dun digsite can be found in which zone?",
"Hammertoe's digsite can be found in which zone?","Bael Modan can be found in which zone?",
"Agmond's End is in which zone?","The Dead Mire is in which zone?","The Feralfen and the Umbrafen can be found in which zone?",
"Name the Alliance outpost in Shadowmoon Valley, Outland","Name the Horde outpost in Shadowmoon Valley, Outland",
"Name the exclusively-Alliance outpost in Terokkar Forest","Name the exclusively-Horde outpost in Terokkar Forest",
"Name the Alliance outpost in the Arathi Highlands","Name the Horde outpost in Hillsbrad Foothills",
"The Sea of Cinders is in which zone?","Fizzcrank Airstrip is in which zone?","Stars' Rest is in which zone?",
"The Ruins of Isildien are in which zone?","Oneiros is in which zone?","Mannoroc Coven is in which zone?",
"Malaka'jin is in which zone?","The Shado-pan Monastery is in which zone?","Tian Monastery is in which zone?",
"What is the area named after the progenitor of dragonkin, Galakrond, called?","Which zone is Northwest of Uldum and South of Feralas",
"Which zone is bordered by Mount Hyjal, Darkshore, Winterspring and Ashenvale?","The quest 'Gnomebliteration' takes place in which area?",
"The quest 'Gnomebliteration' requires you to kill how many gnomes?","Where is Land's End Beach?",
"Shadowprey Village is the sole Horde flightpath for which area?","Razorfen Downs is in which zone?",
"Razorfen Kraul is in which zone?","Zone: Snow, hard soil and steam pools.","Zone: Jungle, dinosaurs and lava plumes.",
"Zone: Jungle, troll ruins and pirates.","The renegade Colonel Kurzen found refuge in which zone after he was consumed by foul magic?",
"The Maiden's Fancy connects Ratchet to which port?","The Maiden's Fancy connects Booty Bay to which port?",
"Where is Earth Song Falls located?","Where can you find Zaetar's grave?","Where is Winterax Hold?",
"What was the Alliance-only Quest item that transformed you into a Furbolg called?",
"Name one of the Hunter Artifact weapons.","Name one of the Mage artifact weapons.","Which year did the Warcraft movie come out?",
"What is the max number of Legion legendaries you can equip?","Who was the director of the Warcraft movie?",
"First Arcanist _________","This mana tree is a type of magical tree that balances nature and arcane magic by feeding on ley lines. Its fruit was used to free the Nightfallen from their addiction to the Nightwell.",
"The capital city of the Night Elves, located at the edge of the Well of Eternity and home of Queen Azshara.",
"Who voices Thrall and King Varian Wrynn?","The Naga loyal to Queen Azshara constructed their capital city of ________ under the Great Sea, near the eye of the Maelstrom.",
"This faction is a coalition of all class orders formed in order to defeat the Burning Legion at the Tomb of Sargeras. Their base of operations is located on the Broken Shore.",
"Name one of the main Legion factions on the Broken Isles.","Who is the leader of the Wardens?",
"Who assassinated King Llane Wrynn I?","This dragonflight was created by Nefarian's magical experiments, using the blood of dragons from the other dragonflights.",
"This largely autonomous branch of the Cenarion Circle is working specifically to undo the corruption in Felwood.",
"What is the male counterpart of the Banshee called?","Sylvanas Windrunner had a younger brother whose name was ______",
"The first and only human 'Ranger Lord', trained by the high elves of Quel'Thalas. He died and became undead during the Third War, joining Sylvanas' rogue Forsaken.",
"What is the name of the elite group of blood elf rangers active in Quel'Thalas, led by Halduron Brightwing?",
"What used to be the name of the starting area in Teldrassil for the Night Elves?","What is the name of the horde faction based in the Ghostlands?",
"Which boss does the mount Astral Cloud Serpent drop from?","Which boss does the mount Vitreous Stone Drake drop from?",
"Which boss does the mount Experiment 12-B drop from?","Who was the most powerful Old God during the Black Empire?",
"In which raid does the weapon Fandral's Flamescythe drop?","Which class has the talent Posthaste?",
"In which zone do you find Aggramar's Vault?","Who is known by the nickname Green Jesus?",
"In which zone can a fireside teleporter be found that takes you to Timeless Isle?",
"During which event can you loot Penny Pouch?","This ancient cave system under Mount Hyjal served as the sleeping place for druids as well as the prison vault for the Watchers.",
"Which faction rewards the Brawler's Burly Mushan Beast mount?","Name one of the Demon Hunter artifact weapons.",
"What is the name of Varian Wrynn's sword?","Where is Onyxia's Lair located?","What is the name of the primary military arm of the night elf race?",
"What is the name of the signature glaive weapon of the night elf Watchers?","In which instance do you fight the Headless Horseman?",
"The Horseman was once a Knight of the Silver Hand, but is now cursed. His name was Sir ______ _______",
"'Where are you Tyrande? I need you!' During which quest can you hear this quote?","Who destroyed the Eye of Sargeras?",
"Name one of the Demon Hunter specializations.","Quote: 'Intimidation is a weapon of the Legion. Intelligence is not.'",
"How many classes currently exist? (Legion)","Where is Deliverance Point Located?","What is the name of the Demon Hunter order hall?",
"Who was the previous wielder of the Ashbringer?","Quote: 'Boldly said... But I remain unconvinced.'",
"Name one of the zones where warden tower pvp world quests spawn in the Broken Isles.",
"How many warden towers exist in the Broken Isles?","_______'s Apex","Which boss has the chance to drop Fathom Dweller?",
"Which is the last boss in Mogu'shan Vaults?","Which Sha do we fight in Siege of Orgrimmar?",
"Which secondary profession has an Artifact in Legion?","Name one of the two closest advisors to Anduin Wrynn.",
"What is the name of Tyrande Whisperwind's owl companion?","What is the name of Tyrande Whisperwind's saber cat?",
"Who is the leader of the Coilfang Naga?","Quote: 'Don't look so smug! I know what you're thinking, but Tempest Keep was merely a setback.'",
"What is the reward for fishing up all the coins in the Dalaran fountain? (WoTLK)","What is the name of the achievement rewarded for fishing up all the coins in the Dalaran fountain? (Legion)",
"Who do you attempt to rescue inside Darkheart Thicket?","Which class has 4 specializations?",
"Name a class that can obtain a class specific mount.(pre-Legion)","Name one of Kalec's girlfriends.",
"Name one of the biggest Mary Sues in the history of Warcraft.","Name a Warcraft novel that has a single word for its title.",
"Tirion Fordring once defended an orc that later became a close friend and joined him in the Northrend campaign. What was the orc's name?",
"Quote: 'Sometimes the hand of fate must be forced.'","How much Artifact Power does Concordance of the Legionfall cost?",
"Where can Wrathion be found during the WoD campaign?","At the end of this WoD dungeon you fight a boss in the outskirts of Stormwind.",
"Quote: 'No more play?'","Where is the Druid class order hall located?","Where is Nighthaven?",
"This Night elf's son died during the The War of the Shifting Sands.","Name one of Azshara's titles/epithets.",
"Name one of Deathwing's names/titles.","Quote: 'To fully prepare for a world of perfection, all the imperfect must be swept away.'",
"Who is said to be the weakest of the Old Gods?","What was Onyxia's name in her human guise?",
"In which raid do you fight both Nefarian and Onyxia?","Who charged Alexstrasza with protecting life and gave her a portion of her power?",
"What is Alexstrasza's nickname according to Chromie?","What is Chromie's real name?","This place is considered holy ground for the dragonflights.",
"What is the name of the black dragon residing in Highmountain?","True/False: Wrathion is the last black dragon alive.",
"Where is the main auction house located in Stormwind?","Where is the Blasted Lands portal located in Orgrimmar?",
"Who was the last boss (rank 9) of the Brawler's Guild during season 1?","Who was the first boss (rank 1) of the Brawler's Guild during season 1?",
"In which zone can you find children attempting to perform a dark ritual?","'In the sleeping city of ________ walk only mad things.'",
"Item: 'The fish know all the secrets. They know the cold. They know the dark.'","Where in Tirisfal Glades do Faerie dragons converge around a mushroom ring to sing to one another, lighting up the forest with their strange ritual?",
"Where was Invincible buried?","What is the name of the T20 Demon Hunter set?","What is the name of the T20 Hunter set?",
"______ Vision of Sargeras","Vol'jin was the leader of which Troll tribe?","The Blood elves have been fighting against which Troll tribe for millenia?",
"Quote: 'To find him, drown yourself in the circle of stars.'","Name one of the Old Gods.",
"Who created the Old Gods?","Quote: 'Your will betray your friends.'","What kind of Archaeology Fragments does Puzzle box of Yogg-saron require in order to be solved?",
"Who was Illidan's beloved?","Who was Illidan's mentor and first leader of the Kaldorei Resistance?",
"Who is the leader of the Nightfallen?","What is the symbol of the Nightborne rebels?",
"Which faction rewards the Llothien Prowler?","_______ is both a zone and a city.","What was the name of the capital of the Night Elf empire before the Sundering?",
"_______ is both a zone and a Queen.","Name one of the factions residing in Shattrath.",
"Which was the main faction in Isle of Quel'danas?","In which Outland zone can you gather Apexis crystals?",
"Who is the current leader of the Blood elves?","Who is the current leader of the Gnomes?",
"Which Alliance city serves as a capital for two races?","Where can you find a Grimtotem Elder during Lunar Festival?",
"In which zone does the Sprite Darter Hatchling companion drop?","'King of the Gordok' buff can be gained in which instance?",
"Title: Raise 60 reputations to Exalted.","Where can Aviana be found?","In which instance do you fight aboard a moving train?",
"Which troll tribe resurrected the Thunder King?","Which mount can be obtained in Shadowfang Keep during the Love is in the Air holiday event?",
"Which achievement rewards Violet Proto-drake?","'The ice stone has melted! _____ your strength grows no more! Your frozen reign will not come to pass!'",
"Who is the leader of the ghost elf faction in Azsuna?","What does Magna mean?","How many order halls have their entrances in Dalaran?",
"Where is the Celestial Planetarium located?","What does Khadgar mean in dwarvish?","What does Bael Modan mean?",
"Which seasonal event celebrates the hottest season of the year?","What is the primary language of the Horde races?",
"What is the primary language of the Alliance races?","Name one of the known Guardians of Tirisfal.",
"Which class can speak in 3 languages?","Name one of the prime Keepers of Ulduar.","Which titan is imprisoned beneath the Throne of Thunder?",
"What is the name of the instance dungeon located in Orgrimmar?","What is the name of the instance dungeon located in Stormwind?",
"Which class can be created by any primary race? (Legion)","Quote: 'To ask why we fight, is to ask why the leaves fall. It is in their nature. Perhaps, there is a better question.'",
"Quote: 'Hush, Tyrande!'","The ______ _______ is the central fortress of Dalaran which houses the Eye of Dalaran, the Grand Library as well as the Arcane Vault.",
"Name a member of the Council of Six (past or present).","What is the name given to the Kirin Tor high council of Dalaran?",
"Which sha can be found inside Heart of Fear?","What kind of legendary item could be obtained during the Pandaria campaign?",
"Name one of the August Celestials.","Who is the last boss of the Burning Crusade expansion?",
"Xuen the _____ _____","In her youth, Jaina Proudmoore was in a relationship with ______ ________",
"Who is the leader of the Cult of the Damned?","Which raid instance was a part of both Vanilla WoW and WotLK?",
"Who was the aspect of the blue dragonflight during the Northrend Campaign?","Where can the Focusing Iris usually be found?",
"Quote: 'But the truest victory, my son, is stirring the hearts of your people. I tell you this, for when my days have come to an end, you shall be King.'",
"Who was the prime consort of Malygos?","Who is the leader of the Knights of the Ebon Blade? (WotLK)",
"The Argent Crusade and the Knights of the Ebon Blade merged to form which faction?",
"Which dragon shrine is located east of the Wyrmrest Temple?","Anub'arak was also known as the _______ ____",
"Who is the leader of the Shado-Pan?","What does the acronym VotW stand for?","What does the acronym RFK stand for?",
"Esarus thar no'Darador = '__ _____ ___ _____ we serve.'","What does the name Garrosh mean?",
"What does 'Lok-tar ogar' mean?","Who was the last emperor of Pandaria?","What does the acronym CoEN stand for?",
"'Let our enemies know our names. Let our allies honor our passing. We are the ____ __ ______.'",
"Which race features the 'Aberration' passive that reduces shadow and nature damage taken?",
"How many major zones does Outland have?","Uldaman is located in which zone?","Who was warchief of the Horde when the First War began?",
"Gronnstalker's Armour is a raid tier set for which class?","Nemesis Raiment is a raid tier set for which class?",
"Who was the last Pandaren emperor of Pandaria?","How many major zones does Northrend have?",
"What is one of the three dungeons available to level 15 characters through the dungeon finder feature?",
"Which legendary item can be obtained in the Sunwell?","What was the name of Kel'thuzad's pet cat?",
"How many fragments of Val'anyr do you need in order to craft the legendary mace?","Quote: 'The hope for future generations has always resided in mortal hands. And now that my task is done, I will take my place... amongst the legends of the past.'",
"Medivh means 'Keeper of secrets' in which language?","Who was known as the 'Lion of Azeroth'?",
"Quote: 'You've taken everything I've ever cared for, Arthas. Vengeance is all I have left.'",
"What does the acronym IoC stand for?","The _________ are the primary body responsible for maintaining law and order in the city of Suramar.",
"What does 'draenei' mean?","What currency is used to purchase legacy PvP weapons and armor?",
"Kaldorei means ________ __ ___ _____ in their native tongue of Darnassian.","Which Titan keeper do you fight inside the Halls of Lightning?",
"True/False: Kael'thas Sunstrider was a member of the Council of Six.","Where are the entrances to Obsidian Sanctum and Ruby Sanctum located?",
"Which legendary item set can be obtained in the Black Temple?","'An ________! What are you hiding?'",
"Who is depicted on the cover of World of Warcraft: Chronicle Volume 1?","Medivh the ____ ________.",
"Mage Tower, Command Center and ______ _________","Where can a statue depicting Anduin Lothar be found?",
"______, Xavaric's Magnum Opus","Which battleground has the lowest level requirement?",
"Name one of the battlegrounds that were introduced in Mists of Pandaria.","_______ the Ice Watcher",
"During which seasonal event could you decorate your Draenor garrison?","Where is Auchindoun located?",
"Achievement: Slay the leaders of the Alliance.","Achievement: Kill High Priestess Tyrande Whisperwind.",
"Achievement: Damage High Overlord Saurfang until he humors you by pretending to die.",
"Who did Grand Warlock Wilfred Fizzlebang summon by mistake in Trial of the Crusader?",
"This band has performed in Shattrath, Blackrock Depths and the Darkmoon Faire.","What is the name of the Forsaken death metal band performing in Darkmoon Faire?",
"Where can you buy Inky Black Potion?","Quote: 'Knowledge is power, but using it wisely is the key.'",
"Name a member of the Elite Tauren Chieftain band.","Spell: Allows you to see enemies and treasures through physical barriers, as well as enemies that are stealthed and invisible. Lasts 10 sec.",
"The Holy Paladin hidden artifact appearance (The Watcher's Armament) is inspired from which Blizzard game?",
"Quote: 'Not all who wander are lost.'","Who's missing: Aggramar, Sargeras, Khaz'goroth, [...] , Eonar, Golganneth and Aman'Thul.",
"What's missing: Tears of Elune, Hammer of Khaz'goroth, [...], Eye of Aman'thul, Tidestone of Golganneth",
"What does Teldrassil mean?","In which zone could lake Al'Ameth be found?","Where are the Stormrage Barrow Dens located?",
"What's missing: Demon Hunter - Warglaives, [...], one-handed axe, and one-handed sword.",
"What's missing: Mage - Staff, [...], Dagger, One-handed Sword and held in off hand.",
"___________, Tarecgosa's Rest","The _________ is a font of incredible power created by the Highborne and sustained through the Eye of Aman'thul.",
"What is the name of the song sung by Sylvanas Windrunner and her Highborne Lamenters after giving her the locket from her sister Alleria?",
"What is the name of the Legion Hunter class order?","What is the leader of the Warrior class order called?",
"What is the leader of the Priest class Order called?","What is the starting title for all characters of the Demon Hunter class?",
"True/False: You can find Auctioneers only at Valley of Strength and Valley of Honor in Orgrimmar.",
"What is the max level a companion pet can reach?","True/False: The Frost Death Knight hidden artifact appearance (Dark Runeblade) can be obtained from the Lich King in Icecrown Citadel.",
"Faction: 'We are the watchers on the wall. We are the sword in the shadows.'","What is the name of the NPC sending you lost items and currency via mail?",
"Quote: 'I will show you the justice of the grave and the true meaning of fear.'","What is the name of the Rogue class Order Hall?",
"Name one of the items that can be obtained when you kill the Lich King with a player wielding Shadowmourne in the raid.",
"Name one of the bosses that can be found in the Construct Quarter of Naxxramas.","How old is Khadgar by the time of Legion?",
"True/False: Marksmanship Hunters can have active pets.","In this zone, Horde and Alliance forces battle furiously for control of an ancient Titan stronghold.",
"Where is the Draenor player garrison located?","What was the name of the Blood Elf kingdom?",
"Quel'Thalas was also known as the ____ __ _______ ______.","Achievement: Emote /hug on a dead enemy before they release corpse.",
"Spirit Healers are uncorrupted ______ who chose to remain in the Shadowlands and assist the dead in returning to the land of the living.",
"What was the name of Hellfire Peninsula in original Draenor?","Who is the last boss of the Trial of the Champion dungeon?",
"Achievement: Defeat the Whale Shark in Vashj'ir (despite or perhaps because of the fact that he drops no loot).",
"Where is Light's Hope Chapel located?","In which zone can you find the Dead Scar?","What was the name of the fictional legendary sword featured in the South Park episode 'Make Love, Not Warcraft'?",
"During which seasonal event can you summon the demon boss Omen in Moonglade?","Quote: 'Citizens of Dalaran! Raise your eyes to the skies and observe!'",
"During the final battle of the Third War, thousands of these creatures sacrificed themselves to destroy the demon lord Archimonde and save the world.",
"What was Outland originally called?","Name one of the instances located in Auchindoun. (Outland)",
"Quote: 'Sacred vines, entangle the corrupted!'","Name one of the notorious guitar look alike two-handed weapons.",
"Which mount was rewarded from the Hearthstone promotion for winning 3 games?","What was the title rewarded for defeating Kanrethad Ebonlocke and gaining command over fel energy before the expedition to Draenor set out?",
"What is the name of the Alliance Draenor garrison?","What is the name of the Horde Draenor garrison?",
"What does Sylvan elixir transform you into?","What is the name of the secret organization located in Stormwind's Old Town?",
"Name one of the celestial pets that can be obtained in the Celestial Tournament hosted on the Timeless Isle.",
"What does Thas'dorah mean?","What is the name of the song that can be added to your garrison jukebox by looting the Music roll from the Lich King?",
"What is the name of the song that can be added to your garrison jukebox by looting the Music roll located in the Warden's Cage in Shadowmoon Valley on Outland?",
"What is the name of the song playing inside the Temple of the Moon in Darnassus?","Name one of the mounts that need to be collected in order to complete the achievement 'Awake the Drakes'.",
"Achievement: Unlock a class armor set from 10 different raid tiers or PvP seasons.",
"How many Heirlooms do you need to acquire in order to obtain the Heirloom mount?","Achievement: Kill 5 flag carriers in a single Eye of the Storm battle.",
"Name one of the PvP Arena instances.","What is the name of the extremely rare fish that can be caught in Orgrimmar?",
"What is the name of the extremely rare fish that can be caught in Ironforge?","With which profession can you craft Tomes of Illusion?",
"Achievement: Get killed by Deathwing.","What is the title rewarded for getting 100000 honorable kills?",
"The first members of the ________ were volunteers from the Sisterhood of Elune.","The enchanted Keepers of the Grove, who protect the woodlands of Azeroth, are offsrping of the demigod ________.",
"What is the name of the order of priestesses dedicated to the worship of the moon goddess, Elune?",
"Which dragonshrine is the only one you can't visit during the 'Deaths of Chromie' scenario?",
"True/False: Mechanical type monsters can be tamed by hunters.","How many minutes does the 'Deserter' debuff last?",
"How many minutes does the 'Dungeon Deserter' debuff last?","The Warsong Gulch battleground takes place in which zone?",
"Which planet is usually referred to as the Burning Legion's homeworld?","Name one of Broxigar's titles.",
"What was Deathbringer Saurfang's name while he was alive?","Who is the brother of High Overlord Saurfang?",
"What is the name of the starting area for the Blood Elf race?","What is the name of the starting area for the Tauren race?",
"Name a holiday mount that can be obtained during Brewfest from Coren Direbrew.","Which WoW seasonal event is loosely based on the Bavarian Oktoberfest?",
"Achievement: Get 20 killing blows without dying in a single battleground.","Pilgrim's Bounty is a seasonal event that occurs during which month?",
"During this world event, the people of Azeroth gather in graveyards to celebrate and cherish the spirits of those they have lost. One can find the festivities in the cemeteries of any major city.",
"The Klaxxi are a faction located in _____ ______ that are sworn to protect the ideals of the Mantid Empire.",
"What is the Secondary resource used by Monks?","Which class can use Rage as a resource mechanic?",
"Who was Jaina Proudmoore's mentor?","Name one of the Primary Resources used by player classes.",
"Name one of the Secondary Resources used by player classes.","Which class can use Energy as a resource mechanic?",
"What is the Primary Resource used by Demon Hunters?","Name one of the Ways of Pandaren cooking.",
"Spires of Arak is the homeland of which race?","In which language does Shan'do mean 'Honored teacher'?",
"Staff of the Redeemer is a look-alike of which leader's weapon?","Achievement: Complete the Argus campaign.",
"What is the title rewarded for completing the achievement 'Paragon of Argus'?","Who is Thorim's father?",
"Which artifact weapon used to belong to Thorim?","Quote: 'Interlopers! You mortals who dare to interfere with my sport will pay... Wait--you... I remember you... In the mountains...'",
"The Arms Warrior hidden artifact appearance is styled after ________'s axe.","How many battlegrounds exist? (Legion)",
"In which expansion was Resilience removed?","In which expansion was Reforging added?",
"Transmutation Master is a specialization that can be obtained with which profession?",
"With what profession can you craft mount saddles?","What is the name of the dungeon located on Argus?",
"Which city was called the 'Jewel of Argus'?","Name one of the members of the Second Duumvirate.",
"Naralex could be found sleeping at the end of which dungeon?","True/False: Moira Bronzebeard could be found and killed inside Blackrock Depths.",
"This organization is dedicated to researching the origin of the dwarven race.","The _________ is a blood elven organization dedicated to the acquisition of powerful magical artifacts and studying the past, serving as the Horde counterpart to the Explorer's League.",
"True/False: Underlight Angler has no artifact recolors.","Who do you fight outside of Ulduar after accepting the 'Celestial Invitation' ?",
"The ____ ______ were charlatan merchants who were cursed by Medivh for trying to sell fraudulent magical artifacts.",
"What was the name of the human knight of Stormwind who discovered that Katrana Prestor was the black dragon Onyxia?",
"What is the name of the legendary orc-slaying hammer that used to belong to Marshal Windsor?",
"What is the name of the dimensional ship created by the draenei in order to return to their homeworld of Argus?",
"Light's Heart is the core of the naaru prime _____.","Light's Heart was unlocked by using the ____ __ _____.",
"True/False: Gryphons and Wyverns can be tamed by Hunters.","Which class has a raven as its class mount?",
"How many class specific mounts can be obtained by Paladins?","What is the name of the Horde gunship flying over Icecrown?",
"What is the name of the Horde gunship flying over Icecrown?","Players can talk to Zidormi and enter a scenario that allows them to see _________  or ____ __ ________ as they appeared before they were destroyed. (Answer 1 of the 2)",
"Which is the most expensive mount in the game? (Legion)","What was Thrall's real name?",
"How many days does a Fel-Spotted Egg need in order to hatch?","True/False: In Legion, Honor is used to purchase PvP armor and weapons.",
"Which was the first tameable Spirit Beast added in the game?","_______ is  one of the Loa goddesses of the Drakkari and Loque'nahak's mate. Her altar can be found in Zul'Drak.",
"The ____ _____ were an elite group of night elf sorcerers who served as protectors and peace-keepers in the ancient Kaldorei Empire.",
"Where is the Moon Guard's main base of operations located?","Usually, how many World Quests must be done in order to complete one of the daily Broken Isles Emisarry Quests?",
"Name one of the factions residing on Argus.","Who is the leader of the Grand Army of the Light?",
"Name one of Turalyon's mentors.","Item: Request a pickup to the nearest flight master. Only usable in Broken Isles. (5 Min Cooldown)",
"The watcher Mimiron constructed _____ _________ as part of his V0-L7R-0N weapons platform.",
"This imposing fire giant toils over the Colossal Forge, creating the armies that would destroy Azeroth in Yogg-Saron's name.",
"Razorscale, once the broodmother of the proto-drakes of the Storm Peaks, was captured by Loken and twisted into a vicious weapon. She was once known as _______.",
"In which zone did the South Sea Pirates had one of their ships sunk by a giant whale shark?",
"In Badlands there is a quest who has you punching a certain powerful entity in the face. Who do you punch?",
"Name one of the Cataclysm Timewalking Dungeons available during the event.","Which mount has a chance to drop from any Timewalking dungeon boss?",
"What is the name of the Death Knight ability that allows them to emblazon their weapons with runes?",
"Murozond <The Lord __ ___ ________>","Boss quote: 'To repeat the same action and expect different results is madness.'",
"In which patch was MoP Timewalking introduced?","Which zone is considered the current home of the Grimtotem tauren clan?",
"Name one of the Alliance allied races.","Name one of the Horde allied races.","How many confirmed World Trees are there?",
"Name one of the known World Trees.","Which was the original World Tree?","The Great Trees usually act as portals to the _______ _____.",
"What were the Night Elf druids who became the first worgen called?","The ___ __ ___ _____ was a conflict fought between the Night Elves and the former Night Elves and now demons, seven hundred years after the War of the Ancients.",
"In Stranglethorn Vale there is a questline involving a baby raptor. Where can you obtain that specific raptor as a companion pet after the questline is over?",
"What do you use instead of the actual 'Head of Fleet Master Seahorn' in order to trick the Bloodsail Buccaneers in the Cape of Stranglethorn?",
"Who is the leader of the Bloodsail Bucaneers?","_______ the Burning Throne.","The Dwarves named their home Khaz Modan in honor of ___________.",
"Who is the Titan Keeper of Celestial Magics and Lore?","What is the name of Aggramar's flaming sword?",
"What is the name of the Protection Warrior hidden artifact appearance?","Which song is the theme for both the Warrior and Paladin order halls?",
"If Taeshalach is ever combined with Gorribal, __________, Sargeras' greatsword will be reborn.",
"Who was the leader of the Dark Riders of Deadwind Pass?","Name one of the protagonists of the 2018 animated shorts 'Warbringers'",
"Name one of the protagonists of the 2016 animated shorts 'Harbingers'","What was the name of the first animated WoW series?",
"How many class specializations exist as of BfA?","Name one of the specializations eligible for the Mage Tower challenge 'An Impossible Foe'. (Agatha)",
"Name one of the specializations eligible for the Mage Tower challenge 'Feltotem's Fall'. (Tugar Bloodtotem)",
"__________, Longbow of the Ancient Keepers","_________, Stave of the Ancient Keepers",
"What is the name of the eccentric Archmage living in a secluded tower in Azshara?",
"What was the name of the author who wrote the book 'War Crimes?'","What was the name of the author who wrote the 'War of the Ancients' trilogy?",
"Who is depicted on the cover of the third volume of WoW: Chronicle?","Who is the wielder of Taeshalach?",
"What does Taeshalach mean?","Where can the Scythe of the Unmaker be obtained?","Argus ___ _______",
"Name one of Magni Bronzebeard's titles","Quote: 'I speak for Azeroth.'","Who forged the Ashbringer?",
"Who shared his named with the legendary sword Ashbringer?","The _____ _____ is an anvil that is located in the heart of Ironforge.",
"Item: 'The Knights of the Ebon Blade reside in Acherus, the Ebon Hold. They were once the champions of the scourge. They are now the damned.'",
"Item: 'The Earthen Ring reside in the Heart of Azeroth. They wield the power of the elemental forces between which they maintain balance. They are the true masters of the elements.'",
"This currency is used by Arcanomancer Vridiel in Dalaran above the Broken Isles to create or upgrade Legion Legendary items.",
"Name one of the Horde faction leaders. (BfA)","Name one of the Alliance faction leaders. (BfA)",
"The Stormrage Barrow Dens are named after _________ _________.","The Stormrage Barrow Dens are the sacred barrow dens of  _________, where many of the Night Elf druids slumber in the Emerald Dream.",
"Name one of the Timewalking raids available. (Legion)","Name one of the bosses that can be found and killed in 'The Siege' area of Ulduar.",
"The Alliance equivalent of the Sunreavers is the ______ ________.","Name one of the expansions where the initial loading screen didn't feature a portal.",
"Name one of the factions that were introduced on Argus.","What is the name of the currency used in The Underbelly of Dalaran? (Legion)",
"Currency: 'A rough, hand-minted coin. It bears a symbol similar to that of the Kirin Tor, with one key difference: the eye is closed.'",
"What is the name of the Underbelly Guard Captain?","Which mount is rewarded by completing the achievement 'Underbelly Tycoon'?",
"What was the maximum item level an item could have during Legion?","Shaohao had defeated all of the Sha, except for one - the ___ __ _____.",
"Which class didn't get new spell cast animations until the release of BfA?","What is the official title of the ruler of Kul'Tiras?",
"Name one of the four noble houses that rule over Kul'Tiras.","Which dungeon needs to completed in order to finish the Alliance main storyline quest in BfA?",
"Name a dungeon that can not be completed on Normal difficulty in BfA.","True/False: Horde players must complete a questline in order to attune to Siege of Boralus.",
"What is the official title of the chief commander of the Alliance navy?","What is the name of the navy of the Scarlet Crusade?",
"What is the name of the mortal disguise of the dreadlord Mal'Ganis?","Quote: 'I am _________. I AM ETERNAL!'",
"What is the name of the homeworld of the Nathrezim?","Taking into account the recolored versions, how many skins exist for a single artifact weapon?",
"What is the name of the Battle for Azeroth bonus roll item?","What was the original name of the once proud Highborne city Dire Maul?",
"Who is nicknamed the 'Daughter of the Sea'?","Quote: 'I heard, I heard, across a moonlit sea, the old voice warning me: [...] - Jaina Proudmoore'",
"Dire Maul East is also known as ________ _______.","Prince Tortheldrin is the end boss of which dungeon?",
"What does Shen'dralar mean?","The Shen'dralar were a secretive Highborne society who dwelled in the _________ within Dire Maul.",
"True/False: World of Warcraft no longer requires a game purchase to play, just a subscription.",
"True/False: The Death Knight specialization 'Blood' was originally a damage specialization.",
"True/False: BfA Collector's Edition contained an art book.","Name one Hero Class.","How many Timewarped Badges do timewalking-exclusive mounts usually cost?",
"Who voices Jaina Proudmoore?","Who voices Sylvanas Windrunner?","The War of the Thorns is also known as the _______ __ __________.",
"ADP is used as chronological reference. It is a shorthand for _____ ___ ____ ______.",
"The Blood War is also known as the ______ ___ _______.","True/False: The Scrapper was introduced in Legion.",
"Which device allows weapons and armor of uncommon quality or higher to be broken down into base components?",
"The _____ __ _______ notably put an end to negotiations between King Varian Wrynn and Lor'themar Theron to bring the blood elves back into the Alliance.",
"The _____ __ _______ was a civil war within the Kirin Tor that took place as part of the Alliance-Horde war on Pandaria.",
"Shenqing, the ______ ____, is an ancient mogu artifact. It was eventually shattered during a showdown between Garrosh and Anduin Wrynn in Pandaria.",
"The _____ __ ___ ______ ______ is the order of monks succeeding the order based out of the Peak of Serenity in Pandaria.",
"Quote: 'There are many secrets both mysterious and divine, you have yours and I have mine.'",
"_____ __ ___ is a series of animated shorts telling the backstories of the prominent orc characters from Warlords of Draenor.",
"Who is the Champion of the Banshee Queen?","'So says the ______ of Xavius.'","Name one of the zones found in Northrend.",
"Name one of the zones found in the Broken Isles.","The Felstorm was a gigantic swirl of fel situated above the ____ __ ________. In reality, it served as a portal leading to the world of Argus.",
"The ______ ___ ______ _____ was an attempt by the Alliance and the Horde to stop the third invasion of the Burning Legion before it became a full-scale conflict.",
"Name one of the portals the Legion has used to get to Azeroth.","Name one of the neutral capital cities in Kalimdor.",
"Where are the Echo Isles located?","Name one of the neutral capital cities in the Eastern Kingdoms.",
"Which kind of dragons can be found in Kalimdor?","Which kind of dragons can be found in the Eastern Kingdoms?",
"Name one of the zones in which the song 'Enchanted Forest' can be heard.","Spell: 'Leap backwards.'",
"Spell: 'Exposes all hidden and invisible enemies within the targeted area for 20 sec.'",
"Spell: 'Summons a legion of ghouls who swarms your enemies, fighting anything they can for 30 sec.'",
"Spell: 'Summons a rune weapon for 8 sec that mirrors your melee attacks and bolsters your defenses. While active, you gain 40% parry chance.'",
"Spell: 'Reduces your falling speed. You can activate this ability with the jump key while falling.'",
"Spell: 'Transform to demon form for 15 sec, increasing current and maximum health by 30% and Armor by 100%.'",
"Spell: 'Activates Cat Form and places you into stealth until cancelled.'","Spell: 'Infuse a friendly healer with energy, allowing them to cast spells without spending mana for 12 sec.'",
"Spell: 'Roots the target in place for 30 sec. Damage may cancel the effect.'","Spell: 'Increases your mana regeneration by 750% for 6 sec.'",
"Spell: 'Infuses the target with brilliance, increasing their Intellect by 10% for 60 min. If target is in your party or raid, all party and raid members will be affected.'",
"_________ Sound","Specialization: 'Takes on the form of a great cat to deal damage with bleeds and bites.'",
"Name a hybrid class.","Name a pure class.","Specialization: 'A master of chaos who calls down fire to burn and demolish enemies.'",
"Specialization: 'A master archer or sharpshooter who excels in bringing down enemies from afar.'",
"Specialization: 'Ignites enemies with balls of fire and combustive flames.'","Specialization: 'A dark stalker who leaps from the shadows to ambush his or her unsuspecting prey.'",
"What is the name of the mount purchasable only by Death Knights?","Specialization: 'An icy harbinger of doom, channeling runic power and delivering vicious weapon strikes.'",
"Specialization: 'A righteous crusader who judges and punishes opponents with weapons and Holy magic.'",
"Specialization: 'A martial artist without peer who pummels foes with hands and fists.'",
"Specialization: 'A totemic warrior who strikes foes with weapons imbued with elemental power.'",
"Who was the first of the Draenei shaman?","Farseer Nobundo was a former __________.","Specialization: 'Uses magic to shield allies from taking damage as well as heal their wounds.'",
"Specialization: 'A battle-hardened master of two-handed weapons, using mobility and overpowering attacks to strike <his/her> opponents down.'",
"Spell: 'Turns your skin to stone, increasing your current and maximum health by 20%, and reducing damage taken by 20% for 15 sec.'",
"Spell: 'Roll a short distance.'","Spell: 'Grants immunity to all damage and harmful effects for 8 sec. Cannot be used if you have Forbearance. Causes Forbearance for 30 sec.'",
"Spell: 'Blesses a party or raid member, granting immunity to movement impairing effects for 8 sec.'",
"Spell: 'Pulls the spirit of a party or raid member, instantly moving them directly in front of you.'",
"Spell: 'Infuses the target with vitality, increasing their Stamina by 10% for 60 min. If the target is in your party or raid, all party and raid members will be affected.'",
"Spell: 'Conceals you in the shadows until cancelled, allowing you to stalk enemies without being seen.'",
"Spell: 'Invoke ancient symbols of power, generating 40 Energy and increasing your damage done by 15% for 10 sec.'",
"Which mount is rumored to be chiseled from the same rare mineral as hearthstone themselves?",
"True/False: Lorewise, hearthstones are very rare objects.","What does the rune on a hearthstone mean?",
"Where was Vol'jin's hearthstone bound to?","Spell: 'Shift partially into the elemental planes, taking 40% less damage for 8 sec.'",
"Spell: 'Summons a totem at the target location that gathers electrical energy from the surrounding air and explodes after 2 sec, stunning all enemies within 8 yards for 3 sec.'",
"Spell: 'Hardens your skin, reducing all damage you take by 40% and granting immunity to interrupt and silence effects for 8 sec.'",
"Spell: 'Strikes fear in the enemy, disorienting for 20 sec. Damage may cancel the effect. Limit 1.'",
"Spell: 'Transform into a colossus for 20 sec, causing you to deal 20% increased damage and removing all roots and snares.'",
"Spell: 'Increases the attack power of all raid and party members within 100 yards by 10% for 60 min.'",
"Name one of the herbs that can be found in Kul'Tiras or Zandalar.","Name one of the herbs that can be found in the Broken Isles.",
"Both the ward of House Proudmoore and a member of the Proudmoore Guard, ______ is also the squire of Cyrus Crestfall, a former knight.",
"The Rank 3 Perk for Felwort allows you to grow herbs by looting seeds and placing them in _______ ____ near a source of water.",
"____________ is a herb native to Eversong Woods. It grows in and around areas of blood elf magical activity and can be used to increase spell power by a small amount.",
"True/False: Only Blood Elves can consume the herb Bloodthistle.","______ _________ was the last known leader of the Syndicate and the Crown Prince of Alterac.",
"Which area is the Syndicate based in?","The _________ is mostly a human criminal organization led by villainous nobles of the now fallen kingdom of Alterac.",
"Toy: 'Smells faintly of peppermint kisses and murder, two of Singer's favorite things.'",
"What color are the masks worn by members of the Syndicate?","What is the name of the only remaining spellbook written by Medivh?",
"Name one of the items Nerzhul used in order to open the rifts that ultimately destroyed Draenor.",
"Name one of the addictive herbs found on Azeroth.","What was the name of the secret sect founded by the Kirin Tor of Dalaran to spy on Medivh, in his tower of Karazhan?",
"The ______ ______ is one of a series of 4 rings that a player may earn from The Violet Eye faction. The ring gets more powerful the higher the player's standing is.",
"The  ___ __ _______ is a device that was created by the mages of Dalaran to focus their magic in an effort to reconstruct the Violet Citadel. Ner'zhul would later use it alongside other artifacts to open dimensional rifts to countless worlds.",
"Name one of the former main leaders of the Council of the Black Harvest.","Where did the battle between the Guardian Aegwynn and the avatar of Sargeras take place?",
"_______ is a strange, fickle and powerful entity of pure arcane energy hailing from another plane of existence. It was eventually defeated by the Guardian Aegwynn and bound to an enchanted greatstaff.",
"How many pieces was Atiesh, Greatstaff of the Guardian shattered into?","What was the name of Magna Aegwynn's mentor?",
"The ______ __ _______ is a dark forest in southwestern Wintergrasp.","How many [Splinter of Atiesh] were needed in order to make [Frame of Atiesh]?",
"The Guardian of Tirisfal is also known as Guardian of the __________.","_______ Foxton was a close personal friend of Thrall during his early life as a slave of Aedelas Blackmoore. She was instrumental in aiding Thrall break free from his captivity.",
"A __________ is a prestigious song composed for a specific individual. It is commonly seen as the greatest honor the orcs can grant and can only be composed after the tale of a hero is finished, when they die.",
"___________ are ruby red gems containing a great deal of power that can only be awakened once they are fed. They feast on blood and are often used in demonic summoning.",
"Quote: 'Thrall will never be free!'","The _____ ____ are a mysterious group allied to the Syndicate in Alterac. According to Thrall, they are members of the Shadow Council.",
"True/False: Since the Shattering, Purple Lotus cannot be found in Felwood.","What is the name of the herb that can only be found near graveyards?",
"Who is the herb Gromsblood named after?","What is the name of the achievement awarded to players for completing the Kul Tiras storyline?",
"What is the name of the small mist-shrouded island located off the northern coast of Icecrown?",
"Quote: 'In this world where time is your enemy, it is my greatest ally. This grand game of life that you think you play in fact plays you. To that I say... Let the games begin!'",
"Quote: 'Uulwi ifis halahs gag erh'ongg w'ssh.'","Who was the Immolated Champion that could be seen being tortured by the Lich King in one of the visions in the Yogg-Saron encounter?",
"Quote: 'Despair... so delicious...'","Quote: 'Break yourselves upon my body. Feel the strength of the earth!'",
"Quote: 'I was away for too long. My absence cost us the lives of some of our greatest heroes. Trash like you and this evil witch were allowed to roam free -- unchecked.'",
"Quote: 'Spirits of wind, carry to Saurfang the Younger the song of war! May ALL of our fallen brethren be vindicated by this battle!'",
"Quote: 'There is no good. No evil. No Light. There is only POWER!'","Quote: 'You landlubbers are tougher than I thought. I'll have to improvise!'",
"Quote: 'None may challenge the Brotherhood!'","Quote: 'Ah-hah! Another chance to test my might.'",
"Quote: 'I saw the same look in his eyes when he died. Terenas could hardly believe it. Hahahaha!'",
"'...We are the nameless, faceless, sons and daughters of the Alliance. By the Light and by the might of the Alliance, the first strike belongs to us and the last strike is all that our enemies see. We are ___ ______.'",
"____ _____ was formerly one of Queen Azshara's handmaidens.","Name one of the locations The Dreamway connects to via a series of Dream Portals.",
"How many Keepers dwell within Ulduar?","What was the name of the historic event that allowed both Forsaken and Humans to mingle in peace and occurred after the Argus Campaign in the Arathi Highlands?",
"Achievement: 'Slew Prince Tenris Mirkblood and acquired his Vampiric Batling pet.'",
"Achievement: 'Defeat Nalak, the Storm Lord, on the Isle of Thunder.'","Achievement: 'Get caught in 10 consecutive land mine explosions in the Sparksocket Minefield without landing.'",
"Achievement: 'Defeat Magmaw in Blackwing Descent without anyone in the raid becoming infected with a parasite.'",
"Achievement: 'Bake a Delicious Chocolate Cake.'","Achievement: 'Learn the Master Riding skill.'",
"Achievement: 'Throw a snowball at Muradin Bronzebeard during the Feast of Winter Veil.'",
"Achievement: 'Successfully fish from a school.'","Achievement: 'Unmask and defeat the Black Knight at the Argent Tournament.'",
"Achievement: 'Grab the flag and capture it in under 75 seconds.' (Twin Peaks)","Quote: 'I'll rip the secrets from your flesh!'",
"Quote: 'What's this! He... he kept it? All this time, he kept it! I knew! I sensed a part of him still alive! Trapped... struggling... Oh, Arthas!'",
"Quote: 'Whether the world's greatest gnats or the world's greatest heroes, you're still only mortal!'",
"Name one of the memories Argent Confessor Paletress can summon during her encounter in the Trial of the Champion dungeon.",
"Name either of the Twin Emperors that can be found inside the Temple of Ahn'Qiraj.",
"Quote: 'A valiant defense, but this city must be razed. I will fulfill Malygos's wishes myself!'",
"Name one of the bosses that can be fought in the Violet Hold. (WotLK)","Name one of the dungeons available during the Mists of Pandaria timewalking event.",
"Name a boss that can be found in the Emerald Nightmare.","Name a class that can obtain their hidden artifact appearance in the Emerald Nightmare raid.",
"What is the reward for Honor Level 10?","What is the reward for Honor Level 250?","Which reputation do you need to be exalted with in order to unlock the Mag'har Orc Allied Race?",
"Which reputation do you need to be exalted with in order to unlock the Dark Iron Dwarves Allied Race?",
"How many Darkmoon Prize Tickets does the Darkmoon Dirigible cost?","What is the name of the fish that can be used as currency in the Darkmoon Faire?",
"Achievement: 'Collect 1000 unique pets.'","What is the name of the companion dropped by the Darkmoon Faire boss, Moonfang?",
"Name a song where the phrase 'An Karanir Thanagor' appears.","What does the phrase 'Elune adore.' mean?",
"Name one of the zones found in Kul Tiras.","Name one of the primary factions found in the Argent Tournament.",
"Who is the racial leader of the Ramkahen?","Name either piece that's part of the [Fists of the Heavens] Windwalker Monk artifact weapon.",
"'We do not fight for glory, for fame, or riches. We exist to protect those who need it most, often without reward or recognition. We are the watchers in the wild. We are the eagle on the wind. We walk the lonely road. For ours is the ______ ____.'",
"What is the name of Emmarel Shadewarden's pet eagle?","Name either of the WoW novellas that were included with the Collector's Edition of Battle for Azeroth.",
"What does 'Anu belore dela'na.' mean?","What does 'Quel'Thalas' mean?","What is the family name of the High Elves' royal bloodline?",
"Name any of the resources used in Warfronts.","Name one of the buildings that can be created while in a Warfront (as of patch 8.1)",
"Name one of the bases (outposts) in the Battle for Stromgarde warfront.","Name one of the bases (outposts) in the Battle for Darkshore warfront.",
"What is the name of the item used to chop down trees around a Warfront?","True/False: You can use Flight Master's Whistle while inside a Warfront.",
"Name one of the Commanders that can be found in the Stromgarde Warfront.","What was Stromgarde's original name?",
"The ___________ of Silvermoon (also known as the Council of Silvermoon) was the ruling power over Quel'Thalas, consisting of the seven highest lords in the kingdom.",
"Name one of the new Four Horsemen, residing in Acherus: the Ebon Hold above the Broken Isles.",
"Name one of the original Four Horsemen.","Quote: 'Prepare yourselves, the bells have tolled! Shelter your weak, your young and your old! Each of you shall pay the final sum. Cry for mercy, the reckoning has come!'",
"Name one of the factions the Headless Horseman was affiliated with when he was still alive.",
"With which profession can a player create wands?","Who is the Elemental Lord of water?",
"Name one of Ragnaros' titles.","What is the title awarded for defeating Ragnaros in Firelands on Heroic Difficulty?",
"Quote: 'Somehow you survived! No matter. Look upon our wonders, you mortals, and despair! Behold the world that shall be your tomb!'",
"Name a profession that didn't exist in Vanilla WoW.","In which year was World of Warcraft released?",
"Mount: 'A favorite unit of the Lich King, both for its power as a siege weapon, and the satisfying sound of flung meat.'",
"What was the age of Uther the Lightbringer when he died?","The ___ __ ___ _____ _______ was a series of civil wars and conflicts between the three rival dwarf clans of the city of Ironforge, originally beginning as an internal conflict to decide the ruler of Ironforge.",
"Name one of the Elemental Lords.","Mount: 'Some horses merely adopt the dark. This horse was born in it, molded by it.'",
"How many class specific mounts can be obtained by a Warlock?","How many mounts can be crafted through Engineering? (BfA)",
"Name one of the mounts that can be made through Jewelcrafting.","Name one of the mounts that can be obtained through Fishing.",
"During which seasonal event can the mount Swift Springstrider be obtained?","How many Marks of Honor do PvP mounts usually cost?",
"Name one of the Alliance PvP mounts that can be bought with Marks of Honor.","Name one of the Horde PvP mounts that can be bought with Marks of Honor."

};
TriviaBot_Questions[1]['Answers'] = {
{"Anasterian Sunstrider","Anasterian","King Anasterian","King Anasterian Sunstrider"},{"Anduin Lothar"
},{"Anduin Lothar"},{"Khadgar's Whisker"},{"Magna Aegwynn","Aegwynn"},{"Dath'remar Sunstrider","dath'remar"
},{"Magna Aegwynn","Aegwynn"},{"Baron Revilgaz"},{"Baine Bloodhoof"},{"Sylvanas Windrunner","Lady Sylvanas Windrunner"
},{"Sylvanas Windrunner","Lady Sylvanas Windrunner"},{"Muradin Bronzebeard","Muradin"},{"Falstad Wildhammer",
"Falstad"},{"Moira Thaurissan","Moira Bronzebeard","Moira"},{"Fenran Thaurissan","Fenran"},{"Bronzebeard"},{"Dark Iron"
},{"Emeriss","Lethon","Taerar","Ysondre"},{"Sargeras"},{"O'ros"},{"Dire Maul"},{"Uldaman","Annora"},{"Amber-coloured eyes","amber eyes",
"amber colored eyes","amber-colored eyes","amber coloured eyes"},{"twelve","12"},{"Winterspring"},{"Howling Fjord"
},{"Plugger Spazzring"},{"Arator the Redeemer","arator"},{"Quel'thalas","Silvermoon"},{"Marshal Windsor","Windsor"
},{"Nathanos Marris","Nathanos Blightcaller"},{"Nathanos Marris","Nathanos Blightcaller"},{"Alexandros Mograine",
"Lord Mograine"},{"Alexandros Mograine","Lord Mograine"},{"Gul'dan"},{"Zaetar"},{"Centaur"},{"Maraudine","Gelkis","Galak",
"Krenka"},{"Maiev","Maiev Shadowsong"},{"Kur'talos Ravencrest","Lord Ravencrest","Desdel Stareye","Jarod Shadowsong"
},{"Glory of Azshara"},{"Underlight Angler"},{"Val'anyr, Hammer of Ancient Kings","Val'anyr"},{"Dragonwrath, Tarecgosa's Rest",
"Dragonwrath"},{"Timear"},{"High Overlord Saurfang","High Overlord Varok Saurfang","Varok Saurfang"
},{"Talbuks","talbuk"},{"Talbuks","talbuk"},{"Redeemed"},{"The Aldor","Aldor"},{"The Aldor","Aldor","The Sha'tar","Sha'tar"},{"The Scryers",
"Scryers"},{"The Scryers","Scryers"},{"Bloodsail Buccaneers"},{"Troggs"},{"The Forge of Wills","Forge of Wills"
},{"Earthen"},{"Ulduar","Uldum","Uldaman"},{"Gryphon"},{"Grim Batol"},{"Xoroth"},{"K'aresh"},{"Shath'Yar"},{"Hakkar the Soulflayer",
"Hakkar"},{"Ysera"},{"Interrogator Vishas"},{"Infinite","Chromatic","Plagued","Netherwing","Twilight","Storm","Nightmare"
},{"Grim Batol"},{"Alexstrasza the Life-binder","Alexstrasza the Life Binder","Alexstrasza"},{"Genn Greymane"
},{"Gilnean Brigade"},{"Ahn'Qiraj"},{"Fandral Staghelm"},{"Azshara"},{"Suramar"},{"Xarantaur"},{"War of the Shifting Sands"
},{"Strom'kar the Warbreaker","Strom'kar"},{"Roland's Doom"},{"Frenzyheart","Oracles"},{"Loken"},{"Trust"},{"Burning Blade"
},{"Elerethe Renferal"},{"Alterac Valley"},{"Shen'dralar"},{"Orgrimmar"},{"Tanaris"},{"Twilight Highlands"},{"Thandol Span"
},{"The White Lady","White Lady","Blue Child"},{"Blue Child"},{"Mountains"},{"Khaz'goroth"},{"Constellar"},{"Tauren"},{"Urel Stoneheart"
},{"Vulraiis"},{"Helya"},{"The Perenolde Tiara","Perenolde Tiara"},{"Green"},{"White"},{"Red"},{"Blue"},{"Vydhar"},{"Blackrock Depths"
},{"Heart of Draenor"},{"Defias Brotherhood"},{"Hilda Hornswaggle"},{"Monara"},{"Tanning"},{"Barkskin","Blackmaw","Blackwood",
"Grizzleweald","Smolderhide","Stillpine","Timbermaw"},{"Karazhan","Guardian's Library"},{"Kilnara"},{"Lady Katrana Prestor",
"katrana prestor"},{"Franclorn Forgewright","Franclorn F. Forgewright"},{"Haleh"},{"Saris Swifthammer"
},{"Demon Hunter"},{"The Oracle Tree","Oracle Tree"},{"Andorhal"},{"Druids of the Talon"},{"Druids of the Claw"
},{"Druids of the Antler"},{"Elerethe Renferal"},{"Druids of the Fang"},{"Druids of the Moon"},{"Emerald Dream"
},{"Ban-Lu"},{"Saidan Dathrohan"},{"Nalorakk","Akil'zon","Jan'alai","Halazzi"},{"Mahamba","Tsul'Kalu","Pogeyan"},{"Hakkar",
"Bethekk","Hethiss","Shirvallah","Hir'eek","Shadra"},{"Akali","Har'koa","Mam'toth","Quetz'lun","Rhunok","Sseratus","Tharon'ja"
},{"Akil'zon","Akunda","Bethekk","Bwonsamdi","Dambala","Shadra","Elortha no Shadra","Kimbul","Eraka no Kimbul",
"Gonk","Gral","Grimath","Halazzi","Har'koa","Hethiss","Hir'eek","Jani","Jan'alai","Krag'wa","Lukou","Nalorakk","Pa'ku","Rezan",
"Sethraliss","Shirvallah","Tharon'ja","Torcali","Torga","Zanza"},{"The Thunder King"},{"Spires of Arak"},{"Talador"
},{"Nagrand"},{"Gorgrond"},{"DEHTA","D.E.H.T.A.","Druids for the Ethical and Humane Treatment of Animals"
},{"Archdruid Lathorius","Lathorius"},{"Bindings of the Windseeker"},{"Skywall","Vortex Pinnacle"},{"Tidestone of Golganneth",
"Aegis of Aggramar","Eye of Aman'thul","Hammer of Khaz'goroth","Tears of Elune"},{"Aman'thul","Eonar",
"Norgannon","Golganneth","Khaz'goroth","Aggramar"},{"Broken Shore"},{"Thal'dranath"},{"N'raqi"},{"Shuul'wah"},{"Arom Waycrest"
},{"Jintha"},{"Darrowshire"},{"Silithus","Feralas"},{"Shattrath"},{"The Sha'tar"},{"Born from light","Born of light"},{"The Aldor"
},{"The Scryers"},{"Kirin'Var","Netherstorm"},{"Ashran","Warspear","Seething Shore","Zuldazar","Mugambala"},{"Olgra"
},{"Mazthoril"},{"Paladin"},{"Respect","Tenacity","Compassion"},{"Ascendant Council"},{"Ignis the Furnace Master",
"Ignis"},{"Odyn"},{"Loken"},{"Aesir"},{"Wrenchcalibur"},{"Elun'dris","The Eye of Elune"},{"Bwonsamdi"},{"Tyrathan Khort"},{"Dranosh'ar Blockade",
"Durotar"},{"Torga"},{"Mam'toth"},{"Sethraliss"},{"Atul'aman","Dazar'alor","Nazwatha"},{"Fras Siabi"},{"Akunda"},{"Bwonsamdi"
},{"Jani"},{"Krag'wa"},{"Rezan"},{"Rezan"},{"Shell-less","Shellless"},{"Matron of Tenacity, Herald of Endless Research",
"Matron of Tenacity Herald of Endless Research","Matron of Tenacity - Herald of Endless Research"
},{"Dorian Atwater"},{"Boralus"},{"Dazar'alor"},{"A candle"},{"A fire"},{"A secret"},{"Tomorrow"},{"A river"},{"A plant"},{"My shadow",
"A shadow"},{"Time"},{"Witches"},{"Liches"},{"Brightwood","Southern Elwynn","Southern Elwynn Forest"},{"Circle of the Ancients"
},{"Andrassil"},{"Crown of the Snow"},{"Daral'nir"},{"Brightmane"},{"Chaos"},{"Warspear"},{"Stormshield"},{"Zaetar","Remulos"
},{"Maraudon"},{"Gni'kiv Medallion","The Shaft of Tsol","Shaft of Tsol"},{"Stormheim","Dreyrgrot"},{"Warden Iolol",
"Iolol"},{"High King Modimus Anvilmar","Modimus Anvilmar"},{"1","One"},{"Druid","Death Knight","Demon Hunter","Hunter",
"Mage","Monk","Paladin","Priest","Rogue","Shaman","Warlock","Warrior"},{"Druid","Death Knight","Demon Hunter","Hunter",
"Mage","Monk","Paladin","Priest","Rogue","Shaman","Warlock","Warrior"},{"Druid"},{"Mage"},{"Shaman"},{"Hunter"},{"Warlock"},{"Priest"},{"Typhoon"
},{"Germination"},{"Divine Star"},{"Consecration"},{"Earth Shield"},{"Wellspring"},{"Bladestorm"},{"Incanter's Flow"
},{"Posthaste"},{"First Blood"},{"Icy Talons"},{"Deeper Stratagem"},{"Dark Pact"},{"Explosive Shot"},{"Chi Torpedo"},{"Valiance Expedition"
},{"The Silver Covenant"},{"Stormwind"},{"Alterac"},{"Dalaran"},{"Kul'Tiras","Kul Tiras"},{"Pride"},{"Anger"},{"Despair"},{"Violence"
},{"Alleria"},{"Vereesa"},{"Twilight Grove"},{"Bough Shadow"},{"Seradane"},{"Stormheim"},{"Eye of Azshara"},{"Val'sharah"
},{"Theralion"},{"Alleria"},{"Aggra","Jaina"},{"Durotan"},{"Rogue","Death Knight","Mage","Druid"},{"Paladin","Priest","Warlock"},{"Warrior",
"Hunter","Shaman"},{"Shaman"},{"Monk","Paladin"},{"Druid"},{"Primal Rage"},{"Time Warp"},{"Saidan"},{"Gavinrad"},{"Uther"},{"Turalyon"
},{"Greater Blessing of Might"},{"Please Send Tell"},{"Bastion of Twilight"},{"Blackwing Descent"},{"Blackwing Lair"
},{"Trial of the Grand Crusader"},{"Blackrock Caverns"},{"Blackrock Depths"},{"Lower Blackrock Spire"
},{"Upper Blackrock Spire"},{"Throne of the Four Winds"},{"Throne of Thunder"},{"Halls of Origination"
},{"Halls of Lightning"},{"Siege of Orgrimmar"},{"Honorable Kill","Honourable Kill"},{"Dishonorable Kill",
"Dishonourable Kill"},{"In my humble opinion"},{"Age/Sex/Location","age sex location"},{"Humans","human"
},{"Night Elves","night elf"},{"Night Elves","night elf"},{"Blood Elves","blood elf"},{"Dwarves","dwarf"},{"Dwarves","dwarf"
},{"Gnomes","gnome"},{"Gnomes","gnome"},{"Draenei"},{"Draenei"},{"Worgen"},{"Orc"},{"Tauren"},{"Tauren"},{"Trolls","troll"},{"Goblins","goblin"
},{"Goblins","goblin"},{"Undead","Forsaken"},{"Undead","Forsaken"},{"Blood elves","blood elf"},{"Blood elves","blood elf"
},{"Blood elves","blood elf"},{"Arakkoa"},{"Draenei"},{"Draenei"},{"Draenei"},{"Ethereals","ethereal"},{"Grummles","grummle"},{"Jinyu"
},{"Mantid"},{"Night elves","night elven","night elf"},{"Night elves","night elven","night elf"},{"Tuskarr"},{"Vrykul"
},{"Balance"},{"Retribution"},{"Retribution"},{"Restoration","Resto druid","Restoration druid"},{"Guardian"},{"Bolstering"
},{"Bursting"},{"Explosive"},{"Fortified"},{"Grievous"},{"Infested"},{"Necrotic"},{"Overflowing"},{"Quaking"},{"Raging"},{"Reaping"
},{"Sanguine"},{"Skittish"},{"Teeming"},{"Tyrannical"},{"Volcanic"},{"Thaddius"},{"Heigan","Heigan the Unclean"},{"Hodir"},{"Corporal"
},{"Grunt"},{"Knight-lieutenant","knight lieutenant"},{"Blood guard"},{"Commander"},{"Lieutenant general","lieutenant-general"
},{"Field Marshal"},{"Warlord"},{"Starcaller"},{"The Astral Walker"},{"Herald of the Titans"},{"Bane of the Fallen King"
},{"The Light of Dawn"},{"The Flamebreaker"},{"The Stormbreaker"},{"Fire-Watcher"},{"Vanquisher"},{"The Seeker"
},{"The Undying"},{"The Immortal"},{"Salty"},{"5.0.4","Mists of Pandaria","Mists of Pandaria Pre-Patch"},{"5.0","5.0.5",
"Mists of Pandaria","Mists of Pandaria Pre-Patch"},{"4.3","Dragon Soul","Hour of Twilight"},{"6.02","6.0",
"Warlords of Draenor"},{"5.4","Siege of Orgrimmar"},{"6.2","Fury of Hellfire","Hellfire Citadel"},{"Algalon the Observer",
"Algalon"},{"Algalon the Observer","Algalon"},{"General Vezax","vezax"},{"Yogg-Saron"},{"Herod"},{"Gara'jal the Spiritbinder",
"Gara'jal"},{"Sindragosa"},{"King Terenas Menethil II","King Terenas Menethil","Terenas Menethil"},{"Spirit of Hakkar",
"Hakkar"},{"Vaelastrasz the Corrupt","Vaelastrasz"},{"Deathbringer Saurfang","Dranosh Saurfang","saurfang"
},{"Professor Putricide","putricide"},{"Harbinger Skyriss"},{"Harbinger Skyriss"},{"Harbinger Skyriss"},{"C'thun"
},{"Millhouse Manastorm"},{"when the raven swallows the day"},{"Grand Warlock Wilfred Fizzlebang",
"Wilfred Fizzlebang"},{"Razorgore the Untamed"},{"Eredar Twins","Sacrolash","Alythess"},{"Falric"},{"Marwyn"},{"Durumu the Forgotten",
"Durumu"},{"Megaera"},{"Ra-den"},{"Ordos, Fire-God of the Yaungol","Ordos"},{"Lich King","The Lich King","Arthas"
},{"Yrel"},{"Taerar"},{"Cousin Slowhands"},{"Blingtron 4000"},{"Sylvanas Windrunner","Sylvanas"},{"High Overlord Saurfang",
"Varok Saurfang"},{"The Lich King","Lich King","Arthas Menethil","Arthas"},{"Tarecgosa","Dragonwrath"},{"Rhonin"
},{"Lady Anacondra"},{"Lord Pythas"},{"Lord Cobrahn"},{"Defender"},{"Naxxramas"},{"Naxxramas"},{"Naxxramas"},{"Gurubashi Mojo Madness"
},{"30","Thirty"},{"28","Twenty eight"},{"26","Twenty six"},{"22","Twenty two"},{"16","Sixteen"},{"16","Sixteen"},{"20","Twenty"},{"1","One"},{"Gnomish X-Ray Specs"
},{"Iron Boot Flask"},{"Orb of Deception"},{"Orb of the Sin'dorei"},{"Imperial Granary","Valley of the Four Winds",
"Pandaria"},{"Thekal"},{"Hexxer"},{"Grand Widow"},{"Farseer"},{"Vindicator"},{"Admiral"},{"Lord"},{"First Arcanist"},{"Fire-God of the Yaungol"
},{"Red Crane"},{"Jade Serpent"},{"Black Ox"},{"White Tiger"},{"the Shifting Sands"},{"Sargeras"},{"Cho'gall"},{"Chromaggus"
},{"Temple of Atal'Hakkar","Sunken Temple"},{"The Hakkari","Hakkari"},{"Green","Emerald"},{"Teron Gorefiend"},{"Core hound"
},{"Grizzly Hills"},{"Val'sharah"},{"Suramar"},{"Broken Isles"},{"Darkshore"},{"Kalimdor"},{"Darkshore"},{"Kalimdor"},{"Sholazar Basin"
},{"The Hinterlands"},{"Silverpine Forest"},{"Westfall"},{"Ghostlands"},{"Hillsbrad Foothills","Arathi Highlands"
},{"Alonsus Faol"},{"Galen Trollbane"},{"Arathor","Arathi"},{"Mulgore"},{"Badlands"},{"Northern Barrens"},{"Badlands"},{"Zangarmarsh"
},{"Zangarmarsh"},{"Wildhammer Stronghold"},{"Shadowmoon Village"},{"Allerian Stronghold"},{"Stonebreaker Hold"
},{"Refuge Pointe"},{"Tarren Mill"},{"Searing Gorge"},{"Borean Tundra"},{"Dragonblight"},{"Feralas"},{"Feralas"},{"Desolace"
},{"Stonetalon Mountains"},{"Kun-Lai Summit","Kun Lai Summit"},{"Jade Forest","The Jade Forest"},{"Galakrond's Rest"
},{"Silithus"},{"Felwood"},{"Uldum"},{"1000","one thousand","a thousand"},{"Tanaris","Kalimdor"},{"Desolace"},{"Thousand Needles"
},{"Southern Barrens"},{"Borean Tundra","Tiragarde Sound"},{"Un'goro Crater"},{"Stranglethorn Vale","Cape of Stranglethorn",
"Northern Stranglethorn"},{"Stranglethorn Vale","Northern Stranglethorn"},{"Booty Bay"},{"Ratchet"},{"Maraudon"
},{"Maraudon"},{"Alterac Valley"},{"Dartol's Rod of Transformation"},{"Titanstrike","Talonclaw","Thas'dorah"
},{"Ebonchill","Felo'melorn","Alu'neth"},{"2016"},{"3"},{"Duncan Jones"},{"Thalyssra"},{"Arcan'dor"},{"Zin-Azshari"},{"Chris Metzen"
},{"Nazjatar"},{"Armies of Legionfall"},{"The Wardens","The Nightfallen","Valarjar","Highmountain Tribe","Court of Farondis",
"Dreamweavers"},{"Maiev Shadowsong","Sira Moonwarden"},{"Garona"},{"Chromatic"},{"Emerald Circle"},{"Spectre"},{"Lirath"
},{"Nathanos Blightcaller"},{"Farstriders"},{"Shadowglen"},{"Tranquillien"},{"Elegon"},{"Slabhide"},{"Ultraxion"},{"Y'Shaarj"
},{"Firelands"},{"Hunter"},{"Stormheim"},{"Go'el","Thrall"},{"Gorgrond"},{"Hallow's End"},{"Barrow Deeps"},{"Brawler's Guild"
},{"Twinblades of the Deceiver","Aldrachi Warblades"},{"Shalamayne"},{"Dustwallow Marsh"},{"Sentinels","Sentinel Army"
},{"Umbra Crescent"},{"Scarlet Monastery"},{"Thomas Thomson"},{"Close enough to touch"},{"Maiev Shadowsong"
},{"Vengeance","Havoc"},{"Illidan Stormrage"},{"12"},{"Broken Shore"},{"Fel Hammer"},{"Tirion Fordring"},{"Illidan Stormrage"
},{"Val'sharah","Highmountain","Stormheim"},{"8"},{"Cordana"},{"Kosumoth","Kosumoth the Hungering"},{"Will of the Emperor"
},{"Sha of Pride"},{"Fishing"},{"Prophet Velen","Genn Greymane"},{"Dori'thur"},{"Ash'alah"},{"Lady Vashj"},{"Kael'thas Sunstrider"
},{"Titanium Seal of Dalaran"},{"The Wish Remover"},{"Malfurion Stormrage"},{"Druid"},{"Druid","Paladin","Warlock"
},{"Anveena Teague","Anveena","Jaina Proudmoore","The Sunwell"},{"Rhonin","Krasus","Thrall","Green Jesus","Anduin Wrynn"
},{"Stormrage","Wolfheart","Illidan","Traveler","Elegy"},{"Eitrigg"},{"Illidan Stormrage"},{"520 million"},{"Khadgar's tower"
},{"The Everbloom"},{"Patchwerk"},{"Val'sharah"},{"Moonglade"},{"Fandral Staghelm"},{"Cherished Heart of the People",
"Daughter of the Moon","Glory of Our People","Light of Lights","Light of the Moon","The Light Beneath the Tides",
"Her Radiance","Queen Beneath the Tides","Flower of Life"},{"The Destroyer","Aspect of Death","The Worldbreaker",
"Black Aspect","Earth-Warder","Blood's Shadow","the Cataclysm"},{"Queen Azshara"},{"N'Zoth"},{"Katrana Prestor"
},{"Blackwing Descent"},{"Eonar"},{"Allie"},{"Chronormu"},{"Dragonblight"},{"Ebonhorn","Ebyssian"},{"FALSE"},{"Trade District"
},{"The Drag"},{"Ahoo'ru"},{"Bruce"},{"Elwynn Forest"},{"Ny'alotha"},{"Puzzle Box of Yogg-Saron"},{"Whispering Forest"
},{"Tirisfal Glades","Balnir Farmstead"},{"Demonbane"},{"Wildstalker"},{"Cursed"},{"Darkspear"},{"Amani"},{"Il'gynoth"},{"Y'Shaarj",
"C'Thun","Yogg-Saron","N'Zoth"},{"Void Lords"},{"C'thun"},{"Nerubian"},{"Tyrande Whisperwind"},{"Kur'talos Ravencrest"
},{"First Arcanist Thalyssra","Thalyssra"},{"Dusk Lily"},{"The Nightfallen"},{"Suramar"},{"Zin-Azshari"},{"Azshara"
},{"Lower City","Aldor","Scryers","Sha'tar"},{"Shattered Sun Offensive"},{"Blade's Edge Mountains"},{"Lor'themar Theron"
},{"Gelbin Mekkatorque","High Tinker Mekkatorque"},{"Darnassus","Ironforge"},{"Feralas"},{"Feralas"},{"Dire Maul",
"Dire Maul North"},{"The Beloved"},{"Mount Hyjal","Highmountain"},{"Grimrail Depot"},{"Zandalar"},{"Big Love Rocket"
},{"What a long, strange trip it's been"},{"Ahune"},{"Prince Farondis"},{"Protector"},{"4"},{"Ulduar"},{"Trust"},{"Red Mountain"
},{"Midsummer Fire Festival"},{"Orcish"},{"Common"},{"Alodi","Scavell","Aegwynn","Medivh"},{"Demon Hunter"},{"Mimiron","Freya",
"Thorim","Hodir"},{"Ra","Ra-den"},{"Ragefire Chasm"},{"Stormwind Stockade"},{"Hunter","Warrior"},{"Chen Stormstout"},{"Malfurion Stormrage"
},{"Violet Citadel"},{"Ansirem Runeweaver","Kalec","Karlain","Khadgar","Modera","Vargoth","Krasus","Kel'Thuzad","Drenden",
"Kael'thas Sunstrider","Antonidas","Rhonin","Aethas Sunreaver","Jaina Proudmoore"},{"Council of Six",
"The Six","High Council","Ruling Council"},{"Sha of Fear"},{"Cloak"},{"Yu'lon","Chi-Ji","Xuen","Niuzao"},{"Kil'jaeden"
},{"White Tiger"},{"Arthas Menethil"},{"Kel'Thuzad"},{"Naxxramas","Onyxia's Lair"},{"Malygos"},{"Eye of Eternity"},{"Terenas Menethil"
},{"Sindragosa"},{"Darion Mograine"},{"Ashen Verdict"},{"Bronze"},{"Traitor King"},{"Taran Zhu"},{"Vault of the Wardens"
},{"Razorfen Kraul"},{"By blood and honor"},{"Warrior's Heart"},{"Victory or death"},{"Shaohao"},{"Cathedral of Eternal Night"
},{"Sons of Lothar"},{"Worgen"},{"7","Seven"},{"Badlands"},{"Blackhand"},{"Hunter","Huntard"},{"Warlock"},{"Shaohao"},{"10","Ten"},{"Ragefire Chasm",
"Deadmines","Wailing Caverns"},{"Thori'dal, the Stars' Fury","Thori'dal"},{"Mr. Bigglesworth","Mr.Bigglesworth"
},{"30"},{"Medivh"},{"Thalassian"},{"Anduin Lothar"},{"Kael'thas Sunstrider"},{"Isle of Conquest"},{"Duskwatch"},{"Exiled ones"
},{"Mark of Honor"},{"Children of the Stars"},{"Loken","Kronus"},{"TRUE"},{"Chamber of Aspects","Wyrmrest Temple",
"Dragonblight"},{"Warglaives of Azzinoth"},{"Illusion"},{"Medivh"},{"Last Guardian"},{"Nether Disruptor"},{"Burning Steppes"
},{"Prydaz"},{"Warsong Gulch"},{"Temple of Kotmogu","Deepwind Gorge","Silvershard Mines"},{"Toravon"},{"Hallow's End",
"Feast of Winter Veil"},{"Talador","Terokkar Forest","Bone Wastes"},{"For The Horde!","For The Horde"},{"Immortal No More"
},{"Orgrimmar Offensive"},{"Jaraxxus"},{"Elite Tauren Chieftain","ETC"},{"Blight Boar"},{"Darkmoon Island"},{"Khadgar"
},{"Samuro","Sig Nicious","Bergrisst","Mai'Kyl","Chief Thunder-Skins"},{"Spectral Sight"},{"Overwatch"},{"Velen"},{"Norgannon"
},{"Aegis of Aggramar"},{"Crown of the Earth"},{"Teldrassil"},{"Moonglade"},{"Fist weapon"},{"Wand"},{"Dragonwrath"},{"Nightwell"
},{"Lament of the Highborne"},{"Unseen Path"},{"Battlelord"},{"High Priest","Cardinal"},{"Illidari"},{"FALSE"},{"25"},{"TRUE"
},{"Shado-Pan"},{"Thaumaturge Vashreen"},{"Lich King"},{"Hall of Shadows"},{"Muradin's Favor","Jaina's Locket",
"Sylvanas' Music Box","Tabard of the Lightbringer","Reins of the Crimson Deathcharger"},{"Patchwerk",
"Grobbulus","Gluth","Thaddius"},{"46"},{"TRUE"},{"Wintergrasp"},{"Shadowmoon Valley","Frostfire Ridge"},{"Quel'Thalas"
},{"Land of Eternal Spring"},{"Make Love, Not Warcraft"},{"Val'kyr"},{"Tanaan Jungle"},{"The Black Knight"
},{"From Hell's Heart I Stab at Thee"},{"Eastern Plaguelands"},{"Isle of Quel'Danas","Ghostlands","Eversong Woods"
},{"The Sword of a Thousand Truths"},{"Lunar Festival"},{"Rhonin"},{"Wisp"},{"Draenor"},{"Mana-Tombs","Auchenai Crypts",
"Sethekk Halls","Shadow Labyrinth"},{"Cenarius"},{"Sun-Lute of the Phoenix King","Arcanite Ripper","Necromedes, the Death Resonator"
},{"Hearthsteed"},{"Of the Black Harvest"},{"Lunarfall"},{"Frostwall"},{"Tree"},{"SI:7"},{"Chi-Chi","Zao","Xu-Fu","Yu'la"},{"Valor of the Forest"
},{"Invincible"},{"The Black Temple"},{"Shalandis Isle"},{"Azure Drake","Black Drake","Blue Drake","Purple Netherwing Drake",
"Twilight Drake","Bronze Drake","Blazing Drake","Onyxian Drake","Red Drake"},{"Azeroth's Next Top Model"
},{"35"},{"Stormtrooper"},{"Ring of Trials","Circle of Blood Arena","Ruins of Lordaeron","Dalaran Arena","Ring of Valor",
"Tol'Viron Arena","Tiger's Peak","Ashamane's Fall"},{"Old Crafty"},{"Old Ironjaw"},{"Enchanting"},{"Stood in the Fire"
},{"of the Horde","of the Alliance"},{"Watchers"},{"Cenarius"},{"Sisterhood of Elune"},{"Bronze"},{"TRUE"},{"15"},{"30"},{"Ashenvale"
},{"Argus"},{"The Red","The Red Axe"},{"Dranosh"},{"Broxigar"},{"Eversong Woods"},{"Mulgore"},{"Swift Brewfest Ram","Great Brewfest Kodo"
},{"Brewfest"},{"Wrecking Ball"},{"November"},{"Day of the Dead"},{"Dread Wastes"},{"Chi"},{"Warrior","Druid"},{"Antonidas"},{"Energy",
"Focus","Mana","Rage","Runes","Pain","Fury"},{"Runic Power","Arcane Charge","Chi","Holy Power","Insanity","Combo Points",
"Soul Shards"},{"Monk","Rogue","Druid"},{"Pain","Fury"},{"Grill","Wok","Pot","Steamer","Oven","Brew"},{"Arakkoa"},{"Darnassian"},{"Velen"
},{"You Are Now Prepared!"},{"The Lightbringer"},{"Odyn"},{"Titanstrike"},{"Thorim"},{"Saurfang"},{"11"},{"Warlords of Draenor",
"WoD"},{"Cataclysm"},{"Alchemy"},{"Leatherworking","Tailoring"},{"Seat of the Triumvirate"},{"Mac'Aree"},{"Velen","Kil'jaeden"
},{"Wailing Caverns"},{"TRUE"},{"Explorers' League"},{"Reliquary"},{"FALSE"},{"Algalon"},{"Dark Riders"},{"Reginald Windsor",
"Marshal Windsor"},{"Ironfoe"},{"Vindicaar"},{"Xe'ra"},{"Tear of Elune"},{"TRUE"},{"Rogue"},{"6"},{"Orgrim's Hammer"},{"The Skybreaker"
},{"Theramore","Peak of Serenity"},{"Bloodfang Widow"},{"Go'el"},{"5"},{"FALSE"},{"Loque'nahak"},{"Har'koa"},{"Moon Guard"},{"Suramar"
},{"4"},{"Army of the Light","Argussian Reach"},{"Turalyon"},{"Alonsus Faol","Uther the Lightbringer","Anduin Lothar"
},{"Flight Master's Whistle"},{"Flame Leviathan"},{"Ignis","Ignis the Furnace Master"},{"Veranus"},{"Thousand Needles"
},{"Deathwing"},{"End Time","Grim Batol","Lost City of the Tol'vir","The Stonecore","The Vortex Pinnacle",
"Throne of the Tides"},{"Infinite Timereaver"},{"Runeforging"},{"of the Infinite"},{"Murozond"},{"7.1.5"},{"One Thousand Needles"
},{"Void elves","Lightforged draenei","Dark Iron dwarves"},{"Highmountain tauren","Nightborne elves",
"Zandalari trolls"},{"5"},{"Nordrassil","Teldrassil","Vordrassil","Shaladrassil","Unnamed tree"},{"Nordrassil"
},{"Emerald Dream"},{"Druids of the Pack","Druids of the Scythe"},{"War of the Satyr"},{"Zul'Gurub"},{"Cow head"
},{"Fleet Master Firallon","Fleet Admiral Tethys"},{"Antorus"},{"Khaz'goroth"},{"Norgannon"},{"Taeshalach"},{"Last Breath of the Worldbreaker"
},{"Holy Warriors Gather"},{"Gorshalach"},{"Ariden"},{"Jaina Proudmoore","Sylvanas Windrunner","Azshara"},{"Gul'dan",
"Illidan Stormrage","Khadgar"},{"Burdens of Shao-Hao"},{"36"},{"Unholy","Feral","Fire","Outlaw","Elemental","Fury"},{"Beast Mastery",
"Windwalker","Discipline","Destruction"},{"Rhok'delar"},{"Lok'delar"},{"Xylem"},{"Christie Golden"},{"Richard A. Knaak"
},{"Tyrande Whisperwind"},{"Aggramar"},{"Flame Rend"},{"Antorus the Burning Throne"},{"The Unmaker"},{"The Speaker",
"Herald of Azeroth","The Diamond King","King of Khaz Modan","Lord and Thane of Ironforge","High Thane",
"The King Under the Mountain","Mountain King"},{"Magni Bronzebeard"},{"Magni Bronzebeard"},{"Alexandros Mograine"
},{"Great Anvil"},{"Soul of the Deathlord"},{"Soul of the Farseer"},{"Wakening Essence"},{"Sylvanas Windrunner",
"Varok Saurfang","Baine Bloodhoof","Lor'themar Theron","Jastor Gallywix","Ji Firepaw","Thalyssra","Mayla Highmountain",
"Geya'rah"},{"Anduin Wrynn","Council of Three Hammers","Gelbin Mekkatorque","Tyrande Whisperwind",
"Malfurion Stormrage","Velen","Genn Greymane","Aysa Cloudsinger","Alleria Windrunner","Turalyon","Jaina Proudmoore"
},{"Malfurion Stormrage"},{"Moonglade"},{"The Black Temple","Ulduar"},{"Flame Leviathan","Razorscale","Ignis the Furnace Master",
"XT-002 Deconstructor"},{"Silver Covenant"},{"Wrath of the Lich King","Cataclysm","Mists of Pandaria",
"Battle for Azeroth"},{"Army of the Light","Argussian Reach"},{"Sightless Eye"},{"Sightless Eye"},{"Raethan"
},{"Ratstallion"},{"1000"},{"Sha of Pride"},{"Warlock"},{"Lord Admiral"},{"Waycrest","Stormsong","Ashvane","Proudmoore"},{"Siege of Boralus"
},{"King's Rest","Siege of Boralus"},{"False"},{"Grand Admiral"},{"Scarlet Fleet"},{"Barean Westwind"},{"Mal'Ganis"
},{"Nathreza"},{"24"},{"Seal of Wartorn Fate"},{"Eldre'Thalas"},{"Jaina Proudmoore"},{"Beware beware the Daughter of the Sea"
},{"Warpwood Quarter"},{"Dire Maul West"},{"Those Who Remain Hidden"},{"Athenaeum"},{"True"},{"True"},{"False"},{"Death Knight",
"Demon Hunter"},{"5000"},{"Laura Bailey","Carrie Gordon Lowrey"},{"Patty Mattson","Piera Coppola"},{"Burning of Teldrassil"
},{"After the Dark Portal"},{"Battle for Azeroth"},{"False"},{"Scrapper"},{"Purge of Dalaran"},{"Purge of Dalaran"
},{"Divine Bell"},{"Order of the Broken Temple"},{"Monkey King"},{"Lords of War"},{"Nathanos Blightcaller"
},{"Shadow"},{"Borean Tundra","Coldarra","Howling Fjord","Dragonblight","Grizzly Hills","Zul'Drak","Sholazar Basin",
"Crystalsong Forest","The Storm Peaks","Icecrown","Hrothgar's Landing","Wintergrasp"},{"Val'sharah","Stormheim",
"Helheim","Azsuna","Highmountain","Suramar","The Broken Shore","Eye of Azshara"},{"Tomb of Sargeras"},{"Battle for Broken Shore"
},{"Dark Portal","Felstorm","Well of Eternity","Dalaran","Sunwell"},{"Timbermaw Hold","Gadgetzan","Zul'Farrak",
"Caverns of Time","Ramkahen"},{"Durotar","Kalimdor"},{"Booty Bay","Zul'Gurub","Blackrock Spire","Gnomeregan",
"Hearthglen","Zul'Aman"},{"Bronze","Blue","Green"},{"Red","Black"},{"Dire Maul","Feralas","Duskwood","Ashenvale","Teldrassil",
"Shadowglen","Shadowthread Cave","Fel Rock"},{"Disengage"},{"Flare"},{"Army of the Dead"},{"Dancing Rune Weapon"
},{"Glide"},{"Metamorphosis"},{"Prowl"},{"Innervate"},{"Entangling Roots"},{"Evocation"},{"Arcane Intellect"},{"Tiragarde"
},{"Feral"},{"Death Knight","Druid","Paladin","Monk","Shaman","Priest","Warrior","Demon Hunter"},{"Hunter","Mage","Rogue","Warlock"
},{"Destruction"},{"Marksmanship"},{"Fire"},{"Subtlety"},{"Winged Steed of the Ebon Blade"},{"Frost"},{"Retribution"
},{"Windwalker"},{"Enhancement"},{"Farseer Nobundo"},{"Vindicator"},{"Discipline"},{"Arms"},{"Fortifying Brew"},{"Roll"},{"Divine Shield"
},{"Blessing of Freedom"},{"Leap of Faith"},{"Power Word: Fortitude"},{"Stealth"},{"Symbols of Death"},{"Hearthsteed"
},{"True"},{"Home"},{"The Den"},{"Astral Shift"},{"Capacitor Totem"},{"Unending Resolve"},{"Fear"},{"Avatar"},{"Battle Shout"},{"Riverbud",
"Sea Stalk","Star Moss","Akunda's Bite","Winter's Kiss","Siren's Pollen","Anchor Weed"},{"Yseralline Seed",
"Felwort","Starlight Rose","Fjarnskaggl","Foxflower","Dreamleaf","Aethril"},{"Taelia"},{"Fertile Soil"},{"Bloodthistle"
},{"True"},{"Aliden Perenolde"},{"Strahnbrad","Hillsbrad Foothills"},{"Syndicate"},{"Syndicate Mask"},{"Orange"},{"Book of Medivh"
},{"Scepter of Sargeras","Skull of Gul'dan","Book of Medivh","Eye of Dalaran"},{"Flushbloom","Bloodthistle"
},{"Violet Eye"},{"Violet Signet"},{"Eye of Dalaran"},{"Kanrethad Ebonlocke","Ritssyn Flamescowl"},{"Northrend"
},{"Aluneth"},{"42"},{"Scavell"},{"Forest of Shadows"},{"40"},{"Tirisfalen"},{"Taretha"},{"Lok'vadnod"},{"Bloodstones"},{"Captain Skarloc"
},{"Argus Wake"},{"False"},{"Grave Moss"},{"Grom Hellscream"},{"The Pride of Kul Tiras"},{"Hrothgar's Landing"},{"Nefarian"
},{"Yogg-Saron"},{"Bolvar Fordragon"},{"Falric"},{"Ozruk"},{"Varian Wrynn"},{"Thrall"},{"Archbishop Benedictus"},{"Mr. Smite"
},{"Edwin VanCleef"},{"Armsmaster Harlan"},{"Marwyn"},{"7th Legion"},{"Lady Vashj"},{"Twilight Grove","Duskwood","Dream Bough",
"Feralas","Ursoc's Den","Grizzly Hills","Seradane","Hinterlands","Stormrage Barrow Dens","Moonglade","Nordrassil",
"Mount Hyjal","The Dreamgrove","Val'sharah","Rift of Aln","Malorne's Nightmare"},{"4"},{"Gathering"},{"Vampire Hunter"
},{"Praise the Sun!"},{"Mine Sweeper"},{"Parasite Evening"},{"The Cake Is Not A Lie"},{"Breaking the Sound Barrier"
},{"Scrooge"},{"The Old Gnome and the Sea"},{"It's Just a Flesh Wound"},{"Fire, Walk With Me"},{"Interrogator Vishas"
},{"Jaina Proudmoore"},{"Stormcaller Brundir","Assembly of Iron"},{"Hogger","Edwin VanCleef","Mutanus","Herod",
"Lucifron","Prince Thunderaan","Chromaggus","Hakkar","Emperor Vek'nilash","Warlord Kalithresh","Prince Malchezaar",
"Gruul the Dragonkiller","Lady Vashj","Archimonde","Illidan Stormrage","Priestess Delrissa","M'uru",
"Ingvar the Plunderer","Cyanigosa","Eck the Ferocious","Onyxia","Heigan the Unclean","Ignis the Furnace Master",
"General Vezax","Algalon the Observer"},{"Vek'nilash","Vek'lor"},{"Cyanigosa"},{"Erekem","Moragg","Ichoron","Xevozz",
"Lavanthor","Zuramat the Obliterator","Cyanigosa"},{"Gate of the Setting Sun","Temple of the Jade Serpent",
"Stormstout Brewery","Siege of Niuzao Temple","Shado-Pan Monastery","Mogu'shan Palace"},{"Ursoc","Nythendra",
"Dragons of Nightmare","Xavius","Il'gynoth","Cenarius","Elereth Renferal","Ysondre","Emeriss","Lethon","Taerar"
},{"Druid","Hunter","Monk","Priest"},{"Honorable Pennant","Honourable Pennant"},{"Prestigious Midnight Courser"
},{"The Honorbound"},{"7th Legion"},{"1000","One thousand","A thousand"},{"Darkmoon Daggermaw"},{"Master of Minions"
},{"Moon Moon"},{"O Thanagor","Arthas, My Son","Invincible","The Shattering"},{"Elune be with you"},{"Tiragarde Sound",
"Drustvar","Stormsong Valley"},{"The Sunreavers","The Silver Covenant","The Argent Crusade","Knights of the Ebon Blade"
},{"King Phaoris","Phaoris"},{"Al'burq","Alra'ed"},{"Unseen Path"},{"Snowfeather"},{"A Good War","Elegy"},{"The sun guides us"
},{"High Home"},{"Sunstrider"},{"Iron","Wood"},{"Great Hall","Barracks","War Mill","Altar of Storms","Workshop","Tree of Life",
"Ancient of War","Altar of Elders","Hunter's Hall","Armory","Glaiveworks","Plagueworks"},{"Great Hall","West Path",
"East Path","Center Path","Valorcall Pass","Stromgarde Keep"},{"Bashal'aran","Lornesta Mine","Cinderfall Grove",
"Forlorn Crossing","Gloomtide Strand","Ashwood Depot","Lor'danel"},{"Lumberjack's Axe"},{"True"},{"High Exarch Turalyon",
"Muradin Bronzebeard","Danath Trollbane","Rokhan","Eitrigg","Lady Liadrin"},{"Strom"},{"Convocation"},{"Thoras Trollbane",
"Nazgrim","Darion Mograine","Sally Whitemane"},{"Highlord Mograine","Thane Korth'azz","Lady Blaumeux",
"Sir Zeliek"},{"Headless Horseman"},{"Kingdom of Lordaeron","Lordaeron","Knights of the Silver Hand",
"Scarlet Crusade"},{"Enchanting"},{"Neptulon"},{"Firelord","Ruler of the Firelands","Lord of Fire","Lord of Flame",
"The Great Fire"},{"Firelord"},{"Kil'Jaeden"},{"Jewelcrafting","Inscription","Archaeology"},{"2004"},{"Meat Wagon"
},{"64"},{"War of the Three Hammers"},{"Neptulon","Smolderon","Therazane","Thunderaan","Ragnaros","Al'Akir"},{"Acherus Deathcharger"
},{"5","Five"},{"7","Seven"},{"Jade Panther","Sunstone Panther","Sapphire Panther","Ruby Panther","Jeweled Onyx Panther"
},{"Sea Turtle","Riding Turtle","Crimson Water Strider","Brinedeep Bottom-Feeder","Pond Nettle","Great Sea Ray"
},{"Noblegarden"},{"15"},{"Black Battlestrider","Black War Ram","Black War Steed Bridle","Black War Tiger",
"Black War Elekk","Stormpike Battle Charger","Black War Mammoth"},{"Red Skeletal Warhorse","Black War Wolf",
"Black War Kodo","Black War Raptor","Swift Warstrider","Frostwolf Howler","Black War Mammoth"}
};
TriviaBot_Questions[1]['Category'] = {
"3","3","3","1","3","3","3","3","3","3","3","3","3","3","3","1","1","3","3","3","1","3","1","1","1","1","3","3","3","3","3","3","3","1","3","3","1","1","3","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","3","3","3","1","1","1","3","1","1","3","1","1","1","1","1","1","1","3",
"1","1","1","1","1","1","1","1","1","1","1","1","3","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","3","3","3","3","3","3","4","4","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","4","4","4","4","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1",
"3","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2",
"2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1",
"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","1","1","1","1","1","1","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3",
"3","3","3","3","3","3","3","3","3","3","3","3","3","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","1","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4",
"4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1",
"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1",
"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1",
"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1",
"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1",
"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","3","3","1","2","2","2","2","2","3","1","1","1","1","1","1","1","3","3","3","3","1","2","2","2","3","3","1","1","1","1","1","1","1","2","2","3","2","2","3","2","1","1","1","1","1","1","1","1","3","1","2","2","1","3","1","1","1",
"1","1","1","1","1","1","2","1","1","1","1","1","1","1","1","1","1","1","3","1","3","3","1","1","1","1","1","1","1","1","1","1","1","2","2","2","2","2","2","2","2","2","2","2","1","2","2","2","2","2","2","2","2","2","2","2","2","3","3","2","2","2","2","2","2","2","2","2","2","1","1","1","1","2","2","2","2","2","2","1","1",
"3","1","1","1","3","1","3","2","1","1","1","1","3","1","1","3","1","1","1","1","1","1","1","3","1","1","3","3","1","1","1","1","1","3","3","3","3","3","3","3","3","3","3","3","3","3","3","4","1","1","2","2","2","2","2","2","2","2","2","2","3","3","3","3","3","3","3","1","1","1","2","2","1","1","1","1","2","1","1","1","1",
"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","3","3","3","1","1","2","3","2","3","1","1","2","3","1","3","2","2","1","1","1","1","1","1","1"
};
TriviaBot_Questions[1]['Points'] = {
"2","2","2","2","2","2","2","2","1","1","1","1","1","1","1","1","1","1","2","2","2","2","2","2","2","2","2","2","2","3","3","2","2","2","2","2","2","2","2","2","2","2","2","2","2","3","1","1","2","2","2","2","2","2","2","2","2","2","2","2","2","3","3","2","2","2","2","3","2","3","2","2","3","2","2","3","3","2","3","2","2",
"2","3","3","2","3","2","4","4","4","3","2","3","2","3","3","5","5","3","3","4","4","4","4","4","3","3","3","5","4","3","3","3","3","2","4","4","5","3","4","4","3","3","3","4","4","4","4","3","4","4","5","4","4","4","4","3","3","3","3","4","4","3","3","4","3","3","3","4","5","4","3","4","3","3","3","3","3","3","4","3","4",
"4","3","3","3","3","3","3","3","3","4","3","5","4","3","4","3","3","4","4","4","4","4","4","4","3","3","3","2","2","4","4","4","4","4","4","4","4","3","3","3","3","4","3","4","3","3","3","3","3","4","4","2","3","3","3","1","1","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","2","3","3","3",
"3","3","3","4","4","4","4","1","1","2","2","2","1","1","1","2","2","2","2","1","1","1","1","1","1","2","2","4","4","3","3","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","2","2","1","1","1","1","1","2","1","1","2","2","2","1","1","1","1","1","2","2","2","2","2","1","1","2","1","3","2","1",
"1","2","2","1","1","1","3","1","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","3","2","3","2","2","2","2","2","2","2","2","1","1","1","1","1","2","2","3","2","2","2","2","1","3","3","3","3","3","3","2","2","1","1","2","2","2","1","2","2","1","1","2","2","2","1","2","3","2","2","3","2","2","2","2","3","2",
"3","3","3","2","2","2","3","3","4","2","3","3","3","2","2","2","2","4","1","1","1","2","1","1","1","2","3","2","1","1","3","4","1","1","1","1","1","1","1","1","1","1","1","1","2","1","2","1","2","2","1","1","2","2","2","1","1","1","1","1","1","1","2","1","1","1","1","2","2","1","2","2","2","2","1","1","1","1","1","1","1",
"1","2","1","1","2","2","1","2","1","1","1","1","1","1","1","2","2","2","2","2","2","2","2","1","1","3","3","3","2","2","2","1","1","3","1","2","3","3","3","2","1","2","3","3","3","5","5","3","2","1","2","2","2","2","2","1","2","1","1","1","1","1","1","1","1","1","1","1","1","1","2","2","1","2","1","1","1","1","1","1","2",
"1","2","1","1","1","2","3","2","1","1","2","2","1","1","1","3","2","3","3","1","2","2","1","1","1","1","3","2","2","3","2","2","1","2","3","2","1","2","1","1","1","2","2","2","5","3","5","1","2","2","1","1","2","2","1","2","2","3","1","2","1","3","2","1","2","1","1","2","1","1","1","1","2","2","2","3","3","2","1","1","2",
"2","1","3","1","1","5","3","1","1","1","1","1","1","2","1","1","1","2","1","1","1","1","1","1","2","1","1","1","2","1","2","3","1","2","2","2","1","2","1","1","1","3","3","1","2","1","3","1","1","2","2","1","1","2","1","1","1","2","1","2","2","3","1","1","2","3","1","2","1","1","1","1","1","2","1","1","2","1","1","1","1",
"1","1","1","1","1","1","2","2","1","1","3","1","1","1","2","1","3","1","1","1","1","1","1","2","1","1","1","1","1","1","1","1","3","1","1","2","1","2","1","1","1","2","3","1","2","1","1","2","1","1","1","1","1","1","1","1","1","3","1","2","1","1","1","2","2","2","2","2","5","1","1","1","1","1","2","2","1","1","1","2","1",
"2","1","1","1","1","1","1","5","1","3","1","1","1","1","1","1","1","1","1","1","3","1","1","1","1","1","1","1","1","3","3","1","1","1","3","1","1","1","1","1","1","3","1","1","1","3","5","1","3","3","3","5","1","1","1","1","1","1","3","3","3","3","1","1","1","3","5","1","1","1","1","1","5","3","2","2","4","3","1","1","1",
"1","3","3","3","1","1","1","3","1","1","1","4","3","3","4","3","1","1","1","3","1","5","4","3","2","2","3","2","2","2","1","1","1","2","2","2","1","2","1","1","2","1","3","2","1","2","2","2","1","1","1","1","1","1","2","1","1","1","2","3","1","1","3","2","1","1","1","1","1","1","3","4","2","2","2","1","3","1","1","2","2",
"3","4","1","2","2","1","2","3","3","2","4","4","1","1","3","3","3","3","3","2","1","1","1","1","3","2","3","3","2","3","3","3","4","2","2","2","2","2","2","2","2","2","2","2","1","1","1","1","1","1","1","1","2","1","1","1","1","3","3","1","1","2","2","2","2","2","2","2","2","1","2","2","4","2","2","2","2","2","2","1","2",
"2","3","3","2","5","3","2","3","2","2","3","3","3","3","4","3","3","3","3","4","3","4","3","4","5","5","3","4","3","3","3","3","3","3","3","2","3","3","3","3","3","3","3","3","3","3","3","2","2","3","2","2","2","2","2","2","2","2","2","2","3","3","3","3","2","2","3","2","2","3","2","2","1","1","1","1","1","1","3","3","1",
"2","2","3","3","4","2","3","3","2","1","1","1","1","1","1","1","1","3","2","2","1","2","1","2","1","1","3","2","1","2","4","2","2","2","1","2","2","2","2","2","2","2"
};
TriviaBot_Questions[1]['Hints'] = {
{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{"The heroes get to fight her during the events of Legion."},{},{"Not orange"},{},{"Not blue"},{"Not purple"
},{},{"Deep down into the Mountain"},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}
};


-- 43.9% of questions submitted by Nox
-- 53.4% of questions submitted by Alastor
-- 0.8% of questions submitted by Admantium
-- 2.0% of questions submitted by Diarah
-- 32.0% of questions award 2 points
-- 37.5% of questions award 1 points
-- 21.9% of questions award 3 points
-- 6.8% of questions award 4 points
-- 1.9% of questions award 5 points
-- 1176/1242 valid questions
-- question set compiled on 24/04/2019 20:14
