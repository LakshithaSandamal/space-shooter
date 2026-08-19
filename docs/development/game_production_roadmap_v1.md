# Starfall Courier — 10-Phase Production Roadmap v1

> Canonical implementation sequence from current visual prototype to release-ready mobile game.

## Purpose

This document defines **when** major systems should be implemented.

It must be used together with:

- `docs/game_design/game_concept_v0.md` — what game is being built,
- `docs/visual_design/visual_system_v0.md` — canonical visual language,
- `docs/visual_design/asset_drawing_system_v1.md` — production drawing rules,
- `docs/visual_design/final_visual_inventory_v1.md` — final visual inventory,
- `docs/godot_architecture.md` — architecture,
- `docs/node_selection_guide.md` — Godot node selection,
- `instructions/godot_ai_instructions.md` — coding rules.

The user's current explicit request always controls implementation scope.

Do **not** skip forward and prebuild systems from later phases merely because they are listed here.

---

# Production principles

1. Every phase must leave the project runnable.
2. Each phase should add one coherent layer of player value.
3. Gameplay remains a portrait three-lane courier survival game.
4. Player shooting, weapons, ammunition, aiming, and free-flight controls are out of scope unless the design is explicitly changed.
5. Procedural/vector/canvas visuals remain the default art pipeline.
6. Fairness is non-negotiable: generated hazard patterns must always preserve at least one survivable route.
7. Production gameplay must never depend on `res://dev/`.
8. Every meaningful phase must add or update automated validation.
9. New folders/scenes/resources are created only when the phase genuinely needs them.
10. A phase is complete only when code, UX, validation, and relevant visual review agree.

---

# Phase 1 — Core Run Foundation

## Goal

Create the smallest correct playable Starfall Courier foundation.

## Deliverables

- real `Main` run composition scene,
- procedural Courier Corridor background,
- self-contained Courier `CharacterBody2D` scene,
- three logical lanes: `0 = left`, `1 = center`, `2 = right`,
- crisp deterministic lane-change movement,
- left/right touch input,
- desktop keyboard/mouse input for development,
- player collision body with only the player collision layer enabled,
- minimal run HUD shell with lane feedback and temporary control hint,
- Phase 1 automated lane-logic validation,
- existing Godot CI remains green.

## Explicitly not included

- hazards,
- collisions with hazards,
- Star Core collection,
- distance/score/combo,
- Near Miss,
- power-ups,
- routes,
- contracts,
- progression,
- save data.

## Completion test

Launching `res://scenes/main.tscn` must show the Courier in Courier Corridor. Tapping/clicking the left or right half of the screen moves exactly one lane. Keyboard left/right or A/D supports desktop testing. Attempts to move beyond the outer lanes are ignored.

## Completion record

- Status: **COMPLETE**
- Completed: `2026-08-20`
- Godot CI: 4.7.1 import/parse, resource loading, Phase 1 lane validation, main-scene smoke test, and existing visual-lab smoke tests passed.
- The implementation intentionally contains no Phase 2 gameplay systems.

---

# Phase 2 — First Playable Survival Loop

## Goal

Turn lane movement into a real endless survival run.

## Deliverables

- Standard Asteroid gameplay scene,
- deterministic authored/validated three-lane spawn patterns,
- at least one safe lane in every pattern,
- world-forward motion model,
- crash detection and run end,
- restart flow,
- distance tracking,
- Star Core collectible gameplay scene,
- score from collection/distance,
- core HUD values: Distance and Cores,
- basic difficulty ramp,
- automated fairness checks for Phase 2 pattern data.

## Completion test

A player can start a run, dodge asteroids, collect Star Cores, travel farther, crash, and immediately restart.

---

# Phase 3 — Skill, Combo, and Near-Miss Loop

## Goal

Create the mastery layer that makes repeated runs rewarding.

## Deliverables

- combo multiplier,
- combo grace timer,
- combo break rules,
- Near-Miss detection,
- duplicate Near-Miss prevention,
- Close Call / Danger Streak feedback,
- score weighting for combo and Near Miss,
- improved pattern variety,
- readable difficulty curve,
- HUD Combo state,
- Phase 3 VFX/audio hooks,
- deterministic scoring tests.

## Completion test

A skilled player can intentionally maintain combo and perform Near Misses without the game creating ambiguous or duplicate rewards.

---

# Phase 4 — Core Power-Up System

## Goal

Add tactical recovery and risk tools without changing the control model.

## Deliverables

- Shield pickup and one-hit protection,
- brief Shield recovery/invulnerability behavior,
- Time Warp pickup and time-scale/world-speed behavior,
- Overcharge scoring/reward behavior,
- active power-up HUD presentation,
- pickup availability/timing rules,
- duration/state ownership,
- interactions with crash, combo, and Near Miss,
- VFX and sound hooks,
- tests for activation, expiration, and mutually relevant edge cases.

## Completion test

All three core power-ups can be collected, clearly read, activated correctly, expire predictably, and never require additional movement controls.

---

# Phase 5 — Sectors, Threat, and Hazard Expansion

## Goal

Build the full run progression language.

## Deliverables

- five sector gameplay packages,
- Courier Corridor,
- Wreck Belt,
- Ion Reach,
- Solar Rift,
- Void Passage,
- sector transitions,
- Threat levels 1–5,
- pressure rise/fall pacing,
- Heavy Asteroid,
- Fast Debris,
- Drifting Debris,
- Energy Mine,
- Laser Gate,
- Meteor Strike,
- Cargo Wreck,
- Gravity Anomaly,
- sector-specific pattern pools,
- survivability validation across combined hazards.

## Completion test

A long run transitions through distinct sectors, introduces new readable hazards, changes intensity over time, and never produces an unavoidable lane state.

---

# Phase 6 — Routes, Contracts, Extraction, and Elite Events

## Goal

Add meaningful run decisions beyond pure survival distance.

## Deliverables

- world-space Safe / Core Field / Danger route gates,
- route modifiers,
- route selection by lane movement only,
- contract framework,
- Standard Delivery,
- Fragile Cargo,
- Core Shipment,
- Express Delivery,
- Hazard Route,
- extraction decision,
- secure reward vs continue risk,
- elite events: Debris Storm, Hunter Sweep, Collapse Corridor, Core Surge,
- future-compatible Courier Hunter telegraph encounter slot,
- route/contract HUD state.

## Completion test

A player can accept a contract, make lane-based route choices, complete the objective, choose extraction or continued risk, and receive a deterministic run result.

---

# Phase 7 — Career Progression and Long-Term Content

## Goal

Turn individual runs into a persistent progression game.

## Deliverables

- Star Chips persistent currency,
- persistent profile data model,
- versioned save format,
- permanent upgrades,
- Courier / Interceptor / Phantom playable ship data,
- later ship slots only when their gameplay differences are defined,
- ship mastery 1–10,
- courier reputation and ranks,
- missions,
- achievements,
- statistics,
- unlock conditions,
- economy/balance configuration through Resources where justified.

## Completion test

Progress survives restart, migrations are version-safe, rewards cannot be duplicated by normal flow, and progression meaningfully changes future runs without breaking the three-lane identity.

---

# Phase 8 — Complete UX, Menus, Onboarding, and Settings

## Goal

Transform the feature-complete game into a coherent consumer application.

## Deliverables

- splash/brand flow,
- main menu,
- mode selection,
- Contracts screen,
- Hangar,
- Upgrades,
- Missions,
- Achievements,
- Statistics,
- run summary,
- pause/settings,
- first-run tutorial/onboarding,
- control tutorial,
- audio settings,
- haptic settings where supported,
- reduced-motion setting,
- readable accessibility alternatives,
- safe-area aware mobile layout,
- final canonical fonts/icons integrated.

## Completion test

A first-time player can install the game, understand controls, start a run, return to menus, manage progression/settings, and continue later without developer knowledge.

---

# Phase 9 — Production Polish, Audio, Performance, and Device Readiness

## Goal

Reach release-quality feel and stable mobile performance.

## Deliverables

- final music system,
- complete SFX pass,
- haptics pass,
- final VFX timing and hierarchy,
- sector/background polish,
- animation polish,
- reduced-motion alternatives,
- mobile GPU/CPU profiling,
- Compatibility vs Mobile renderer decision based on measurements,
- allocation/per-frame redraw audit,
- memory/load-time optimization,
- portrait device/aspect-ratio testing,
- safe-area/notch handling,
- pause/resume/app-background behavior,
- battery/thermal sanity testing,
- localization-ready text structure.

## Completion test

Target devices maintain the selected performance budget with no critical readability regressions, excessive thermal load, major frame spikes, or broken mobile lifecycle behavior.

---

# Phase 10 — Release Candidate, QA, Store, and Launch Readiness

## Goal

Produce the final release candidate and launch package.

## Deliverables

- complete regression suite,
- long-run soak tests,
- save migration tests,
- economy/balance pass,
- difficulty tuning,
- crash/error cleanup,
- export presets,
- Android production export validation,
- iOS production export validation,
- signing/provisioning checklist,
- app icons/splash/store artwork,
- screenshots/trailer capture plan,
- privacy/permissions review,
- version/build numbering,
- release notes,
- store metadata checklist,
- final launch checklist,
- post-launch issue/analytics plan only if corresponding services are deliberately chosen.

## Completion test

A signed release candidate can be installed on target devices, complete the full user journey, survive regression/soak testing, preserve saves, and meet the selected store submission requirements.

---

# Phase status

| Phase | Status |
|---|---|
| 1. Core Run Foundation | **COMPLETE** |
| 2. First Playable Survival Loop | **NEXT / PLANNED** |
| 3. Skill / Combo / Near Miss | Planned |
| 4. Core Power-Ups | Planned |
| 5. Sectors / Threat / Hazards | Planned |
| 6. Routes / Contracts / Extraction | Planned |
| 7. Career Progression | Planned |
| 8. UX / Menus / Settings | Planned |
| 9. Production Polish / Performance | Planned |
| 10. Release Candidate / Launch | Planned |

---

# AI phase rule

Before implementing a requested phase:

1. Read the current user request.
2. Read `game_concept_v0.md`.
3. Read this roadmap.
4. Read architecture/node/visual documents relevant to the phase.
5. Inspect current implementation.
6. Implement only the active phase requirements.
7. Add/update automated validation.
8. Run Godot CI/headless validation.
9. Visually review affected dev scenes when presentation changes.
10. Update this file's phase status only when the phase actually meets its completion test.
