local _, TriviaBot_Questions = ...
TriviaBot_Questions = TriviaBot_Questions or {}

local setIndex = #TriviaBot_Questions + 1
TriviaBot_Questions[setIndex] = {
  ["Categories"] = {},
  ["Questions"] = {},
}

TriviaBot_Questions[setIndex]["Title"] = "Trump Quote Check"
TriviaBot_Questions[setIndex]["Description"] = "Decide whether each quote is a genuine Trump quote or a fake one written for the game."
TriviaBot_Questions[setIndex]["Author"] = "Codex"
TriviaBot_Questions[setIndex]["Modes"] = { "TRUMP_QUOTE" }

table.insert(TriviaBot_Questions[setIndex]["Categories"], "Trump Quote Check")

local CAT_QUOTES = 1

local function addQuestion(entry)
  table.insert(TriviaBot_Questions[setIndex]["Questions"], entry)
end

local function addFakeQuote(quote)
  addQuestion({
    ["Question"] = quote,
    ["Answers"] = { "FAKE" },
    ["Reveal"] = "Fake. Written for TriviaClassic.",
    ["Category"] = CAT_QUOTES,
    ["Points"] = "1",
    ["Hints"] = {},
  })
end

local function addRealQuote(quote, reveal)
  addQuestion({
    ["Question"] = quote,
    ["Answers"] = { "REAL" },
    ["Reveal"] = reveal,
    ["Category"] = CAT_QUOTES,
    ["Points"] = "1",
    ["Hints"] = {},
  })
end

addRealQuote("I never understood wind.", "Real. Turning Point USA speech, December 2019.")
addRealQuote("Show me someone without an ego, and I'll show you a loser.", "Real. Trump, 2012.")
addRealQuote("I was the best baseball player in New York when I was young.", "Real. Trump, 2017.")
addRealQuote("My fingers are long and beautiful, as, it has been well documented, are various other parts of my body.", "Real. Trump, 2011.")
addRealQuote("People are flushing toilets 10 times, 15 times, as opposed to once.", "Real. Small business roundtable, December 2019.")
addRealQuote("Because my hair - I don't know about you, but it has to be perfect.", "Real. Regulatory rollback remarks, July 2020.")
addRealQuote("I always look orange. And so do you.", "Real. House Republican retreat dinner, September 2019.")
addRealQuote("I never thought a word would sound so good. It's called 'total acquittal.'", "Real. Post-acquittal White House remarks, February 2020.")
addRealQuote("We'll have an economy based on wind.", "Real. Turning Point USA speech, December 2019.")
addRealQuote("Then I have an Article 2, where I have the right to do whatever I want as President.", "Real. Turning Point USA student summit, July 2019.")
addRealQuote("I don't take responsibility at all", "Real. Coronavirus task force press conference, March 2020.")
addRealQuote("If we did half the testing, we would have half the cases.", "Real. Press conference, July 2020.")
addRealQuote("Success in this fight will require the full, absolute measure of our collective strength, love, and devotion.", "Real. Coronavirus task force briefing, April 2020.")
addRealQuote("I know more about grass than any human being, I think, anywhere in the world.", "Real. Remarks in D.C. 2025")
addRealQuote("This is an island surrounded by water — big water, ocean water.", "Real. Remarks on Puerto Rico Hurricane Response. 2017.")
addRealQuote("I am the least racist person ever to serve in office, okay? I am the least racist person.", "Real. Marine One Departure Remarks 2019")
addRealQuote("Good luck. Hope you don’t test positive.", "Real. Jokingly ominous sendoff. Rose Garden 2020")
addRealQuote("I don't think plastic is going to affect a shark very much as they're munching their way through the ocean.", "Real. Remarks while signing E.O. Feb. 2025")
addRealQuote("I wouldn't mind if there were an anti-Viagra, something with the opposite effect. I'm not bragging. I'm just lucky.", "Real, Playboy Oct. 2004")
addRealQuote("All of the women on The Apprentice flirted with me - consciously or unconsciously. That's to be expected.", "Real. Trump: How To Get Rich, 2004")
addRealQuote("In life you have to rely on the past, and that’s called history.", "Real. Celebrity Apprentice. S07E11")
addRealQuote("At the Super Bowl, when Beyonce was thrusting her hips forward in a very suggestive manner, if someone else had done that, it would've been a national scandal. I thought it was ridiculous.", "Real. Howard Stern Feb 2013.")
addRealQuote("When someone is nice to me, I love that person. Even if they’re bad people. I couldn’t care less.", "Real. Mar 2026.")
addRealQuote("I know a lot about golf. I’ve won 38 club championships, and I don’t get to practice much.", "Real, Interview Nov 2025")


addFakeQuote("The Statue of Liberty would absolutely vote for me.")
addFakeQuote("Clouds are basically the ceiling of America.")
addFakeQuote("I walk into a room and the lighting gets better, because it knows I'm there. It just knows.")
addFakeQuote("I have the best handshake in America; it's like a brand, okay?")
addFakeQuote("I could make a sandwich so beautiful you'd put it in a museum.")
addFakeQuote("The escalator is one of the great inventions, and I've seen them all - nobody respects escalators more than me.")
addFakeQuote("I look at a menu and the menu gets nervous. It knows I'll pick the best thing.")
addFakeQuote("I invented the phrase 'humanitarian' - and everybody knows it.")
addFakeQuote("I could sell ice to an iceberg - tremendous dealmaking.")
addFakeQuote("I've seen a lot of ceilings - beautiful ceilings - and I know acoustics better than the people who claim to.")
addFakeQuote("I could make a suitcase so efficient you'd cry. You'd say, 'Sir, it's beautiful.'")
addFakeQuote("I like elevators. Escalators are fine too, but elevators - very loyal, very strong.")
addFakeQuote("My handwriting is so strong the pen gets nervous. That's real power.")
addFakeQuote("Some executive orders are total disasters. Mine are so beautiful you'd frame it.")
addFakeQuote("I am not a fan of books. I would never want a book's autograph.")
addFakeQuote("My desk is so clean, it’s unbelievable. People come in, they look at it, and they start weeping.")
addFakeQuote("People are charging phones that are already at 100 percent. Fully charged, and they charge them again.")
addFakeQuote("I don’t respect chaos unless it’s organized around me.")
addFakeQuote("You learn everything you need to know about leadership from who reaches for the last shrimp.")
addFakeQuote("A lot of very weak people have learned how to sound reasonable.")
addFakeQuote("I’ve always had a good instinct for who’s bluffing. It’s almost a burden.")
addFakeQuote("A weak person’s favorite word is ‘complicated.’")
addFakeQuote("I’ve never been impressed by consensus. Consensus is what happens when nobody can win.")

_G.TriviaBot_Questions = TriviaBot_Questions
if TriviaClassic and TriviaClassic.RegisterTriviaBotSet then
  TriviaClassic:RegisterTriviaBotSet("Trump Quote Check", TriviaBot_Questions)
end
