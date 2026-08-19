# Starfall Courier — AI Agent Entry Point

This repository is the Godot 4.7 project for **Starfall Courier**.

The repository name `space-shooter` is legacy. Do not infer shooter mechanics from the repository name.

## Mandatory read order

Before a meaningful implementation task, read the sources relevant to the task in this order:

1. `docs/game_design/game_concept_v0.md` — what game is being built.
2. `docs/visual_design/visual_system_v0.md` — canonical visual semantics, palette, sizing, typography, iconography, and procedural direction.
3. `docs/visual_design/asset_drawing_system_v1.md` — senior production drawing language and polish rules.
4. `docs/visual_design/final_visual_inventory_v1.md` — canonical final visual inventory, variants, states, animation requirements, and QA coverage.
5. `docs/godot_architecture.md` — project architecture.
6. `docs/node_selection_guide.md` — Godot node selection.
7. `instructions/godot_ai_instructions.md` — general coding-agent rules.
8. `instructions/visual_ai_instructions.md` — required additionally for visual/UI/VFX/shader work.
9. Existing affected scenes/scripts and the relevant `dev/visual_lab/` page — established local implementation.

The user's current explicit task defines the implementation scope. Do not implement unrelated future gameplay simply because it appears in the design bible or visual inventory.

## Product invariant

Starfall Courier is a portrait three-lane courier survival game.

The player is a courier, not a soldier.

Do not add player shooting, guns, ammunition, aiming, weapon upgrades, generic shooter enemy waves, or free-flight controls unless the user explicitly changes the canonical game design.

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

### Visual quality rule

Do not improve a simple procedural asset by adding random glow, random lines, or particle noise.

Improve in this order:

1. silhouette,
2. structural planes,
3. material separation,
4. functional accents,
5. controlled energy/glow,
6. animation/state language,
7. micro-detail only when scale supports it.

`final_visual_inventory_v0.md` is historical. New visual work follows the v1 files.

## Validation

Godot validation is available through the repository GitHub Action and should remain green after meaningful Godot changes.

When Godot 4.7.1 is available locally, also run:

```bash
godot --headless --path . --editor --quit
```

Never claim validation succeeded unless the command or CI check actually ran successfully.