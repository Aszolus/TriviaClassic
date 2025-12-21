# TriviaClassic Style Guide

Scope
- Lua code only (WoW Classic Era addon).
- Keep rules short and enforceable.

Module structure
- One module = one file; avoid cross-file globals.
- Use a single table per module (`local M = {}`) and return/export via global only once.
- Keep globals prefixed with `TriviaClassic_` when unavoidable.

Naming
- Functions: `VerbNoun` (e.g., `BuildPool`, `HandleAnswer`).
- Locals are `lowerCamel` and short.
- Avoid ambiguous abbreviations; prefer `question`, `participant`, `category`.

State
- All mutable state lives in a single table per subsystem:
  - `Game.state`, `UI.state`, `ModeContext.data`.
- Avoid scattered flags; group related flags into sub-tables.
- Prefer explicit booleans over nil checks.

Control flow
- Early return on invalid input.
- Avoid deep nesting; max 2 levels when possible.
- Extract repeated branches into helpers.

Dependencies
- Pass dependencies in via constructors (`CreateGame(repo, store, deps)`).
- Avoid reading `_G` except in WoW API boundary files.
- Runtime lookups should be centralized in `core/Runtime.lua`.

Error handling
- Don’t swallow errors silently; log via `TriviaClassic_GetLogger()` when safe.
- Use `pcall` only at event boundaries.

Collections
- Never rely on iteration order of `pairs`.
- When order matters, build an array and sort it.

UI separation
- UI methods should not change game state directly.
- Presenter is the only layer allowed to send chat.
- UI only reacts to presenter outputs and updates widgets.

Answer matching
- All answer normalization goes through `TriviaClassic_Answer`.
- Do not implement ad‑hoc matching in modes or UI.

Tests
- Add/adjust tests when changing answer matching or game flow.
- Prefer small, isolated tests that use `tests/fake_runtime.lua`.
