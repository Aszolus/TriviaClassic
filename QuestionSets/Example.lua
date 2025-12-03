-- -------------------------------------------------- --
-- Minimal question set template for TriviaClassic
-- This set has exactly 2 questions, 2 hints, 2 answers.
-- -------------------------------------------------- --

local _, TriviaBot_Questions = ...
TriviaBot_Questions = TriviaBot_Questions or {}
_G.TriviaBot_Questions = TriviaBot_Questions

TriviaBot_Questions[1] = {
  ['Categories'] = {},
  ['Question']   = {},
  ['Answers']    = {},
  ['Category']   = {},
  ['Points']     = {},
  ['Hints']      = {}
};

TriviaBot_Questions[1]['Title']       = "Deadliest of Azeroth"
TriviaBot_Questions[1]['Description'] = "Questionset about the different deadly creatures a player faces in Hardcore WoW and about Classic"
TriviaBot_Questions[1]['Author']      = "Aszolus-Doomhowl"

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

if TriviaClassic and TriviaClassic.RegisterTriviaBotSet then
  TriviaClassic:RegisterTriviaBotSet("Deadliest of Azeroth", TriviaBot_Questions)
end
