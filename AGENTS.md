# AGENTS.md

Purpose
- Guidance for AI or human agents working in this repository.
- Keep instructions short, concrete, and aligned with WoW addon constraints.

Environment
- Target: World of Warcraft Classic Era addon.
- Runtime APIs: WoW Lua globals (CreateFrame, SendChatMessage, etc.).
- No external libraries; prefer existing helpers in core/ and game/.

Repo layout
- core/: runtime, storage, events, shared helpers.
- game/: game state machine, chat formatting, timers, scoring.
- modes/: axis-composed handlers (participation/flow/scoring/view).
- repo/: question sets, importer, repository.
- UI/: frames, presenter, and UI utilities.
- data/question_sets/: bundled TriviaBot-format sets.

Design principles
- Presenter sends chat only on user actions.
- Game logic is side-effect free; UI owns timers and user-visible status text.
- Modes should return data/format strings; avoid direct chat/UI calls.
- Keep helpers centralized (avoid duplicate trim/normalize logic).

Coding conventions
- Lua 5.1 style; minimize globals, prefer local functions.
- Avoid implicit nil behavior; validate inputs at boundaries.
- Prefer deterministic behavior unless randomness is required (document it).
- Use EmmyLua annotations for public-facing types/functions.

Refactor safety
- Do not change saved variable keys without a migration plan.
- Avoid breaking .toc load order or file naming conventions.
- When touching UI/UI.lua, keep changes minimal or split into new modules.

Tests
- tests/ contains Lua unit tests runnable via tests/run_tests.lua.
- Add or update tests when changing AnswerService or game flow logic.

PR checklist
- Scan for duplicated helpers; consolidate if you touched them.
- Ensure mode composition still works for open/turn-based/steal flows.
- Verify chat text stays under 220 characters (MessageFormatter/Chat).
