# Godot 4.7 Architecture — Starfall Courier

## 1. Architecture goal

Starfall Courier is a portrait-mode three-lane arcade survival game.

The architecture must support the full design direction without prebuilding the full design.

Default principle:

> A reusable gameplay object should usually be a self-contained scene with a small statically typed script on its root node.

Canonical product reference:

- `docs/game_design/game_concept_v0.md`

AI operating reference:

- `instructions/godot_ai_instructions.md`

This document defines **how to structure the Godot project**, not which future feature should be implemented next.

---

## 2. Core architectural model

Godot is scene-based. Use that model directly instead of forcing a service-heavy application architecture onto the game.

Likely game concepts that may deserve independent scenes when they are implemented:

- courier/player ship,
- Star Core,
- hazard types,
- power-up pickups,
- route gates,
- HUD,
- menus,
- reusable VFX.

The gameplay scene composes these objects.

Do not create all scenes in advance.

---

## 3. Self-contained scenes

Reusable scenes should contain the nodes/resources needed for their own behavior.

A player scene must not assume an external HUD exists at a hard-coded path.

Bad:

```gdscript
get_node("../../Main/Hud").set_combo(value)
```

Prefer:

- exported typed configuration,
- typed public methods,
- signals for outward events,
- parent-injected external dependencies only when necessary.

A scene should know as little as possible about the larger tree.

---

## 4. Composition over deep inheritance

Prefer small scenes and focused behavior over deep class trees.

Do not build speculative hierarchies such as:

```text
GameEntity
  -> MovingEntity
    -> HazardEntity
      -> AdvancedHazard
```

Introduce reusable components only when genuine reuse/complexity appears.

Potential future components may include:

- near-miss detector,
- shield state,
- collectible behavior,
- timed effect state.

Do not create them until a real feature requires them.

---

## 5. Parent coordinates, children report

Default communication direction:

### Parent -> child

Use a direct typed method call for commands.

Example:

```gdscript
player.move_to_lane(target_lane)
```

### Child -> owner/parent

Use signals to report events.

Example:

```gdscript
signal lane_changed(lane_index: int)
signal collected(value: int)
signal crashed
```

### Siblings

Siblings should not search for each other using relative paths.

Their common owner coordinates them or injects the required reference.

---

## 6. Data belongs in Resources when appropriate

Use custom `Resource` types for reusable serialized configuration once a real system needs them.

Possible future data:

```text
ship_data.gd
hazard_data.gd
hazard_pattern_data.gd
sector_data.gd
contract_data.gd
upgrade_data.gd
```

Possible values:

- lane-change duration,
- reward multipliers,
- spawn parameters,
- hazard speed,
- telegraph duration,
- sector tuning,
- contract targets,
- power-up duration.

Do not use Nodes merely to hold data.

Do not create Resources before there is meaningful reusable data.

---

## 7. Recommended repository direction

Create domain folders only when the first real file for the domain exists.

```text
res://
├── project.godot
│
├── scenes/
│   ├── main.tscn
│   ├── player/
│   ├── hazards/
│   ├── collectibles/
│   ├── power_ups/
│   ├── routes/
│   ├── effects/
│   └── ui/
│
├── scripts/
│   ├── core/
│   ├── player/
│   ├── hazards/
│   ├── collectibles/
│   ├── power_ups/
│   ├── routes/
│   ├── components/
│   ├── systems/
│   └── ui/
│
├── resources/
│   ├── ships/
│   ├── hazards/
│   ├── patterns/
│   ├── sectors/
│   ├── contracts/
│   └── progression/
│
├── assets/
│   ├── ships/
│   ├── hazards/
│   ├── collectibles/
│   ├── power_ups/
│   ├── effects/
│   ├── ui/
│   ├── audio/
│   └── backgrounds/
│
├── docs/
│   └── .gdignore
│
└── instructions/
    └── .gdignore
```

This is a destination map, not scaffolding work.

---

## 8. Main gameplay scene responsibility

`Main` is the composition root for one active run.

A likely future tree may evolve toward:

```text
Main (Node2D)
├── Background
├── World (Node2D)
│   ├── Lanes (Node2D)
│   ├── Player
│   ├── Hazards (Node2D)
│   ├── Collectibles (Node2D)
│   ├── GameplayTriggers (Node2D)
│   └── Effects (Node2D)
├── Camera2D
└── HudLayer (CanvasLayer)
    └── Hud (Control)
```

Do not create nodes just because they appear in this example.

### Main may coordinate

- current-run lifecycle,
- high-level spawn ownership,
- distance/run progression,
- high-level event connections,
- current sector/Threat coordination when those systems exist,
- high-level HUD state flow.

### Main should not contain

- lane movement internals,
- hazard-specific behavior,
- Star Core animation internals,
- power-up implementation internals,
- UI layout internals.

If Main becomes a large monolithic controller, split by real responsibilities.

---

## 9. Player architecture

The courier ship is a deterministic three-lane controller.

Default root:

```text
Player (CharacterBody2D)
├── Sprite2D / AnimatedSprite2D
├── CollisionShape2D
└── optional owned children required by implemented features
```

The gameplay state should preserve a discrete lane index:

```text
0 = left
1 = center
2 = right
```

Visual/physical movement between lane centers may interpolate smoothly, but game logic must still have a clear destination/current lane.

Do not implement free analog flight unless the game design changes.

Do not add weapon origins or firing behavior by default.

---

## 10. Hazard architecture

Choose the hazard root by behavior, not by visual appearance.

Examples:

### Overlap-only deterministic hazard

Use `Area2D` when the object needs hit/overlap detection but not solid collision response.

### Physics-driven debris

Use `RigidBody2D` when forces, angular velocity, bounce, and physics simulation are intentionally part of the behavior.

### Fixed solid obstacle

Use `StaticBody2D`.

### Code-controlled solid moving obstacle

Use `CharacterBody2D` only if deterministic collision response is actually needed.

Do not choose `RigidBody2D` merely because something looks like an asteroid.

---

## 11. Collectible and power-up architecture

Star Cores and ordinary power-up pickups are usually detection objects, so `Area2D` is the default.

Example:

```text
StarCore (Area2D)
├── Sprite2D / AnimatedSprite2D
└── CollisionShape2D
```

A pickup should report collection through a signal or controlled interaction and should not directly modify arbitrary HUD nodes.

The run owner/system decides how collection affects score, combo, mission progress, or persistent rewards.

---

## 12. Near-Miss architecture

Near Miss is a gameplay detection concept, not physical collision.

A likely implementation may use a separate `Area2D` region around a hazard/player, but the exact ownership should be chosen when the system is implemented.

Requirements when implemented:

- distinguish a true collision from a near miss,
- avoid duplicate rewards for one pass,
- preserve deterministic scoring,
- support multiple hazard shapes where practical.

Do not implement this component until Near Miss is the active milestone.

---

## 13. Route and extraction architecture

Route gates and extraction choices are world-space gameplay interactions.

They will likely combine:

- world-space presentation,
- lane occupancy,
- trigger detection,
- high-level run-state decisions.

Use `Area2D` for overlap/trigger detection where appropriate.

Do not implement route choice as unrelated screen buttons; the game concept requires selecting a route by moving into the corresponding lane.

---

## 14. UI architecture

World gameplay and screen UI must remain separate.

Recommended:

```text
HudLayer (CanvasLayer)
└── Hud (Control)
    └── layout containers / labels / indicators
```

Use `Control` containers and anchors for responsive portrait layout.

The gameplay center should remain clear.

HUD presentation listens to run/player events or receives state from a higher-level owner.

Gameplay entities must not search for HUD descendants.

---

## 15. Typed GDScript standard

Use static typing throughout.

Example:

```gdscript
extends CharacterBody2D

const MIN_LANE: int = 0
const MAX_LANE: int = 2

var current_lane: int = 1

func request_lane_change(direction: int) -> void:
    current_lane = clampi(current_lane + direction, MIN_LANE, MAX_LANE)
```

Exact movement implementation is milestone-specific.

Use:

- files/folders: `snake_case`
- variables/functions/signals/groups: `snake_case`
- node/class names: `PascalCase`
- constants: `UPPER_SNAKE_CASE`

---

## 16. Process callbacks

Use `_physics_process(delta)` for physics-dependent movement/collision logic.

Use `_process(delta)` only for render-frame work that actually needs it.

Prefer built-in tools when appropriate:

- `Timer`,
- Tween,
- `AnimationPlayer`,
- signals.

Do not poll every system every frame unnecessarily.

---

## 17. Signals

Use signals for outward gameplay events.

Examples appropriate to Starfall Courier:

```gdscript
signal lane_changed(lane_index: int)
signal crashed
signal core_collected(value: int)
signal power_up_collected(power_up_id: StringName)
signal route_selected(route_id: StringName)
```

Do not use signals to replace a simple parent-to-child command.

---

## 18. Groups

Groups are useful for broad categories when many unrelated instances share behavior.

Potential examples once needed:

```text
hazards
collectibles
power_ups
gameplay_triggers
```

Use groups only when group behavior is actually useful.

Do not use them to replace clear ownership/references for one known node.

---

## 19. Autoload policy

Autoloads are global state and should be rare.

Before adding one:

1. Does it genuinely need to outlive scene replacement?
2. Is the responsibility project-wide?
3. Can a scene-owned node, Resource, signal, static helper, or injected reference solve it more locally?

Possible future legitimate candidates may include:

- persistent profile/save state,
- settings,
- scene-transition coordination.

Do not automatically create:

```text
GameManager
PlayerManager
HazardManager
UIManager
GlobalManager
```

---

## 20. Collision architecture

Define layers by semantic responsibility.

A possible future mapping:

```text
Layer 1: player
Layer 2: hazards
Layer 3: collectibles
Layer 4: power_ups
Layer 5: world
Layer 6: gameplay_triggers
```

This is a proposal, not current mandatory configuration.

Add a layer only when the corresponding feature exists.

Configure masks deliberately.

---

## 21. Fair procedural-generation architecture

The concept requires every hazard pattern to have at least one survivable route.

When procedural patterns are implemented:

- prefer authored/validated pattern data over unconstrained randomness,
- represent lane occupancy clearly,
- validate that at least one safe route exists,
- keep telegraph/reaction windows readable,
- separate difficulty tuning from raw random spawning.

Fairness is part of system correctness.

A generator that can produce impossible states is a gameplay bug.

---

## 22. Run-state ownership

Run-specific values may eventually include:

- distance,
- score,
- combo,
- Threat,
- active sector,
- active power-ups,
- contract state.

Do not immediately place them in an Autoload.

Prefer ownership by the active run scene/controller until cross-scene persistence is actually required.

Persistent career values such as Star Chips, reputation, ship mastery, upgrades, and lifetime statistics belong to a separate persistence design later.

---

## 23. Dependency direction

Preferred direction:

```text
Main / run composition
    -> gameplay scenes
        -> owned child behavior
            -> Resources/data
```

Events travel upward using signals.

Avoid:

- player searching for Main,
- hazard searching for HUD,
- collectible directly changing persistent global currency,
- arbitrary sibling NodePaths,
- global mutable state for local run concerns.

---

## 24. Performance

Do not optimize before measurement, but avoid obvious waste.

- Use Nodes for active scene behavior.
- Use Resources/RefCounted objects for data/helper responsibilities.
- Disable processing when unnecessary.
- Prefer scene instances for normal gameplay objects.
- Consider pooling only after profiling proves spawn/free churn matters.
- Keep collision masks narrow and intentional.
- Avoid effects that compromise mobile readability/performance.

---

## 25. Validation

After meaningful changes, validate with Godot 4.7 when available:

```bash
godot --headless --path . --editor --quit
```

Also check:

- parser errors,
- missing resources,
- invalid NodePaths,
- input actions,
- collision configuration,
- main scene load,
- reusable scene independence where relevant.

Never claim runtime/headless validation succeeded if Godot was not executed.

---

## 26. Development sequence rule

Do not infer a full implementation roadmap from this architecture document.

The user chooses the next milestone.

At every stage:

1. read `docs/game_design/game_concept_v0.md`,
2. inspect the current project,
3. implement the smallest coherent requested feature,
4. validate,
5. stop.

The full game concept describes destination, not permission to prebuild future systems.
