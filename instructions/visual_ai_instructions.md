# AI Instructions — Starfall Courier Visual Production

Use these instructions for any task that creates, changes, reviews, or debugs visual assets, UI styling, animation, VFX, shaders, typography, iconography, or visual test scenes.

## Read order

Before visual work, read:

1. `docs/game_design/game_concept_v0.md`
2. `docs/visual_design/visual_system_v0.md`
3. `docs/visual_design/final_visual_inventory_v0.md`
4. `docs/godot_architecture.md`
5. `docs/node_selection_guide.md`
6. `instructions/godot_ai_instructions.md`
7. the affected production visual code
8. the relevant `dev/visual_lab/` page

The current user request still controls implementation scope.

## Procedural-first rule

The default production visual pipeline is native Godot mathematical/vector/canvas rendering.

Prefer:

- `_draw()`,
- `Polygon2D`,
- `Line2D`,
- `Curve2D`,
- CanvasItem shaders,
- AnimationPlayer/Tween,
- particles when justified,
- reusable visual Resources/data.

Do not silently introduce PNG sprite sheets or PNG icon packs for visuals already represented by the procedural system.

## Production ownership

Reusable production visuals belong under:

```text
res://scripts/visuals/
res://shaders/visual/
```

The development lab belongs under:

```text
res://dev/visual_lab/
```

Never make production gameplay depend on `dev/`.

## Existing production visual classes

Reuse these before inventing parallel systems:

- `StarfallVisualTokens`
- `StarfallFontRegistry`
- `StarfallUIThemeFactory`
- `StarfallSpaceBackgroundVisual`
- `StarfallShipVisual`
- `StarfallGameObjectVisual`
- `StarfallEffectVisual`

If a new visual is a real new family, add it deliberately and update the inventory manifest.

## Color semantics

Preserve semantic meaning:

- purple = Starfall identity / selection,
- cyan = navigation / energy / Shield,
- magenta/red = danger / high intensity,
- gold = reward / value,
- green = success / extraction,
- orange = warning / solar impact,
- white = important readable structure/text.

Do not choose colors independently per asset when an existing semantic token applies.

## Typography and icons

Canonical text family:

```text
res://assets/fonts/text/oxanium/Oxanium[wght].ttf
```

Canonical icon family:

```text
res://assets/fonts/icons/material_symbols/MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf
```

Do not replace missing files with a different permanent font or icon family without explicit approval.

Fallback rendering may be used only so development scenes remain inspectable. The missing canonical font must still be reported as an issue.

Do not use emoji or arbitrary Unicode characters as production icons.

## Animation rules

Prefer parameter animation instead of frame animation.

Examples:

- pulse radius,
- line length,
- alpha,
- glow strength,
- rotation,
- geometry spread,
- shader parameters,
- particle emission.

Effects must preserve gameplay readability and must be compatible with future reduced-motion behavior.

## Visual lab requirement

Every meaningful new visual family, variant, or state must be added to the appropriate visual-lab page.

Use:

```text
res://dev/visual_lab/visual_lab.tscn
```

or the relevant isolated page.

Compare variants side-by-side whenever the difference is important to gameplay readability.

## Visual QA checklist

Check:

- gameplay-scale readability,
- silhouette distinction,
- warning vs active state distinction,
- semantic color correctness,
- glow containment,
- background competition,
- animation timing,
- clipping,
- route clarity,
- UI hierarchy,
- font/icon availability,
- mobile portrait spacing,
- reduced-motion feasibility.

## Validation

After meaningful code/scene changes, run when Godot 4.7 is available:

```bash
godot --headless --path . --editor --quit
```

Then run the affected visual-lab scene in the editor/device.

Never claim runtime/headless validation when the Godot executable was not actually run.
