# Starfall Courier Documentation

This folder contains the canonical product, visual-design, and Godot architecture sources for the project.

Godot ignores this folder because `docs/.gdignore` is present.

## Source-of-truth order

For AI agents and developers:

1. The user's current explicit task defines the current implementation scope.
2. `game_design/game_concept_v0.md` defines the canonical game identity and full design direction.
3. `visual_design/visual_system_v0.md` defines semantic colors, sizing, typography/iconography, procedural rendering direction, and the base visual system.
4. `visual_design/asset_drawing_system_v1.md` defines the canonical senior production drawing language and polish standard.
5. `visual_design/final_visual_inventory_v1.md` defines the canonical final visual inventory, variants, states, animation requirements, ownership, and QA coverage.
6. `godot_architecture.md` defines how the project should be structured in Godot.
7. `node_selection_guide.md` defines how to choose Godot nodes for requirements.
8. `instructions/godot_ai_instructions.md` defines general coding-agent rules.
9. `instructions/visual_ai_instructions.md` adds rules for visual/UI/VFX/shader tasks.
10. Existing project code/scenes define established local implementation conventions.

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

Defines **how production art must be drawn**:

- silhouette hierarchy,
- structural planes,
- material separation,
- functional details,
- controlled energy/glow,
- detail-density budgets,
- sector depth construction,
- richer ship anatomy,
- collectible/power-up structure,
- hazard detailing,
- route/extraction/Hunter treatment,
- VFX timing/motion grammar,
- UI construction,
- shader discipline,
- senior polish and anti-patterns.

### `visual_design/final_visual_inventory_v1.md`

Defines **what final visual coverage must exist**:

- production quality tiers,
- asset families,
- target sizes,
- minimum variant counts,
- required states,
- animation requirements,
- production ownership,
- visual-lab review requirements,
- technical/art QA gates,
- explicit exclusions under the current game concept.

---

## Godot architecture

### `godot_architecture.md`

Defines:

- scene composition,
- ownership,
- communication,
- Resources,
- run-state ownership,
- fair procedural-generation rules,
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

---

## Production visual implementation

Reusable visual code:

```text
res://scripts/visuals/
```

Shared shaders:

```text
res://shaders/visual/
```

Current procedural implementation includes:

- semantic visual tokens,
- font registry,
- UI theme factory,
- sector backgrounds,
- ship family renderer,
- collectible/power-up/hazard/route renderer,
- effect renderer,
- shared background/energy/time-warp/sector/UI shaders.

The current implementation is a baseline. v1 docs intentionally set a higher quality target than the first visual-lab pass.

---

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

The v1 quality target expects the lab to evolve toward side-by-side gameplay-scale, enlarged-detail, state, silhouette, and cross-background comparisons.

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

GitHub Actions installs official Godot 4.7.1 and validates project import, required scripts/scenes/shaders, the main scene, and visual-lab pages.

Local validation when Godot is installed:

```bash
godot --headless --path . --editor --quit
```

After visual changes, also inspect the relevant visual-lab scene in the Godot editor at real gameplay scale.

---

## Visual production principle

> More detail is not the target. Better-designed detail is the target.

Improve assets through silhouette, structure, material hierarchy, functional accents, controlled energy, and deliberate motion before adding micro-detail.