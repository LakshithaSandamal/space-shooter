# Space Shooter Documentation

This folder contains the human-readable architecture and Godot usage rules for the project.

Godot ignores this folder because it contains a `.gdignore` marker. This keeps design documentation out of the Godot FileSystem dock and import scan.

## Documents

- `godot_architecture.md` — project architecture, scene boundaries, communication rules, data flow, naming, and folder structure.
- `node_selection_guide.md` — practical rules for choosing the correct Godot node for each space-shooter requirement.

## Project baseline

- Engine: Godot 4.7
- Language: GDScript
- Code style: statically typed GDScript
- Game type: 2D space shooter
- Architecture: scene composition with small, self-contained scenes
- Communication: direct child calls for commands, signals for events, resources for reusable data
- Global state: avoid by default; use Autoload only for truly project-wide lifetime concerns

## Core design principles

1. Choose a scene root by what the object fundamentally is.
2. Keep reusable scenes self-contained.
3. Avoid hard-coded paths to nodes outside a scene.
4. Prefer composition over deep scene or script inheritance.
5. Prefer signals when a child reports something that happened.
6. Prefer direct typed method calls when a parent tells a child to do something.
7. Prefer `Resource` objects for reusable configuration and game data.
8. Use `CharacterBody2D` for ships that are moved deliberately by code and need collision response.
9. Use `Area2D` for hitboxes, hurtboxes, pickups, detection regions, and simple projectiles that only need overlap detection.
10. Keep UI under `Control` nodes, usually inside a `CanvasLayer` when it must stay fixed to the screen.
11. Use `snake_case` for files, folders, and groups; use `PascalCase` for node names.
12. Add an Autoload only when the system must survive scene changes or truly has project-wide scope.

## Source material

These rules are based on the uploaded Godot 4.7 tutorial set and the official Godot 4.7 documentation, especially:

- Nodes and Scenes
- Applying object-oriented principles in Godot
- Scene organization
- Project organization
- When to use scenes versus scripts
- Autoloads versus regular nodes
- When and how to avoid using nodes for everything
- Resources
- Groups
- Using CharacterBody2D/3D
- Using Area2D
- Canvas layers
