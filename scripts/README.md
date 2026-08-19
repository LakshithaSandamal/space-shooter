# Scripts

This folder contains GDScript source code used by **Starfall Courier**.

Do not create empty architecture for future features. Add each domain folder only when its first real script is implemented.

## Planned organization

```text
scripts/
├── core/          # Current-run orchestration/foundational local code
├── player/        # Courier ship and lane-control behavior
├── hazards/       # Hazard-specific behavior
├── collectibles/  # Star Cores and collectible behavior
├── power_ups/     # Power-up behavior when implemented
├── routes/        # Route/extraction behavior when implemented
├── components/    # Reusable behavior only after genuine reuse appears
├── systems/       # Scene-owned run systems
└── ui/            # HUD/menu presentation
```

These are organizational destinations, not directories to create immediately.

## Rules

- Use Godot 4.7.
- Use statically typed GDScript.
- Use `snake_case` filenames.
- Keep one clear responsibility per script.
- Choose the most appropriate specialized Godot node.
- Keep reusable scenes self-contained.
- Use direct typed calls for parent-to-child commands.
- Use signals for events reported outward.
- Avoid hard-coded external NodePaths.
- Prefer `Resource` for reusable serialized configuration when needed.
- Avoid speculative Autoload/global-manager patterns.
- Do not add generic abstraction layers before a concrete need exists.
- Preserve the game's three-lane, non-combat courier identity.
- Do not create firing/projectile/combat systems unless explicitly requested.

## Read before gameplay implementation

1. `../docs/game_design/game_concept_v0.md`
2. `../instructions/godot_ai_instructions.md`
3. `../docs/godot_architecture.md`
4. `../docs/node_selection_guide.md`

The game concept defines **what** to build.

Architecture and node guides define **how** to build it in Godot.

The user's current request defines **what to implement now**.
