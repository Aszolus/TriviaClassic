TriviaClassic
=============

TriviaClassic is a World of Warcraft Classic Era addon for hosting quick trivia games in guild/party/raid/custom channels. It supports timed questions, multiple game modes, per-character leaderboards, and optional team management.

Getting Started
---------------
- Install: copy the `TriviaClassic` folder into `_classic_era_/Interface/AddOns/`.
- Launch: log in and type `/trivia` to open the UI.
- Channel: pick Guild/Party/Raid/Say/Yell or a custom channel (joins automatically).
- Sets & categories: choose which question sets/categories to include; the question counter updates live.
- Timer: set the per-question timer (clamped to allowed min/max).
- Steal timer: for Team Steal mode, set a separate timer used during steal attempts.
- Mode: select a game mode (see below); the choice is saved per character.
- Start: click **Start**, then **Next** to announce questions. Use **Skip** to replace a question. Click **Announce Winner/Results** after timeouts.
- Answers: players respond in the configured channel; correct answers are detected automatically.

Game Modes
----------
- Fastest: first correct answer wins the question.
- All Correct: all players who answer correctly before time expires score points; results are announced when time is up.
- Team: credits the answering player’s team; announcements include team name and members.
- Team Steal: active team must answer with `final:`; on wrong/timeout, another team can steal the same question with the same timer.
New modes can be added by registering a handler under `GameModes/` (one file per mode, see existing examples).

Teams (optional)
----------------
Use the Teams tab to create teams, register players, and move them between teams. Team assignments are stored per character.

Data & Persistence
------------------
- Per-character data is stored in `TriviaClassicCharacterDB` (scores, leaderboard, fastest time, mode, timer, teams).
- A session scoreboard is shown in the UI; all-time leaderboard is persisted.

Files & Structure
-----------------
- `Constants.lua`: channel and mode definitions.
- `GameModes/`: per-mode logic/state (one file per mode) and the mode registry.
- `Game.lua`: core game flow (question selection, scoring, timers).
- `Chat.lua`: outbound chat messaging and event filtering.
- `QuestionRepository.lua` / `QuestionLoader.lua`: question set management and import helpers.
- `UI/*.lua` and `UI.lua`: frame layout, dropdowns, team UI, and in-game controls.
- `QuestionSets/*.lua`: bundled trivia sets (TriviaBot format).
- `TriviaClassic.toc`: addon load order.

Development Notes
-----------------
- To add a new mode, create a handler file under `GameModes/` (provide `createState`, `beginQuestion`, `handleCorrect`, `onTimeout`, and optional `pendingWinners`/`winnerCount`/`resetProgress`/`primaryAction`), then register it.
- To add a question set, drop a TriviaBot-style table into `QuestionSets/` and list it in the `.toc`.
- Avoid altering saved variable keys unless you also handle migration (`SCHEMA_VERSION` in `Core.lua`).

Commands
--------
- `/trivia` — toggle the main UI.
- `/trivia scores` — print the top leaderboard entries to your chat frame.
