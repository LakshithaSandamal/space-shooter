# Starfall Courier — Asset Drawing System v1

Status: **canonical production drawing standard**  
Applies to: procedural/vector art, shaders, UI, VFX, animation, visual review scenes, and any AI-generated visual implementation.

This document defines **how Starfall Courier visuals must be constructed**. It does not change gameplay scope. `game_concept_v0.md` remains authoritative for what the game is, while this file defines the production-level drawing language used to express it.

---

## 1. Visual quality target

Starfall Courier should feel like a premium futuristic courier-navigation game built from elegant mathematical forms rather than image assets.

The target is:

> **Premium, readable neon sci-fi vector art with layered geometric sophistication, restrained luminous energy, strong silhouette hierarchy, and deliberate motion design.**

The game must not look like:

- placeholder geometry,
- flat icon art used as world objects,
- generic mobile sci-fi,
- random neon outlines,
- cartoon spacecraft,
- military hardware,
- retro/pixel art,
- a particle demo,
- a collection of unrelated procedural experiments.

Every production visual must look as if it belongs to one coherent industrial/graphic-design system.

---

## 2. Core construction model

Most important world visuals should be built in layers. Not every asset needs all layers, but major assets should usually use at least four.

### Layer 1 — primary silhouette

The object must remain identifiable with fill color only.

Rules:

- prioritize gameplay readability before detail,
- use a strong directional shape,
- preserve clear negative space,
- avoid unnecessary concavity at small gameplay sizes,
- test the silhouette at approximately 50% of intended display size.

### Layer 2 — structural planes

Use secondary geometry to suggest a designed physical object rather than a symbol.

Examples:

- panel planes,
- inset hull sections,
- frame rails,
- wing braces,
- clipped corners,
- chamfered notches,
- internal rings,
- segmented armor plates,
- mechanical pylons,
- exposed energy chambers.

### Layer 3 — material separation

Separate materials visually using shape and value before relying on glow.

Typical material groups:

- light metallic hull,
- purple anodized structural frame,
- charcoal/dark-violet hazard body,
- translucent cyan energy,
- magenta hostile/overcharge energy,
- gold reward energy,
- green extraction/success energy.

### Layer 4 — functional accents

Every luminous mark must explain something.

Good uses:

- reactor line,
- shield emitter,
- route direction,
- active hazard channel,
- power core,
- warning node,
- extraction alignment mark,
- selected UI edge.

Bad uses:

- random glowing stripes,
- every edge glowing,
- decorative lines with no visual hierarchy.

### Layer 5 — controlled soft energy

Glow should support the focal point, not replace form.

Use:

1. crisp inner energy shape,
2. small brighter rim/core,
3. wider low-alpha halo,
4. optional animated outer falloff.

Never use one large blurred neon halo as the entire effect.

### Layer 6 — micro-detail

Micro-detail exists only where scale allows it.

Examples:

- tiny vent cuts,
- two-pixel-equivalent panel gaps,
- small status dots,
- short technical line segments,
- micro-glyphs,
- secondary crack branches.

At gameplay scale, micro-detail should disappear before primary structure becomes noisy.

---

## 3. Global geometric language

### 3.1 Friendly / courier geometry

Use:

- forward-pointing arrowhead structures,
- long central spines,
- tapered noses,
- symmetrical left/right framing,
- swept wing triangles,
- deliberate central negative space,
- clean beveled corners,
- thin luminous rails,
- concentrated rear engine geometry.

Meaning:

- precise,
- stable,
- fast,
- professional,
- advanced,
- controlled.

### 3.2 Reward / utility geometry

Use:

- circles,
- diamonds,
- hexagonal frames,
- orbit rings,
- nested symmetric modules,
- floating center elements,
- clean radial rhythm.

Meaning:

- collectible,
- helpful,
- valuable,
- system-controlled.

### 3.3 Hazard geometry

Use:

- irregular mass,
- broken symmetry,
- harsh diagonals,
- hooks,
- spikes,
- unstable ring segmentation,
- fractured planes,
- deliberately imbalanced internal spacing.

Meaning:

- unsafe,
- unstable,
- hostile,
- difficult to predict.

### 3.4 Navigation / gate geometry

Use:

- open frames rather than solid blocks,
- paired side structures,
- nested brackets,
- corridor-like perspective lines,
- directional openings,
- clean visual centerline.

Meaning:

- pass through,
- choose,
- align,
- extract,
- navigate.

---

## 4. Stroke hierarchy

The 720 × 1280 reference viewport is the base visual scale.

Recommended world-space visual stroke hierarchy at normal gameplay scale:

| Role | Typical width |
|---|---:|
| micro technical detail | 0.8–1.1 |
| secondary panel line | 1.1–1.6 |
| important internal accent | 1.6–2.2 |
| structural outline | 2.0–3.0 |
| hazard warning line | 2.4–4.0 |
| major gate/beam structure | 3.0–6.0 |

Rules:

- do not give every line the same weight,
- outlines should not completely cage every polygon,
- brighter lines should generally be thinner than dark structural frames,
- high-energy beams can be visually thick but should contain a brighter narrow core.

---

## 5. Semantic color system

Use the existing tokens from `StarfallVisualTokens` as the production basis.

### Environment

- Space Black `#050711`
- Space Navy `#080D1D`
- Secondary Navy `#0D1428`
- Surface Dark `#111A31`

### Starfall identity

- Purple Primary `#8B5CFF`
- Purple Bright `#A784FF`
- Purple Deep `#5C3FC8`

### Energy / navigation / shield

- Cyan Primary `#27E7FF`
- Cyan Soft `#83F4FF`
- Cyan Deep `#1593B3`

### Danger / intensity

- Magenta Primary `#FF3EA5`
- Magenta Bright `#FF79C6`
- Danger Red `#FF5364`
- Warning Orange `#FF9D45`

### Reward

- Gold Primary `#FFC857`
- Gold Bright `#FFE08A`
- Gold Deep `#C98A2D`

### Success / extraction

- Success Green `#4EE6A8`
- Success Bright `#8AF5C7`

### Text

- Text Primary `#F5F7FF`
- Text Secondary `#B9C1D9`
- Text Muted `#7F89A6`
- Text Disabled `#566078`

### Semantic rules

- purple = Starfall identity, selection, premium system framing,
- cyan = navigation, ship energy, shield, guidance,
- magenta/red = danger, hostile energy, overcharge intensity,
- orange = warning and solar/heat telegraph,
- gold = reward, Star Cores, high value, mastery,
- green = safe extraction/completion,
- white = readable structure and highest-priority UI text.

Do not recolor asset families randomly to create variants. Variants should primarily change geometry, secondary value, accent distribution, and motion rhythm while preserving semantic color meaning.

---

## 6. Material rendering language

### 6.1 Light metallic courier hull

Target impression:

- clean ceramic-metal alloy,
- premium aerospace finish,
- very lightly reflective,
- no scratches/rust/grunge texture.

Procedural treatment:

- primary off-white fill,
- cool gray lower/inner plane,
- subtle darker panel separation,
- small cyan reflection near the reactor,
- no full white outer glow.

### 6.2 Purple structural alloy

Target impression:

- anodized structural frame,
- rigid and technical,
- slightly darker than the luminous accents.

Use:

- deep purple body,
- brighter violet edge only where light would catch,
- occasional thin cyan seam where frame touches an energy component.

### 6.3 Hazard rock/metal

Target impression:

- dark mass with readable faceting,
- not a flat charcoal polygon.

Use 3 value tiers:

1. base dark body,
2. lighter face/plane,
3. deep cavity/crater.

Magenta fissures should remain sparse and directional.

### 6.4 Energy fields

Use layered energy rather than simple circles.

Combine:

- solid/bright core,
- partial arcs,
- gaps,
- rotating segment groups,
- outer low-alpha field,
- periodic highlight sweep.

---

## 7. Lighting and depth rules

The game is 2D, but important assets should imply depth.

Preferred cues:

- overlapping polygon planes,
- slight light-to-dark value separation,
- inner shadows represented by darker geometry,
- offset highlight rails,
- front-facing core brighter than structural frame,
- small occlusion gaps/negative spaces,
- rear trail visually underneath the ship.

Avoid fake 3D gradients everywhere. Depth should primarily come from designed geometry and value grouping.

---

# 8. Background drawing system

Backgrounds require more than a gradient and random stars. Each sector should feel like a designed navigational region.

## 8.1 Background layer stack

Each sector should support these depth bands:

### Far field

- base space gradient,
- tiny low-contrast star population,
- broad nebula masses,
- large faint celestial silhouette.

### Mid field

- medium stars,
- sector-specific debris/cloud/energy structures,
- distant shipping infrastructure,
- subtle route-axis geometry.

### Near field

- sparse speed dust,
- occasional larger drifting particles/fragments,
- high-speed streaks during intensity states,
- temporary sector transition elements.

### Navigation overlay

- three-lane perspective hints,
- route alignment lines,
- event/contract corridor accents when needed.

Navigation lines must remain below hazards and collectibles in visual priority.

## 8.2 Sector identity packages

### Courier Corridor

Mood: controlled trade lane / premium infrastructure.

Details:

- navy base,
- cyan lane tracers,
- violet station-light clusters,
- distant orbital ring silhouettes,
- clean sparse stars,
- occasional rectangular docking-beacon arrays.

### Wreck Belt

Mood: abandoned traffic field.

Details:

- more visible charcoal debris silhouettes,
- broken cargo frame fragments,
- muted gold emergency beacons,
- purple-blue dust haze,
- distant broken hull arcs,
- lower star visibility where wreck density increases.

### Ion Reach

Mood: electrically active deep-space corridor.

Details:

- cool cyan-violet gaseous wisps,
- narrow branching ion filaments,
- occasional horizontal energy ribbons,
- increased cyan star tint,
- soft pulsing haze rather than constant brightness.

### Solar Rift

Mood: hot unstable transit zone.

Details:

- warmer dark-violet base,
- orange-red distant flare bands,
- bright rim-lit planet/moon edge,
- heat-like drifting bands,
- warning-orange dust streak accents,
- magenta solar fissure hints.

### Void Passage

Mood: minimal, ominous, premium high-risk emptiness.

Details:

- near-black base,
- very low star density,
- one large distant violet/cyan gravitational structure,
- thin warped star arcs,
- subtle lensing geometry,
- restrained brightness so rewards/hazards dominate.

## 8.3 Background variants per sector

Each sector should support visual intensity presets rather than completely separate art:

- Calm,
- Standard,
- High Speed,
- Threat Elevated,
- Elite/Event.

Parameters that may vary:

- speed dust amount,
- route-line intensity,
- haze movement,
- accent frequency,
- vignette strength,
- anomaly presence,
- distant light density.

---

# 9. Player ship drawing system

The playable ship family must be the most carefully authored geometry in the game.

## 9.1 Shared ship anatomy

Every ship silhouette should be designed from these logical regions:

1. **nose / navigation tip** — immediate forward direction,
2. **central hull spine** — stable visual axis,
3. **cockpit / sensor chamber** — dark inset detail,
4. **left/right structural frames** — purple identity,
5. **wing plane / stabilizer** — ship family silhouette difference,
6. **reactor chamber** — cyan focal point,
7. **engine throat** — transition into trail,
8. **micro-panel layer** — limited secondary sophistication.

## 9.2 Detail density target

At normal size, a ship should typically contain:

- 1 primary hull polygon group,
- 2–4 frame/wing polygon groups,
- 2–5 inset structural planes,
- 2–4 panel lines,
- 1 major reactor,
- 2–6 small energy/accent lines,
- 1 ship-specific signature feature.

The current simple hull + wing + reactor representation is a baseline only; v1 should progressively move toward this richer layer count.

## 9.3 Ship-family differentiation

### Courier

Identity: balanced, elegant, professional.

Features:

- medium arrowhead nose,
- swept purple frame,
- balanced wing width,
- clear cyan reactor,
- twin thin cyan rear channels,
- restrained white hull center.

### Interceptor

Identity: narrow and fast.

Features:

- longer nose,
- thinner center spine,
- sharper outer wing tips,
- smaller body mass,
- longer engine line,
- cyan velocity rails near wing roots.

### Phantom

Identity: stealth/phase visual language.

Features:

- crescent-like outer frame,
- thinner white hull exposure,
- cyan-deep frame material,
- separated wing tips creating negative space,
- low-alpha phase arcs.

### Hauler

Identity: stable cargo-capable silhouette.

Features:

- wider rear body,
- side cargo-frame pods,
- heavier frame thickness,
- gold-deep utility marks,
- shorter but broader engine exhaust.

### Vector

Identity: ultra-precise directional machine.

Features:

- longest central nose,
- smallest center mass,
- extended angular vector fins,
- strong cyan directional rails,
- sharper rear convergence.

### Eclipse

Identity: premium darker high-tier silhouette.

Features:

- deep violet outer frame,
- controlled magenta secondary accent,
- partial ring/crescent geometry,
- brighter central reactor contrast,
- more negative space than Hauler/Courier.

### Pathfinder

Identity: exploration/mastery ship.

Features:

- layered route-bracket geometry,
- gold navigation arc detail,
- cyan sensor marks,
- multi-plane wing structure,
- clean balanced premium silhouette.

## 9.4 Ship visual states

### Normal

- reactor pulse 5–10% radius range,
- subtle engine breathing,
- no large aura.

### Shielded

Use at least:

- main translucent shield shell,
- partial rotating protective arcs,
- brighter leading-edge segment,
- occasional impact ripple location.

### Time Warp

Use:

- compressed engine plume,
- offset temporal outlines,
- dual cyan/purple phase rings,
- subtle rear image echo,
- optional full-screen shader supplied elsewhere.

### Overcharged

Use:

- brighter reactor,
- longer plume,
- magenta electrical branch accents,
- thin white-hot core sparks,
- restrained outer energy ring.

### Impact

Use:

- extremely short white flash,
- local cyan/purple/magenta hit ring based on cause,
- directional impulse line,
- no long full-screen obstruction.

### Crashed / destroyed

Break the visual into meaningful structural parts:

- hull core,
- left frame/wing,
- right frame/wing,
- reactor burst,
- 3–8 smaller fragments,
- fading trail residue.

The destruction should look like the existing ship breaking apart, not a generic explosion sprite.

### Prestige/mastery

Use:

- gold micro-rail or ring accents,
- purple/cyan retained as core identity,
- more refined detailing rather than simply making the entire ship gold.

---

# 10. Collectible drawing system

## 10.1 Star Core

Target size: approximately 22–30 px gameplay footprint, larger in menus/showcase.

Construction:

- diamond/crystal core,
- secondary inset core,
- 1–2 orbit arcs,
- tiny white-hot center,
- low-alpha gold halo,
- subtle rotating or oscillating accent.

Variants:

- Standard,
- Dense/large-value,
- Contract-emphasized,
- Elite/high-value presentation.

Do not differentiate value only by scale. Change orbit pattern, inner segmentation, and secondary gold tone.

## 10.2 Star Chip

Construction:

- hexagonal/technical token shape,
- cut corner or segmented perimeter,
- internal gold trace,
- small center notch/core,
- minimal rotating highlight.

It should read as persistent currency, not as another Star Core.

---

# 11. Power-up drawing system

All power-ups share a common collectible grammar:

- centered energy symbol,
- readable outer frame/orbit,
- controlled halo,
- one unique motion rhythm.

## Shield

- cyan core,
- nested protective arcs,
- partial shell gaps,
- clockwise counter-moving arc pair,
- brighter leading arc.

## Time Warp

- purple/cyan concentric rings,
- temporal split/offset,
- clock/phase-line hint without becoming a literal clock icon,
- alternating ring speed.

## Overcharge

- magenta energy chamber,
- white inner bolt/core,
- short electrical tendrils,
- irregular but controlled pulse.

## Core Magnet

- cyan structural horseshoe / field frame,
- tiny gold core suspended inside,
- 2–3 inward attraction lines,
- periodic pull animation.

## Stabilizer

- geometric balanced hex/diamond frame,
- centered cyan line,
- opposite rotating stabilizer segments,
- calm low-frequency motion.

## Phase Shift

- repeated offset diamond/ship-like ghost layers,
- cyan primary contour,
- purple secondary echoes,
- horizontal phase drift.

## Emergency Jump

- success-green/cyan exit frame,
- upward/forward transit cue,
- short ring compression animation,
- visually distinct from normal extraction gate.

Reserved/future power-up slots remain visual prototypes until corresponding gameplay is explicitly implemented.

---

# 12. Hazard drawing system

Hazards need more internal structure than the current simple shapes because they occupy a large percentage of gameplay time.

## 12.1 Standard Asteroid

Target footprint: 52–76 px.

Each variant should include:

- 8–12 vertex irregular outer silhouette,
- 2–4 large internal plane polygons,
- 1–3 crater/cavity shapes,
- sparse crack branch,
- optional magenta fissure on selected variants,
- one darker underside face.

Minimum production silhouettes: 6.

Variation dimensions:

- broad vs tall,
- fractured corner,
- double-lobed,
- central crater,
- shard protrusion,
- smoother compact rock.

## 12.2 Heavy Asteroid

Target footprint: 96–148 px.

Use:

- 10–16 vertex main silhouette,
- multiple large facets,
- deep cavities,
- 2–5 crack regions,
- optional embedded dark-violet mineral plane,
- stronger parallax/rotation impression.

Minimum production silhouettes: 4.

Heavy asteroid visuals must communicate greater lane occupancy immediately.

## 12.3 Fast Debris

Use:

- thin metallic shard silhouettes,
- 1–2 panel edges,
- small magenta/orange warning reflection,
- long motion streak,
- asymmetrical orientation.

Minimum silhouettes: 6.

## 12.4 Drifting Debris

Use:

- broader scrap shapes,
- broken cargo panel edges,
- visible plate layering,
- occasional cyan dead-system light,
- slow tumble cue.

Minimum silhouettes: 6.

## 12.5 Energy Mine

Construction:

- dark central mechanical body,
- 6–10 radial emitter arms,
- central magenta/red core,
- segmented warning ring,
- small secondary emitter dots.

States:

- idle/armed,
- warning,
- active/triggering,
- impact/detonation.

Warning state should change rhythm and ring geometry, not only color.

## 12.6 Laser Gate

Construction:

- left/right pylon bodies,
- multi-plane metal housing,
- emitter chamber,
- bright beam core,
- soft outer beam glow,
- small warning indicators,
- optional secondary support rail.

States:

- inactive/approach,
- warning/charging,
- active,
- impact,
- disabled/fading where applicable.

The beam should visually have:

1. low-alpha field,
2. strong colored beam,
3. narrow near-white energy center.

## 12.7 Meteor Strike warning

Use:

- projected impact ring,
- directional streak/trajectory cue,
- orange warning brackets,
- tightening countdown arc or shrinking outer ring.

The warning marker must remain readable over all five sectors.

## 12.8 Cargo Wreck

Use:

- recognizable broken shipping structure,
- large dark hull slab,
- exposed purple/gray frame,
- 2–4 broken panel pieces,
- sparse emergency amber/orange indicator,
- clear navigational silhouette.

Avoid making it look like an asteroid.

## 12.9 Gravity Anomaly

Use layered mathematical distortion cues:

- dark center well,
- warped cyan/purple arcs,
- uneven outer orbit ring,
- small star/lens streaks,
- subtle shader distortion,
- weak magenta danger cue only at higher intensity.

The center should feel spatially deep without requiring a bitmap texture.

---

# 13. Routes, extraction, and encounter drawing

## 13.1 Route gates

Shared anatomy:

- two main frame pylons/brackets,
- open pass-through center,
- identity glyph/energy core,
- outer selection brackets,
- subtle directional streaks.

### Safe Route

- green/cyan,
- calmer rounder inner framing,
- lower pulse frequency.

### Core Field

- gold,
- floating mini-core motifs,
- richer reward shimmer.

### Danger Route

- magenta/red,
- sharper interior angle language,
- stronger warning pulse.

### Contract Bonus

- purple identity frame,
- secondary cyan contract/target marker,
- technical bracket detail.

### Elite Route

- purple/magenta with restrained gold prestige hint,
- more layered frame structure,
- highest-detail route presentation.

States:

- distant/approach,
- active/readable,
- selected,
- passed/fading,
- unavailable/disabled.

Selected state should introduce a bracket-lock animation and brighten the route center, not merely increase overall glow.

## 13.2 Extraction Gate

This is a major event visual and should be more sophisticated than normal route gates.

Use:

- larger paired structural columns,
- nested cyan/green energy field,
- central vertical alignment corridor,
- inward-moving particles/lines,
- scanning bands,
- success glyph/mark,
- multiple depth layers.

States:

- incoming/preview,
- available,
- selected,
- extraction active,
- secured/success.

## 13.3 Courier Hunter visual slot

The Hunter is a future encounter visual from the game design; it must remain visually distinct from normal hazards without turning the game into a shooter.

Use:

- aggressive angular silhouette,
- dark body,
- magenta/red telegraph channels,
- narrow cyan/white sensor focal point if appropriate,
- intercept lines,
- lock-on/approach warning geometry.

Do not create player weapon language around it unless the game concept is explicitly changed.

---

# 14. VFX drawing and motion system

Effects should be constructed as time-driven geometry and shader parameters, not sprite frames.

## 14.1 Motion curves

Recommended feel:

- interface/selection: fast ease-out,
- warning: repeated controlled pulse,
- pickup: immediate expansion then fast fade,
- shield impact: local sharp response,
- route lock: quick snap + short settle,
- extraction: slower premium build,
- mastery/reward: confident staged reveal.

## 14.2 Typical timing ranges

| Effect | Typical duration |
|---|---:|
| button/select response | 0.10–0.22 s |
| core pickup burst | 0.25–0.45 s |
| shield hit | 0.20–0.40 s |
| near miss | 0.20–0.45 s |
| crash primary burst | 0.45–0.90 s |
| route selected | 0.25–0.55 s |
| sector transition | 0.60–1.20 s |
| extraction buildup | 0.80–1.60 s |
| record/achievement | 0.70–1.40 s |

These are art-direction targets, not gameplay timing rules.

## 14.3 Spawn / despawn

Use:

- broken ring segments,
- converging/diverging lines,
- center flare,
- optional materialization slice.

Avoid a plain scale-from-zero tween.

## 14.4 Crash/destruction

Use:

- real asset fragment geometry,
- shock ring,
- short white/orange energy flash,
- cyan reactor residue where appropriate,
- magenta/orange secondary sparks,
- fading fragment alpha.

## 14.5 Star Core pickup

Use:

- gold radial lines,
- collapsing orbit ring,
- tiny white center flash,
- HUD-directed optional streak later if justified.

## 14.6 Shield impact

Use:

- local arc at collision side,
- short cyan-white flash,
- ripple traveling partially around shell,
- small outer arc breakup.

## 14.7 Near Miss / Danger Streak

Near Miss:

- directional cyan streak pair,
- narrow short-lived bracket/ring cue.

Danger Streak:

- increased magenta accent,
- stronger directional slash count,
- still below hazard visibility priority.

## 14.8 Engine trail

Build from layers:

- wide purple low-alpha envelope,
- narrower cyan body,
- thin bright central filament,
- occasional small segmented pulse near engine throat.

Different ship states may alter length, width, and turbulence rather than changing to unrelated colors.

## 14.9 Time Warp

Use:

- offset ring groups,
- purple/cyan temporal arcs,
- longitudinal streaking,
- subtle screen-space distortion,
- reduced-motion mode must be possible.

## 14.10 Overcharge

Use:

- magenta branch arcs,
- white-hot small nodes,
- reactor amplification,
- longer engine plume,
- controlled pulse rate.

## 14.11 Route selected

Use:

- four-corner lock brackets,
- small center pulse,
- frame-energy sweep toward the selected route.

## 14.12 Extraction

Use:

- upward/inward energy lines,
- layered vertical field,
- green/cyan success palette,
- staged build rather than an instant flash.

## 14.13 Sector transition

Use:

- speed-line compression,
- sector accent interpolation,
- brief route-line distortion,
- optional wipe-like haze shift.

## 14.14 Threat pulse

Use:

- red/magenta ring segmentation,
- HUD/frame pulse where appropriate,
- avoid full-screen opaque flashes.

## 14.15 New record / achievement / mastery

Use premium staged effects:

- gold/purple radial structure,
- small star/core fragments,
- clean expansion,
- short hold,
- controlled fade.

Do not use confetti-style generic celebration visuals.

---

# 15. Shader system

Shared shaders should remain parameterized and reusable.

Required visual responsibilities:

- space field / procedural stars,
- sector grading,
- neon energy,
- Time Warp distortion,
- UI panel energy treatment,
- future shield/anomaly refinements when justified.

## Shader quality rules

- prefer subtle layered noise over obvious repeating patterns,
- avoid animated noise everywhere,
- preserve object silhouette before adding distortion,
- use screen-space distortion only for short/high-value states,
- avoid expensive full-screen effects as permanent background decoration,
- maintain Compatibility renderer awareness until renderer strategy changes deliberately.

---

# 16. UI drawing system

UI should look like the same design organization that manufactured the courier ships and route gates.

## 16.1 Panel anatomy

Premium panel construction:

1. dark translucent base,
2. 1 px-equivalent structural edge,
3. one brighter semantic accent edge,
4. clipped/beveled corner or segmented corner treatment,
5. optional faint internal grid/scan pattern,
6. generous internal spacing.

Do not use identical rounded cards everywhere.

## 16.2 Button anatomy

A production button should support:

- structural dark body,
- leading/selected accent edge,
- text/icon hierarchy,
- hover/pressed energy sweep,
- disabled low-contrast state.

Button variants:

- primary,
- secondary,
- danger,
- icon-only,
- tab,
- compact chip,
- confirm/success where needed.

## 16.3 HUD modules

HUD modules should favor narrow technical framing instead of large menu-card surfaces.

Examples:

- Distance — large white numeric value + muted unit,
- Combo — brighter accent and compact multiplier frame,
- Star Cores — gold glyph + count,
- Power-up — icon frame + remaining-state indicator,
- Contract — compact purple/cyan objective strip,
- Threat — red/magenta segmented meter/ring.

## 16.4 Progress bars

Avoid plain filled rectangles.

Use:

- framed rail,
- clipped ends,
- segmented fill or energy line,
- small leading highlight,
- semantic color,
- low-alpha inactive background.

## 16.5 Cards

Contract, upgrade, mission, achievement, and summary cards should use:

- strong information hierarchy,
- one primary metric/action,
- compact icon badge,
- controlled decorative edge,
- differentiated selected/completed/locked states.

---

# 17. Typography and icon-font system

## 17.1 Text family

Canonical family:

```text
res://assets/fonts/text/oxanium/Oxanium[wght].ttf
```

Use one family with weight/size hierarchy rather than mixing decorative fonts.

Recommended roles:

| Role | Typical reference size |
|---|---:|
| micro technical label | 10–12 |
| caption / muted label | 12–14 |
| body / normal UI | 15–18 |
| button | 17–20 |
| HUD secondary value | 18–24 |
| HUD primary value | 24–34 |
| page title | 30–40 |
| brand / major result | 48–68 |

Rules:

- numerals must remain highly readable,
- uppercase is useful for short technical labels but should not be forced on paragraphs,
- use tracking/spacing carefully rather than excessive letter spacing.

## 17.2 Icon font

Canonical family:

```text
res://assets/fonts/icons/material_symbols/MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf
```

Use for normal interface symbols only.

Do not use:

- emoji,
- random Unicode shapes,
- mixed icon packs,
- PNG icon sheets.

For highly game-specific symbols such as route identities or Star Core emblems, procedural custom geometry may be better than forcing a generic library icon.

---

# 18. Procedural implementation architecture

Production drawing code remains under:

```text
res://scripts/visuals/
```

Shared shaders remain under:

```text
res://shaders/visual/
```

Development visual comparison remains under:

```text
res://dev/visual_lab/
```

## Preferred implementation pattern

A renderer should expose semantic parameters rather than raw arbitrary drawing values.

Good examples:

```text
ship_type
visual_state
variant
sector
intensity
selected
warning_strength
power_level
```

Avoid exposing dozens of unrelated per-point coordinates to gameplay code.

Gameplay owns state; visual nodes render that state.

## Geometry reuse

Prefer helper functions/data for:

- mirrored hull sections,
- closed polygon outlines,
- repeated route bracket geometry,
- reusable orbit rings,
- asteroid facet generation,
- panel notch construction,
- shared energy-core layers.

Do not create a separate script for every tiny variant when one typed renderer can express the family cleanly.

---

# 19. Animation implementation rules

Prefer:

- time-driven parameter motion,
- Tween,
- AnimationPlayer,
- shader uniforms,
- reusable Curve resources when needed.

Do not build frame-by-frame sprite animation replacements using dozens of hard-coded procedural frames.

Animation should manipulate continuous properties:

- radius,
- alpha,
- scale,
- angle,
- offset,
- line length,
- fragment spread,
- shader intensity,
- trail length,
- color interpolation.

---

# 20. Detail-density budget

### Tiny object / HUD icon

- one dominant shape,
- one inner feature,
- one accent/glow,
- no micro-panel clutter.

### Small world object

- primary silhouette,
- 1–3 secondary planes,
- focal energy element,
- 1–2 accents.

### Medium world object

- primary silhouette,
- 3–6 secondary planes,
- 2–5 technical details,
- focal energy system,
- state overlay.

### Large object / gate / heavy hazard

- major silhouette,
- layered structural planes,
- meaningful negative space,
- multiple depth tiers,
- tertiary detail where visible,
- state/readability system,
- controlled localized VFX.

---

# 21. Senior polish checklist

Before calling a visual production-ready, ask:

1. Does the silhouette read instantly?
2. Does the object have a clear focal point?
3. Are at least two visual depth/material layers visible where appropriate?
4. Is there meaningful negative space?
5. Are secondary details aligned with the object's function?
6. Is glow localized rather than global?
7. Is the semantic color meaning correct?
8. Does the state change geometry/motion as well as color when important?
9. Does the animation have deliberate easing/rhythm?
10. Does it remain readable over every sector background?
11. Does it still read when scaled down?
12. Could any decorative detail be mistaken for collision or danger?
13. Does the asset look related to the rest of the Starfall system?
14. Does the effect support gameplay rather than obscure it?
15. Is a reduced-motion version feasible?

---

# 22. Anti-patterns

Do not improve a simple asset by merely adding:

- random line noise,
- more bloom,
- more particles,
- more colors,
- arbitrary gradients,
- constantly rotating rings,
- tiny unreadable details,
- decorative spikes unrelated to identity.

Do not:

- outline every surface equally,
- make backgrounds as bright as gameplay objects,
- make safe and dangerous objects share the same motion rhythm,
- use a giant glow to fake detail,
- make all UI elements rounded rectangles,
- use color alone for critical state differences,
- create new permanent visual conventions without updating this document and the visual lab.

---

# 23. AI visual-work sequence

For any meaningful visual creation or refinement task, an AI agent should work in this order:

1. identify the gameplay meaning from `game_concept_v0.md`,
2. identify semantic colors and sizing from `visual_system_v0.md`,
3. identify required family/variant/state from `final_visual_inventory_v1.md`,
4. apply this drawing system,
5. inspect existing renderer code,
6. improve geometry in layers rather than replacing the system,
7. add/update the relevant visual-lab comparison,
8. run Godot CI/headless validation,
9. inspect the visual in-editor at gameplay scale,
10. report unresolved visual quality issues explicitly.

---

# 24. Final standard

A production Starfall Courier visual should not merely be technically rendered. It should communicate **purpose, hierarchy, material, state, and motion** through a coherent procedural design language.

The success criterion is not “more detail.” It is **better-designed detail**.