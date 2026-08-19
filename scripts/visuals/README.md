# Production visual code

This folder owns reusable procedural/vector visual implementation for Starfall Courier.

It is production code, not a demo folder.

## Classes

- `starfall_visual_tokens.gd` — semantic colors, design size, sector accents.
- `starfall_font_registry.gd` — canonical Oxanium and Material Symbols font paths/availability.
- `starfall_ui_theme_factory.gd` — procedural Godot `Theme` baseline.
- `space_background_visual.gd` — five procedural sector backgrounds.
- `ship_visual.gd` — all ship silhouette slots and ship visual states.
- `game_object_visual.gd` — collectibles, power-ups, hazards, route/extraction gates, Hunter visual slot.
- `effect_visual.gd` — spawn/despawn, destruction, pickup, Near Miss, power-up, route, extraction, transition, Threat and progression VFX.

## Rules

- Keep visual geometry separate from collision geometry.
- Reuse semantic colors from `StarfallVisualTokens`.
- Do not hard-code a parallel palette per visual.
- Keep visual code independent from gameplay state ownership; gameplay scenes set visual properties/states.
- Do not make production visuals depend on `res://dev/`.
- Prefer parameterized variants over copied scripts.
- Prefer mathematical animation over frame-sheet animation.
- Add every meaningful new state/variant to the visual lab.

## Review

Run:

```text
res://dev/visual_lab/visual_lab.tscn
```

Read:

```text
res://docs/visual_design/visual_system_v0.md
res://docs/visual_design/final_visual_inventory_v0.md
res://instructions/visual_ai_instructions.md
```
