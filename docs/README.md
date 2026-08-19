# Starfall Courier Documentation

This folder contains the canonical product, visual-design, and Godot architecture sources for the project.

Godot ignores this folder because `docs/.gdignore` is present.

## Source-of-truth order

For AI agents and developers:

1. The user's current explicit task defines the current implementation scope.
2. `game_design/game_concept_v0.md` defines the canonical game identity and full design direction.
3. `visual_design/visual_system_v0.md` defines the canonical visual style, colors, sizes, variants, motion/VFX language, typography, iconography, shaders, and UI system.
4. `visual_design/final_visual_inventory_v0.md` maps the final visual families to production code, required variants/states, QA requirements, and visual-lab coverage.
5. `godot_architecture.md` defines how the project should be structured in Godot.
6. `node_selection_guide.md` defines how to choose Godot nodes for requirements.
7. `instructions/godot_ai_instructions.md` defines general coding-agent rules.
8. `instructions/visual_ai_instructions.md` adds rules for visual/UI/VFX/shader tasks.
9. Existing project code/scenes define local implementation conventions.

## Documents

### `game_design/game_concept_v0.md`

Canonical **Starfall Courier v0 design bible**.

Covers:

- product identity,
- three-lane gameplay,
- run loop,
- Star Cores,
- combo,
- Near Misses,
- power-ups,
- hazards,
- sectors,
- route choices,
- contracts/extraction,
- Threat,
- elite events,
- progression,
- ships/mastery,
- missions/achievements/statistics,
- game modes,
- visual/UI/audio direction,
- AI implementation guardrails,
- core-vs-future scope.

### `visual_design/visual_system_v0.md`

Canonical **Starfall Courier procedural visual system and final-product asset catalog**.

Covers:

- premium neon deep-space courier identity,
- procedural/vector-first rendering policy,
- 720 × 1280 reference sizing,
- semantic color tokens,
- geometry/stroke/glow language,
- layered backgrounds and five sector packages,
- navigation/lane/route/extraction visuals,
- ship families/states,
- Star Cores/Star Chips,
- power-ups,
- hazard variants,
- animation/VFX language,
- shader catalog,
- Oxanium Variable typography,
- Material Symbols Sharp Variable icon font,
- UI component/screen inventory,
- motion/accessibility/performance guidance.

For any visual implementation, read this document before inventing colors, sizes, art assets, fonts, icons, effects, or animation styles.

### `visual_design/final_visual_inventory_v0.md`

Canonical **implementation manifest for the final production visual inventory**.

It maps:

- production visual classes,
- shader ownership,
- every visual family,
- ship/object/hazard/power-up variants,
- required visual states,
- VFX coverage,
- font/icon dependencies,
- visual QA checks,
- known gaps,
- the exact dev scene used to inspect each family.

### `godot_architecture.md`

Godot 4.7 architecture rules tailored to Starfall Courier:

- scene composition,
- scene ownership,
- communication,
- Resources,
- run-state ownership,
- fair procedural-generation requirements,
- folder direction,
- validation.

### `node_selection_guide.md`

Behavior-first node selection for:

- courier ship,
- lanes,
- hazards,
- Star Cores,
- power-ups,
- Near-Miss detection,
- route gates,
- HUD,
- data/configuration.

## Production visual implementation

Reusable production visual code:

```text
res://scripts/visuals/
```

Shared visual shaders:

```text
res://shaders/visual/
```

The procedural implementation currently includes:

- semantic visual tokens,
- canonical font registry,
- procedural UI theme factory,
- five sector backgrounds,
- seven ship silhouette slots,
- player visual states,
- collectibles,
- core and future power-up visual slots,
- every documented hazard family,
- route/extraction/Hunter visuals,
- complete procedural VFX inventory,
- reusable background/energy/time-warp/sector/UI shaders.

## Development visual lab

Combined review scene:

```text
res://dev/visual_lab/visual_lab.tscn
```

Independent pages:

```text
res://dev/visual_lab/pages/backgrounds.tscn
res://dev/visual_lab/pages/ships.tscn
res://dev/visual_lab/pages/collectibles_powerups.tscn
res://dev/visual_lab/pages/hazards_routes.tscn
res://dev/visual_lab/pages/effects.tscn
res://dev/visual_lab/pages/ui.tscn
```

The lab is development-only and must never become a production gameplay dependency.

## Project baseline

- Engine: Godot 4.7
- Language: statically typed GDScript
- Canonical game: **Starfall Courier**
- Reference viewport: **720 × 1280 portrait**
- Genre: portrait-mode sci-fi arcade survival / three-lane courier runner
- Core control: tap left/right to move between three lanes
- Player identity: courier, not soldier
- Combat: not a core mechanic
- Visual pipeline: procedural/vector/canvas first
- Text family: Oxanium Variable
- UI icon family: Material Symbols Sharp Variable
- Architecture: scene composition with small self-contained scenes
- Communication: typed calls downward, signals outward/upward
- Data: Resources when reusable serialized configuration is justified
- Globals: avoid by default

## Current validation status

The repository contains the visual test harness, but headless/runtime validation must still be run on a machine with the Godot 4.7 executable:

```bash
godot --headless --path . --editor --quit
```

The UI lab intentionally reports the canonical font binaries as missing until those files exist at their documented paths.

## Strongest design constraint

> **Add depth around the original gameplay — never replace the original gameplay.**

The repository name `space-shooter` is legacy/contextual and must not be used as justification to introduce shooting mechanics.
