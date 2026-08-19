# Development-only scenes

`dev/` contains Godot-visible scenes used to inspect, compare, and test production assets without coupling those tests to the real game flow.

Do not place production gameplay dependencies in this folder.

## Visual lab

Main combined scene:

```text
res://dev/visual_lab/visual_lab.tscn
```

Run this scene directly from the Godot editor to review the complete procedural visual inventory in portrait mode.

Independent pages can also be run directly:

```text
res://dev/visual_lab/pages/backgrounds.tscn
res://dev/visual_lab/pages/ships.tscn
res://dev/visual_lab/pages/collectibles_powerups.tscn
res://dev/visual_lab/pages/hazards_routes.tscn
res://dev/visual_lab/pages/effects.tscn
res://dev/visual_lab/pages/ui.tscn
```

## What the lab is for

Use it to detect:

- weak silhouette differences,
- unreadable hazards,
- warning vs active-state confusion,
- excessive glow,
- color-semantic drift,
- effects that obscure gameplay,
- animation timing that feels too slow/fast,
- sector backgrounds that compete with gameplay,
- inconsistent scale,
- route-gate ambiguity,
- missing typography/icon font assets,
- UI spacing and hierarchy problems.

## Production sources

The gallery does not own the art implementation. It instantiates production visual classes from:

```text
res://scripts/visuals/
```

and references production shader sources from:

```text
res://shaders/visual/
```

Changing a production visual should therefore update both the game and the lab preview.

## Font health check

The UI page checks these canonical files:

```text
res://assets/fonts/text/oxanium/Oxanium[wght].ttf
res://assets/fonts/icons/material_symbols/MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf
```

If either file is absent, the lab deliberately marks it as `MISSING` instead of hiding the issue behind a fallback font.

## Validation

After changing visual code, run:

```bash
godot --headless --path . --editor --quit
```

Then open the relevant visual-lab page and visually inspect animation, variants, clipping, contrast, and readability at the target portrait viewport.
