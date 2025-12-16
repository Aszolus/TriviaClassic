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
- `core/` — shared runtime and init
  - `core/Constants.lua`: channel and mode definitions
  - `core/Types.lua`: EmmyLua type hints
  - `core/Util.lua`: trim/normalize/clamp helpers
  - `core/Events.lua`: lightweight event bus
  - `core/Init.lua`: addon init, DB, event frame
- `game/` — core game runtime + services
  - `game/Game.lua`: game state machine (question flow, scoring, timers)
  - `game/Chat.lua`: outbound chat transport and event filtering
  - `game/MessageFormatter.lua`: default chat formatting
  - `game/TimerService.lua`: per-question timer logic for the UI
  - `game/ScoreboardService.lua`: scoreboard rendering helpers
  - `game/AnswerService.lua`: shared answer normalization/extraction/matching
- `repo/` — question data and import
  - `repo/QuestionRepository.lua`: set storage and pool building
  - `repo/QuestionLoader.lua`: entry point for bundled sets
  - `repo/TriviaBotImporter.lua`: TriviaBot-format importer
- `modes/` — encapsulated game modes (one file per mode)
  - `modes/Registry.lua`: mode registration and resolver
  - `modes/Fastest.lua`, `modes/AllCorrect.lua`, `modes/Team.lua`, `modes/TeamSteal.lua`
    - Each mode can provide: `logic` (required), `view` (optional), `format` (optional)
- `ui/` — thin view + presenter orchestration
  - `ui/Layout.lua`, `ui/Constants.lua`, `ui/Helpers.lua`
  - `ui/components/SelectableList.lua`
  - `ui/Presenter.lua`: orchestrates actions and chat (button-driven only)
  - `ui/UI.lua`: frames and UI state; defers logic to Presenter
- `data/question_sets/*.lua`: bundled trivia sets (TriviaBot format)
- `TriviaClassic.toc`: explicit load order

Development Notes
-----------------
Adding a Mode (encapsulated)
- Create `modes/YourMode.lua` and call `TriviaClassic_RegisterMode("YOUR_MODE", handler)`.
- Provide logic handlers:
  - `createState()` — returns per-mode context
  - `beginQuestion(ctx, game)` — reset flags at question start
  - `evaluateAnswer(game, ctx, sender, rawMsg)` — enforce eligibility and use AnswerService
    - Example: `local A = TriviaClassic_Answer; local msg = A.extract(rawMsg,{requiredPrefix="final:"}); if msg and A.match(msg, game:GetCurrentQuestion()) then ... end`
  - `handleCorrect(game, ctx, sender, elapsed)` — record result and set pending flags
  - `onTimeout(game, ctx)` — rotate or finalize when window expires
  - Optional: `pendingWinners`, `winnerCount`, `resetProgress`, `onSkip`
- Provide view hooks (optional):
  - `view.primaryAction(game, ctx) -> {label, enabled, command}`
  - `view.getQuestionTimerSeconds(game, ctx) -> number` (e.g., return a different timer for reuse windows)
  - `view.scoreboardRows(game) -> rows, fastestName, fastestTime` (team/solo rows)
  - Optional status text helpers like `view.onWinnerFound(game, ctx, result)`
- Provide format hooks (optional): override pieces of MessageFormatter
  - e.g., `format.formatQuestion(index,total,question,active)` or `format.formatWinners(winners, question)`

Answer Policy (shared)
- All modes share the same normalization/matching via `TriviaClassic_Answer`:
  - `normalize(text)`: lowercase, trim, collapse spaces, strip leading/trailing punctuation
  - `extract(raw, opts)`: apply small input rules (e.g., `requiredPrefix="final:"`)
  - `match(candidate, question)`: compares to pre-normalized `question.answers`
- Use AnswerService in `evaluateAnswer`; do not hand-roll normalization.

Advance Flow (generic)
- The UI’s primary button triggers `Presenter:OnPrimaryPressed()` which calls `Game:PerformPrimaryAction("advance")`.
- The active mode’s `handler.onAdvance(game, ctx)` can either:
  - Reopen the current question (reuse window) by setting `questionOpen=true` and returning `{question,index,total,reuse=true}`
  - Or advance to the next question
- Presenter always announces via `format.formatQuestion(...)`, and sets timer via `view.getQuestionTimerSeconds(...)`.
- No mode-specific events/commands are needed in UI/Core.

Hardware-event chat rule
- Only the Presenter sends chat, and only in response to button clicks (user actions).
- Modes never send chat; they return strings via `format` or data for Presenter to send.

Question Sets
- Drop a TriviaBot-style set into `data/question_sets/` and list it in the `.toc`.
- The importer normalizes answers using the shared `AnswerService`.

Saved Variables
- Avoid altering saved variable keys unless you handle migration (see `SCHEMA_VERSION` in `core/Init.lua`).

Commands
--------
- `/trivia` — toggle the main UI.
- `/trivia scores` — print the top leaderboard entries to your chat frame.
