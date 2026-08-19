# Starfall Courier — Final Visual Production Inventory v0

This document is the implementation manifest for the final visual language defined by `visual_system_v0.md`.

It answers four questions for AI agents and developers:

1. Which visual families must exist in the final product?
2. Which production implementation owns each family?
3. Which variants/states must be represented?
4. Where is each family inspected in the development visual lab?

The visual lab is a review/test harness. Production visual code lives outside `dev/`.

---

## 1. Production implementation map

### Shared tokens and fonts

```text
res://scripts/visuals/starfall_visual_tokens.gd
res://scripts/visuals/starfall_font_registry.gd
res://scripts/visuals/starfall_ui_theme_factory.gd
```

Responsibilities:

- semantic colors,
- reference design size,
- sector accents,
- canonical text/icon font paths,
- procedural UI theme surfaces.

Canonical fonts:

```text
res://assets/fonts/text/oxanium/Oxanium[wght].ttf
res://assets/fonts/icons/material_symbols/MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf
```

The font registry does not hide absent files. The visual lab reports missing font binaries as an issue.

### Procedural backgrounds

```text
res://scripts/visuals/space_background_visual.gd
res://shaders/visual/space_background.gdshader
res://shaders/visual/sector_grade.gdshader
```

Required sector variants:

- Courier Corridor,
- Wreck Belt,
- Ion Reach,
- Solar Rift,
- Void Passage.

Background sub-elements:

- deep-space field,
- deterministic starfield,
- subtle nebula haze,
- distant planet/moon treatment,
- route/navigation lines,
- distant movement/speed dust,
- transition streak language.

Review page:

```text
res://dev/visual_lab/pages/backgrounds.tscn
```

### Player ship family

```text
res://scripts/visuals/ship_visual.gd
```

Ship silhouette slots:

- Courier,
- Interceptor,
- Phantom,
- Hauler,
- Vector,
- Eclipse,
- Pathfinder.

Required Courier state language:

- normal,
- shielded,
- Time Warp,
- Overcharged,
- impact flash,
- crashed/destruction,
- prestige/mastery.

Shared ship visual systems:

- white/light hull,
- purple structural frame,
- cyan reactor,
- procedural engine plume,
- ship-specific silhouette/signature,
- power-up/state overlays.

Future ship slots are visual prototypes only until their gameplay is explicitly requested.

Review page:

```text
res://dev/visual_lab/pages/ships.tscn
```

### Collectibles and persistent reward visuals

```text
res://scripts/visuals/game_object_visual.gd
```

Required:

- Star Core,
- Star Core geometry variants,
- Star Chip.

States/uses:

- normal collectible,
- high-value visual variation,
- event/contract emphasis language,
- pickup VFX handled by `effect_visual.gd`.

Review page:

```text
res://dev/visual_lab/pages/collectibles_powerups.tscn
```

### Power-ups

```text
res://scripts/visuals/game_object_visual.gd
res://scripts/visuals/effect_visual.gd
res://shaders/visual/neon_energy.gdshader
res://shaders/visual/time_warp.gdshader
```

Core power-ups:

- Shield — cyan protective ring language,
- Time Warp — purple/cyan temporal-ring language,
- Overcharge — magenta lightning/energy language.

Reserved future visual slots:

- Core Magnet,
- Stabilizer,
- Phase Shift,
- Emergency Jump.

Future slots are allowed in the visual inventory because this task explicitly requests the final visual catalogue; they must not be interpreted as implemented gameplay systems.

Review page:

```text
res://dev/visual_lab/pages/collectibles_powerups.tscn
```

### Hazard family

```text
res://scripts/visuals/game_object_visual.gd
```

Required hazards:

- Standard Asteroid — multiple silhouette variants,
- Heavy Asteroid — multiple silhouette variants,
- Fast Debris,
- Drifting Debris,
- Energy Mine — warning + active,
- Laser Gate — warning + active,
- Meteor Strike warning marker,
- Cargo Wreck,
- Gravity Anomaly.

Visual rules:

- hazards use darker bodies than the player,
- lethal energy uses magenta/red,
- warnings use orange/magenta before activation,
- warning and active states must be distinguishable without relying on text,
- glow is never part of collision geometry.

Review page:

```text
res://dev/visual_lab/pages/hazards_routes.tscn
```

### Route, extraction, and encounter visuals

```text
res://scripts/visuals/game_object_visual.gd
```

Route gate variants:

- Safe Route — success green/cyan,
- Core Field — gold,
- Danger Route — magenta,
- Contract Bonus — purple,
- Elite Route — magenta/purple.

Route states:

- approach,
- readable/active,
- selected,
- passed/fading,
- unavailable/disabled.

Current procedural prototype directly covers normal/selected visual language; production gameplay scenes may drive the other states using the same renderer.

Extraction:

- extraction incoming,
- available,
- selected/secured language,
- success green + cyan.

Future encounter visual slot:

- Courier Hunter silhouette and hostile telegraph language.

Review page:

```text
res://dev/visual_lab/pages/hazards_routes.tscn
```

### Animation and VFX family

```text
res://scripts/visuals/effect_visual.gd
```

Required effect inventory:

- spawn,
- despawn,
- crash/destruction,
- Star Core pickup,
- Shield impact,
- Near Miss,
- Danger Streak,
- engine trail,
- Time Warp,
- Overcharge,
- route selected,
- extraction,
- sector transition,
- Threat pulse,
- new record,
- achievement,
- mastery/reputation.

All effects are mathematical/time-driven. They must not depend on sprite-sheet frames.

Review page:

```text
res://dev/visual_lab/pages/effects.tscn
```

### Shader inventory

```text
res://shaders/visual/space_background.gdshader
res://shaders/visual/neon_energy.gdshader
res://shaders/visual/time_warp.gdshader
res://shaders/visual/sector_grade.gdshader
res://shaders/visual/ui_panel.gdshader
```

Current responsibilities:

- procedural background noise/star treatment,
- reusable neon-energy treatment,
- full-screen Time Warp distortion,
- sector color grading/vignette,
- subtle futuristic UI-panel treatment.

Do not create object-specific shader copies when a parameterized shared shader can express the effect cleanly.

### UI / typography / iconography

```text
res://scripts/visuals/starfall_font_registry.gd
res://scripts/visuals/starfall_ui_theme_factory.gd
```

Text family:

- Oxanium Variable only for standard game/UI typography unless the visual system is explicitly revised.

Icon family:

- Material Symbols Sharp Variable for normal icon/button/HUD glyphs.

Do not use:

- emoji as UI icons,
- random Unicode symbols,
- mixed icon libraries,
- PNG icon packs,
- arbitrary per-screen fonts.

Required UI families represented by the final visual system:

- splash/brand treatment,
- main menu,
- gameplay HUD,
- route choice,
- extraction decision,
- contracts,
- hangar,
- upgrades,
- missions,
- achievements,
- statistics,
- pause,
- run summary,
- settings,
- tutorial/onboarding,
- notifications/badges/progress states,
- primary, secondary, danger, and icon buttons.

The v0 lab focuses on the reusable visual language rather than implementing full navigation flows.

Review page:

```text
res://dev/visual_lab/pages/ui.tscn
```

---

## 2. Combined review scene

Run:

```text
res://dev/visual_lab/visual_lab.tscn
```

The combined scene exposes all six visual review families as tabs:

1. Backgrounds,
2. Ships,
3. Collectibles + Power-ups,
4. Hazards + Routes,
5. VFX,
6. UI.

Every page can also be run independently.

---

## 3. Required visual QA checks

Before a visual family is considered production-ready, inspect it for:

### Readability

- recognizable at 720 × 1280 reference proportions,
- readable at gameplay scale,
- player more visually important than background,
- lethal warning clearer than decorative effects.

### Color semantics

- purple = Starfall identity/selection,
- cyan = navigation/energy/shield,
- magenta/red = danger/high-intensity,
- gold = reward/value,
- green = success/extraction,
- orange = warning/solar impact,
- white = important readable structure/text.

### Motion

- lane-related motion should feel crisp rather than floaty,
- loops must not flash aggressively,
- warning timing must read before the active lethal state,
- VFX must not cover safe-route information,
- reduced-motion alternatives must remain possible.

### Scale and collision separation

- visual glow may exceed geometry,
- collision must never be derived from glow bounds,
- large hazards must still communicate lane occupancy clearly,
- decorative background geometry must never resemble a collision object.

### UI

- text hierarchy is clear,
- touch targets remain large enough,
- no generic mobile-app card overload,
- important values are brighter than labels,
- font/icon binaries are present before final UI approval.

---

## 4. Current known gaps that the visual lab should expose

The procedural implementation is a production visual baseline, not final art approval.

Known items requiring real-device/editor review:

1. Oxanium Variable font binary is not yet committed at the canonical path.
2. Material Symbols Sharp Variable font binary is not yet committed at the canonical path.
3. Compatibility-renderer appearance/performance of the shader set has not yet been profiled on target mobile hardware.
4. Actual Godot editor/headless parsing must be run in an environment with the Godot 4.7 executable.
5. Glow intensity, animation timing, and object scale need visual review in the lab before locking values.
6. Reduced-motion variants still need implementation when accessibility/settings work begins.
7. Full production UI screens should be composed only when their corresponding product feature is implemented; the visual lab currently validates the shared language.

These are explicit QA items, not reasons to replace the procedural visual direction.

---

## 5. AI implementation rule

For any future visual task:

1. Read `game_concept_v0.md`.
2. Read `visual_system_v0.md`.
3. Read this inventory manifest.
4. Reuse the production visual classes/shaders when possible.
5. Add the new variant/state to the relevant visual-lab page.
6. Run headless validation when Godot 4.7 is available.
7. Visually inspect the relevant dev scene.
8. Report any unresolved visual or runtime issue explicitly.

Do not create a separate hidden art system outside this inventory without updating the documentation and dev lab.
