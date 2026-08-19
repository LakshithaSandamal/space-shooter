# AI Instructions — Godot 4.7 Space Shooter

These instructions define how an AI coding agent must work inside this repository.

## 1. Project identity

- Engine: Godot 4.7
- Language: GDScript
- Game type: 2D space shooter
- Main project file: `project.godot`
- Current main scene: `res://scenes/main.tscn`
- Architecture reference: `docs/godot_architecture.md`
- Node-selection reference: `docs/node_selection_guide.md`

Do not assume APIs from older Godot versions or unstable future documentation.

## 2. Read before editing

Before making a meaningful change:

1. Inspect `project.godot`.
2. Inspect the scene(s) affected by the task.
3. Inspect the script(s) already attached to those scenes.
4. Read the relevant architecture section in `docs/`.
5. Reuse existing conventions instead of inventing a parallel pattern.
6. Identify the smallest set of files that must change.

Never rewrite unrelated files just because a cleaner architecture is imaginable.

## 3. Incremental development rule

Build one real requirement at a time.

Do not scaffold future systems before they are needed.

For example, when implementing player movement, do not also create:

- enemy managers,
- inventory systems,
- save systems,
- wave data,
- generic service locators,
- unnecessary Autoloads.

Every change should leave the project runnable and understandable.

## 4. Node-selection rules

Choose the root node by what the object fundamentally does.

Default choices for this project:

- Main gameplay composition root -> `Node2D`
- Player ship -> `CharacterBody2D`
- AI-controlled enemy ship -> `CharacterBody2D`
- Simple projectile -> `Area2D`
- Pickup -> `Area2D`
- Hitbox/hurtbox -> `Area2D`
- Detection radius -> `Area2D`
- Fixed solid obstacle -> `StaticBody2D`
- Physics-driven asteroid/debris -> `RigidBody2D`
- World-space image -> `Sprite2D`
- Frame animation -> `AnimatedSprite2D`
- Complex property animation -> `AnimationPlayer`
- Camera -> `Camera2D`
- Spawn point -> `Marker2D`
- Screen HUD layer -> `CanvasLayer`
- UI root/layout -> `Control`
- Reusable configuration data -> `Resource`
- Lightweight runtime helper/data -> `RefCounted`

Before choosing a generic `Node` or `Node2D`, check whether Godot already has a specialized node for the required behavior.

## 5. Scene architecture rules

Scenes should be self-contained whenever possible.

A reusable scene must not depend on hard-coded paths outside itself.

Do not write code like:

```gdscript
get_node("../../Main/Hud")
```

Instead use one of these patterns:

- exported dependency,
- parent-injected reference,
- direct parent-to-child method call,
- child-to-parent signal,
- Resource configuration.

A child should not know more about the larger scene tree than necessary.

## 6. Communication rules

Use this default direction:

### Parent to child

Use a direct typed method call when the parent is commanding behavior.

Example:

```gdscript
weapon.fire()
```

### Child to parent or external owner

Use signals when reporting an event that already happened.

Example:

```gdscript
signal died
signal hit(target: Node)
signal score_awarded(points: int)
```

### Siblings

Do not make siblings search for each other through relative paths.

Let the common parent coordinate them or inject the required reference.

## 7. Composition over inheritance

Prefer small scenes and focused behavior components over deep inheritance trees.

Do not create unnecessary hierarchies such as:

```text
BaseEntity
 -> MovingEntity
   -> CombatEntity
     -> EnemyCombatEntity
       -> FastEnemyCombatEntity
```

Only introduce shared base classes when there is real, stable shared behavior.

## 8. Autoload policy

Autoload is not the default solution for shared functionality.

Do not create global managers automatically.

Avoid speculative classes such as:

- `GameManager`
- `EnemyManager`
- `PlayerManager`
- `UIManager`
- `AudioManager`
- `GlobalManager`

Before adding an Autoload, prove that the responsibility:

1. must exist across scene changes,
2. is truly project-wide,
3. cannot be handled cleanly by scene ownership, a Resource, a signal, a static helper, or dependency injection.

Reasonable future examples may include persistent settings, save/profile state, or scene-transition coordination.

## 9. Resource policy

Use `Resource` for reusable game data rather than Nodes.

Good future examples:

- ship stats,
- weapon configuration,
- enemy configuration,
- wave configuration.

Example pattern:

```gdscript
class_name WeaponData
extends Resource

@export var damage: float = 10.0
@export var fire_interval: float = 0.2
@export var projectile_speed: float = 700.0
```

Keep behavior in Nodes/scripts and data in Resources when separation is useful.

## 10. GDScript typing rules

Use statically typed GDScript.

Functions must declare return types whenever practical.

Preferred:

```gdscript
var speed: float = 320.0
var target: Node2D

func take_damage(amount: float) -> void:
    pass

func get_target_position() -> Vector2:
    return target.global_position
```

Use type inference only when the resulting type is obvious and stable.

Avoid vague untyped state when the type is known.

## 11. Naming rules

Use:

- folders: `snake_case`
- filenames: `snake_case`
- variables: `snake_case`
- functions: `snake_case`
- signals: `snake_case`
- groups: `snake_case`
- node names: `PascalCase`
- class names: `PascalCase`
- constants: `UPPER_SNAKE_CASE`

Keep names domain-specific and descriptive.

Avoid vague names such as:

- `thing`
- `data2`
- `manager`
- `helper`
- `stuff`
- `temp` for permanent code

## 12. Script responsibilities

A script should have one clear responsibility.

Prefer:

```text
player.gd
projectile.gd
health.gd
weapon.gd
wave_spawner.gd
hud.gd
```

Avoid giant scripts that combine movement, UI, spawning, persistence, audio, and game state.

Do not split a tiny script into many components unless reuse or complexity justifies it.

## 13. Physics rules

### CharacterBody2D

Use for code-controlled ships requiring collision response.

Movement must normally happen in `_physics_process(delta)`.

Do not manually update `position` as the normal collision-aware movement path.

Use `velocity` with `move_and_slide()` or `move_and_collide()` as appropriate.

### Area2D

Use for detection and overlap without solid collision response.

Good uses:

- bullets,
- hitboxes,
- hurtboxes,
- pickups,
- detection zones.

### RigidBody2D

Use when the physics engine should control movement through forces, impulses, mass, and angular velocity.

Do not use it for deterministic player movement unless that is an intentional gameplay mechanic.

### StaticBody2D

Use for fixed solid collision.

## 14. Collision layers and masks

Never assign collision layers randomly.

When a new gameplay collision category is introduced:

1. define its purpose,
2. document the layer,
3. configure both layer and mask intentionally,
4. avoid broad masks that collide with everything unless required.

A likely future model is:

```text
1 player
2 enemies
3 player_projectiles
4 enemy_projectiles
5 world
6 pickups
```

Do not add these until the corresponding gameplay systems exist.

## 15. Processing rules

Use `_physics_process(delta)` for physics movement and collision-dependent gameplay.

Use `_process(delta)` only for work that truly needs a per-render-frame callback.

Do not leave processing enabled on nodes that do not need it.

Prefer built-in systems such as:

- `Timer`,
- `AnimationPlayer`,
- Tweens,
- signals,

instead of manually polling everything every frame.

## 16. Input rules

Gameplay code should use named Input Map actions, not raw keyboard key codes scattered through scripts.

Preferred conceptual actions:

```text
move_left
move_right
move_up
move_down
fire_primary
pause
```

Only add input actions required by the current implementation.

## 17. UI rules

Use `Control`-derived nodes for UI.

Use layout containers and anchors instead of treating UI as world-space `Node2D` objects.

Use `CanvasLayer` when HUD elements must remain fixed while `Camera2D` moves the world.

Gameplay entities should not directly search for or mutate HUD nodes.

Emit gameplay events and let a higher-level owner update presentation.

## 18. Asset rules

Do not modify source art, audio, fonts, or imported assets unless the task explicitly requires it.

Do not commit `.godot/` generated import/cache data.

Keep third-party engine plugins under `addons/`.

Use lowercase `snake_case` paths to avoid case-sensitivity problems across platforms.

## 19. Scene-file editing rules

When editing `.tscn` files manually:

- preserve valid Godot scene syntax,
- preserve resource references,
- do not invent resource UIDs unless necessary,
- keep node ownership correct,
- avoid rewriting unrelated serialized properties,
- verify every referenced path exists.

Prefer minimal scene edits.

## 20. Error handling

Do not silently hide invalid state.

For dependencies that are required by design:

- type them,
- validate them early,
- fail clearly during development if they are missing.

For optional resources or external files, handle absence deliberately.

Do not use defensive null checks everywhere as a substitute for correct ownership.

## 21. Documentation rules

Update documentation when a change introduces a lasting architectural decision, such as:

- a new top-level system,
- an Autoload,
- a collision-layer convention,
- a new reusable component pattern,
- a significant folder-structure change.

Do not update architecture docs for trivial implementation details.

## 22. Validation requirement

After meaningful changes, validate the project with the Godot 4.7 executable when available.

Preferred project parse/import validation:

```bash
godot --headless --path . --editor --quit
```

If the executable is named differently, use the installed Godot 4.7 binary.

Also check:

- GDScript parser errors,
- invalid scene syntax,
- missing resources,
- missing NodePaths,
- incorrect input action names,
- incorrect collision setup,
- main scene loading.

If Godot cannot be executed in the environment, explicitly state that runtime/headless validation was not performed.

Never claim a successful Godot run unless the command actually ran successfully.

## 23. Change-report format

After completing a coding task, report:

1. what changed,
2. why those nodes/architecture were chosen,
3. files changed,
4. validation performed,
5. any remaining limitation.

Do not bury errors or skipped validation.

## 24. Current staged-development constraint

This repository is intentionally being built from a fresh project.

Do not implement unrelated future game features ahead of the requested stage.

For every task:

- implement the requested stage,
- keep it clean,
- validate it,
- then stop.

The next feature should be added only when requested.
