# Godot 4.7 Node Selection Guide — Starfall Courier

Choose a node by the behavior the object needs, not by its visual name.

Canonical game reference:

- `docs/game_design/game_concept_v0.md`

Starfall Courier is a three-lane survival/courier game, not a combat-focused shooter.

---

## Quick decision flow

### 2D transform/container only?

Use `Node2D`.

Examples:

- gameplay world container,
- hazard container,
- effect container,
- lane-marker parent.

### Code-controlled body requiring collision response?

Use `CharacterBody2D`.

Primary project example:

- courier/player ship.

Possible future example:

- deterministic moving obstacle that must produce solid collision response.

Use `_physics_process()` for physics-dependent movement.

### Overlap/contact detection without solid response?

Use `Area2D`.

Project examples:

- simple hazard,
- Star Core,
- power-up pickup,
- Near-Miss region,
- route gate,
- extraction trigger,
- gameplay trigger.

### Solid and fixed?

Use `StaticBody2D`.

Examples:

- fixed boundary,
- immovable obstacle.

### Physics engine should simulate movement?

Use `RigidBody2D`.

Examples:

- debris intentionally driven by impulses,
- asteroid intentionally using physical spin/bounce.

Do not choose `RigidBody2D` just because the object is an asteroid.

### Physics body moved by animation/code while affecting physics?

Consider `AnimatableBody2D`.

Use only when its specific behavior is required.

---

## Project node matrix

| Requirement | Default node | Why |
|---|---|---|
| Main gameplay root | `Node2D` | Composes the run |
| World/entity container | `Node2D` | Lightweight 2D transform parent |
| Courier/player ship | `CharacterBody2D` | Deterministic lane movement + collision response |
| Simple overlap hazard | `Area2D` | Detects player overlap without solid response |
| Physics debris/asteroid | `RigidBody2D` | Physics-driven movement/spin |
| Fixed obstacle | `StaticBody2D` | Immovable solid collision |
| Star Core | `Area2D` | Collection trigger |
| Power-up pickup | `Area2D` | Collection trigger |
| Near-Miss region | `Area2D` | Proximity detection |
| Route/extraction trigger | `Area2D` | Lane-based trigger interaction |
| World image | `Sprite2D` | Displays one texture |
| Frame animation | `AnimatedSprite2D` | Sprite-frame animation |
| Complex property animation | `AnimationPlayer` | Coordinates property/node animation |
| Collision shape | `CollisionShape2D` | Shape for physics/Area parent |
| Camera | `Camera2D` | Controls 2D viewport |
| Lane/spawn anchor | `Marker2D` | Semantic position without visual/physics behavior |
| HUD layer | `CanvasLayer` | Separates screen UI from world camera |
| HUD/menu layout | `Control` | Screen-space layout |
| Text | `Label` | UI text |
| Interactive menu action | `Button` | UI interaction |
| Progress display | `ProgressBar` / `TextureProgressBar` | Progress representation |
| Scene-owned timing | `Timer` | Engine-managed timing |
| World positional SFX | `AudioStreamPlayer2D` | Positional sound |
| Music/UI SFX | `AudioStreamPlayer` | Non-positional sound |
| VFX particles | `GPUParticles2D` | 2D particles |
| Reusable configuration | `Resource` | Serialized data |
| Pure runtime helper/data | `RefCounted` | Lightweight object outside tree |

---

## Player scene

Default when player implementation begins:

```text
Player (CharacterBody2D)
├── Sprite2D / AnimatedSprite2D
└── CollisionShape2D
```

Add children only when a real feature requires them.

Why `CharacterBody2D`:

- movement is controlled deliberately by player input,
- lane state should be deterministic,
- collision response can be handled predictably,
- Godot's character-body movement API fits code-controlled movement.

Do not add a weapon origin by default.

Do not replace the three-lane model with unrestricted free-flight movement.

---

## Lane representation

Lanes are logical positions.

Useful scene tools may include:

```text
LaneMarkers (Node2D)
├── LeftLane (Marker2D)
├── CenterLane (Marker2D)
└── RightLane (Marker2D)
```

`Marker2D` is appropriate when a lane needs a named world position but no independent behavior.

Do not create lane nodes if simple calculated positions are clearer for the current milestone.

Choose the simplest representation that remains readable and testable.

---

## Star Core

Recommended default:

```text
StarCore (Area2D)
├── Sprite2D / AnimatedSprite2D
└── CollisionShape2D
```

Why `Area2D`:

- it needs collection detection,
- it does not need to act as a solid body,
- overlap signals fit the behavior.

---

## Simple hazard

If a hazard only needs to travel toward the player and report overlap:

```text
Hazard (Area2D)
├── Sprite2D / AnimatedSprite2D
└── CollisionShape2D
```

Use `Area2D`.

If physical collision response/bounce is part of the design, reconsider the root type.

---

## Physics debris

When debris should truly be physics simulated:

```text
Debris (RigidBody2D)
├── Sprite2D
└── CollisionShape2D
```

Use forces/impulses/velocity according to `RigidBody2D` behavior.

Do not manually force its transform every physics frame as the normal pattern.

---

## Near-Miss region

Near Miss is proximity detection, so `Area2D` is a natural tool.

Possible conceptual structure:

```text
Hazard
├── CollisionShape2D
└── NearMissArea (Area2D)
    └── CollisionShape2D
```

This is only one possible ownership design.

Do not build it until Near Miss is the active milestone.

The implementation must prevent duplicate Near-Miss rewards for the same hazard pass.

---

## Route gate

Route selection occurs inside the playfield by choosing a lane.

A route gate may use:

```text
RouteGate (Node2D)
├── presentation
├── LeftRouteTrigger (Area2D)
├── CenterRouteTrigger (Area2D)
└── RightRouteTrigger (Area2D)
```

This is conceptual.

The exact tree should be created only when the route feature is requested.

Use world-space triggers rather than replacing the mechanic with unrelated UI buttons.

---

## HUD

Recommended:

```text
HudLayer (CanvasLayer)
└── Hud (Control)
    └── layout children
```

Use `Control` containers/anchors for portrait responsive layout.

Keep the center of the playfield clear.

---

## Main gameplay scene

Possible future composition:

```text
Main (Node2D)
├── Background
├── World (Node2D)
│   ├── Player
│   ├── Hazards
│   ├── Collectibles
│   └── GameplayTriggers
├── Camera2D
└── HudLayer
```

`Main` is a composition root, not a reason to put every gameplay rule into one script.

---

## Visual node rules

### `Sprite2D`

Use for one texture.

### `AnimatedSprite2D`

Use for frame-based animation such as:

- thruster frames,
- collectible pulse frames,
- animated hazard,
- pickup animation.

### `AnimationPlayer`

Use when one animation coordinates multiple properties/nodes:

- UI transition,
- route-gate emphasis,
- shield impact,
- fade/scale/rotation sequences.

### Tween

Use for focused runtime interpolation such as a short UI or visual transition when a reusable animation asset is unnecessary.

Do not add multiple animation systems for the same simple job.

---

## Timing rules

Use `Timer` when timing belongs naturally to scene lifecycle.

Future examples:

- combo grace time,
- temporary invulnerability,
- power-up duration,
- hazard telegraph delay.

For a tiny one-off delay, `SceneTree.create_timer()` can be suitable.

Do not create a global timing manager.

---

## Data: Node vs Resource vs RefCounted

### Use `Node` when

- it belongs in the scene tree,
- it needs lifecycle callbacks,
- it represents active behavior.

### Use `Resource` when

- it is reusable serialized configuration,
- it should be Inspector-editable,
- it may be shared by scenes.

Future example:

```gdscript
class_name ShipData
extends Resource

@export var lane_change_duration: float = 0.12
@export var reward_multiplier: float = 1.0
```

### Use `RefCounted` when

- it is lightweight runtime data/helper logic,
- it does not need tree lifecycle,
- it does not need Inspector serialization.

---

## UI nodes

Use `Control`-derived nodes for screen UI.

Prefer layout containers:

- `MarginContainer`
- `VBoxContainer`
- `HBoxContainer`
- `CenterContainer`
- `PanelContainer`

Use anchors/offsets rather than arbitrary world coordinates.

Use `CanvasLayer` for HUD independent from the world camera.

---

## Node-selection anti-patterns

### `Node2D` for everything

Use specialized physics/UI nodes when their behavior is required.

### `Area2D` for a solid collision-controlled player

`Area2D` detects overlap; it is not the default solid player controller.

### `RigidBody2D` for deterministic lane input

Use `CharacterBody2D` unless physics-driven player movement becomes an intentional design change.

### `Control` as a world gameplay object

World gameplay belongs in 2D world nodes. Screen UI belongs in `Control`.

### Nodes used only as data

Use `Resource`/`RefCounted` when appropriate.

### Combat nodes because of the repository name

Do not add bullets, weapons, enemy-health combat architecture, or firing input just because the repository is called `space-shooter`.

The canonical game is Starfall Courier.

### Manager nodes everywhere

First ask whether scene ownership, signals, Resources, or direct references solve the responsibility locally.

---

## Decision checklist

Before adding a node, answer:

1. What exact behavior does it provide?
2. Is there a more specialized built-in Godot node?
3. Does it actually need to exist in the scene tree?
4. Is the responsibility behavior or data?
5. Does it require physical collision response or only overlap detection?
6. Is it world-space or screen-space?
7. Who owns it?
8. Can the containing scene run without hidden external paths?
9. Does this node support the current requested milestone?
10. Does it preserve the three-lane non-combat Starfall Courier design?

If the answers are unclear, do not add the node yet.
