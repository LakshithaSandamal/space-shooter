# Starfall Courier — AI Agent Entry Point

This repository is the Godot 4.7 project for **Starfall Courier**.

The repository name `space-shooter` is legacy. Do not infer shooter mechanics from the repository name.

## Mandatory read order

Before a meaningful implementation task, read the sources relevant to the task in this order:

1. `docs/game_design/game_concept_v0.md` — what game is being built.
2. `docs/visual_design/visual_system_v0.md` — canonical visual language.
3. `docs/visual_design/final_visual_inventory_v0.md` — implemented final visual inventory and QA coverage.
4. `docs/godot_architecture.md` — project architecture.
5. `docs/node_selection_guide.md` — Godot node selection.
6. `instructions/godot_ai_instructions.md` — general coding-agent rules.
7. `instructions/visual_ai_instructions.md` — required additionally for visual/UI/VFX/shader work.
8. Existing affected scenes/scripts — established local implementation.

The user's current explicit task defines the implementation scope. Do not implement unrelated future gameplay simply because it appears in the design bible.

## Product invariant

Starfall Courier is a portrait three-lane courier survival game.

The player is a courier, not a soldier.

Do not add player shooting, guns, ammunition, aiming, or free-flight controls unless the user explicitly changes the design.

## Visual invariant

The visual pipeline is procedural/vector/canvas first.

Production visual code:

```text
res://scripts/visuals/
res://shaders/visual/
```

Visual QA scene:

```text
res://dev/visual_lab/visual_lab.tscn
```

Production code must never depend on `dev/`.

## Validation

After meaningful Godot changes, run when Godot 4.7 is available:

```bash
godot --headless --path . --editor --quit
```

Never claim validation succeeded unless the command actually ran successfully.
