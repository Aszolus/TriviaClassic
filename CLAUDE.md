# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TriviaClassic is a World of Warcraft Classic Era addon (Interface 11505) for hosting trivia games in guild/party/raid/custom channels. Written entirely in Lua with no build step.

## Commands

**Run tests:**
```bash
lua tests/run_tests.lua
```

**Install addon:** Copy `TriviaClassic` folder to `_classic_era_/Interface/AddOns/`

**In-game commands:**
- `/trivia` - Toggle main UI
- `/trivia scores` - Print leaderboard

## Architecture

### Layered Design

- **core/** - WoW API adapters and shared utilities. All WoW API calls are isolated here via adapter pattern (`WowClock.lua`, `WowChat.lua`, `WowEvents.lua`, `WowStorage.lua`). `Runtime.lua` provides dependency injection.
- **game/** - Core game engine. `Game.lua` is the state machine. Services handle answers, timers, scoring, and message formatting.
- **modes/** - Pluggable game mode handlers. Each mode implements `createState()`, `beginQuestion()`, `evaluateAnswer()`, `handleCorrect()`, `onTimeout()`. Register via `TriviaClassic_RegisterMode()`.
- **repo/** - Question data management with TriviaBot format importer.
- **ui/** - Thin presenter layer. `Presenter.lua` orchestrates actions; `UI.lua` handles frames. UI never calls Game methods directly.

### Key Patterns

**Dependency Injection:** Tests replace runtime adapters with mocks in `tests/fake_runtime.lua`.

**Answer Matching:** All modes use shared `TriviaClassic_Answer` service for normalization and matching. Never hand-roll answer logic.

**Chat Rule:** Only Presenter sends chat, only in response to button clicks. Modes return data/strings for Presenter to broadcast.

**Load Order:** Explicitly defined in `TriviaClassic.toc`. Order matters for Lua globals.

### Adding a Game Mode

1. Create `modes/YourMode.lua`
2. Call `TriviaClassic_RegisterMode("YOUR_MODE", handler)`
3. Implement required logic handlers (`createState`, `beginQuestion`, `evaluateAnswer`, `handleCorrect`, `onTimeout`)
4. Optional: Add `view` hooks for UI customization, `format` hooks for message customization
5. Add file to `TriviaClassic.toc` in the modes section

### Adding Question Sets

Drop TriviaBot-format Lua files into `data/question_sets/` and add to `.toc`.

## Testing

Tests use a custom assertion framework (`TC_ASSERT_EQ`, `TC_ASSERT_TRUE`, `TC_ASSERT_FALSE`, `TC_TEST`). Tests run in standalone Lua with WoW API shimmed via `tests/wow_shim.lua` and runtime mocked via `tests/fake_runtime.lua`.

## Saved Variables

Per-character data stored in `TriviaClassicCharacterDB`. Schema versioning in `core/Init.lua` - handle migrations when changing saved variable structure.
