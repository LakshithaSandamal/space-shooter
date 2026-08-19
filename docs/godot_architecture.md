# Godot Architecture for Space Shooter

## 1. Architecture goal

This project should stay easy to understand, test, extend, and refactor as the game grows. Godot is scene-based, so the architecture should use scenes as reusable game objects rather than forcing a traditional service-heavy application architecture onto the engine.

The default rule is:

> A reusable gameplay object should usually be a self-contained scene with a small typed script on its root node.

Examples:

- Player ship -> `Player` scene
- Enemy ship -> `Enemy` scene
- Bullet -> `Projectile` scene
- HUD -> `Hud` scene
- Explosion -> `Explosion` scene

The main scene composes these objects rather than implementing all behavior itself.

## 2. Core architecture principles

### 2.1 Self-contained scenes

A reusable scene should contain the nodes and resources it needs to function.

A `Player` scene should not assume that a node exists at a path such as:

```gdscript
get_node("../../Main/Hud")
```

That creates a hidden dependency on the scene's environment and makes the player difficult to reuse or test.

Instead:

- expose configuration with exported typed properties,
- expose commands through methods,
- report events with signals,
- inject required external references from the parent when truly necessary.

### 2.2 Composition over deep inheritance

Prefer composing focused child nodes and components instead of building deep class trees such as:

```text
Ship
  -> CombatShip
    -> EnemyCombatShip
      -> FastEnemyCombatShip
```

Prefer reusable behavior components or small scene composition when behavior is shared.

Potential components later:

- health
- damage receiver
- weapon
- movement controller
- hitbox
- hurtbox

Do not create components before the game actually needs reuse.

### 2.3 Parent coordinates, children report

A practical communication rule:

- Parent -> child: direct typed method call for commands.
- Child -> parent/external context: signal for an event that already happened.

Example:

```gdscript
# Parent tells a weapon to fire.
weapon.fire()
```

```gdscript
# Weapon reports that a shot was fired.
signal fired(projectile: Node2D)
```

This keeps ownership and dependency direction clear.

### 2.4 Avoid sibling dependencies

Sibling nodes should not normally search for or control each other directly.

Bad:

```gdscript
get_node("../Hud").update_score(score)
```

Better:

- the gameplay node emits a signal,
- the common parent receives it,
- the parent updates the HUD.

### 2.5 Use Resources for data

A `Resource` is preferred for reusable configuration and content data because it is lightweight, serializable, Inspector-friendly, and not part of the scene tree.

Possible future resources:

```text
ship_stats.gd
weapon_data.gd
enemy_data.gd
wave_data.gd
```

Possible values:

- speed
- max health
- fire rate
- projectile speed
- damage
- score value
- spawn configuration

Do not use Nodes just to hold data.

## 3. Recommended repository structure

The repository currently keeps scenes and scripts in separate top-level folders. To remain maintainable, mirror the same gameplay domains in both folders.

```text
res://
├── project.godot
│
├── scenes/
│   ├── main.tscn
│   ├── player/
│   ├── enemies/
│   ├── projectiles/
│   ├── effects/
│   └── ui/
│
├── scripts/
│   ├── core/
│   ├── player/
│   ├── enemies/
│   ├── projectiles/
│   ├── components/
│   ├── systems/
│   └── ui/
│
├── resources/
│   ├── ships/
│   ├── weapons/
│   ├── enemies/
│   └── waves/
│
├── assets/
│   ├── player/
│   ├── enemies/
│   ├── projectiles/
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

Do not create every directory immediately. Add a directory when the first real file for that domain exists.

## 4. Main scene responsibility

The main scene is the composition root for one gameplay run.

Recommended shape when gameplay begins:

```text
Main (Node2D)
├── Background (Node2D or Parallax2D)
├── World (Node2D)
│   ├── PlayerSpawn (Marker2D)
│   ├── Enemies (Node2D)
│   ├── Projectiles (Node2D)
│   └── Effects (Node2D)
├── Camera2D
└── HudLayer (CanvasLayer)
    └── Hud (Control)
```

The exact tree should only be created when those systems are implemented.

### Main should own

- high-level game flow for the current run,
- spawning scene instances,
- connecting high-level signals,
- coordinating score, wave progression, and game-over flow,
- references to top-level containers.

### Main should not own

- player movement code,
- enemy movement code,
- projectile collision details,
- animation internals,
- weapon internals,
- individual health logic.

## 5. Scene boundaries

Create a separate scene when an object:

- is instantiated more than once,
- has its own lifecycle,
- has several child nodes,
- needs isolated testing,
- represents a clear game concept,
- is likely to be reused.

Examples that deserve scenes:

- player ship,
- enemy type,
- projectile type,
- explosion,
- HUD,
- pause menu.

Do not create a scene for a trivial value or tiny helper that has no node behavior.

## 6. Script boundaries

Attach a script when a node needs behavior or state that the built-in node does not already provide.

Do not attach scripts merely to rename concepts.

A script should generally have one clear responsibility.

Good examples:

```text
player.gd             -> player-specific orchestration
player_movement.gd    -> movement behavior if it becomes reusable/complex
health.gd             -> reusable health component
projectile.gd         -> projectile movement/lifetime/hit handling
wave_spawner.gd       -> wave spawning rules
hud.gd                -> HUD presentation updates
```

Avoid generic files such as:

```text
manager.gd
utils.gd
helpers.gd
game_system.gd
```

unless the responsibility is precisely defined.

## 7. Typed GDScript standard

Use static typing throughout gameplay code.

Preferred:

```gdscript
extends CharacterBody2D

@export var move_speed: float = 320.0

func _physics_process(delta: float) -> void:
    var direction: Vector2 = Input.get_vector(
        "move_left",
        "move_right",
        "move_up",
        "move_down"
    )
    velocity = direction * move_speed
    move_and_slide()
```

Avoid untyped declarations when the type is known.

Preferred naming:

- files/folders: `snake_case`
- variables/functions/signals/groups: `snake_case`
- node names/classes: `PascalCase`
- constants: `UPPER_SNAKE_CASE`

## 8. Process callbacks

### `_physics_process(delta)`

Use for:

- movement involving physics bodies,
- collision-driven movement,
- deterministic gameplay physics updates.

Player and enemy `CharacterBody2D` movement belongs here.

### `_process(delta)`

Use for frame-dependent visual or non-physics logic when necessary.

Examples:

- purely visual interpolation,
- UI animation logic not handled by AnimationPlayer/Tween.

Do not put every script into both callbacks automatically.

## 9. Signals

Signals are the main decoupling tool for gameplay events.

Use event-style, past-tense names where practical:

```gdscript
signal health_changed(current: float, maximum: float)
signal died
signal projectile_fired(projectile: Node2D)
signal score_awarded(points: int)
```

Good uses:

- player died,
- enemy destroyed,
- health changed,
- projectile hit something,
- wave completed,
- score changed.

Do not use signals simply to replace a straightforward parent-to-child method call.

## 10. Groups

Groups are useful when many unrelated scene instances share a category or need a broadcast operation.

Possible groups:

```text
player
enemies
projectiles
 damageable
```

Use `snake_case` group names.

Do not use groups as a replacement for ownership or clear references when only one known node is involved.

## 11. Autoload policy

Autoloads are global state and must be rare.

Before adding an Autoload, ask:

1. Must this object exist before and after gameplay scene changes?
2. Is its responsibility truly global?
3. Can a regular scene node, Resource, signal, static function, or injected reference solve the problem more locally?

Reasonable future Autoload candidates may include:

- persistent save/profile state,
- scene transition coordination,
- project-wide settings that must survive scene replacement.

Do not create these by default:

```text
GameManager
EnemyManager
PlayerManager
AudioManager
UIManager
```

A local scene-owned node is preferred until global lifetime is demonstrably required.

## 12. Data flow example

A later enemy-destruction flow should look roughly like this:

```text
Projectile detects hit
    -> Enemy/Health receives damage
        -> Health emits died
            -> Enemy emits destroyed(score_value)
                -> Main receives destroyed
                    -> Main updates run score
                    -> Main tells HUD to display the new score
```

The projectile does not directly find the HUD or score system.

## 13. Dependency rules

Allowed dependency direction:

```text
Main / high-level scene
    -> instantiated gameplay scenes
        -> owned child nodes/components
            -> Resources/data
```

Events may travel upward using signals.

Avoid:

- child searching for Main,
- enemy searching for HUD,
- projectile searching for global score state,
- arbitrary sibling node paths,
- globally accessible mutable state for local gameplay concerns.

## 14. Performance rules

Do not optimize before measurement, but avoid obvious structural waste.

- Prefer `Resource`/`RefCounted` for pure data instead of Nodes.
- Disable processing when an object does not need per-frame callbacks.
- Do not create one global `_process()` manager for every entity just because it seems architectural.
- Use scene instances for normal gameplay objects.
- Consider pooling only after profiling shows spawn/free churn is a real problem.
- Keep collision layers and masks intentional.

## 15. Collision architecture

Define layers by gameplay responsibility, not arbitrary numbers.

A likely later plan:

```text
Layer 1: player
Layer 2: enemies
Layer 3: player_projectiles
Layer 4: enemy_projectiles
Layer 5: world
Layer 6: pickups
```

Exact layers should be added to `project.godot` only when the corresponding gameplay system is implemented.

## 16. UI architecture

World gameplay and screen UI should remain separate.

Recommended hierarchy:

```text
HudLayer (CanvasLayer)
└── Hud (Control)
    ├── ScoreLabel
    ├── HealthBar
    └── ...
```

Use `Control` containers and anchors for layout rather than manually positioning UI with `Node2D`.

Use `CanvasLayer` when UI must stay fixed while `Camera2D` moves the world.

## 17. Testing and validation

Every implementation step should keep the project runnable.

Preferred validation after meaningful changes:

```bash
godot --headless --path . --editor --quit
```

For a quick project run where the scene exits on its own or a dedicated test harness exists, use a headless run as appropriate.

Also validate:

- no parser errors,
- no missing resources,
- no invalid NodePaths,
- main scene can load,
- typed GDScript warnings/errors are addressed,
- scenes can be run independently when designed to be reusable.

## 18. Development sequence

Do not scaffold the entire final game up front.

Recommended incremental order:

1. project bootstrap,
2. player scene and movement,
3. shooting/projectile scene,
4. first enemy scene,
5. damage and death,
6. spawning/waves,
7. HUD and score,
8. game state/game-over,
9. effects/audio,
10. data/resources and balancing,
11. persistence/settings only when required.

Each stage should introduce only the architecture needed for that stage.
