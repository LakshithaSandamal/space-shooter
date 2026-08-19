# AI Instructions — Starfall Courier Visual Production

Use these instructions for any task that creates, changes, reviews, or debugs visual assets, UI styling, animation, VFX, shaders, typography, iconography, or visual test scenes.

## Read order

Before visual work, read:

1. `docs/game_design/game_concept_v0.md`
2. `docs/visual_design/visual_system_v0.md`
3. `docs/visual_design/asset_drawing_system_v1.md`
4. `docs/visual_design/final_visual_inventory_v1.md`
5. `docs/godot_architecture.md`
6. `docs/node_selection_guide.md`
7. `instructions/godot_ai_instructions.md`
8. the affected production visual code
9. the relevant `dev/visual_lab/` page

The current user request still controls implementation scope.

`final_visual_inventory_v0.md` is historical. Do not use it as the production quality target when v1 applies.

## Product-scope guardrail

Starfall Courier is a portrait three-lane courier survival game.

Do not introduce these merely because the repository name contains `space-shooter` or because they are common sci-fi-game assets:

- player guns,
- player bullets,
- ammunition,
- aiming reticles,
- weapon upgrade UI,
- generic enemy-wave shooter systems,
- free-flight joystick controls.

Future-design visual slots such as reserved power-ups, ship silhouettes, or Courier Hunter may be represented in the visual catalogue, but they are not permission to implement their gameplay systems.

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

## Senior drawing rule

When a visual looks too simple, do not solve it with random glow, more particles, or decorative line noise.

Refine in this order:

1. **Primary silhouette** — recognizable without glow.
2. **Structural planes** — layered geometry, frame, panels, cutouts, negative space.
3. **Material separation** — light hull, dark body, structural alloy, energy regions.
4. **Functional accents** — reactor lines, warning emitters, route marks, state indicators.
5. **Controlled energy/glow** — crisp core + restrained outer falloff.
6. **State/motion language** — warning, selected, impact, pickup, success, destruction.
7. **Micro-detail** — only where gameplay scale can support it.

Use `asset_drawing_system_v1.md` as the detailed standard.

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

If a new visual is a real new family, add it deliberately and update `final_visual_inventory_v1.md`.

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

Critical gameplay states should not rely on color alone; vary geometry, rhythm, or state overlays as well.

## Geometry and material hierarchy

Major gameplay visuals should usually contain multiple meaningful layers rather than one polygon plus outline.

For medium/hero objects, consider:

- primary body,
- secondary structure/frame,
- inset/depth plane,
- focal core/emitter,
- panel/technical details,
- selective luminous accents,
- state overlay.

Use negative space intentionally. Do not fill every empty region with decoration.

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

Game-specific route/Star Core glyphs may use custom procedural geometry when a generic Material Symbol would weaken identity.

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
- particle emission,
- trail length,
- phase offset.

Effects must preserve gameplay readability and must be compatible with future reduced-motion behavior.

Avoid constant motion on every element. Motion rhythm should communicate state and priority.

## Background rules

Backgrounds require designed depth layers, not only a gradient and random stars.

Use the sector packages in `asset_drawing_system_v1.md` and preserve this priority:

```text
player / route decision / lethal hazard
    > collectible / power-up
    > near-field atmosphere
    > navigation guides
    > background decoration
```

Decorative celestial bodies or wreck silhouettes must not resemble collidable gameplay objects.

## Visual lab requirement

Every meaningful new visual family, variant, or state must be added to the appropriate visual-lab page.

Use:

```text
res://dev/visual_lab/visual_lab.tscn
```

or the relevant isolated page.

Compare variants side-by-side whenever the difference is important to gameplay readability.

For v1 refinement work, the visual lab should increasingly include:

- normal gameplay-scale previews,
- enlarged inspection previews,
- state comparisons,
- monochrome silhouette comparisons for ships/hazards where useful,
- sample sector-background contrast tests.

## Visual QA checklist

Check:

- gameplay-scale readability,
- silhouette distinction,
- structural/material layering,
- meaningful negative space,
- focal-point clarity,
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
- reduced-motion feasibility,
- compatibility with the current renderer strategy.

## Validation

After meaningful code/scene changes:

1. ensure the repository Godot GitHub Action is green,
2. when Godot 4.7.1 is available locally, run:

```bash
godot --headless --path . --editor --quit
```

3. run the affected visual-lab scene in the editor/device,
4. visually inspect at gameplay size, not only enlarged preview size.

Never claim runtime/headless validation when the command or CI check did not actually run.