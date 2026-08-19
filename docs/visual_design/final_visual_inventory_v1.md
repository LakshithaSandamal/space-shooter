# Starfall Courier — Final Visual Production Inventory v1

Status: **canonical production inventory**  
Supersedes: `final_visual_inventory_v0.md` for new visual work.  
Companion standard: `asset_drawing_system_v1.md`.

This document defines **what visual families must exist in the final product, what quality level they require, which variants/states are expected, where they are implemented, and how they are reviewed**.

It does not authorize new gameplay. Future-design visual slots remain visual-only until corresponding gameplay is explicitly requested.

---

## 1. Production quality tiers

Every inventory item is assigned a quality target.

### Tier A — hero / constant-attention visual

Examples:

- playable ships,
- extraction gate,
- gameplay HUD,
- major route choices,
- major sector atmosphere.

Requirements:

- strongest silhouette work,
- multiple structural/material layers,
- state-specific animation,
- polished VFX integration,
- explicit gameplay-scale review.

### Tier B — recurring gameplay visual

Examples:

- hazards,
- Star Cores,
- power-ups,
- route gates,
- common effects.

Requirements:

- strong silhouette,
- secondary detail,
- meaningful state language,
- polished but lightweight animation.

### Tier C — support / decorative visual

Examples:

- distant stars,
- background debris,
- minor UI dividers,
- small technical indicators.

Requirements:

- coherent style,
- restrained detail,
- must never compete with Tier A/B gameplay readability.

---

## 2. Canonical production ownership

### Shared visual tokens / typography / UI theme

```text
res://scripts/visuals/starfall_visual_tokens.gd
res://scripts/visuals/starfall_font_registry.gd
res://scripts/visuals/starfall_ui_theme_factory.gd
```

### Procedural world renderers

```text
res://scripts/visuals/space_background_visual.gd
res://scripts/visuals/ship_visual.gd
res://scripts/visuals/game_object_visual.gd
res://scripts/visuals/effect_visual.gd
```

### Shared shader library

```text
res://shaders/visual/
```

### Development review

```text
res://dev/visual_lab/visual_lab.tscn
```

Production gameplay must not depend on `dev/`.

---

# 3. Background and environment inventory

Review page:

```text
res://dev/visual_lab/pages/backgrounds.tscn
```

## 3.1 Sector background families — Tier A

Reference composition: 720 × 1280 portrait.

Required sectors:

| Sector | Primary identity | Required distinguishing details |
|---|---|---|
| Courier Corridor | controlled premium transit lane | cyan shipping traces, distant orbital infrastructure, violet station lights, clean sparse starfield |
| Wreck Belt | abandoned traffic field | wreck silhouettes, cargo-frame fragments, muted gold beacons, purple-blue dust |
| Ion Reach | electrically active corridor | cyan/violet ion filaments, gaseous haze, energy ribbons, stronger cool-star tint |
| Solar Rift | hot unstable route | orange-red flare bands, rim-lit celestial body, heat streaks, magenta/orange warning atmosphere |
| Void Passage | ominous minimal high-risk space | near-black field, low star density, warped violet/cyan structure, gravitational lens-like arcs |

### Required layers per sector

- base vertical/depth gradient,
- far star layer,
- medium star/spark layer,
- broad nebula/haze layer,
- one large distant focal form,
- sector-specific mid-field detail,
- subtle navigation perspective layer,
- near speed-dust layer,
- temporary high-speed streak layer,
- sector color-grade/vignette support.

### Intensity variants

Each sector must support parameterized presets:

1. Calm,
2. Standard,
3. High Speed,
4. Threat Elevated,
5. Elite/Event.

### Animation

- multi-speed star drift/twinkle,
- very slow haze movement,
- occasional sector-specific energy motion,
- near-layer movement tied to run speed,
- intensity-aware streaking.

### Production notes

The current procedural background is a baseline and should be progressively upgraded toward layered depth. Avoid large opaque nebula circles in final production; use irregular mathematical fields, layered gradients/noise, curved bands, and partial structures.

---

## 3.2 Distant celestial/environment modules — Tier C

Target logical footprint: 120–420 px depending on distance.

Required reusable variants:

- small dark moon × 3,
- large partial planet rim × 3,
- ringed planet × 2,
- broken moon/fragment field × 2,
- orbital ring silhouette × 2,
- distant wreck structure × 3,
- ion cloud mass × 3,
- solar flare band × 3,
- void lens/vortex structure × 2.

States:

- normal,
- sector-tinted,
- transition fade.

These are decorative only and must never resemble active hazards.

---

## 3.3 Background particles and motion accents — Tier C

Required families:

- tiny stars,
- bright sparse stars,
- cyan/purple accent stars,
- speed dust,
- high-speed streaks,
- tiny distant debris,
- ion motes,
- solar embers,
- void distortion streaks.

Variant requirement: at least 3 motion/size bands for major sector particles.

---

# 4. Player ship inventory

Review page:

```text
res://dev/visual_lab/pages/ships.tscn
```

Logical authoring footprint:

- normal ship geometry: 96 × 112,
- allowed visual envelope with trails/states: up to 140 × 190.

Gameplay target size remains governed by `visual_system_v0.md` and actual readability testing.

## 4.1 Courier — Tier A

Required geometry layers:

- central white hull spine,
- nose/navigation tip,
- dark cockpit/sensor inset,
- left/right purple frame,
- swept wing planes,
- secondary inner wing braces,
- cyan reactor chamber,
- twin engine throat channels,
- 2–4 panel seams,
- 2–4 small cyan/violet technical accents.

Required states:

- Normal,
- Shielded,
- Time Warp,
- Overcharged,
- Impact,
- Crashed,
- Prestige/Mastery.

Required motion:

- reactor breathing,
- engine trail pulse,
- slight controlled idle energy rhythm,
- state-specific overlays,
- real structural breakup on crash.

## 4.2 Interceptor — Tier A visual slot

Geometry identity:

- longer narrow nose,
- thin central mass,
- sharper outer fins,
- cyan velocity rails,
- longer/thinner engine trail.

Variants/states:

- normal showcase,
- prestige showcase,
- shared power-state compatibility where gameplay later requires it.

## 4.3 Phantom — Tier A visual slot

Geometry identity:

- crescent/phase outer frame,
- separated wing tips,
- larger negative-space cuts,
- darker cyan-deep structural material,
- subtle phase-outline detail.

## 4.4 Hauler — Tier A visual slot

Geometry identity:

- broad rear body,
- cargo-frame side pods,
- heavier support rails,
- gold-deep utility markings,
- wider short engine plume.

## 4.5 Vector — Tier A visual slot

Geometry identity:

- longest central direction spine,
- minimal central mass,
- precision fins,
- strong cyan directional rails.

## 4.6 Eclipse — Tier A visual slot

Geometry identity:

- deep-violet outer frame,
- controlled magenta secondary accent,
- crescent/ring influence,
- high negative-space ratio.

## 4.7 Pathfinder — Tier A visual slot

Geometry identity:

- route-bracket wing framing,
- gold navigation arcs,
- cyan sensor marks,
- multi-plane exploration/mastery silhouette.

### Ship family production rule

The seven ship silhouettes must differ first by geometry, not recolor. Each silhouette should still be recognizable in monochrome.

Future ship slots remain visual prototypes until their gameplay roles are explicitly implemented.

---

# 5. Collectibles and reward inventory

Review page:

```text
res://dev/visual_lab/pages/collectibles_powerups.tscn
```

## 5.1 Star Core — Tier B

Gameplay footprint: approximately 22–30 px.

Required variants:

1. Standard Core,
2. Dense/Large-value Core,
3. Contract-emphasized Core,
4. Elite/high-value Core.

Required construction:

- faceted diamond/crystal center,
- bright inner center,
- orbit arc group,
- controlled gold halo,
- subtle radial pulse.

Variant differentiation:

- orbit count/pattern,
- inner segmentation,
- facet structure,
- secondary gold tone,
- pulse rhythm.

Required states:

- normal,
- highlighted/route-emphasized,
- pickup transition.

## 5.2 Star Chip — Tier B

Gameplay/menu footprint: approximately 20–32 px world, larger in UI.

Required variants:

- Standard Chip,
- Premium/achievement Chip visual treatment.

Construction:

- compact hex/technical token,
- clipped perimeter,
- inner trace,
- small gold core/notch,
- subtle highlight orbit/sweep.

---

# 6. Power-up inventory

Review page:

```text
res://dev/visual_lab/pages/collectibles_powerups.tscn
```

Typical gameplay footprint: 28–38 px, visual halo up to 56–72 px.

## 6.1 Shield — Tier B

Required variants:

- Standard,
- Enhanced/high-value presentation.

Required visual layers:

- center emitter,
- 2–3 broken shield arcs,
- soft cyan field,
- leading bright arc,
- counter-rotating secondary arc.

Pickup VFX:

- cyan ring compression/expansion,
- short white center flash.

## 6.2 Time Warp — Tier B

Required variants:

- Standard,
- Elite/high-value presentation.

Required layers:

- purple outer temporal ring,
- cyan secondary ring,
- offset phase slices,
- central timing/phase mark.

Motion:

- alternating ring rotation,
- slight phase offset,
- non-constant pulse.

## 6.3 Overcharge — Tier B

Required variants:

- Standard,
- Charged/elite presentation.

Required layers:

- magenta energy chamber,
- white-hot center/bolt,
- 3–6 short electrical branches,
- compact halo.

Motion:

- irregular branch variation,
- faster pulse than Shield/Time Warp.

## 6.4 Reserved future power-up visuals — Tier B prototype

Visual slots:

- Core Magnet,
- Stabilizer,
- Phase Shift,
- Emergency Jump.

Minimum variants: 2 each where useful.

These remain visual-only until their gameplay systems are explicitly requested.

---

# 7. Hazard inventory

Review page:

```text
res://dev/visual_lab/pages/hazards_routes.tscn
```

## 7.1 Standard Asteroid — Tier B

Gameplay footprint: 52–76 px.

Minimum final silhouettes: **6**.

Variant set should cover:

- compact rounded fracture,
- tall shard-heavy rock,
- broad double-lobed body,
- major crater body,
- broken-corner body,
- smooth heavy-plane body.

Required geometry per variant:

- irregular 8–12 point outer contour,
- 2–4 internal facets,
- 1–3 cavities/craters,
- sparse crack system,
- darker underside/depth face,
- optional restrained magenta fissure.

Motion variants:

- slow clockwise rotation,
- slow counter-clockwise rotation,
- minimal drift-only where rotation hurts readability.

## 7.2 Heavy Asteroid — Tier B

Gameplay footprint: 96–148 px.

Minimum final silhouettes: **4**.

Required geometry:

- 10–16 point outer contour,
- 4–8 large facet planes,
- 2–5 cavity/crater shapes,
- multi-branch fracture regions,
- deep underside region,
- optional dark-violet mineral plane.

Visual requirement:

Must clearly communicate greater lane occupancy before the player reaches it.

## 7.3 Fast Debris — Tier B

Gameplay footprint: 18–34 px body, longer motion envelope.

Minimum silhouettes: **6**.

Required variants:

- thin shard,
- triangular plate,
- broken beam,
- clipped hull fragment,
- narrow cargo brace,
- asymmetric metal strip.

Required treatment:

- dark metallic body,
- one panel edge,
- tiny warning reflection,
- directional motion streak.

## 7.4 Drifting Debris — Tier B

Gameplay footprint: 30–58 px.

Minimum silhouettes: **6**.

Required variants:

- broad plate,
- broken crate frame,
- curved hull fragment,
- paired plate assembly,
- panel-with-brace,
- broken equipment block.

Motion:

- slow tumble cue,
- lateral drift cue where gameplay state requires it.

## 7.5 Energy Mine — Tier B

Gameplay footprint: 40–58 px; warning envelope may extend to 80–96 px.

Minimum body variants: **3**.

Required states:

- idle/armed,
- warning,
- active/triggering,
- impact/detonation.

Required detail:

- dark mechanical core,
- 6–10 emitter arms,
- segmented warning ring,
- central magenta/red reactor,
- secondary emitter dots,
- distinct warning rhythm.

## 7.6 Laser Gate — Tier B

Gameplay visual width: approximately 120–220 px depending on lane span.

Required variants:

- Standard single beam,
- Wider dual-emitter treatment,
- Elite/contract presentation where design requires it.

Required states:

- inactive/approach,
- charging/warning,
- active,
- impact,
- disabled/fading where applicable.

Pylon detail requirement:

- primary housing,
- secondary panel plane,
- emitter chamber,
- warning indicator,
- structural brace/accent.

Beam detail requirement:

- low-alpha outer field,
- colored beam body,
- near-white narrow core.

## 7.7 Meteor Strike warning — Tier B

Warning footprint: 60–110 px depending on strike size.

Required states:

- initial warning,
- tightening/critical warning,
- strike/impact transition.

Required cues:

- impact ring,
- trajectory line/streak,
- orange warning bracket,
- shrinking/countdown arc or ring compression.

## 7.8 Cargo Wreck — Tier B

Gameplay footprint: 80–160 px depending on wreck type.

Minimum final silhouettes: **4**.

Required variants:

- broken cargo hull,
- torn frame assembly,
- split container structure,
- collapsed shipping-module silhouette.

Required detail:

- recognizable metal structure,
- exposed frame,
- broken panels,
- small amber/orange dead-system indicator,
- clearly non-asteroid silhouette.

## 7.9 Gravity Anomaly — Tier B

Visual envelope: 100–190 px.

Required variants:

- Standard anomaly,
- Elevated-threat variant,
- Elite/event treatment if needed.

Required states:

- dormant/approach,
- active,
- intensified.

Required visual layers:

- dark center well,
- warped cyan/purple arcs,
- irregular orbit ring,
- lensing streaks,
- subtle shader distortion,
- optional danger accent at higher intensity.

---

# 8. Route and extraction inventory

Review page:

```text
res://dev/visual_lab/pages/hazards_routes.tscn
```

## 8.1 Route gates — Tier A/B

Typical visual footprint: 96–160 px per route frame presentation.

Required route identities:

1. Safe Route,
2. Core Field,
3. Danger Route,
4. Contract Bonus,
5. Elite Route.

Shared gate layers:

- paired structural frame,
- open pass-through center,
- semantic energy field,
- route identity glyph/mark,
- subtle directional flow,
- outer selection bracket group.

Required states:

- distant/approach,
- active/readable,
- selected,
- passed/fading,
- unavailable/disabled.

### Safe Route

Colors: green + cyan.

Geometry:

- cleaner/rounder inner frame,
- calmer pulse.

### Core Field

Colors: gold + restrained cyan/white.

Geometry:

- mini-core orbit detail,
- reward-oriented shimmer.

### Danger Route

Colors: magenta/red.

Geometry:

- sharper inner angles,
- warning segmentation.

### Contract Bonus

Colors: purple + cyan.

Geometry:

- technical contract bracket/glyph,
- structured target/mission feel.

### Elite Route

Colors: purple + magenta + restrained gold prestige accent.

Geometry:

- most layered route frame,
- stronger premium hierarchy without excessive brightness.

## 8.2 Extraction Gate — Tier A

Visual footprint: approximately 140–220 px wide × 170–280 px tall depending on camera composition.

Required layers:

- large paired structural columns,
- internal frame depth plane,
- cyan/green energy corridor,
- vertical alignment marks,
- inward-moving lines/particles,
- scan bands,
- success mark/glyph.

Required states:

- incoming/preview,
- available,
- selected,
- extraction active,
- secured/success.

Required animation:

- staged energy activation,
- scan sweep,
- inward pull,
- vertical extraction field,
- successful settle/fade.

---

# 9. Future Courier Hunter encounter visual

Review page:

```text
res://dev/visual_lab/pages/hazards_routes.tscn
```

Quality: Tier A visual prototype.

The Hunter is an encounter visual slot from the game design. It must not cause the AI to introduce player shooting/combat systems.

Required silhouette language:

- aggressive dark angular body,
- broken/hostile framing,
- narrow pursuit profile,
- magenta/red energy channels,
- clear focal sensor/core,
- intercept trajectory marks.

Required visual states when the encounter is eventually implemented:

- distant warning,
- approach/intercept,
- active pursuit,
- threat telegraph,
- exit/defeat state according to actual future gameplay design.

No player bullets, weapon icons, ammo UI, or gun systems belong in this inventory under the current game concept.

---

# 10. VFX inventory

Review page:

```text
res://dev/visual_lab/pages/effects.tscn
```

## 10.1 Spawn — Tier B

Variants:

- normal object spawn,
- premium/route event spawn,
- encounter/elite spawn language.

Required layers:

- segmented ring,
- converging lines,
- center flare,
- optional materialization slice.

## 10.2 Despawn — Tier B

Required treatment:

- reverse/modified ring flow,
- directional fade,
- no simple scale-to-zero only.

## 10.3 Player crash/destruction — Tier A

Required stages:

1. impact flash,
2. reactor burst,
3. major structural separation,
4. small fragment emission,
5. fading energy residue.

Fragments should match ship geometry.

## 10.4 Star Core pickup — Tier B

Required layers:

- gold radial burst,
- collapsing orbit,
- white center flash,
- optional short streak toward UI only if later justified.

## 10.5 Shield impact — Tier B

Required layers:

- collision-side local arc,
- white-cyan flash,
- partial ripple,
- shell-break secondary arc.

## 10.6 Near Miss — Tier B

Required variants:

- normal Near Miss,
- stronger Near Miss presentation where score/state requires it.

Required cues:

- directional cyan slashes,
- compact bracket/ring,
- rapid fade.

## 10.7 Danger Streak — Tier B

Required cues:

- stronger directional slash density,
- controlled magenta accent,
- compact ring/bracket reinforcement.

Must not obscure incoming hazards.

## 10.8 Engine trail — Tier A/B

Required layers:

- purple outer envelope,
- cyan inner plume,
- white/cyan central filament,
- engine-throat pulse.

Required variants:

- Normal,
- Overcharged,
- Time Warp,
- ship-family length/width variation.

## 10.9 Time Warp effect — Tier A

Required layers:

- offset ring groups,
- purple/cyan temporal arcs,
- longitudinal streaks,
- subtle full-screen distortion support,
- ship phase echo.

## 10.10 Overcharge effect — Tier A/B

Required layers:

- magenta branch arcs,
- white hot nodes,
- reactor amplification,
- extended engine trail.

## 10.11 Route selected — Tier B

Required layers:

- four-corner lock bracket,
- route-frame energy sweep,
- center pulse,
- quick settle.

## 10.12 Extraction — Tier A

Required layers:

- cyan/green vertical field,
- inward movement,
- scan bands,
- bright but controlled success peak.

## 10.13 Sector transition — Tier A/B

Required variants:

- standard sector shift,
- high-speed/elite shift.

Required layers:

- streak compression,
- haze/color interpolation,
- route-line distortion,
- sector accent arrival.

## 10.14 Threat pulse — Tier B

Required layers:

- segmented red/magenta ring/frame,
- controlled repetition,
- no full-screen opaque flash.

## 10.15 New Record — Tier B

Required layers:

- gold radial structure,
- small star/core shards,
- staged expansion/hold/fade.

## 10.16 Achievement — Tier B

Required layers:

- purple/gold structured burst,
- badge emphasis,
- controlled premium reveal.

## 10.17 Mastery / Reputation — Tier A/B

Required layers:

- purple/cyan structural chevrons/arcs,
- restrained gold prestige layer,
- deliberate staged motion.

---

# 11. Shader inventory

Current production path:

```text
res://shaders/visual/
```

## 11.1 `space_background.gdshader`

Quality target: Tier A support shader.

Responsibilities:

- procedural deep-space field,
- non-repeating variation,
- star/background energy support,
- sector-aware parameters.

## 11.2 `sector_grade.gdshader`

Responsibilities:

- sector tint,
- vignette,
- intensity presets,
- restrained atmosphere shifts.

## 11.3 `neon_energy.gdshader`

Responsibilities:

- shared energy edge/core behavior,
- glow falloff,
- pulse parameters,
- reuse across multiple object families.

## 11.4 `time_warp.gdshader`

Responsibilities:

- short-duration temporal distortion,
- UV/radial displacement,
- intensity controls,
- reduced-motion-compatible fallback path.

## 11.5 `ui_panel.gdshader`

Responsibilities:

- subtle panel depth,
- restrained scan/grid treatment,
- selected/active energy response where useful.

## 11.6 Future shared shader extensions

Add only when implementation proves they are necessary:

- shield field/refraction,
- gravity anomaly lensing,
- hazard beam refinement,
- holographic route field.

Do not create one shader file per object variant.

---

# 12. UI screen inventory

Review page:

```text
res://dev/visual_lab/pages/ui.tscn
```

All UI follows the procedural panel/button system and canonical fonts/icons.

## 12.1 Splash / Brand — Tier A

Required:

- STARFALL COURIER wordmark treatment,
- subtle space-field background,
- restrained cyan/purple route motif,
- no generic loading spinner unless product flow requires it.

## 12.2 Main Menu — Tier A

Required modules:

- brand/title region,
- primary Play action,
- mode/navigation actions,
- profile/progression summary,
- settings access,
- subtle animated background.

## 12.3 Gameplay HUD — Tier A

Required modules:

- distance,
- combo/multiplier,
- Star Core count/value,
- active power-up state,
- contract/objective strip when relevant,
- Threat representation when relevant,
- pause control,
- route-choice presentation when active.

HUD rules:

- minimal screen occupancy,
- high numerical readability,
- thin technical frames,
- avoid menu-card styling during gameplay.

## 12.4 Route Choice UI — Tier A

Required:

- Safe/Core/Danger/Contract/Elite identity support,
- selected/locked state,
- readable benefit/risk summary according to actual gameplay data,
- synchronized visual language with route gates.

## 12.5 Extraction Decision — Tier A

Required:

- strong extraction identity,
- clear continue/extract decision hierarchy,
- green/cyan success semantics,
- risk continuation semantics if applicable to actual design.

## 12.6 Contracts — Tier B

Required states:

- available,
- active,
- progress,
- completed,
- failed/expired where design supports it,
- locked.

Card detail:

- contract icon/glyph,
- objective title,
- progress metric,
- reward,
- status edge.

## 12.7 Hangar / Ship Selection — Tier A/B

Required:

- large ship showcase region,
- ship identity/name,
- selection state,
- progression/mastery information,
- visual comparison without clutter.

## 12.8 Upgrades — Tier B

Required states:

- available,
- affordable,
- selected,
- purchased,
- locked/maxed.

## 12.9 Missions — Tier B

Required:

- mission card,
- progress rail,
- reward badge,
- completed state.

## 12.10 Achievements — Tier B

Required:

- locked/unlocked,
- progress where supported,
- achievement badge,
- reward/prestige presentation.

## 12.11 Statistics — Tier B

Required:

- strongest run,
- distance,
- Star Cores,
- Near Miss metrics,
- route/sector performance according to actual stored stats.

Visual style:

- data-first,
- technical hierarchy,
- limited decorative glow.

## 12.12 Pause — Tier B

Required:

- Resume,
- Restart/End Run as actual product flow dictates,
- Settings,
- Exit/Back,
- clear gameplay-dim layer.

## 12.13 Run Summary — Tier A

Required:

- distance/result hero metric,
- reward/core summary,
- combo/Near Miss highlights,
- contract result,
- records/achievements,
- progression/mastery result,
- next action.

## 12.14 Settings — Tier B

Required reusable controls:

- toggle,
- slider,
- selector,
- sound/music controls,
- motion/accessibility controls when implemented,
- reset/confirm patterns.

## 12.15 Tutorial / Onboarding — Tier B

Required:

- lane-movement cue,
- Star Core cue,
- hazard warning cue,
- route-choice cue,
- power-up cue,
- concise text panel.

Use actual game concepts only; do not teach shooting.

---

# 13. UI component inventory

## 13.1 Buttons

Required variants:

- Primary,
- Secondary,
- Danger,
- Success/Confirm when needed,
- Icon-only,
- Tab,
- Compact chip.

Required states:

- idle,
- hover/focus,
- pressed,
- selected,
- disabled.

## 13.2 Panels / containers

Required variants:

- gameplay micro-panel,
- menu panel,
- modal/dialog,
- card,
- hero summary panel.

## 13.3 Progress / status

Required:

- segmented progress bar,
- continuous energy rail,
- mastery/reputation progress,
- mission/contract progress,
- Threat indicator,
- power-up state timer/charge representation if gameplay needs it.

## 13.4 Badges / chips

Required:

- route identity,
- rarity/value,
- completed,
- locked,
- new,
- elite,
- record.

## 13.5 Notification system

Required variants:

- small gameplay notification,
- reward notification,
- achievement/record banner,
- warning notification,
- contract progress update.

---

# 14. Typography and icon inventory

## 14.1 Text font

Canonical file:

```text
res://assets/fonts/text/oxanium/Oxanium[wght].ttf
```

Required weight roles:

- light/regular for support text,
- medium/semi-bold for standard UI,
- bold/heavy for primary HUD/results/branding.

Do not introduce additional permanent text families without explicit visual-system revision.

## 14.2 Icon font

Canonical file:

```text
res://assets/fonts/icons/material_symbols/MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf
```

Required semantic icon set includes:

- Play,
- Pause,
- Back,
- Close,
- Confirm,
- Settings,
- Audio,
- Music,
- Haptics if implemented,
- Contracts,
- Hangar/ship,
- Upgrades,
- Missions,
- Achievements,
- Statistics,
- Shield,
- Time Warp,
- Overcharge,
- Warning,
- Lock,
- Route,
- Extraction,
- Reward,
- Record.

Custom procedural game-specific glyphs may be used for route identity/Star Core symbols when the generic icon font is not appropriate.

---

# 15. Animation-state inventory

All significant assets should support explicit state-driven animation rather than unrelated always-on motion.

## Common animation categories

- Idle/Breathing,
- Approach,
- Warning,
- Active,
- Selected,
- Impact,
- Pickup,
- Transition,
- Success,
- Disabled/Fade,
- Destroyed.

Not every family uses every state.

### Timing quality rule

Visual effects should be short enough for a fast arcade game. Long cinematic animation belongs only in menus/results/major transitions where gameplay is not being obscured.

---

# 16. Visual-lab coverage requirements

The final lab should evolve from simple cards into comparison-oriented production review.

## Backgrounds page

Must compare:

- all five sectors,
- at least Calm/Standard/Threat intensity,
- background contrast behind sample player/hazard/reward markers.

## Ships page

Must compare:

- all seven silhouettes in monochrome and full material color,
- Courier states,
- normal gameplay size and enlarged inspection size,
- crash animation.

## Collectibles + Power-ups page

Must compare:

- Star Core variants,
- Star Chip,
- all core power-ups,
- reserved future slots clearly labeled,
- normal size and enlarged inspection size.

## Hazards + Routes page

Must compare:

- all asteroid variants,
- debris variants,
- mine states,
- laser states,
- meteor warning stages,
- cargo wreck silhouettes,
- anomaly states,
- route gate identities/states,
- extraction gate,
- Courier Hunter prototype.

## Effects page

Must compare:

- all effect families,
- loops where appropriate,
- short effects automatically replayed,
- reduced-motion feasibility notes.

## UI page

Must compare:

- typography scale,
- button families/states,
- HUD modules,
- panels/cards,
- progress/status components,
- route-choice UI,
- summary/result presentation,
- icon font availability.

---

# 17. Required QA gates

A visual is not production-ready until it passes these checks.

## 17.1 Silhouette

- reads immediately,
- works against all sector backgrounds,
- does not rely on glow.

## 17.2 Detail hierarchy

- primary form dominates,
- secondary detail supports identity,
- micro-detail does not create noise.

## 17.3 Color semantics

- uses canonical semantic meaning,
- critical states do not rely on color alone.

## 17.4 Motion

- animation supports function,
- warning/active differences are obvious,
- loops avoid aggressive flashing,
- reduced-motion path is possible.

## 17.5 Gameplay clarity

- glow does not imply collision size,
- decorative background objects cannot be mistaken for hazards,
- route information remains visible during VFX,
- player remains highest-priority moving object.

## 17.6 Technical

- parses/loads in Godot 4.7.1 CI,
- no missing required resource references,
- no shader errors,
- no production dependency on `dev/`,
- reasonable Compatibility-renderer behavior until renderer policy changes.

---

# 18. Production implementation priority

This is an art-production priority, not a gameplay roadmap.

## Visual Pass 1 — Hero language

Refine first:

1. Courier ship,
2. Standard Asteroid,
3. Star Core,
4. Shield/Time Warp/Overcharge,
5. Courier Corridor background,
6. Safe/Core/Danger route gates,
7. gameplay HUD,
8. engine trail,
9. Near Miss,
10. crash/destruction.

Goal: prove the premium v1 language on the most frequently seen objects.

## Visual Pass 2 — Family expansion

Then refine:

- remaining sectors,
- ship family silhouettes,
- asteroid/heavy-asteroid variants,
- debris families,
- Mine,
- Laser Gate,
- Meteor warning,
- Cargo Wreck,
- Gravity Anomaly,
- Contract/Elite routes,
- extraction,
- full power-up family.

## Visual Pass 3 — Product UI and polish

Then refine:

- full menus,
- contracts,
- hangar,
- upgrades,
- missions,
- achievements,
- stats,
- run summary,
- notifications,
- prestige/mastery presentation,
- reduced-motion variants,
- performance polish.

---

# 19. Explicit exclusions under current game concept

Do not create as standard production inventory:

- player guns,
- player bullets,
- ammo pickups,
- weapon upgrade UI,
- aiming reticles,
- combat damage numbers,
- generic enemy-wave shooter families,
- free-flight joystick UI.

The repository name is legacy. Starfall Courier remains a three-lane courier survival game unless the canonical game concept is explicitly revised.

---

# 20. AI implementation rule

For any future visual task:

1. read `docs/game_design/game_concept_v0.md`,
2. read `docs/visual_design/visual_system_v0.md`,
3. read `docs/visual_design/asset_drawing_system_v1.md`,
4. read this inventory,
5. inspect existing production renderer/shader code,
6. refine the existing family instead of creating parallel art systems,
7. update the relevant visual-lab page,
8. run GitHub/Godot validation,
9. visually inspect at gameplay scale,
10. report remaining quality gaps.

The final product goal is not to maximize the number of visual objects. The goal is to make every required visual family **distinct, layered, coherent, readable, and commercially polished**.