# Starfall Courier — Visual System & Asset Catalog v0

This document is the canonical visual-design source for **Starfall Courier**.

It defines the final-product visual language, procedural/vector asset catalog, color system, typography, icon-font usage, approximate gameplay sizes, visual variants, animation states, shaders, VFX, UI components, and future file organization.

Use this document together with:

- `../game_design/game_concept_v0.md` — what the game is.
- `../godot_architecture.md` — how the Godot project is structured.
- `../node_selection_guide.md` — which Godot nodes to use.
- `../../instructions/godot_ai_instructions.md` — how an AI agent must work.

The current user task always defines what to implement now. This document describes the final visual target; it is **not permission to implement every visual system at once**.

---

# 1. Visual Direction

## Identity

**Premium Neon Deep-Space Courier**

The game should look like a high-end futuristic courier/navigation interface operating in dangerous deep space.

The visual tone is:

- sleek,
- precise,
- geometric,
- premium,
- futuristic,
- dark,
- readable,
- calm between danger,
- energetic during risk,
- technological rather than military,
- sophisticated rather than cartoonish.

The game is **not** military sci-fi, horror, pixel art, retro 8-bit art, a generic Material-style app, or a colorful cartoon space shooter.

## Core visual relationship

```text
near-black navy space
+
white/light ship structure
+
purple Starfall identity
+
cyan navigation/energy
+
gold value/reward
+
magenta danger/high intensity
```

## Visual hierarchy rule

The brightest visual on screen must correspond to the most important gameplay information.

Priority should usually be:

1. lethal immediate hazard / warning,
2. player ship,
3. route decision or active objective,
4. collectible / power-up,
5. HUD critical value,
6. decorative background.

Background elements must never visually compete with gameplay objects.

---

# 2. Rendering Philosophy

## Procedural/vector first

The primary art pipeline is **native Godot mathematical/vector/canvas rendering**, not sprite-sheet animation.

Preferred tools:

- custom `Node2D._draw()`,
- `Polygon2D`,
- `Line2D`,
- `Curve2D`,
- `Path2D`,
- `Gradient`,
- `CanvasItem` shaders,
- `AnimationPlayer`,
- Tweens,
- `GPUParticles2D` / `CPUParticles2D` when appropriate,
- reusable `Resource` data for visual parameters.

## Do not default to raster assets

Do not add PNG sprite sheets for:

- player ships,
- asteroids,
- Star Cores,
- power-ups,
- route gates,
- warning graphics,
- spawn/destruction frames,
- engine trails,
- common VFX,
- UI icons.

A raster asset is allowed only when the requested result genuinely benefits from raster imagery and the user explicitly accepts it.

## Text and icons are font assets

Two font families are allowed as first-class visual assets:

1. **Oxanium Variable** — all normal game/UI text.
2. **Material Symbols Sharp Variable** — UI/button/HUD icons.

Do not use emoji, random Unicode symbols, PNG icon packs, or mixed icon libraries in normal UI.

---

# 3. Reference Resolution and Sizing

All sizes in this document are **logical design pixels** based on a portrait reference viewport of:

```text
720 × 1280
```

The project may later use a different internal rendering resolution, but visual proportions should remain equivalent.

## Safe sizing rules

- Gameplay ship readable width: roughly `64–86 px`.
- Standard touch target: minimum `52 × 52 px`; preferred `56–64 px`.
- Primary action button height: `64–72 px`.
- Secondary button height: `52–60 px`.
- HUD icon size: `20–28 px`.
- Main menu icon size: `24–32 px`.
- Decorative glow may exceed geometry bounds but must not affect gameplay collision.

Never derive collision shapes from glow size.

---

# 4. Canonical Color System

These are v0 visual tokens. Minor tuning is allowed during implementation, but semantic meaning must remain stable.

## Space / surfaces

| Token | Hex | Purpose |
|---|---:|---|
| `space_black` | `#050711` | deepest background |
| `space_navy` | `#080D1D` | primary space background |
| `space_navy_2` | `#0D1428` | raised background/panel base |
| `surface_dark` | `#111A31` | cards/panels |
| `surface_hover` | `#17213C` | hover/selected dark surface |
| `line_dark` | `#26324F` | subtle dividers/borders |
| `line_muted` | `#394462` | secondary outlines |

## Identity / energy

| Token | Hex | Purpose |
|---|---:|---|
| `purple_primary` | `#8B5CFF` | Starfall identity, selected states |
| `purple_bright` | `#A784FF` | active/highlight purple |
| `purple_deep` | `#5C3FC8` | structure/shadow purple |
| `cyan_primary` | `#27E7FF` | navigation, energy, shield |
| `cyan_soft` | `#83F4FF` | bright cyan highlights |
| `cyan_deep` | `#1593B3` | cyan shadow/low intensity |

## Danger / intensity

| Token | Hex | Purpose |
|---|---:|---|
| `magenta_primary` | `#FF3EA5` | danger route, Overcharge, hostile energy |
| `magenta_bright` | `#FF79C6` | warning highlight |
| `danger_red` | `#FF5364` | critical failure / imminent collision |
| `warning_orange` | `#FF9D45` | warning / Solar Rift / meteor telegraph |

## Reward / success

| Token | Hex | Purpose |
|---|---:|---|
| `gold_primary` | `#FFC857` | Star Cores, reward/value |
| `gold_bright` | `#FFE08A` | reward highlight |
| `gold_deep` | `#C98A2D` | reward shadow |
| `success_green` | `#4EE6A8` | completion/extraction/success |
| `success_bright` | `#8AF5C7` | success emphasis |

## Text

| Token | Hex | Purpose |
|---|---:|---|
| `text_primary` | `#F5F7FF` | headings/major values |
| `text_secondary` | `#B9C1D9` | normal labels/body |
| `text_muted` | `#7F89A6` | metadata/inactive labels |
| `text_disabled` | `#566078` | disabled content |

## Color discipline

- Purple = identity/selection.
- Cyan = navigation, energy, shield, active movement.
- Magenta = danger, high-risk, Overcharge.
- Gold = reward/value.
- Green = completed/safe success.
- Orange = temporary warning/solar/impact alert.
- White = high-priority information and ship body.

Do not recolor semantic systems casually.

---

# 5. Line, Shape and Glow Language

## Geometry

Use:

- sharp aerodynamic wedges,
- beveled/angled corners,
- clean arcs,
- narrow chamfers,
- compact hexagonal/diamond motifs,
- concentric rings for energy,
- thin route/navigation lines.

Avoid:

- bubbly/cartoon curves,
- ornate fantasy silhouettes,
- excessive mechanical detail,
- noisy greebles at gameplay scale.

## Stroke widths at 720 × 1280

- micro technical line: `1 px`.
- normal UI/vector line: `2 px`.
- active route/energy line: `3 px`.
- strong warning outline: `4 px` maximum.

## Corner radii

UI corner radii:

- compact chips/pills: `10–14 px`.
- standard buttons/cards: `14–18 px`.
- large menu panels: `18–24 px`.

Do not create excessively round mobile-app cards.

## Glow

Glow is controlled, layered emphasis—not a default effect on everything.

Typical glow radius:

- small object: `4–10 px`,
- collectible/power-up: `8–16 px`,
- major active gate: `12–26 px`,
- full-screen event: shader-driven rather than giant blur sprites.

---

# 6. Background Visual Assets

The background is a layered procedural system rather than one large image.

## 6.1 Base deep-space field

**Type:** shader / custom draw

**Visual:** almost-black navy with subtle radial/vertical atmospheric variation.

**Size:** full viewport.

**Variants:**

- Courier Corridor,
- Wreck Belt,
- Ion Reach,
- Solar Rift,
- Void Passage.

Each sector changes atmospheric emphasis without changing the game's identity.

## 6.2 Starfield

**Type:** procedural points / MultiMesh / shader

**Star size variants:**

- micro: `0.8–1.2 px`,
- small: `1.5–2 px`,
- bright: `2–3.5 px` plus subtle glow.

**Variants:**

- dim white-blue,
- cyan-tinted,
- purple-tinted,
- rare gold distant star.

Animation: subtle twinkle only. Never heavy flashing.

## 6.3 Space dust

**Type:** particles/procedural specks

**Size:** `1–3 px` particles.

**Variants:** low/medium/high speed density.

Used to communicate forward speed.

## 6.4 Nebula haze

**Type:** procedural noise shader

**Size:** full/partial viewport.

**Variants:**

- navy-purple,
- cyan-ion,
- gold-solar,
- violet-void.

Opacity should normally remain low (`~5–18%` visual contribution).

## 6.5 Distant planets/moons

**Type:** procedural circles/SDF shader

**Gameplay size:** apparent diameter `80–280 px`, typically partially off-screen or very distant.

**Variants:**

- dark moon,
- ringed silhouette,
- cyan rim-lit planet,
- violet gas body,
- warm Solar Rift body.

Decorative only; never resemble gameplay obstacles.

## 6.6 Shipping route lines

**Type:** `Line2D` / shader

**Width:** `1–2 px`.

**Variants:**

- normal cyan/purple,
- distant muted,
- sector entry,
- route-choice emphasis.

## 6.7 Distant shipping lights

**Type:** tiny points/lines

**Size:** `1–4 px`.

Variants: stationary, drifting, paired convoy lights.

## 6.8 Speed streak field

**Type:** shader/Line2D particles

**Length:** `8–40 px` depending speed.

Variants:

- normal travel,
- high threat,
- sector transition,
- Time Warp altered streaks.

## 6.9 Sector transition backdrop

**Type:** full-screen shader + streaks

Duration: `0.6–1.2 s` without removing control unless game design explicitly pauses.

Variants per sector palette.

---

# 7. Lane and Navigation Visuals

## 7.1 Lane anchors

Lane positions are gameplay logic, not always visible graphics.

Optional subtle indicator:

- bottom lane dots/chevrons,
- `8–14 px` each,
- inactive `text_muted`, selected `cyan_primary`.

## 7.2 Navigation lane guide

Optional temporary tutorial/route indicator.

Line width: `1–2 px`.

Do not permanently draw bright lane separators across gameplay.

## 7.3 Route-choice gates

**Visual height:** `120–190 px` on playfield.

**Per-lane width:** lane width minus `12–20 px` margin.

Variants:

- Safe Route — cyan/green,
- Core Field — gold,
- Danger Route — magenta,
- Contract Bonus — purple/gold,
- Elite Route — magenta/purple.

States:

- approach,
- readable/active,
- selected,
- passed,
- disabled/unavailable.

Animation:

- low pulse while readable,
- quick `0.12–0.20 s` selection confirmation,
- fade/stream backward after pass.

## 7.4 Extraction gate

**Size:** `220–320 px` wide apparent gate, height `100–170 px`.

Colors: success green + cyan + white.

States:

- incoming,
- extraction available,
- extract selected,
- continue selected,
- secured.

---

# 8. Player Ship Visual Assets

Player collision and visual geometry are separate.

## Common gameplay size

Target visible bounds:

```text
64–86 px wide
76–104 px high
```

The ship should remain recognizable at `~70 px` width.

Hangar/menu rendering may reuse the same vector definition at `220–360 px` height.

## Shared construction language

- white/light metallic central hull,
- purple frame/wings,
- cyan reactor/engine,
- compact aerodynamic silhouette,
- strong central nose,
- symmetrical base construction,
- minimal readable internal detail.

## 8.1 Courier

Role: balanced default ship.

Silhouette: medium-width arrowhead, stable central body.

Variants/states:

- normal,
- selected/hangar,
- shielded,
- Time Warp affected,
- Overcharged,
- impact flash,
- crash/destruction,
- mastery/prestige highlight.

## 8.2 Interceptor

Role: high mobility.

Silhouette: narrower nose, wider swept wings, visibly fast.

Gameplay size: `62–82 × 78–102 px`.

Same state variants as Courier.

## 8.3 Phantom

Role: defensive specialist.

Silhouette: compact protected core, heavier enclosing frame.

Gameplay size: `70–88 × 76–98 px`.

Same state variants as Courier.

## Future ship visual slots

Reserve visual language, but do not implement until requested:

- Hauler — broader/heavier cargo body,
- Vector — razor-thin near-miss silhouette,
- Eclipse — energy-focused dark frame,
- Pathfinder — navigation/sensor-oriented geometry.

## 8.4 Engine core

Core size: `8–14 px`.

Color: cyan white-hot center with cyan glow.

States:

- idle/normal travel,
- lane change surge,
- high speed,
- Time Warp,
- Overcharge,
- shutdown/crash.

## 8.5 Engine trail

Normal length: `20–42 px`.

High-speed length: `40–70 px`.

Width: `4–12 px` total plume.

Color: cyan core + purple fringe.

Animation: continuous procedural noise/pulse, not frames.

## 8.6 Lane-change bank effect

Duration: `0.12–0.22 s`.

Visual:

- small lateral tilt/geometry skew,
- brief engine flare,
- tiny trailing energy line.

Never make the ship movement feel floaty.

---

# 9. Collectibles and Currency Visuals

## 9.1 Star Core

**Gameplay size:** `22–30 px` geometry, glow may reach `36–44 px`.

Visual:

- gold/yellow energy core,
- bright white-gold center,
- crystal/ring/compact star geometry,
- controlled pulse.

Variants:

- normal,
- high-value/route bonus,
- contract-target highlighted,
- Core Surge event,
- collecting/magnetized future state.

Animations:

- idle pulse `0.8–1.4 s`,
- small rotation/drift,
- pickup burst `0.12–0.24 s`.

## 9.2 Star Chip

Persistent currency is mainly UI/meta-progression.

Icon size:

- HUD/meta compact: `18–24 px`,
- reward screen: `32–48 px`,
- large reward burst: `56–72 px`.

Visual: gold token/chip geometry with small purple Starfall mark.

Variants:

- normal,
- reward burst,
- rare/large payout.

---

# 10. Power-Up Visual Assets

Common pickup geometry size: `28–38 px`; glow envelope `44–60 px`.

All power-ups must be identifiable by silhouette + color before text.

## 10.1 Shield

Color: cyan.

Geometry: circular/ring protection motif.

Pickup states:

- idle,
- targeted/approach,
- collected.

Active player states:

- full shield bubble,
- impact deformation,
- shield consumed.

Bubble radius around ship: `48–60 px`.

## 10.2 Time Warp

Color: purple-blue/cyan.

Geometry: clock/ring/temporal split motif.

Active states:

- activation ring,
- sustained time distortion,
- expiration pulse.

## 10.3 Overcharge

Color: magenta + white.

Geometry: lightning/energy burst motif.

Active states:

- activation flash,
- sustained ship edge streaks,
- expiration.

## Future power-up slots

Do not implement until requested:

- Core Magnet — cyan/gold attraction rings,
- Stabilizer — purple locked-ring motif,
- Phase Shift — cyan-violet phased outline,
- Emergency Jump — white/cyan jump gate motif.

---

# 11. Hazard Visual Assets

Hazards must be darker than the player and immediately readable.

## 11.1 Standard Asteroid

Size: `52–76 px`.

Visual:

- irregular polygon,
- charcoal/dark violet body,
- subtle magenta edge/cracks,
- restrained highlight.

Shape variants: minimum `5–8` seeded silhouettes.

States:

- normal,
- near-miss highlight response,
- impact/crash interaction,
- sector-tinted variants.

## 11.2 Heavy Asteroid

Size: `96–148 px`.

Variants: minimum `4–6` silhouettes.

Visual: larger blocky structure, deeper shadow, sparse glowing cracks.

## 11.3 Fast Debris

Size: `18–34 px`.

Variants:

- metal shard,
- panel fragment,
- strut,
- capsule fragment,
- small rock.

Use motion streak to communicate speed.

## 11.4 Drifting Debris

Size: `30–58 px`.

Variants: minimum `5`.

Animation: slow rotation + readable horizontal lane drift.

## 11.5 Energy Mine

Body size: `40–58 px`.

Warning envelope: `70–100 px`.

States:

- dormant,
- arming,
- warning,
- active,
- deactivating/despawn.

Color: magenta/red with white hot center when active.

## 11.6 Laser Gate

Beam thickness: core `3–6 px`, glow `12–24 px`.

Gate geometry occupies one or more lane widths.

States:

- telegraph line,
- charging,
- active beam,
- cooldown/fade.

Telegraph must be visible before lethal state.

## 11.7 Meteor Strike

Meteor visible size: `48–82 px`.

Warning marker: `52–90 px` ring/target area.

States:

- warning marker,
- incoming streak,
- impact burst,
- debris fade.

Color: warning orange + magenta danger accents.

## 11.8 Cargo Wreck

Apparent size: `150–280 px` depending pattern.

Variants:

- transport nose,
- broken cargo frame,
- engine module,
- split hull,
- station fragment.

Dark purple/charcoal with faint dead cyan/orange lights.

## 11.9 Gravity Anomaly

Core radius: `36–60 px`.

Visible field radius: `100–190 px`.

Visual:

- dark center,
- violet/cyan warped rings,
- subtle distortion,
- moving contour lines.

States:

- forming,
- active,
- peak,
- collapsing.

---

# 12. Elite Event Visuals

## Debris Storm

- increased streak density,
- debris warning edge cues,
- short sector-tinted storm overlay.

## Hunter Sweep

The Hunter is a future non-player combat pressure system; the courier does not shoot it.

Hunter visual target when implemented:

- apparent ship width `160–260 px`, often at top/far plane,
- dark structure,
- magenta attack systems,
- white/purple silhouette accents.

Attack visuals:

- lane telegraph,
- sweep beam/strike,
- reposition streak.

## Collapse Corridor

- rapid route-safe-lane highlight changes,
- strong but readable cyan/magenta lane telegraphs.

## Core Surge

- increased gold glow density,
- reward pulse at event start,
- gold trail accents without obscuring hazards.

---

# 13. Spawn, Despawn and Destruction Animation Assets

No sprite frames. Build these from parameter animation, geometry, particles and shaders.

## 13.1 Generic spawn

Duration: `0.18–0.40 s`.

Sequence:

1. faint point/ring,
2. vertical/forward energy streak,
3. geometry resolves from `70–85%` scale,
4. opacity reaches full,
5. glow settles.

Variants:

- player start,
- collectible,
- power-up,
- hazard/energy hazard,
- route gate.

## 13.2 Generic safe despawn

Duration: `0.15–0.30 s`.

Sequence: backward streak + alpha fade + mild scale reduction.

Use for objects leaving the playable route, not for collisions.

## 13.3 Player crash/destruction

Total duration: `0.45–0.90 s` before run-summary transition.

Sequence:

1. impact white/magenta flash `40–80 ms`,
2. ship geometry separates into `5–10` procedural fragments,
3. cyan engine extinguishes,
4. purple/white fragments rotate outward,
5. short sparks/energy ring,
6. fragments fade,
7. controlled screen shake/vignette.

No gore, fireball military explosion, or large orange Hollywood blast.

## 13.4 Shield-save impact

Duration: `0.20–0.35 s`.

- shield compresses toward impact side,
- bright cyan ring,
- small white flash,
- shield breaks/dissolves if consumed,
- short invulnerability shimmer.

## 13.5 Energy-hazard collapse

Duration: `0.15–0.35 s`.

- ring contraction,
- center flash,
- line fragments,
- fade.

---

# 14. Core Gameplay VFX Catalog

## Engine trail

Continuous. Cyan + purple.

## Lane-change streak

`0.12–0.22 s`.

## Star Core pickup burst

`0.12–0.24 s`; gold radial shard/ring.

## Combo increment

HUD micro-pulse `0.08–0.16 s`; stronger on milestone multipliers.

## Combo milestone

`0.25–0.45 s`; controlled gold/purple emphasis.

## Combo decay warning

Subtle gold-to-muted pulse, not danger red.

## Near Miss

`0.12–0.25 s`:

- directional cyan/white edge streak,
- tiny freeze/emphasis optional only if it does not harm responsiveness,
- HUD text flash.

Streak variants:

- normal Near Miss,
- Close Call,
- Danger Streak,
- Edge Run.

## Shield activation

`0.18–0.30 s`; cyan ring expands to ship bubble.

## Shield impact

See destruction section.

## Time Warp activation

`0.25–0.50 s`:

- purple/cyan radial distortion,
- stretched background streaks,
- small edge chromatic shift if readable.

## Time Warp sustain

Low-intensity full-screen shader; never blur gameplay beyond recognition.

## Time Warp ending

`0.20–0.35 s`; distortion contracts.

## Overcharge activation

`0.18–0.32 s`; magenta-white flash and energy outline.

## Overcharge sustain

Magenta edge trails + stronger reward effects.

## Route selection

`0.12–0.22 s`; selected gate brightens and sends a line toward the player lane.

## Contract completed

`0.35–0.65 s`; green/purple compact HUD confirmation.

## Successful extraction

`0.5–1.0 s`; green/cyan gate resolve and forward streak.

## Sector transition

`0.6–1.2 s`; sector palette blend + speed streaks.

## Threat increase

`0.20–0.40 s`; compact magenta pulse in HUD, no large modal.

## New record

`0.4–0.8 s`; gold + white controlled burst.

## Achievement unlocked

`0.5–0.9 s`; purple/gold toast.

## Reputation/mastery level-up

`0.6–1.1 s`; expanding purple-cyan rings + number transition.

---

# 15. Shader Catalog

Create shaders only when the corresponding feature is implemented.

Recommended future paths are documented later.

## 15.1 `space_background`

Purpose:

- base navy gradient,
- subtle noise,
- sector palette interpolation.

## 15.2 `star_twinkle`

Purpose: low-cost brightness variation for starfield.

## 15.3 `nebula_haze`

Purpose: layered low-contrast procedural nebula.

## 15.4 `neon_glow`

Purpose: reusable controlled edge/emissive-like 2D glow for vector visuals.

Avoid applying to every object.

## 15.5 `energy_core`

Purpose: radial core, ring, pulse and hot center for Star Cores/energy nodes.

## 15.6 `shield_field`

Purpose: cyan transparent field, rim, impact deformation/flash.

## 15.7 `time_warp`

Purpose: full-screen or scoped UV distortion + streak alteration.

## 15.8 `overcharge`

Purpose: magenta energy edge/pulse overlay.

## 15.9 `danger_telegraph`

Purpose: warning pulse/scan for mines, lasers, meteor targets.

## 15.10 `route_gate`

Purpose: gate fill/edge animation and semantic color transitions.

## 15.11 `anomaly_distortion`

Purpose: local gravity-anomaly warp/rings.

## 15.12 `sector_grade`

Purpose: subtle global palette bias per sector.

## 15.13 `impact_flash`

Purpose: short object-level white/color flash after shield/hazard impact.

## 15.14 `hologram_ui`

Purpose: use sparingly in hangar/ship preview; subtle scanline/fade only.

## 15.15 `ui_panel`

Purpose: optional subtle panel gradient/noise; must not create heavy glassmorphism.

---

# 16. Sector Visual Packages

All sectors share the same base geometry/style.

## Courier Corridor

Primary atmosphere: navy + cyan + purple.

Background density: low-medium.

Hazard readability: cleanest.

## Wreck Belt

Primary atmosphere: deep purple + charcoal + muted damaged gold/orange.

Decorative objects:

- distant wreck fragments,
- broken route lights,
- sparse dead cargo structures.

## Ion Reach

Primary atmosphere: blue/cyan electrical energy.

Visual effects:

- thin electrical arcs,
- pulse lines,
- ion haze.

## Solar Rift

Primary atmosphere: gold/orange energy + magenta danger.

Visual effects:

- warm distant glow,
- solar streaks,
- meteor warning emphasis.

## Void Passage

Primary atmosphere: almost-black + violet + cyan anomaly energy.

Visual effects:

- minimal stars,
- deeper negative space,
- stronger anomaly rings,
- rare sharp lights.

---

# 17. Typography System

## Text family

**Canonical family:** `Oxanium`

Preferred source asset when added:

```text
res://assets/fonts/text/oxanium/Oxanium[wght].ttf
```

Use the variable font if practical so one font file can produce the required weight hierarchy.

Do not silently substitute another futuristic font.

## Weight roles

- `300` Light — secondary metadata only.
- `400` Regular — body/supporting text.
- `500` Medium — labels/buttons.
- `600` SemiBold — HUD values/section headings.
- `700` Bold — major headings.
- `800` ExtraBold — title/record/major numeric emphasis.

## Type scale at 720 × 1280

| Role | Size | Weight | Notes |
|---|---:|---:|---|
| Game logo `STARFALL` | `50–64` | `800` | uppercase, tight composition |
| Game logo `COURIER` | `26–34` | `600–700` | tracking +4–8% |
| Hero numeric/record | `40–52` | `700–800` | distance, final score |
| Screen title | `30–36` | `700` | uppercase |
| Section title | `22–26` | `600–700` | uppercase/short |
| Large HUD value | `22–28` | `600–700` | distance/combo |
| Button label | `18–22` | `600–700` | uppercase for primary actions |
| Body | `16–18` | `400–500` | readable mobile text |
| Small HUD label | `13–15` | `500–600` | uppercase optional |
| Metadata | `11–13` | `400–500` | avoid smaller than 11 |
| Tiny technical label | `10–11` | `500` | rare only |

## Typography rules

- Use uppercase for headings, short labels and primary actions.
- Do not uppercase long body text.
- Numbers should usually be brighter than their label.
- Use increased tracking on small uppercase labels.
- Avoid extremely thin weights over moving gameplay.
- Avoid text glow except major logo/event emphasis.
- Keep text white/cyan/gold semantic; do not rainbow-code labels.

---

# 18. Icon Font System

## Icon family

**Canonical family:** `Material Symbols Sharp`

Preferred source asset when added:

```text
res://assets/fonts/icons/material_symbols/MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf
```

If the exact distributed filename differs, keep the folder and semantic family stable.

Use the **Sharp** family only unless the visual system is intentionally revised.

## Why Sharp

- geometric,
- angular,
- compact,
- readable at mobile sizes,
- consistent with Starfall's cockpit/terminal visual language.

## Standard icon sizes

- micro/status: `16–18 px`,
- HUD: `20–24 px`,
- standard button: `24 px`,
- navigation/menu: `24–28 px`,
- large action: `28–32 px`,
- empty-state/decorative icon: `40–56 px` maximum.

## Variable icon styles

Create reusable Godot `FontVariation` resources when implemented:

- `icon_outline` — fill `0`, weight roughly `400–500`.
- `icon_selected` — fill `1`, weight roughly `500–600`.
- `icon_inverse` — tuned for bright-on-dark contrast.

Use optical size appropriate to the rendered icon size.

## Semantic icon map

Use these concepts consistently; exact Material Symbol glyph name can be confirmed during implementation.

| UI concept | Preferred symbol concept |
|---|---|
| Play | play arrow |
| Pause | pause |
| Resume | play arrow |
| Close | close |
| Back | arrow back / chevron left |
| Forward | chevron right |
| Contracts | assignment / task |
| Hangar / Ships | rocket / spaceship-like available symbol |
| Upgrades | upgrade / trending up |
| Missions | flag / target |
| Stats | monitoring / bar chart |
| Achievements | trophy / workspace premium |
| Reputation | military-tech-like rank symbol only if non-military reading; otherwise stars/award |
| Settings | settings |
| Sound | volume up |
| Music | music note |
| Haptics | vibration |
| Shield | shield |
| Time Warp | schedule / hourglass / timer |
| Overcharge | bolt |
| Star Core | star / brightness motif if needed in UI |
| Star Chips | token / paid / hex token motif |
| Distance | route / navigation |
| Combo | multiplier is primarily text; bolt/star optional |
| Near Miss | swipe/edge/flash concept |
| Warning | warning |
| Locked | lock |
| Unlocked | lock open |
| Extract | exit / arrow forward |
| Continue | fast forward / arrow forward |
| Route | alt route |
| Safe | verified / check circle |
| Reward | star / redeem |
| Danger | warning |
| New record | trophy |
| Info | info |
| Help/tutorial | help |

Do not use different icons for the same action on different screens.

---

# 19. UI Surface and Component Catalog

All UI should use Godot `Control` nodes and a shared `Theme` when implementation reaches UI work.

## 19.1 Main menu

Required visuals:

- STARFALL COURIER logo lockup,
- selected ship hero preview,
- subtle hangar/space terminal backdrop,
- primary Play button,
- Contracts entry,
- Hangar entry,
- Upgrades entry,
- Missions entry,
- Stats entry,
- currency/reputation summary,
- settings icon button.

Ship hero size: `240–360 px` high.

## 19.2 Primary button

Height: `64–72 px`.

Radius: `16–20 px`.

Visual: purple-to-cyan controlled gradient or purple active fill; white label.

States:

- default,
- pressed,
- disabled,
- focused/keyboard if desktop testing,
- loading only when necessary.

## 19.3 Secondary button

Height: `52–60 px`.

Dark surface + thin purple/cyan border.

States: default/pressed/disabled/selected.

## 19.4 Danger button

Use only for destructive/critical actions.

Magenta/red semantic accents.

## 19.5 Icon button

Touch target: `52–60 px`.

Glyph: `22–28 px`.

Variants:

- plain HUD,
- bordered panel,
- selected/filled,
- disabled.

## 19.6 Cards/panels

Padding: `16–24 px`.

Radius: `16–22 px`.

Border: `1–2 px`.

Variants:

- normal,
- selected purple,
- reward gold,
- dangerous magenta,
- completed green,
- disabled/locked.

## 19.7 Chips / badges

Height: `26–34 px`.

Variants:

- sector,
- threat,
- reward multiplier,
- mastery level,
- contract status,
- locked/unlocked.

## 19.8 Tabs

Height: `44–52 px`.

Selected state: purple/cyan line or contained dark-selected surface.

Do not use huge pill tabs.

## 19.9 Progress bars

Height:

- compact: `6–8 px`,
- prominent: `10–14 px`.

Uses:

- reputation,
- mastery,
- upgrade level,
- mission progress,
- contract progress.

Variants: purple/cyan normal, gold reward, green completion.

## 19.10 Toggle

Touch height: `44–52 px`.

Selected: cyan/purple; inactive: muted navy.

## 19.11 Slider

Track: `4–6 px`.

Handle: `18–22 px`.

Use for volume/haptics/settings only.

## 19.12 Modal

Width: `560–640 px` logical maximum with safe margins.

Large enough for clear decision but avoid full-screen card unless content requires it.

## 19.13 Toast / notification

Width: `360–560 px`.

Height: `48–76 px`.

Duration: normally `1.5–3 s` depending content.

Variants:

- info purple/cyan,
- reward gold,
- success green,
- warning magenta/orange.

## 19.14 Tooltip

Only for non-obvious secondary UI; mobile should not depend on hover.

## 19.15 Divider

`1 px` line using `line_dark` or low-alpha purple/cyan.

---

# 20. Gameplay HUD Asset Catalog

The middle of the screen belongs to gameplay.

## Top HUD

Layout concept:

```text
[Pause]    Distance    Combo    Cores
```

Components:

- pause icon button,
- distance label/value,
- combo multiplier,
- Star Core count/icon,
- optional Threat indicator,
- active contract progress only when relevant.

Recommended top height: `72–104 px` including safe-area padding.

## Distance

Value size: `22–28 px`.

Label size: `11–13 px`.

Color: white/cyan.

## Combo

Value size: `24–32 px` depending multiplier.

Color progression: white → gold; do not rainbow-scale.

## Core count

Icon: `18–22 px`; value `18–24 px`.

## Threat

Compact indicator, not permanent giant banner.

Size: `80–130 × 24–34 px`.

Color: magenta intensity steps.

## Active power-up indicator

Only visible when active.

Icon: `20–26 px`.

Timer/progress ring: `28–36 px`.

## Contract objective

Width: `260–420 px`.

Height: `38–58 px`.

Use only during Contract Run/relevant objective.

## Lane indicator

Bottom area: three subtle points/chevrons.

Each: `8–14 px`.

Avoid joystick-like controls; input remains left/right side taps.

---

# 21. Screen-by-Screen UI Visual Requirements

## Splash / boot

- Starfall mark,
- short logo reveal,
- dark background.

## Main menu

See component section.

## Mode selection

- Courier Run,
- Contract Run,
- Deep Run,
- Challenge Run.

Each mode card should use a small icon + short description + reward/difficulty cue.

## Contracts

- contract list,
- objective icon,
- target distance/count,
- reward,
- difficulty/threat,
- accepted/available/completed/locked states.

## Hangar

- large procedural ship preview,
- ship selector,
- handling/traits,
- mastery progress,
- unlocked/locked state,
- selected state.

## Upgrades

- upgrade category icon,
- current level,
- next level change,
- cost,
- five-level track,
- max state.

## Missions

- up to three active missions,
- progress,
- reward,
- completed/claimable state.

## Achievements

- icon,
- title,
- progress/locked state,
- reward/completion marker.

## Stats

- best score,
- best distance,
- highest combo,
- total runs,
- total distance,
- total Star Cores,
- Near Misses,
- contracts,
- power-up stats,
- sector records,
- ship usage,
- playtime.

Charts must remain compact and cockpit-like rather than corporate dashboard-like.

## Pause

- resume,
- restart if game design permits,
- settings,
- quit run.

Keep gameplay dimly visible behind.

## Run summary / game over

- distance,
- score,
- best/new record state,
- Cores,
- Near Misses,
- max combo,
- Star Chips earned,
- contract outcome,
- reputation/mastery progress,
- retry/play again,
- home.

## Extraction decision

- Extract,
- Continue,
- secured reward,
- possible bonus multiplier/risk explanation.

Strong green vs purple/gold choice language, not generic modal buttons.

## Settings

- music,
- SFX,
- haptics,
- accessibility options,
- reset/credits/legal when needed.

## Tutorial/onboarding

Use temporary lane overlays, finger-tap indicators and short text prompts.

Avoid long tutorial pages.

---

# 22. Animation Motion Language

## Timing principles

- interaction micro-motion: `80–180 ms`,
- lane movement: `120–220 ms`,
- common reveal: `180–320 ms`,
- reward emphasis: `300–700 ms`,
- major transition: `500–1200 ms`.

## Easing

Use responsive ease-out for interaction and movement.

Avoid bouncy elastic motion except possibly tiny reward celebration accents.

## UI animation variants

- fade + `96–100%` scale in,
- short directional slide `8–24 px`,
- line/reveal sweep,
- number interpolation,
- selected border/color interpolation.

Avoid large cards flying across the screen unnecessarily.

---

# 23. Visual Variant Rules

Every reusable visual should use semantic states instead of duplicate unrelated designs.

Common state vocabulary:

```text
default
active
selected
disabled
locked
warning
danger
reward
success
completed
expired
hit
shielded
overcharged
time_warped
```

Not every object needs every state.

AI agents must only create the states required by the feature being implemented.

---

# 24. Procedural Asset Data Rules

Where useful, separate geometry/style parameters into `Resource` data.

Example future concepts:

```text
ShipVisualStyle
AsteroidVisualStyle
PowerUpVisualStyle
SectorVisualStyle
RouteGateVisualStyle
```

Possible data fields:

- polygon points,
- stroke width,
- base color,
- accent color,
- glow intensity,
- pulse rate,
- geometry scale,
- variant seed,
- shader parameters.

Do not turn every small constant into a Resource prematurely.

---

# 25. Future Visual File Organization

Create these folders only when their first real implementation file is needed.

```text
res://
├── assets/
│   └── fonts/
│       ├── text/
│       │   └── oxanium/
│       └── icons/
│           └── material_symbols/
│
├── scenes/
│   └── visuals/
│       ├── effects/
│       └── ui/
│
├── scripts/
│   └── visuals/
│       ├── backgrounds/
│       ├── entities/
│       ├── effects/
│       └── ui/
│
├── shaders/
│   ├── backgrounds/
│   ├── effects/
│   └── ui/
│
└── resources/
    └── visual_styles/
```

Domain gameplay scenes should own or instantiate their visual child rather than requiring one global visual manager.

Example:

```text
Player (CharacterBody2D)
├── Visual (procedural Node2D)
├── CollisionShape2D
├── NearMissDetector
└── ...
```

---

# 26. Font Resource Organization

When fonts are added, prefer:

```text
res://assets/fonts/text/oxanium/Oxanium[wght].ttf
res://assets/fonts/icons/material_symbols/MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf
```

Then create reusable Godot resources/theme configuration such as:

```text
res://resources/themes/starfall_theme.tres
res://resources/fonts/text_regular.tres
res://resources/fonts/text_medium.tres
res://resources/fonts/text_semibold.tres
res://resources/fonts/text_bold.tres
res://resources/fonts/icon_outline.tres
res://resources/fonts/icon_selected.tres
```

Exact resource files should be introduced only when UI implementation begins.

---

# 27. Accessibility and Readability

- Do not communicate danger through color alone; use shape/animation/position.
- Do not communicate route type through color alone; include short labels/iconography.
- Keep critical text legible over moving backgrounds with local dark backing or sufficient contrast.
- Use strong telegraphs before lethal energy hazards activate.
- Avoid excessive screen shake.
- Avoid rapid full-screen flashes.
- Avoid constant high-intensity glow.
- Do not place important HUD information under phone safe-area cutouts.

---

# 28. Performance Guardrails

Procedural rendering still needs budgets.

- Prefer one efficient background shader over many overlapping full-screen effects.
- Keep full-screen distortion temporary.
- Reuse materials/resources where practical.
- Use particles for effects, not permanent decoration everywhere.
- Use seeded procedural variants instead of hundreds of separate scene files when behavior is identical.
- Avoid rebuilding complex geometry every frame if it has not changed.
- Call `queue_redraw()` only when custom-drawn geometry/state actually changes.
- Consider MultiMesh/efficient batching for dense repeated background stars/debris only after profiling.
- Keep collision geometry simple and independent from visual complexity.

---

# 29. AI Asset Checklist

Before an AI agent creates any visual, answer:

1. Which game-design feature requires this visual now?
2. Can it be procedural/vector rather than raster?
3. What is its semantic color role?
4. What is its target gameplay size at the 720 × 1280 reference viewport?
5. Which variants/states are required now?
6. Which variants are future-only and should not be created yet?
7. Does it need a shader, or would normal CanvasItem drawing be simpler?
8. Does it need animation, and what duration/easing matches the motion language?
9. Is it world-space or UI-space?
10. Can the geometry be reused at a larger menu/hangar scale?
11. Is any glow purely presentation and excluded from collision?
12. Does the implementation preserve readability and performance?

---

# 30. Final Product Visual Inventory

The final visual product should eventually contain these categories.

## Background

- base deep-space shader,
- starfield,
- dust,
- nebula,
- distant planets/moons,
- shipping lines,
- distant shipping lights,
- speed streaks,
- five sector atmosphere variants,
- sector transitions.

## Navigation

- lane indicator,
- tutorial lane guide,
- Safe/Core/Danger route gates,
- route modifiers,
- extraction gate,
- contract/sector entry markers.

## Player

- Courier,
- Interceptor,
- Phantom,
- future ship slots,
- engine core,
- engine trail,
- lane-change bank effect,
- Shield state,
- Time Warp state,
- Overcharge state,
- impact state,
- destruction fragments/effect,
- hangar/mastery presentation.

## Collectibles

- Star Core,
- high-value Core variant,
- Core Surge presentation,
- Star Chip meta icon/reward effect.

## Power-ups

- Shield,
- Time Warp,
- Overcharge,
- future Core Magnet,
- future Stabilizer,
- future Phase Shift,
- future Emergency Jump.

## Hazards

- Standard Asteroid variants,
- Heavy Asteroid variants,
- Fast Debris variants,
- Drifting Debris variants,
- Energy Mine,
- Laser Gate,
- Meteor warning/meteor/impact,
- Cargo Wreck variants,
- Gravity Anomaly,
- elite-event overlays,
- future Courier Hunter and lane attacks.

## VFX

- generic spawn,
- generic safe despawn,
- player crash,
- shield impact/save,
- Core pickup,
- combo increase,
- combo milestone,
- Near Miss tiers,
- Shield activation,
- Time Warp activation/sustain/end,
- Overcharge activation/sustain/end,
- route selection,
- contract completion,
- extraction,
- sector transition,
- Threat increase,
- new record,
- achievement,
- reputation/mastery level up,
- hazard telegraphs,
- anomaly distortion,
- debris/core-surge event effects.

## Shaders

- space background,
- star twinkle,
- nebula haze,
- neon glow,
- energy core,
- shield field,
- time warp,
- overcharge,
- danger telegraph,
- route gate,
- anomaly distortion,
- sector grade,
- impact flash,
- hologram UI,
- UI panel treatment.

## UI

- boot/splash,
- logo,
- main menu,
- mode select,
- HUD,
- route-choice presentation,
- extraction decision,
- contracts,
- hangar,
- upgrades,
- missions,
- achievements,
- stats,
- pause,
- run summary/game over,
- settings,
- tutorial,
- challenge/deep-run modifiers,
- reusable buttons,
- icon buttons,
- cards,
- tabs,
- chips/badges,
- progress bars,
- toggles,
- sliders,
- modals,
- toasts,
- dividers,
- locked/completed/selected states.

## Fonts

- Oxanium Variable text family,
- Material Symbols Sharp Variable icon family,
- reusable Godot Theme/FontVariation resources when UI development begins.

---

# 31. Non-Negotiable Visual Rules

1. Preserve the premium neon deep-space courier identity.
2. Procedural/vector rendering is the default asset pipeline.
3. Do not introduce PNG sprite-sheet animation as the default solution.
4. Use Oxanium for normal game text.
5. Use Material Symbols Sharp for normal UI icons.
6. Do not mix random icon libraries or emoji into the UI.
7. Keep background darker and quieter than gameplay.
8. Keep the player visually brighter than normal hazards.
9. Gold always communicates value/reward.
10. Magenta/red communicates danger/high-intensity risk.
11. Cyan communicates navigation/energy/shield.
12. Purple is the Starfall identity/selection color.
13. Green communicates successful completion/extraction.
14. Hazard telegraphs must be visually readable before activation.
15. Glow is emphasis, not decoration everywhere.
16. Collision geometry must never use decorative glow bounds.
17. Build only the states/assets required by the current milestone.
18. Future asset slots in this document are planning references, not implementation requests.
19. Maintain readability first, visual spectacle second.
20. Add depth and polish around the three-lane courier gameplay; never visually transform the game into a combat shooter.
