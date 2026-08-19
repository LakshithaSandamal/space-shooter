# Godot 4.7 Node Selection Guide — Space Shooter

Choose a node by the behavior the object needs, not by its visual appearance or name.

A scene's root node should represent what the object fundamentally does.

## Quick decision flow

### Does it need 2D transform only?

Use `Node2D`.

Examples:

- world containers,
- spawn containers,
- effect containers,
- simple logical 2D parents.

### Is it a code-controlled moving body that must collide and respond?

Use `CharacterBody2D`.

Examples:

- player ship,
- enemy ships that use deliberate movement and collision response,
- a complex projectile that must slide, stop, or ricochet based on custom code.

Movement belongs in `_physics_process()` and should normally use `move_and_slide()` or `move_and_collide()` instead of changing `position` directly.

### Does it only need overlap/contact detection with no solid collision response?

Use `Area2D`.

Examples:

- normal bullets,
- laser hit regions,
- hitboxes,
- hurtboxes,
- pickups,
- enemy detection zones,
- trigger regions.

### Is it a solid object that never moves?

Use `StaticBody2D`.

Examples:

- fixed walls,
- immovable level boundaries,
- permanent solid obstacles.

### Should physics simulate its movement?

Use `RigidBody2D`.

Examples:

- drifting debris that should react to forces,
- physical asteroids,
- objects that should naturally bounce/spin through physics.

Do not use `RigidBody2D` for the player ship when exact input-controlled movement is required.

### Is it a physics body moved by animation/code that should affect other physics bodies?

Consider `AnimatableBody2D`.

Use only when that specific physics interaction is needed. Do not use it as the default moving gameplay object.

---

## Project node matrix

| Requirement | Default node | Why |
|---|---|---|
| Game root | `Node2D` | Composes the 2D gameplay world |
| World/entity container | `Node2D` | Lightweight 2D transform parent |
| Player ship | `CharacterBody2D` | Precise code-controlled movement and collision |
| Enemy ship | `CharacterBody2D` | Deterministic AI movement with collision response |
| Simple player bullet | `Area2D` | Needs hit detection, not solid physics |
| Simple enemy bullet | `Area2D` | Same reason as player bullet |
| Ricocheting/complex projectile | `CharacterBody2D` | Manual movement plus detailed collision response |
| Physics asteroid/debris | `RigidBody2D` | Physics-driven motion and rotation |
| Fixed wall/boundary | `StaticBody2D` | Immovable collision body |
| Pickup/power-up | `Area2D` | Trigger when player overlaps |
| Hitbox | `Area2D` | Detect outgoing hit overlap |
| Hurtbox | `Area2D` | Detect incoming damage overlap |
| Enemy detection radius | `Area2D` | Detect targets entering/exiting a region |
| Ship image | `Sprite2D` | Displays one texture |
| Frame-based ship animation | `AnimatedSprite2D` | Sprite-frame animation |
| Complex property animation | `AnimationPlayer` | Animates properties and tracks |
| Collision shape | `CollisionShape2D` | Shape for physics/area parent |
| Camera | `Camera2D` | Controls 2D viewport transform |
| Spawn position | `Marker2D` | Named 2D point without visual/physics behavior |
| HUD screen layer | `CanvasLayer` | Keeps UI independent of world camera |
| HUD/menu root | `Control` | UI layout, anchors, containers |
| Text | `Label` | Displays UI text |
| Button | `Button` | Interactive UI button |
| Health/progress UI | `ProgressBar` / `TextureProgressBar` | Progress display |
| Delay/cooldown | `Timer` | Engine-managed timing |
| World positional sound | `AudioStreamPlayer2D` | 2D positional audio |
| Music/UI sound | `AudioStreamPlayer` | Non-positional audio |
| Explosion/thruster particles | `GPUParticles2D` | Efficient 2D particles |
| Reusable configuration | `Resource` | Serialized data, not scene behavior |
| Pure helper/data object | `RefCounted` | Lightweight object outside scene tree |

---

## Root node choices for our first gameplay scenes

### Player

Recommended:

```text
Player (CharacterBody2D)
├── Sprite2D / AnimatedSprite2D
├── CollisionShape2D
├── WeaponOrigin (Marker2D)
└── ... only nodes required by the current implementation
```

Why `CharacterBody2D`:

- player input explicitly controls movement,
- collision response should be predictable,
- movement can use `velocity` and `move_and_slide()`,
- physics movement belongs in `_physics_process()`.

Do not use `RigidBody2D` for the normal player controller.

### Simple projectile

Recommended:

```text
Projectile (Area2D)
├── Sprite2D
└── CollisionShape2D
```

Why `Area2D`:

- a normal bullet generally only needs to know what it touched,
- it does not need to push bodies or behave as a solid object,
- hit detection can use overlap signals.

If later a projectile must bounce against walls using precise collision information, reconsider `CharacterBody2D` for that projectile type.

### Enemy

Recommended:

```text
Enemy (CharacterBody2D)
├── Sprite2D / AnimatedSprite2D
├── CollisionShape2D
└── ... enemy-specific children
```

Use `CharacterBody2D` when enemy movement is explicitly controlled by AI code.

If an object is more like passive physics debris than an AI-controlled ship, use `RigidBody2D` instead.

### HUD

Recommended:

```text
HudLayer (CanvasLayer)
└── Hud (Control)
    └── UI children
```

Why:

- `Control` is built for UI layout,
- `CanvasLayer` keeps HUD screen-space independent from the world `Camera2D`.

### Main gameplay scene

Recommended later:

```text
Main (Node2D)
├── Background
├── World (Node2D)
├── Camera2D
└── HudLayer (CanvasLayer)
```

`Main` is a composition root, not a giant gameplay controller.

---

## Visual node rules

### `Sprite2D`

Use when one texture is enough.

### `AnimatedSprite2D`

Use for frame-based sprite animation such as:

- thruster animation,
- animated enemy,
- explosion frames,
- pickup animation.

### `AnimationPlayer`

Use when animation needs to coordinate multiple properties/nodes:

- fade + scale + rotation,
- UI transitions,
- complex ship effects,
- multi-node animation sequences.

Do not add `AnimationPlayer` when a simple `AnimatedSprite2D` is sufficient.

---

## Physics node rules

### `CharacterBody2D`

Choose when we control velocity/movement in code and want collision information/response.

For our project this is the default for player and AI ships.

### `Area2D`

Choose for detection, not physical response.

Use it for bullets, pickups, hitboxes, hurtboxes, and trigger zones.

### `StaticBody2D`

Choose for solid, non-moving world collision.

### `RigidBody2D`

Choose when the physics engine should control the body's movement from forces, impulses, mass, angular velocity, and collisions.

Avoid manually setting a `RigidBody2D` transform every physics frame as a normal controller pattern.

---

## UI node rules

Use `Control`-derived nodes for UI instead of `Node2D`.

Prefer containers for layout:

- `MarginContainer`
- `VBoxContainer`
- `HBoxContainer`
- `CenterContainer`
- `PanelContainer`

Use anchors and offsets correctly rather than hard-coding screen coordinates wherever possible.

Put gameplay HUD under `CanvasLayer` when the world camera moves.

---

## Timing rules

Use `Timer` when a lifecycle timer is naturally part of a scene:

- weapon cooldown,
- projectile lifetime,
- enemy fire interval,
- invulnerability duration.

For a tiny one-off delay, `SceneTree.create_timer()` may be sufficient.

Do not create a global timing manager.

---

## Data: Node vs Resource vs RefCounted

### Use `Node` when

- it belongs in the scene tree,
- it needs lifecycle callbacks,
- it uses scene-tree features,
- it represents active behavior.

### Use `Resource` when

- it is reusable configuration/content data,
- it should be editable in the Inspector,
- it should be saved as a `.tres`/resource.

Example:

```gdscript
class_name WeaponData
extends Resource

@export var damage: float = 10.0
@export var fire_interval: float = 0.2
@export var projectile_speed: float = 700.0
```

### Use `RefCounted` when

- it is a lightweight runtime helper/data class,
- it does not need a scene-tree lifecycle,
- it does not need to be a serialized Inspector resource.

---

## Node selection anti-patterns

Avoid these choices:

### `Node2D` for everything

If an object needs physics collision, use the appropriate physics node instead of rebuilding physics manually.

### `Area2D` for a player that needs solid collision response

An `Area2D` is excellent for detection but is not the default choice for a solid player controller.

### `RigidBody2D` for deterministic player input

Use `CharacterBody2D` unless physics-driven movement is intentionally part of the game design.

### `Control` inside the moving world for HUD

Keep screen UI separate through `CanvasLayer`/`Control`.

### Nodes used only as data containers

Prefer `Resource` or `RefCounted`.

### Manager nodes everywhere

First ask whether scene ownership, a signal, a resource, or a direct reference solves the problem locally.

---

## Decision checklist before adding a node

Before adding any node, answer:

1. What exact behavior does this node provide?
2. Is there a more specialized built-in node for that behavior?
3. Does it need to exist in the scene tree?
4. Is it behavior or only data?
5. Does it need physics response or only overlap detection?
6. Is it world-space or screen-space UI?
7. Is it owned by this scene?
8. Can this scene still run without assuming external node paths?

If those answers are unclear, do not add the node yet.
