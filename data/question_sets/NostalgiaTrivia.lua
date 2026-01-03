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
TriviaBot_Questions[setIndex]['Title'] = "Nostalgia Trivia"
TriviaBot_Questions[setIndex]['Description'] = "Decade-based trivia questions."
TriviaBot_Questions[setIndex]['Author'] = "Aszalia - Doomhowl"

-- Add categories (decades)
table.insert(TriviaBot_Questions[setIndex]['Categories'], "1990s")
table.insert(TriviaBot_Questions[setIndex]['Categories'], "2000s")
table.insert(TriviaBot_Questions[setIndex]['Categories'], "2010s")

-- Questions
local function addQuestion(entry)
  table.insert(TriviaBot_Questions[setIndex]['Questions'], entry)
end

-- TV / Cartoons
addQuestion({
  ['Question'] = "What animated 90s show followed four boys: Stan, Kyle, Cartman, and Kenny?",
  ['Answers'] = {"south park"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Oh my god… they ____ him!"},
})

addQuestion({
  ['Question'] = "What Nickelodeon show featured a baby genius named Tommy Pickles?",
  ['Answers'] = {"rugrats"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Tommy Pickles."},
})

addQuestion({
  ['Question'] = "What 90s cartoon featured the heroes Leonardo, Donatello, Michelangelo, and Raphael?",
  ['Answers'] = {"teenage mutant ninja turtles", "tmnt"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Cowabunga."},
})

addQuestion({
  ['Question'] = "What TV family lived at 742 Evergreen Terrace?",
  ['Answers'] = {"the simpsons", "simpsons"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"D'oh!"},
})

addQuestion({
  ['Question'] = "What 90s sitcom featured six friends hanging out at Central Perk?",
  ['Answers'] = {"friends"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Pivot!"},
})

addQuestion({
  ['Question'] = "What 90s show starred a teen witch named Sabrina?",
  ['Answers'] = {"sabrina the teenage witch", "sabrina"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Her cat talks."},
})

addQuestion({
  ['Question'] = "What 90s show starred Will Smith moving to Bel-Air?",
  ['Answers'] = {"the fresh prince of bel-air", "fresh prince of bel-air", "fresh prince"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Now this is a story all about how…"},
})

addQuestion({
  ['Question'] = "What 90s cartoon featured a secret agent dog named Scooby's *very different* cousin? (Hint: he’s not a dog.)",
  ['Answers'] = {"courage the cowardly dog", "courage"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Return the slab!"},
})

addQuestion({
  ['Question'] = "What 90s cartoon had a superhero duo named Yakko, Wakko, and Dot?",
  ['Answers'] = {"animaniacs"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Warner siblings."},
})

addQuestion({
  ['Question'] = "What 90s anime featured collecting seven magical orbs to summon a dragon?",
  ['Answers'] = {"dragon ball z", "dbz", "dragonball z"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Over 9000."},
})

-- Movies
addQuestion({
  ['Question'] = "In The Matrix, what color pill does Neo take to learn the truth?",
  ['Answers'] = {"red"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"The other one keeps you asleep."},
})

addQuestion({
  ['Question'] = "What 90s movie features a toy cowboy named Woody and a space ranger named Buzz?",
  ['Answers'] = {"toy story"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"To infinity and beyond!"},
})

addQuestion({
  ['Question'] = "What 90s movie features a lion named Simba and a villain named Scar?",
  ['Answers'] = {"the lion king", "lion king"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Circle of life."},
})

addQuestion({
  ['Question'] = "What 90s Christmas movie features a kid left behind who sets traps for burglars?",
  ['Answers'] = {"home alone"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Wet Bandits."},
})

addQuestion({
  ['Question'] = "What 90s movie features dinosaurs brought back on an island theme park?",
  ['Answers'] = {"jurassic park"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Life, uh… finds a way."},
})

addQuestion({
  ['Question'] = "What 90s movie has the quote, 'You can't handle the truth!'?",
  ['Answers'] = {"a few good men"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Courtroom drama."},
})

-- Music
addQuestion({
  ['Question'] = "What band is famous for the song 'Smells Like Teen Spirit'?",
  ['Answers'] = {"nirvana"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Grunge."},
})

addQuestion({
  ['Question'] = "What girl group sang 'Wannabe'?",
  ['Answers'] = {"spice girls", "the spice girls"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Tell me what you want, what you really really want."},
})

addQuestion({
  ['Question'] = "What rapper’s 90s hit asked, '…in the middle like you a little…' (Answer: the artist)?",
  ['Answers'] = {"sir mix-a-lot", "sir mixalot"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Big butts."},
})

addQuestion({
  ['Question'] = "What boy band sang 'I Want It That Way'?",
  ['Answers'] = {"backstreet boys", "the backstreet boys"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Tell me why…"},
})

addQuestion({
  ['Question'] = "What singer is known for the 90s hit '…Baby One More Time'?",
  ['Answers'] = {"britney spears", "britney"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"School uniform music video."},
})

-- Toys / Trends
addQuestion({
  ['Question'] = "What was the name of the little digital pet you kept alive on a keychain?",
  ['Answers'] = {"tamagotchi"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Beep. Feed me."},
})

addQuestion({
  ['Question'] = "What 90s toy is a spring that 'walks' down stairs?",
  ['Answers'] = {"slinky"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"It’s… a spring."},
})

addQuestion({
  ['Question'] = "What fuzzy 90s toy was 'adopted' and could talk if you fed it batteries?",
  ['Answers'] = {"furby", "furbies"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"It learned words (sort of)."},
})

addQuestion({
  ['Question'] = "What collectible 90s toy line featured little pocket monsters in plastic balls? (Not Pokémon.)",
  ['Answers'] = {"mighty max"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Skulls/monster-themed compacts."},
})

addQuestion({
  ['Question'] = "What 90s fad involved slapping a band on your wrist so it curled around?",
  ['Answers'] = {"slap bracelet", "slap bracelets"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Schools banned them."},
})

addQuestion({
  ['Question'] = "What is the name of the 90s toy that was a squishy, water filled tube that was difficult to hold in your hand?",
  ['Answers'] = {"water snake"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Kinda resembles a sex toy..."},
})

-- Games / Consoles
addQuestion({
  ['Question'] = "What Nintendo console came after the SNES and used cartridges in the 90s?",
  ['Answers'] = {"nintendo 64", "n64"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Four controller ports."},
})

addQuestion({
  ['Question'] = "What 90s handheld is famous for playing Tetris everywhere?",
  ['Answers'] = {"game boy", "gameboy"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Greenish screen."},
})

addQuestion({
  ['Question'] = "What 90s fighting game popularized 'Finish Him!'?",
  ['Answers'] = {"mortal kombat"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Fatality."},
})

addQuestion({
  ['Question'] = "In Pokémon Red/Blue, what item do you need to catch Pokémon?",
  ['Answers'] = {"pokeball", "poke ball", "poké ball"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Gotta catch 'em all."},
})

addQuestion({
  ['Question'] = "What 90s PC game let you die of dysentery on a wagon trip west?",
  ['Answers'] = {"the oregon trail", "oregon trail"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"School computer lab classic."},
})

-- Tech / Internet
addQuestion({
  ['Question'] = "What was the name of the 90s dial-up sound that haunted everyone? (Answer with the service name.)",
  ['Answers'] = {"aol", "america online"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"You've got mail!"},
})

addQuestion({
  ['Question'] = "What 90s portable music player used interchangeable cassette tapes?",
  ['Answers'] = {"walkman", "sony walkman"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Clipped to your belt."},
})

addQuestion({
  ['Question'] = "What storage device was a stiff square you 'saved' to in the 90s? (3.5-inch.)",
  ['Answers'] = {"floppy disk", "floppy", "diskette"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"The 'save' icon."},
})

-- Food / Snacks
addQuestion({
  ['Question'] = "What 90s snack featured kangaroo-shaped cookies and a sweet, creamy dip?",
  ['Answers'] = {"Dunkaroos"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What 90s drink came in a plastic bottle shaped like a barrel?",
  ['Answers'] = {"hugs", "hugs juice", "hugs drink"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Sticky hands guaranteed."},
})

-- Slightly harder deep cuts
addQuestion({
  ['Question'] = "What 90s cartoon featured a wallaby named Rocko?",
  ['Answers'] = {"rocko's modern life"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Oh-Town."},
})

addQuestion({
  ['Question'] = "What 90s show had the spooky intro line 'The truth is out there'?",
  ['Answers'] = {"the x-files", "x-files", "x files"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Mulder and Scully."},
})

addQuestion({
  ['Question'] = "What 90s cartoon had a dog and a baby: Spike and Tommy? (Name the show.)",
  ['Answers'] = {"rugrats"},
  ['Category'] = 1,
  ['Points'] = "1",
  ['Hints'] = {"Diaper squad."},
})


-- 2000s

-- TV / Cartoons
addQuestion({
  ['Question'] = "What is the name of the company that Dwight Schrute and Michael Scott work for?",
  ['Answers'] = {"Dunder Mifflin"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {},
})

addQuestion({
  ['Question'] = "What 2000s TV drama began with a plane crash on a mysterious island?",
  ['Answers'] = {"lost"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Numbers: 4 8 15 16 23 42."},
})

addQuestion({
  ['Question'] = "What Nickelodeon show featured teens running a web show?",
  ['Answers'] = {"icarly", "i carly"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"iSomething."},
})

addQuestion({
  ['Question'] = "What Disney Channel show starred a pop star living a double life?",
  ['Answers'] = {"hannah montana"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Best of both worlds."},
})

addQuestion({
  ['Question'] = "What animated series featured the phrase '...then everything changed when the fire nation attacked?'",
  ['Answers'] = {"avatar the last airbender", "avatar: the last airbender", "atla"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Element-bending."},
})

addQuestion({
  ['Question'] = "What show featured Adam and Jamie testing myths?",
  ['Answers'] = {"mythbusters", "myth busters"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Busted / Plausible / Confirmed."},
})

addQuestion({
  ['Question'] = "What reality show launched the catchphrase 'You’re fired!'?",
  ['Answers'] = {"the apprentice", "apprentice"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Boardroom."},
})

-- Movies
addQuestion({
  ['Question'] = "What 2000s trilogy begins with a ring found by Frodo Baggins?",
  ['Answers'] = {"the lord of the rings", "lord of the rings", "lotr"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"One ring to rule them all."},
})

addQuestion({
  ['Question'] = "What wizarding movie franchise features 'He who must not be named?'",
  ['Answers'] = {"harry potter"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Hogwarts letter."},
})

addQuestion({
  ['Question'] = "What 2003 movie franchise features Captain Jack Sparrow?",
  ['Answers'] = {"pirates of the caribbean", "pirates of the caribbean: the curse of the black pearl", "pirates"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Why is the rum gone?"},
})

addQuestion({
  ['Question'] = "What animated ogre movie featured Donkey and a princess named Fiona?",
  ['Answers'] = {"shrek"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Somebody once told me..."},
})

addQuestion({
  ['Question'] = "What Pixar movie featured a clownfish dad searching for his son?",
  ['Answers'] = {"finding nemo"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Just keep swimming."},
})

addQuestion({
  ['Question'] = "What 2004 teen comedy says 'On Wednesdays we wear pink'?",
  ['Answers'] = {"mean girls"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"The Plastics."},
})

addQuestion({
  ['Question'] = "What 2008 superhero movie launched the Marvel Cinematic Universe?",
  ['Answers'] = {"iron man"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"I am Iron Man."},
})

addQuestion({
  ['Question'] = "What 2009 movie featured blue aliens on the moon Pandora?",
  ['Answers'] = {"avatar"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Na'vi."},
})

-- Music
addQuestion({
  ['Question'] = "What band released the 2000s hit 'In the End'?",
  ['Answers'] = {"linkin park"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"One thing... I don't know why..."},
})

addQuestion({
  ['Question'] = "What artist sang 'Yeah!' featuring Lil Jon and Ludacris?",
  ['Answers'] = {"usher"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"2004 club anthem."},
})

addQuestion({
  ['Question'] = "What group sang the 2003 hit 'Hey Ya!'?",
  ['Answers'] = {"outkast", "outkast!"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Shake it like a..."},
})

addQuestion({
  ['Question'] = "What artist sang 'Umbrella' (ella ella eh eh eh)?",
  ['Answers'] = {"rihanna"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Featuring Jay-Z."},
})

addQuestion({
  ['Question'] = "What singer released 'Poker Face' in the late 2000s?",
  ['Answers'] = {"lady gaga", "gaga"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Pop icon, meat dress era."},
})

addQuestion({
  ['Question'] = "What band released the 2000s song 'Mr. Brightside'?",
  ['Answers'] = {"the killers", "killers"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Coming out of my cage..."},
})

addQuestion({
  ['Question'] = "What group sang 'I Gotta Feeling'?",
  ['Answers'] = {"the black eyed peas", "black eyed peas"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Tonight's gonna be a good night."},
})

-- Games / Consoles
addQuestion({
  ['Question'] = "What console launched in 2000 and became the best-selling console ever?",
  ['Answers'] = {"playstation 2", "ps2"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Sony."},
})

addQuestion({
  ['Question'] = "What Nintendo motion-control console became associated with broken tvs and injuries?",
  ['Answers'] = {"wii", "nintendo wii"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Bowling injuries."},
})

addQuestion({
  ['Question'] = "What handheld had two screens and a stylus (launched mid-2000s)?",
  ['Answers'] = {"nintendo ds", "ds"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Touch screen."},
})

addQuestion({
  ['Question'] = "What 2001 shooter introduced Master Chief on Xbox?",
  ['Answers'] = {"halo", "halo: combat evolved", "halo combat evolved"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Finish the fight (later)."},
})

addQuestion({
  ['Question'] = "What rhythm game had plastic guitars and made everyone feel like a rock star?",
  ['Answers'] = {"guitar hero"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Strum bar."},
})

addQuestion({
  ['Question'] = "What 2007 game by Valve featured portals and the line 'The cake is a lie'?",
  ['Answers'] = {"portal"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Aperture Science."},
})

addQuestion({
  ['Question'] = "What 2007 shooter is famous for the phrase 'The nuke…' and 'No Russian' (later) — name the game series entry?",
  ['Answers'] = {"call of duty 4", "cod4", "call of duty 4: modern warfare", "modern warfare"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Captain Price era."},
})

addQuestion({
  ['Question'] = "What open-world crime game set in a fictional California starred CJ?",
  ['Answers'] = {"gta san andreas", "grand theft auto: san andreas", "san andreas"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"All you had to do..."},
})

-- Internet / Tech / Memes
addQuestion({
  ['Question'] = "What social network was famous for your 'Top 8' friends?",
  ['Answers'] = {"myspace", "my space"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Profile music autoplay."},
})

addQuestion({
  ['Question'] = "What video site launched in 2005 and became the default for cat videos?",
  ['Answers'] = {"youtube", "you tube"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Subscribe."},
})

addQuestion({
  ['Question'] = "What microblogging platform launched in the mid-2000s and popularized the hashtag later?",
  ['Answers'] = {"twitter"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"140 characters (back then)."},
})

addQuestion({
  ['Question'] = "What phone (brand line) debuted in 2007 and basically reinvented smartphones?",
  ['Answers'] = {"iphone", "i phone"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Apple."},
})

addQuestion({
  ['Question'] = "What 2007 prank involved clicking a link and getting hit with Rick Astley?",
  ['Answers'] = {"rickroll", "rick roll"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Never gonna give you up."},
})

addQuestion({
  ['Question'] = "What messenger app had away messages, buddy lists, and the classic door-opening sound?",
  ['Answers'] = {"aim", "aol instant messenger"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Not MSN."},
})

addQuestion({
  ['Question'] = "What 2000s online image format and culture gave us 'I can has cheezburger'?",
  ['Answers'] = {"lolcats", "lolcat"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Broken English cats."},
})

-- Toys / Trends / Stuff kids begged for
addQuestion({
  ['Question'] = "What toy line involved spinning tops you battled in plastic arenas?",
  ['Answers'] = {"beyblade", "beyblades"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Let it rip!"},
})

addQuestion({
  ['Question'] = "What plush toy brand had 'adoption codes' you used to play online?",
  ['Answers'] = {"webkinz", "webkinz plush"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Virtual pet + stuffed animal."},
})

addQuestion({
  ['Question'] = "What fashion doll brand was the edgy competitor to Barbie in the 2000s?",
  ['Answers'] = {"bratz", "bratz dolls"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Big heads, big attitude."},
})

addQuestion({
  ['Question'] = "What bracelet fad let you wear rubber shapes (animals, letters, etc.) in the late 2000s?",
  ['Answers'] = {"silly bandz", "silly bands", "sillybandz"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"They snapped back into shape."},
})

-- Quick “number” ones (chat-friendly)
addQuestion({
  ['Question'] = "What year did YouTube launch? (number only)",
  ['Answers'] = {"2005"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Mid-2000s."},
})

addQuestion({
  ['Question'] = "What year did the first iPhone release? (number only)",
  ['Answers'] = {"2007"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Late-2000s."},
})

addQuestion({
  ['Question'] = "What year did the Nintendo Wii launch? (number only)",
  ['Answers'] = {"2006"},
  ['Category'] = 2,
  ['Points'] = "1",
  ['Hints'] = {"Motion controls era begins."},
})



-- Ensure the global table exists and register with TriviaClassic if present
_G.TriviaBot_Questions = TriviaBot_Questions
if TriviaClassic and TriviaClassic.RegisterTriviaBotSet then
  TriviaClassic:RegisterTriviaBotSet("Nostalgia Trivia", TriviaBot_Questions)
end
