# Starfall Courier Documentation

This folder contains the human-readable product/design and Godot architecture sources for the project.

Godot ignores this folder because `docs/.gdignore` is present.

## Source-of-truth order

For AI agents and developers:

1. The user's current explicit task defines the current implementation scope.
2. `game_design/game_concept_v0.md` defines the canonical game identity and full design direction.
3. `visual_design/visual_system_v0.md` defines the canonical visual style, procedural asset catalog, colors, sizes, variants, animation/VFX language, typography, iconography, shaders, and UI system.
4. `godot_architecture.md` defines how the project should be structured in Godot.
5. `node_selection_guide.md` defines how to choose Godot nodes for requirements.
6. Existing project code/scenes define local implementation conventions.

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

- premium neon deep-space courier visual identity,
- procedural/vector-first rendering policy,
- 720 × 1280 reference sizing,
- canonical semantic color tokens,
- geometry/stroke/glow language,
- layered backgrounds and five sector visual packages,
- navigation/lane/route/extraction visuals,
- player ship visual families and states,
- Star Cores/Star Chips,
- power-ups,
- every hazard family and required variants,
- elite-event visuals,
- spawn/despawn/crash/destruction animations,
- gameplay VFX catalog,
- shader catalog,
- Oxanium Variable typography system,
- Material Symbols Sharp Variable icon-font system,
- complete UI component and screen inventory,
- motion timing/easing,
- accessibility/readability rules,
- performance guardrails,
- future visual file organization,
- AI visual-asset checklist.

For any visual implementation, read this document before inventing colors, sizes, art assets, fonts, icons, effects, or animation styles.

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

## Project baseline

- Engine: Godot 4.7
- Language: statically typed GDScript
- Canonical game: **Starfall Courier**
- Genre: portrait-mode sci-fi arcade survival / three-lane courier runner
- Core control: tap left/right to move between three lanes
- Player identity: courier, not soldier
- Combat: not a core mechanic
- Visual pipeline: procedural/vector/canvas first; raster sprite sheets are not the default
- Text family: Oxanium Variable
- UI icon family: Material Symbols Sharp Variable
- Architecture: scene composition with small self-contained scenes
- Communication: typed calls downward, signals outward/upward
- Data: Resources when reusable serialized configuration is justified
- Globals: avoid by default

## Strongest design constraint

> **Add depth around the original gameplay — never replace the original gameplay.**

The repository name `space-shooter` is legacy/contextual and must not be used as justification to introduce shooting mechanics.
