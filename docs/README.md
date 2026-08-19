# Starfall Courier Documentation

This folder contains the canonical product, visual-design, production-roadmap, and Godot architecture sources for the project.

Godot ignores this folder because `docs/.gdignore` is present.

## Source-of-truth order

For AI agents and developers:

1. The user's current explicit task defines the current implementation scope.
2. `game_design/game_concept_v0.md` defines the canonical game identity and full design direction.
3. `visual_design/visual_system_v0.md` defines semantic colors, sizing, typography/iconography, procedural rendering direction, and the base visual system.
4. `visual_design/asset_drawing_system_v1.md` defines the canonical senior production drawing language and polish standard.
5. `visual_design/final_visual_inventory_v1.md` defines the canonical final visual inventory, variants, states, animation requirements, ownership, and QA coverage.
6. `development/game_production_roadmap_v1.md` defines the canonical 10-phase implementation sequence and current production phase.
7. `godot_architecture.md` defines how the project should be structured in Godot.
8. `node_selection_guide.md` defines how to choose Godot nodes for requirements.
9. `instructions/godot_ai_instructions.md` defines general coding-agent rules.
10. `instructions/visual_ai_instructions.md` adds rules for visual/UI/VFX/shader tasks.
11. Existing project code/scenes define established local implementation conventions.

The roadmap defines sequence, not permission to prebuild later systems. The current user request still decides what is implemented now.

The historical `visual_design/final_visual_inventory_v0.md` may be used for implementation-history context, but new visual production work follows v1.

---

## Game design

### `game_design/game_concept_v0.md`

Canonical Starfall Courier design bible covering:

- portrait three-lane courier survival,
- run loop,
- Star Cores,
- combo and Near Misses,
- power-ups,
- hazards,
- sectors,
- route choices,
- contracts/extraction,
- Threat,
- progression,
- ships/mastery,
- missions/achievements/statistics,
- game modes,
- product guardrails.

Strongest invariant:

> Add depth around the original gameplay — never replace the original gameplay.

The player is a courier, not a soldier. Do not infer shooting mechanics from the legacy repository name.

---

## Development roadmap

### `development/game_production_roadmap_v1.md`

Defines the 10 production phases:

1. Core Run Foundation,
2. First Playable Survival Loop,
3. Skill / Combo / Near Miss,
4. Core Power-Ups,
5. Sectors / Threat / Hazard Expansion,
6. Routes / Contracts / Extraction / Elite Events,
7. Career Progression,
8. Complete UX / Menus / Settings,
9. Production Polish / Audio / Performance / Device Readiness,
10. Release Candidate / Store / Launch Readiness.

Current phase:

> **Phase 1 — Core Run Foundation**

The phase is complete only after its documented completion test and automated Godot validation pass.

---

## Visual design

See:

```text
visual_design/README.md
```

### `visual_design/visual_system_v0.md`

Defines the visual semantics:

- procedural/vector/canvas-first rendering,
- 720 × 1280 portrait reference,
- semantic palette,
- base object sizes,
- five sector packages,
- ship/power-up/hazard/route visual language,
- Oxanium text family,
- Material Symbols Sharp icon family,
- base UI/VFX/shader system.

### `visual_design/asset_drawing_system_v1.md`

Defines how production art must be drawn through silhouette hierarchy, structural planes, material separation, functional details, controlled energy/glow, motion, density budgets, and senior polish rules.

### `visual_design/final_visual_inventory_v1.md`

Defines final visual coverage, sizes, minimum variants, states, animation requirements, ownership, lab review requirements, and QA gates.

---

## Godot architecture

### `godot_architecture.md`

Defines scene composition, ownership, communication, Resources, run-state ownership, fairness, folder direction, and validation.

### `node_selection_guide.md`

Behavior-first node selection for courier ship, lanes, hazards, Star Cores, power-ups, Near Miss, route gates, HUD, and data/configuration.

---

## Production implementation

Reusable visual code:

```text
res://scripts/visuals/
```

Shared shaders:

```text
res://shaders/visual/
```

Phase-oriented gameplay code is created only as each phase needs it. Phase 1 introduces:

```text
res://scripts/core/run_controller.gd
res://scripts/core/run_input_router.gd
res://scripts/player/courier_controller.gd
res://scripts/ui/run_hud.gd
res://scenes/player/courier.tscn
res://scenes/ui/run_hud.tscn
```

---

## Development visual lab

Combined review scene:

```text
res://dev/visual_lab/visual_lab.tscn
```

Production code must never depend on `dev/`.

---

## Project baseline

- Engine: Godot 4.7 / CI pinned to Godot 4.7.1
- Language: statically typed GDScript
- Canonical game: Starfall Courier
- Reference viewport: 720 × 1280 portrait
- Genre: portrait-mode sci-fi arcade survival / three-lane courier runner
- Player identity: courier, not soldier
- Combat: not a core mechanic
- Visual pipeline: procedural/vector/canvas first
- Text family: Oxanium Variable
- UI icon family: Material Symbols Sharp Variable
- Architecture: scene composition with small self-contained scenes
- Communication: typed calls downward, signals outward/upward
- Data: Resources when reusable serialized configuration is justified
- Globals: avoid by default

---

## Validation

GitHub Actions installs official Godot 4.7.1 and validates project import, required scripts/scenes/shaders, phase-specific logic tests, the main scene, and visual-lab pages.

Local validation when Godot is installed:

```bash
godot --headless --path . --editor --quit
```

After visual changes, also inspect the relevant visual-lab scene in the Godot editor at real gameplay scale.

---

## Visual production principle

> More detail is not the target. Better-designed detail is the target.

Improve assets through silhouette, structure, material hierarchy, functional accents, controlled energy, and deliberate motion before adding micro-detail.
