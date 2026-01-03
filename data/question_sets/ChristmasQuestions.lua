-- -------------------------------------------------- --
-- Skeleton question set (TriviaBot addQuestion format)
-- Categories are decades; add questions below.
-- -------------------------------------------------- --

local _, TriviaBot_Questions = ...
TriviaBot_Questions = TriviaBot_Questions or {}

local setIndex = #TriviaBot_Questions + 1
TriviaBot_Questions[setIndex] = {
  ['Categories'] = {},
  ['Questions'] = {},
}

-- Basic info about the set
TriviaBot_Questions[setIndex]['Title'] = "Christmas Trivia"
TriviaBot_Questions[setIndex]['Description'] = "Christmas-based trivia questions."
TriviaBot_Questions[setIndex]['Author'] = "Aszalia - Doomhowl"

-- Add categories (decades)
table.insert(TriviaBot_Questions[setIndex]['Categories'], "Christmas")

-- Questions
local function addQuestion(entry)
  table.insert(TriviaBot_Questions[setIndex]['Questions'], entry)
end

-- Traditions / Symbols
addQuestion({
  ['Question'] = "What plant do people traditionally kiss under at Christmas?",
  ['Answers'] = {"mistletoe"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Hang it in a doorway."},
})

addQuestion({
  ['Question'] = "What red-and-white striped candy is a classic Christmas treat?",
  ['Answers'] = {"candy cane", "candycanes", "candy canes"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Often hooked like a J."},
})

addQuestion({
  ['Question'] = "What prickly green plant with red berries is a common Christmas decoration?",
  ['Answers'] = {"holly"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Deck the halls with..." },
})

addQuestion({
  ['Question'] = "What do many kids traditionally leave out for Santa to eat and drink?",
  ['Answers'] = {"cookies and milk", "milk and cookies", "cookies", "milk"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Snack for a long night of deliveries."},
})

addQuestion({
  ['Question'] = "What do you call the day after Christmas (December 26) in many countries?",
  ['Answers'] = {"boxing day"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Not about punching."},
})

addQuestion({
  ['Question'] = "What is the name of the fictional gift-giver who visits on December 6 in parts of Europe?",
  ['Answers'] = {"saint nicholas", "st nicholas", "st. nicholas", "st nick"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"The OG Santa inspiration."},
})

-- Songs (no lyrics, just titles/facts)
addQuestion({
  ['Question'] = "Who sings the modern classic 'All I Want for Christmas Is You'?",
  ['Answers'] = {"mariah carey", "mariah"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"She *is* Christmas."},
})

addQuestion({
  ['Question'] = "What Christmas song features a glowing-nosed reindeer in its title?",
  ['Answers'] = {"rudolph the red-nosed reindeer", "rudolph the red nosed reindeer", "rudolph"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"The nose is the whole point."},
})

addQuestion({
  ['Question'] = "In 'The Christmas Song,' what food is described as roasting on an open fire?",
  ['Answers'] = {"chestnuts", "chestnut"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Not marshmallows."},
})

-- Reindeer / Santa lore
addQuestion({
  ['Question'] = "What is the name of Santa’s red-nosed reindeer?",
  ['Answers'] = {"rudolph"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Very shiny nose."},
})

addQuestion({
  ['Question'] = "Name ONE of Santa’s reindeer besides Rudolph.",
  ['Answers'] = {
    "dasher", "dancer", "prancer", "vixen", "comet", "cupid", "donner", "blitzen"
  },
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"There are 8 in the classic list."},
})

addQuestion({
  ['Question'] = "What is Santa’s workshop location traditionally said to be?",
  ['Answers'] = {"north pole", "the north pole"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Very cold."},
})

addQuestion({
  ['Question'] = "What holiday figure is known for leaving coal for bad kids?",
  ['Answers'] = {"santa", "santa claus", "saint nicholas", "st nick"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Naughty list vibes."},
})

-- Movies / Specials
addQuestion({
  ['Question'] = "In Home Alone, what city is Kevin’s family traveling to when they forget him?",
  ['Answers'] = {"paris"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Not New York (that’s the sequel)."},
})

addQuestion({
  ['Question'] = "In Home Alone, what do the burglars call themselves?",
  ['Answers'] = {"wet bandits", "the wet bandits"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Sticky, soggy calling card."},
})

addQuestion({
  ['Question'] = "In Elf, what is the main character’s name?",
  ['Answers'] = {"buddy"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"He’s an elf… kinda."},
})

addQuestion({
  ['Question'] = "In How the Grinch Stole Christmas, what is the name of the Grinch’s dog?",
  ['Answers'] = {"max"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Short and simple."},
})

addQuestion({
  ['Question'] = "What is the name of the town in How the Grinch Stole Christmas?",
  ['Answers'] = {"whoville"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Full of Whos."},
})

addQuestion({
  ['Question'] = "What 2000s Christmas movie features Tim Allen becoming Santa?",
  ['Answers'] = {"the santa clause", "santa clause"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Not 'Santa Claus'—it's the pun."},
})

addQuestion({
  ['Question'] = "In The Nightmare Before Christmas, what is the Pumpkin King’s name?",
  ['Answers'] = {"jack skellington", "jack"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"He’s bony."},
})

addQuestion({
  ['Question'] = "What classic stop-motion special features Hermey the elf who wants to be a dentist?",
  ['Answers'] = {"rudolph the red-nosed reindeer", "rudolph the red nosed reindeer", "rudolph"},
  ['Category'] = 1,
  ['Points'] = "3",
  ['Hints'] = {"A misfit reindeer and an abominable snow monster."},
})

addQuestion({
  ['Question'] = "What Christmas movie features a train taking kids to the North Pole?",
  ['Answers'] = {"the polar express", "polar express"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Tickets, hot chocolate, and believing."},
})

-- Literature / Classics
addQuestion({
  ['Question'] = "Who wrote 'A Christmas Carol'?",
  ['Answers'] = {"charles dickens", "dickens"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Victorian era author."},
})

addQuestion({
  ['Question'] = "In A Christmas Carol, what is Scrooge’s first name?",
  ['Answers'] = {"ebenezer"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Mr. ____ Scrooge."},
})

addQuestion({
  ['Question'] = "How many spirits visit Scrooge (not counting Jacob Marley)?",
  ['Answers'] = {"3", "three"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Past, Present, Future."},
})

-- Food / Drinks
addQuestion({
  ['Question'] = "What creamy holiday drink is traditionally made with eggs and nutmeg?",
  ['Answers'] = {"eggnog", "egg nog"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Sometimes spiked."},
})

addQuestion({
  ['Question'] = "What spiced warm drink is often made by heating wine with spices?",
  ['Answers'] = {"mulled wine", "gluhwein", "glühwein"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Holiday markets love it."},
})

addQuestion({
  ['Question'] = "What German Christmas bread is filled with dried fruit and often dusted with powdered sugar?",
  ['Answers'] = {"stollen"},
  ['Category'] = 1,
  ['Points'] = "3",
  ['Hints'] = {"Dense, festive loaf."},
})

addQuestion({
  ['Question'] = "What ginger-based cookie is often shaped like a person at Christmas?",
  ['Answers'] = {"gingerbread man", "gingerbread"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Run, run, as fast as you can..."},
})

-- Quick number / facts (chat-friendly)
addQuestion({
  ['Question'] = "How many total gifts are given in 'The Twelve Days of Christmas'?",
  ['Answers'] = {"364"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What is the FIRST gift mentioned in 'The Twelve Days of Christmas'?",
  ['Answers'] = {"partridge in a pear tree", "a partridge in a pear tree"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"A bird + a tree."},
})

-- “Fun / weird” Christmas facts
addQuestion({
  ['Question'] = "What animal is traditionally said to guide Santa’s sleigh?",
  ['Answers'] = {"reindeer"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Not horses."},
})

addQuestion({
  ['Question'] = "What do people traditionally hang on a fireplace for Santa to fill?",
  ['Answers'] = {"stockings", "stocking"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Sock, but fancy."},
})

addQuestion({
  ['Question'] = "What do you traditionally place on top of a Christmas tree: an angel or a ____?",
  ['Answers'] = {"star"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Shiny and pointy."},
})

addQuestion({
  ['Question'] = "What do you call a song sung outdoors by a group during Christmas season?",
  ['Answers'] = {"carol", "carols", "caroling"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"You might do it door-to-door."},
})

addQuestion({
  ['Question'] = "What is the name of the famous ballet typically performed around Christmas featuring the Sugar Plum Fairy?",
  ['Answers'] = {"the nutcracker", "nutcracker"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Tchaikovsky."},
})

addQuestion({
  ['Question'] = "What holiday character is known as a 'mean one' in a famous song?",
  ['Answers'] = {"the grinch", "grinch"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Stole Christmas."},
})

addQuestion({
  ['Question'] = "What do you call the night before Christmas?",
  ['Answers'] = {"christmas eve", "xmas eve"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Dec 24."},
})

addQuestion({
  ['Question'] = "What do people traditionally build outside when it snows a lot, using three big balls of snow?",
  ['Answers'] = {"snowman", "a snowman"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Carrot nose optional."},
})

addQuestion({
  ['Question'] = "What do you call Santa’s list of well-behaved kids?",
  ['Answers'] = {"nice list", "the nice list"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"The opposite is naughty."},
})

addQuestion({
  ['Question'] = "In Alpine folklore, what horned figure accompanies Saint Nicholas to punish naughty children?",
  ['Answers'] = {"krampus"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Half-goat, half-demon vibes."},
})

addQuestion({
  ['Question'] = "Who is famously responsible for saying the line 'Bah Humbug? (First and Last name)",
  ['Answers'] = {"Ebenezer Scrooge"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {},
})

-- Ensure the global table exists and register with TriviaClassic if present
_G.TriviaBot_Questions = TriviaBot_Questions
if TriviaClassic and TriviaClassic.RegisterTriviaBotSet then
  TriviaClassic:RegisterTriviaBotSet("Christmas Trivia", TriviaBot_Questions)
end