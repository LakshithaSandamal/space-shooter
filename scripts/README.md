# Scripts

This folder contains GDScript source code used by the game.

Do not create empty architecture for future features. Add each domain folder when its first real script is implemented.

## Planned organization

```text
scripts/
├── core/          # Current-run orchestration and truly foundational local code
├── player/        # Player-specific behavior
├── enemies/       # Enemy-specific behavior
├── projectiles/   # Projectile behavior
├── components/    # Reusable behavior only after genuine reuse appears
├── systems/       # Scene-owned broader gameplay systems such as wave spawning
└── ui/            # HUD/menu presentation scripts
```

These are organizational destinations, not a requirement to create all folders immediately.

## Rules

- Use Godot 4.7 GDScript.
- Use static typing.
- Use `snake_case` filenames.
- Keep one clear responsibility per script.
- Attach behavior to the most appropriate specialized Godot node.
- Keep reusable scenes self-contained.
- Use direct typed calls for parent-to-child commands.
- Use signals for events reported outward.
- Avoid hard-coded NodePaths outside the script's own scene.
- Prefer `Resource` for reusable configuration data.
- Avoid global manager/Autoload patterns unless project-wide lifetime is actually required.
- Do not add generic helpers or abstraction layers before a concrete need exists.

Read before implementing gameplay:

- `../docs/godot_architecture.md`
- `../docs/node_selection_guide.md`
- `../instructions/godot_ai_instructions.md`

## First implementation target

When development continues, the first real gameplay script should be introduced with the player scene rather than creating placeholder code now.
