# AI Instructions — Godot 4.7 Starfall Courier

These instructions define how an AI coding agent must work inside this repository.

## 1. Project identity

- Canonical game: **Starfall Courier**
- Engine: Godot 4.7
- Language: statically typed GDScript
- Presentation: portrait-mode 2D mobile
- Genre: sci-fi arcade survival / three-lane courier runner
- Main project file: `project.godot`
- Current main scene: `res://scenes/main.tscn`
- Game-design source of truth: `docs/game_design/game_concept_v0.md`
- Architecture reference: `docs/godot_architecture.md`
- Node-selection reference: `docs/node_selection_guide.md`

The repository is named `space-shooter`, but **Starfall Courier is not a combat-focused shooter**.

The player is a courier, not a soldier.

The core play is:

```text
three-lane movement
+ dodging
+ Star Core collection
+ combo / Near-Miss mastery
+ power-ups
+ route risk/reward
+ contracts
+ survival progression
```

Do not add player shooting, guns, ammo, aiming, free-flight movement, or combat progression unless the user explicitly changes the game design.

## 2. Source-of-truth precedence

Before making design or implementation decisions, use this order:

1. The user's current explicit request defines the current implementation scope.
2. `docs/game_design/game_concept_v0.md` defines game identity and intended systems.
3. `docs/godot_architecture.md` defines project architecture.
4. `docs/node_selection_guide.md` defines Godot node-selection guidance.
5. Existing code/scenes define established local conventions.

If an old example conflicts with the canonical game concept, preserve the game concept.

Do not treat the full concept document as a request to implement every feature.

## 3. Read before editing

Before a meaningful change:

1. Inspect `project.godot`.
2. Read the relevant section of `docs/game_design/game_concept_v0.md`.
3. Inspect every scene affected by the task.
4. Inspect scripts already attached to those scenes.
5. Read relevant architecture/node guidance.
6. Identify the smallest coherent set of files that must change.
7. Reuse existing conventions rather than creating a parallel architecture.

Never rewrite unrelated files merely because another architecture is imaginable.

## 4. Incremental development rule

Build **one real requested milestone at a time**.

Do not scaffold future systems simply because they exist in the full design.

For example, while implementing three-lane player movement, do not also create:

- contracts,
- progression,
- achievements,
- sectors,
- route choice,
- save/profile state,
- power-up frameworks,
- generic managers,
- unused data resources.

Every stage must leave the project understandable and runnable.

## 5. Core gameplay guardrails

The following rules are product constraints, not optional style preferences.

### Three lanes

The default player movement model is discrete:

```text
LEFT <-> CENTER <-> RIGHT
```

Input intent:

```text
tap left half  -> move one lane left
tap right half -> move one lane right
```

Do not replace this with analog/free 2D flight unless explicitly requested.

### Continuous travel

The player ship represents continuous forward travel while the world/hazards move toward the player.

### Non-combat identity

Survival comes from navigation and timing.

Future hostile events may attack lanes, but the default response is dodge/escape, not shoot.

### Fairness

Every generated hazard pattern must leave at least one survivable route.

When procedural hazard generation is introduced, solvability is a required invariant.

### Risk/reward

Systems such as Star Cores, Near Misses, route choices, contracts, extraction, and Threat exist to make safety-versus-value decisions meaningful.

Do not flatten these into passive rewards.

## 6. Node-selection rules

Choose a node based on required behavior.

Project-oriented defaults:

- Gameplay composition root -> `Node2D`
- Player courier ship -> `CharacterBody2D`
- Simple overlap-only hazard -> `Area2D`
- Star Core collectible -> `Area2D`
- Power-up pickup -> `Area2D`
- Near-Miss detection region -> `Area2D`
- Route/extraction trigger -> `Area2D`
- Fixed solid obstacle -> `StaticBody2D`
- Physics-driven asteroid/debris -> `RigidBody2D`
- World-space visual -> `Sprite2D`
- Sprite-frame animation -> `AnimatedSprite2D`
- Complex property animation -> `AnimationPlayer`
- Camera -> `Camera2D`
- Spawn/lane anchor -> `Marker2D`
- HUD screen layer -> `CanvasLayer`
- UI/layout -> `Control`
- Reusable configuration -> `Resource`
- Lightweight non-Node runtime data/helper -> `RefCounted`

Do not create combat/projectile nodes unless a requested feature actually requires them.

Before using generic `Node`/`Node2D`, check whether a specialized node fits the behavior better.

## 7. Scene architecture rules

Reusable scenes should be self-contained.

Do not couple a scene to hard-coded external tree paths such as:

```gdscript
get_node("../../Main/Hud")
```

Prefer:

- exported dependencies,
- parent-injected references,
- typed direct parent-to-child calls,
- child-to-owner signals,
- Resources for reusable data.

A child should know as little as possible about the larger scene tree.

## 8. Communication rules

### Parent -> child

Use a typed direct method call for commands.

Example:

```gdscript
player.move_to_lane(target_lane)
```

### Child -> owner / parent

Use a signal to report events.

Examples:

```gdscript
signal lane_changed(lane_index: int)
signal core_collected(value: int)
signal crashed
```

### Siblings

Do not make siblings search for one another with relative tree paths.

Let their common owner coordinate them or inject the dependency.

## 9. Composition over inheritance

Prefer scene composition and focused behavior components over deep inheritance.

Do not create speculative inheritance hierarchies.

Introduce a shared base class only when real, stable shared behavior already exists.

## 10. Autoload policy

Autoload is not the default answer for shared functionality.

Do not create speculative globals such as:

- `GameManager`
- `PlayerManager`
- `HazardManager`
- `UIManager`
- `GlobalManager`

Before adding an Autoload, prove that the responsibility:

1. genuinely requires project-wide lifetime or cross-scene persistence, and
2. cannot be handled cleanly through scene ownership, Resources, signals, static helpers, or dependency injection.

Future legitimate candidates may include persistent profile/save state or scene-transition coordination, but only when that requirement exists.

## 11. Resource policy

Prefer custom `Resource` types for reusable configuration/data when the system justifies them.

Future examples may include:

- ship configuration,
- hazard configuration,
- hazard-pattern data,
- sector configuration,
- contract configuration,
- upgrade definitions.

Do not create data abstractions before there is real data to configure.

Keep behavior in Nodes/scripts and reusable configuration in Resources when that separation is useful.

## 12. GDScript typing

Use statically typed GDScript.

Preferred:

```gdscript
var current_lane: int = 1
var lane_change_duration: float = 0.12

func move_to_lane(lane_index: int) -> void:
    pass

func get_lane_position(lane_index: int) -> Vector2:
    return Vector2.ZERO
```

Functions should declare return types whenever practical.

Avoid vague untyped state when the type is known.

## 13. Naming

Use:

- folders: `snake_case`
- files: `snake_case`
- variables/functions/signals/groups: `snake_case`
- node/class names: `PascalCase`
- constants: `UPPER_SNAKE_CASE`

Prefer domain names from the game:

- `star_core`
- `threat_level`
- `current_lane`
- `route_gate`
- `courier_ship`

Avoid meaningless permanent names such as `thing`, `stuff`, `data2`, or `temp`.

## 14. Script responsibilities

Keep each script focused.

Likely examples when those features exist:

```text
player_ship.gd
star_core.gd
hazard.gd
run_controller.gd
lane_controller.gd
hud.gd
```

Do not create a giant script that combines player movement, spawning, score, UI, persistence, audio, and progression.

Also do not over-componentize tiny behavior without a reuse/complexity reason.

## 15. Physics and movement

### CharacterBody2D

Use for the code-controlled courier ship when collision-aware movement is needed.

Physics-dependent movement belongs in `_physics_process(delta)`.

Use `velocity` plus `move_and_slide()`/`move_and_collide()` when actual body collision response is part of the design.

For lane interpolation, preserve deterministic lane state and do not allow interpolation to create invalid fourth/fractional gameplay lanes.

### Area2D

Use for overlap/detection behavior such as:

- collectibles,
- simple hazards,
- Near-Miss zones,
- route gates,
- power-up pickups.

### RigidBody2D

Use only when the physics engine should control debris through forces/impulses/mass/angular velocity.

Do not use it for deterministic player lane controls.

### StaticBody2D

Use for fixed solid collision.

## 16. Collision layers and masks

Never assign collision layers randomly.

When a category becomes real:

1. define its semantic purpose,
2. document the layer,
3. configure both layer and mask intentionally,
4. avoid broad masks unless required.

A likely future conceptual model is:

```text
1 player
2 hazards
3 collectibles
4 power_ups
5 world
6 gameplay_triggers
```

This is only a proposed mapping.

Do not add unused collision categories before the matching systems exist.

## 17. Input rules

Gameplay scripts should use named Input Map actions when actions are appropriate.

For the current game identity, likely actions are:

```text
move_left
move_right
pause
```

Touch input should preserve the conceptual behavior:

```text
left side -> move_left
right side -> move_right
```

Do not add `fire`, aiming, or vertical free-flight actions unless the design changes.

Only add actions required by the current milestone.

## 18. UI rules

Use `Control`-derived nodes for UI and layout.

Use `CanvasLayer` for fixed gameplay HUD when appropriate.

The gameplay center must remain visually clear.

Game systems should report state/events; they should not search the tree for HUD nodes and directly mutate arbitrary UI descendants.

Follow the design language in `docs/game_design/game_concept_v0.md`:

- dark premium cockpit interface,
- controlled neon accents,
- compact spacing,
- strong readability,
- minimal obstruction of playfield.

## 19. Visual/gameplay readability

Visual effects are subordinate to gameplay readability.

Never allow background/VFX/UI to obscure:

- lane position,
- hazards,
- telegraphs,
- Star Cores,
- route choices.

Use the game concept's color language consistently:

- purple -> Starfall identity
- cyan -> energy/navigation/Shield
- magenta -> danger/Overcharge
- gold -> value/rewards
- green -> success/extraction
- white -> primary readability

## 20. Asset rules

Do not alter source art/audio/fonts unless the task requires it.

Do not commit `.godot/` generated cache/import data.

Third-party Godot plugins belong under `addons/`.

Use lowercase `snake_case` asset paths to avoid cross-platform case issues.

## 21. Scene-file editing

When editing `.tscn` manually:

- preserve valid Godot syntax,
- preserve resource references,
- do not invent UIDs unnecessarily,
- preserve ownership,
- keep edits minimal,
- verify referenced paths exist.

## 22. Error handling

Do not silently hide invalid required state.

For required dependencies:

- type them,
- validate them early,
- fail clearly during development if missing.

For optional/external files, handle absence deliberately.

Do not use defensive null checks everywhere as a substitute for correct ownership.

## 23. Documentation updates

Update documentation only for lasting decisions such as:

- changed game identity/rules,
- new top-level architecture,
- an Autoload,
- collision-layer conventions,
- reusable component patterns,
- major folder-structure changes.

Do not rewrite architecture docs for trivial implementation details.

If a user changes the game design, update `docs/game_design/game_concept_v0.md` or create a newer concept version as appropriate.

## 24. Validation requirement

After meaningful Godot changes, validate with the Godot 4.7 executable when available.

Preferred parse/import validation:

```bash
godot --headless --path . --editor --quit
```

Also check:

- GDScript parser errors,
- invalid scene syntax,
- missing resources,
- invalid NodePaths,
- input action names,
- collision setup,
- main scene loading.

If Godot cannot be executed, explicitly report that runtime/headless validation was not performed.

Never claim a successful Godot run unless the command actually succeeded.

## 25. Change-report format

After a coding task, report:

1. what changed,
2. why the selected Godot nodes/architecture fit the requirement,
3. files changed,
4. validation performed,
5. remaining limitations.

Do not bury skipped validation or known errors.

## 26. Staged-development constraint

This repository is intentionally being built incrementally.

For every request:

- understand the current milestone,
- implement only that milestone,
- preserve the game concept,
- keep architecture clean,
- validate,
- stop.

The existence of later systems in the design bible is not permission to build them early.
