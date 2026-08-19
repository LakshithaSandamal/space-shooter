# Starfall Courier — Game Concept v0

> Canonical product and gameplay design source for AI agents and developers.

## Document status

- Version: `v0`
- Status: Concept baseline
- Engine context: Godot 4.7
- Platform orientation: portrait-mode mobile
- Genre: sci-fi arcade survival / courier runner
- Canonical game name: **Starfall Courier**
- Repository name may still be `space-shooter`, but the game is **not a combat-focused space shooter**.

## How AI agents must use this document

This file defines **what game we are building**.

Use the other project documents for **how to implement it**:

- `docs/godot_architecture.md` — architecture and scene-design rules.
- `docs/node_selection_guide.md` — Godot node-selection rules.
- `instructions/godot_ai_instructions.md` — coding-agent operating rules.

When these files are used together:

1. This document has authority over game identity, gameplay, progression, content, theme, and player experience.
2. Architecture documents have authority over implementation structure.
3. Do not invent gameplay that changes the identity described here.
4. Do not implement future systems merely because they appear in this design document. Build only the stage requested by the user.
5. Values explicitly described as examples, recommendations, or future ideas are tunable and must not be treated as immutable requirements without user confirmation.
6. Preserve the strongest design rule:

> **Add depth around the original gameplay — never replace the original gameplay.**

---

# 1. Product identity

**Starfall Courier** is a portrait-mode sci-fi arcade survival game where the player pilots a futuristic courier ship through dangerous interstellar shipping routes.

The player is **not a soldier**. The player is a professional courier transporting valuable cargo through unstable space.

The experience should feel:

- fast,
- clean,
- skill-based,
- premium,
- easy to understand,
- difficult to master,
- highly replayable,
- suitable for short mobile sessions.

Core fantasy:

> **You are carrying valuable cargo through dangerous space routes where every lane decision matters.**

The game must not drift into military sci-fi, horror, or comedy. Its identity is a premium futuristic transportation network operating through beautiful but dangerous deep space.

---

# 2. Non-negotiable gameplay pillars

These are the strongest constraints for every future implementation decision.

## 2.1 Three-lane movement is the core control model

The playfield has three lanes:

```text
LEFT
CENTER
RIGHT
```

Input is deliberately simple:

```text
tap left side  -> move one lane left
tap right side -> move one lane right
```

The ship continuously travels forward while the world moves toward the player.

Do not replace this with free-flight controls, twin-stick controls, aiming controls, or combat controls unless the user explicitly changes the design.

## 2.2 Survival and navigation, not shooting

The player survives by:

- reading patterns,
- changing lanes,
- collecting rewards,
- choosing risk,
- using power-ups,
- timing decisions.

Combat is not the core mechanic.

Even the future Courier Hunter encounter is escaped by dodging telegraphed lane attacks rather than shooting the enemy.

## 2.3 Fairness

Every generated hazard pattern must always leave at least one survivable route.

Difficulty should come from:

- timing,
- speed,
- pattern reading,
- decision making.

It must not come from unavoidable random combinations.

## 2.4 Depth must wrap around simplicity

Long-term systems may add strategy, progression, and replayability, but they must not complicate the basic lane-control language.

The game should remain immediately understandable.

---

# 3. Core gameplay loop

```text
Dodge hazards
    ↓
Collect Star Cores
    ↓
Build combo
    ↓
Use power-ups
    ↓
Survive farther
    ↓
Choose dangerous or safe routes
    ↓
Complete objectives
    ↓
Earn rewards
    ↓
Upgrade career
    ↓
Start another run
```

Immediate goal:

> Travel as far as possible without crashing.

Long-term goal:

> Become the highest-ranked courier by completing dangerous routes, mastering ships, earning Star Chips, completing contracts, and surviving deeper sectors.

---

# 4. Run structure and pacing

Typical run target:

- normal run: approximately **2–6 minutes**
- skilled run: approximately **6–12+ minutes**

A run starts simple and becomes increasingly demanding.

As distance grows:

- world speed increases,
- hazard density increases,
- new hazard types appear,
- patterns become harder,
- sector mechanics change,
- rewards become more valuable,
- risk/reward choices become more important.

Threat should not remain at maximum intensity continuously. Pressure should rise and fall to create pacing.

---

# 5. Distance system

Distance is a primary measure of player skill and run progression.

Example milestones:

```text
250 m
500 m
750 m
1000 m
1500 m
2500 m
5000 m
```

Distance may drive:

- difficulty,
- sector transitions,
- event frequency,
- contract objectives,
- reward multipliers,
- hazard unlocks,
- record tracking.

These milestone numbers are examples and may be tuned during balancing.

---

# 6. Star Cores

**Star Cores** are the main collectible inside a run.

Collecting a Star Core:

- increases score,
- increases combo,
- contributes to missions,
- increases run rewards,
- produces satisfying visual/audio feedback.

Star Cores should sometimes be placed in risky positions so the player must choose between a safer lane and a more valuable lane.

That risk/reward tension is intentional.

---

# 7. Combo system

Each collected Star Core increases combo.

Example progression:

```text
x1
x2
x3
x4
x5
...
x20+
```

Example scoring relationship:

```text
Core base value = 100

x1  -> 100
x5  -> 500
x10 -> 1000
```

Combo uses a grace timer. If another Core is not collected in time, combo returns toward its base value.

Purpose:

> Encourage aggressive but skillful routing without adding new controls.

Exact scoring and decay values are balancing parameters, not locked implementation constants.

---

# 8. Near-Miss system

Near Misses are a major mastery mechanic.

If the player passes extremely close to a hazard without colliding:

```text
NEAR MISS
```

Possible rewards:

- bonus score,
- combo stability,
- mission progress,
- additional run reward potential.

Repeated near misses may create named streaks such as:

```text
CLOSE CALL
DANGER STREAK
EDGE RUN
```

Near Misses add high-skill depth while preserving the original control scheme.

---

# 9. Power-ups

## 9.1 Shield — core

Protects against one collision.

After the protected hit:

- Shield disappears,
- ship receives brief invulnerability,
- strong impact feedback plays.

Visual identity: **cyan**, circular/protective energy language.

## 9.2 Time Warp — core

Temporarily slows hazards and world movement while player lane movement stays responsive.

Useful during:

- dense patterns,
- emergencies,
- advanced sectors.

Visual identity: **purple/blue**, temporal ring/clock/distortion language.

## 9.3 Overcharge — core

Temporarily increases scoring power.

Recommended effects:

- Star Core score ×2,
- Near-Miss score ×2.

It should encourage high-risk play.

Visual identity: **magenta**, lightning/energy-burst language.

## 9.4 Future power-up candidates

Do not implement until explicitly requested.

- **Core Magnet** — pulls nearby Star Cores toward the player.
- **Stabilizer** — pauses combo decay temporarily.
- **Phase Shift** — very short hazard immunity.
- **Emergency Jump** — rare automatic rescue before a lethal hit.

Future additions should be introduced gradually.

---

# 10. Hazard catalogue

Hazards should remain readable and telegraphed.

## Standard Asteroid

Basic, readable, predictable obstacle.

## Heavy Asteroid

Larger and slower; blocks more lane space.

## Fast Debris

Small and fast; tests reaction speed.

## Drifting Debris

Moves horizontally between lanes; tests prediction.

## Energy Mine

Telegraphs before activation.

## Laser Gate

Temporarily blocks lanes with a strong warning before activation.

## Meteor Strike

Shows a warning marker before impact.

## Cargo Wreck

Large wreckage creating complex openings.

## Gravity Anomaly

Changes surrounding hazard movement but must never make controls feel unfair.

---

# 11. Sector progression

All sectors belong to the same Starfall visual universe. They should feel like variations of one coherent transportation network, not separate games.

## Sector 1 — Courier Corridor

Introductory shipping region.

Features:

- standard asteroids,
- simple debris,
- Star Cores,
- basic power-ups.

Visual emphasis: deep navy + cyan.

## Sector 2 — Wreck Belt

Destroyed transport region.

Adds:

- drifting debris,
- wreckage,
- moving gaps,
- narrower safe routes.

Visual emphasis: dark purple + damaged orange/gold detail.

## Sector 3 — Ion Reach

Electromagnetically unstable region.

Adds:

- energy mines,
- lane warning pulses,
- power-up-heavy gameplay,
- more Time Warp opportunities.

Visual emphasis: blue/cyan electrical energy.

## Sector 4 — Solar Rift

High-energy region.

Adds:

- meteor strikes,
- solar surges,
- shorter reaction windows,
- faster patterns.

Visual emphasis: gold/orange energy + magenta warning signals.

## Sector 5 — Void Passage

Late-game mastery region.

Combines:

- complex hazard combinations,
- anomalies,
- elite events,
- high-value Core sequences.

Visual emphasis: almost-black environment + violet/cyan anomalies.

After Void Passage, advanced sector variants may repeat with increasing difficulty.

---

# 12. Route-choice system

At selected distance checkpoints, the player can choose between routes simply by occupying a lane.

Example:

```text
LEFT
SAFE ROUTE
Lower danger
Lower reward

CENTER
CORE FIELD
More Star Cores
Medium danger

RIGHT
DANGER ROUTE
High danger
High reward
```

No extra buttons are required.

Possible route modifiers include:

- increased Star Core spawn,
- longer combo timer,
- more power-ups,
- increased Star Chip reward,
- increased Near-Miss reward,
- increased hazard speed,
- elite encounter chance,
- contract bonus.

Route choices are a major source of run variety and risk/reward decision making.

---

# 13. Courier contracts

Contracts add objective-based goals beyond endless survival.

Examples:

## Standard Delivery

Reach a target distance such as `1000 m`.

## Fragile Cargo

Reach the target without losing Shield protection.

## Core Shipment

Collect a required number of Star Cores.

## Express Delivery

Reach a distance target while starting at increased speed.

## Hazard Route

Complete a required number of Near Misses before reaching the destination.

Contracts may reward:

- Star Chips,
- reputation,
- progression,
- long-term goals.

---

# 14. Extraction system

After a contract objective is complete, an extraction gate may appear.

The player chooses:

## Extract

Safely finish the contract and secure the reward.

## Continue

Keep flying for an increased reward multiplier.

If the player crashes after choosing to continue, part of the bonus may be lost.

This is an intentional risk/reward decision.

---

# 15. Threat Level

A run has an internal Threat Level:

```text
THREAT 1
THREAT 2
THREAT 3
THREAT 4
THREAT 5
```

Threat may increase through:

- distance,
- dangerous route choices,
- advanced sectors,
- contract difficulty.

Threat may influence:

- hazard density,
- pattern complexity,
- speed,
- elite events.

Threat should rise and fall somewhat to create pacing rather than continuous maximum pressure.

Exact thresholds are balancing details to be designed later.

---

# 16. Elite events

High-threat runs may trigger short special events.

Examples:

## Debris Storm

Dense survival sequence.

## Hunter Sweep

Enemy drones attack specific lanes with warnings.

## Collapse Corridor

Safe lane changes repeatedly.

## Core Surge

Large quantities of Star Cores appear inside dangerous patterns.

Elite events should create memorable moments without converting the game into a combat game.

---

# 17. Future major encounter

A future major encounter may feature a **Courier Hunter**.

The player does not shoot it.

Pattern:

```text
telegraph
    ↓
lane attack
    ↓
player dodges
    ↓
hunter repositions
    ↓
new pattern
```

Victory means escaping the Hunter.

This encounter must preserve the courier identity.

---

# 18. Persistent currency — Star Chips

**Star Chips** are the long-term currency.

Possible sources:

- distance,
- Star Cores,
- missions,
- contracts,
- achievements,
- Near-Miss streaks,
- successful extraction,
- major events.

Star Chips are used for permanent progression.

---

# 19. Permanent upgrades

Core upgrade categories:

## Core Value

Improves Core rewards.

## Handling

Improves lane-change responsiveness.

## Time Warp

Increases duration.

## Overcharge

Increases duration.

## Starting Combo

Starts runs at a higher combo level.

The source concept recommends approximately five meaningful levels per upgrade. That number is tunable.

---

# 20. Ships

Ships should create meaningful gameplay differences.

## Courier

Balanced default ship.

## Interceptor

High mobility and faster lane changes; suited to aggressive play.

## Phantom

Defensive specialist with better protection/survival.

## Future ship concepts

Do not implement until requested.

- **Hauler** — slower handling, higher contract rewards.
- **Vector** — better Near-Miss bonuses.
- **Eclipse** — longer power-up effects.
- **Pathfinder** — improved route rewards/choices.

---

# 21. Ship mastery

Each ship gains mastery while used.

Example:

```text
Courier Mastery 1–10
```

Potential mastery rewards:

- Star Chips,
- ship-specific bonuses,
- statistics,
- prestige markers.

Purpose:

> Encourage players to use multiple ships.

---

# 22. Courier reputation

The player has an overall career rank.

Reputation can increase through:

- contracts,
- reaching new sectors,
- missions,
- achievements,
- difficult-route survival.

Higher reputation may unlock:

- advanced contracts,
- new ships,
- new sectors,
- challenge modes.

Progression fantasy:

```text
Unknown Courier
    ↓
Reliable Runner
    ↓
Sector Specialist
    ↓
Elite Courier
    ↓
Deep Route Veteran
    ↓
Legendary Starfall Courier
```

The player should feel increasingly skilled and prestigious, not merely numerically stronger.

---

# 23. Missions

Approximately three active missions at once is considered enough in the source concept.

Mission candidates:

- Core Hunter,
- Deep Space,
- Combo Ace,
- Shield User,
- Near Miss Master,
- Route Specialist,
- Contract Courier,
- Power Surge,
- Sector Survivor.

Mission details and exact reward values remain future balancing/design work.

---

# 24. Achievements

Examples:

```text
First Flight
Collect 100 Cores
Collect 1000 Cores
Reach 1000 m
Reach 5000 m
Reach x10 Combo
Reach x25 Combo
Complete 10 Contracts
Complete 50 Contracts
100 Near Misses
Survive Threat Level 5
Reach Void Passage
```

Achievements should mainly award:

- Star Chips,
- Reputation XP,
- completion progression.

---

# 25. Statistics

Track long-term performance such as:

- best score,
- best distance,
- highest combo,
- total runs,
- total distance,
- total Star Cores,
- Near Misses,
- contracts completed,
- power-ups collected,
- shield saves,
- sector records,
- ship usage,
- playtime.

---

# 26. Game modes

## Courier Run

Primary endless arcade mode.

## Contract Run

Objective-based delivery mode.

## Deep Run

Starts in a harder sector with larger rewards.

## Challenge Run

Special rules may include:

- double speed,
- no Shield,
- Core Storm,
- one lane temporarily disabled,
- high starting Threat.

Modes beyond the requested implementation stage must not be scaffolded prematurely.

---

# 27. Visual identity

Theme:

> **Premium Neon Deep-Space Courier**

The majority of the screen should remain dark, with color reserved for important gameplay information.

Core visual relationship:

```text
dark space
+
white ship
+
purple structure
+
cyan energy
+
gold rewards
+
magenta danger
```

The style should feel:

- sleek,
- mysterious,
- futuristic,
- calm between danger,
- fast during gameplay,
- technologically advanced,
- premium.

It should not feel:

- military,
- horror,
- cartoon-comedy,
- generic Material Design.

---

# 28. Color language

## Purple — Starfall identity

Use for:

- branding,
- important UI outlines,
- ship accents,
- selected states.

## Cyan — energy and movement

Use for:

- engines,
- Shield,
- active elements,
- navigation,
- important HUD values.

## Magenta / Pink — danger and intensity

Use for:

- hazards,
- warnings,
- Overcharge,
- dangerous routes.

## Gold — value and reward

Use for:

- Star Cores,
- Star Chips,
- contract rewards,
- rare opportunities.

## Green — success

Use for:

- completed contracts,
- unlocked items,
- successful claims,
- extraction.

## White — primary readability

Use for:

- headings,
- important numbers,
- primary ship surfaces.

---

# 29. Background style

Use:

- almost-black navy,
- sparse stars,
- soft nebula gradients,
- occasional distant planets,
- faint space dust,
- subtle geometric route lines,
- occasional distant shipping lights.

Avoid:

- huge bright planets dominating gameplay,
- giant blurred circles,
- overly colorful galaxy backgrounds,
- background effects that compete with hazards.

Gameplay objects must always be easiest to read.

---

# 30. Ship art direction

Ships should have:

- sharp aerodynamic silhouette,
- strong central nose,
- white/light metallic center,
- neon purple framing,
- cyan energy core,
- visible engine glow,
- compact mobile-readable proportions.

They should feel futuristic but not overly realistic.

Silhouette readability at gameplay scale is more important than tiny detail.

---

# 31. Hazard art direction

Hazards should use darker body colors than the player.

Asteroids:

- dark violet,
- charcoal,
- subtle magenta edges,
- small glowing cracks.

Energy hazards:

- stronger magenta/red,
- clear telegraphs,
- brighter active state.

Danger must be recognizable immediately.

---

# 32. Star Core art direction

Star Cores should be among the most attractive objects in the game.

Appearance:

- gold/yellow central energy,
- compact circular or crystal-like form,
- subtle glow,
- bright center,
- clean silhouette.

The visual goal is to make the player naturally want to collect them.

---

# 33. UI identity

UI direction:

> **Premium futuristic courier cockpit interface**

Use:

- dark transparent panels,
- rounded rectangles,
- thin neon borders,
- controlled glow,
- compact spacing,
- strong typography,
- clear icons,
- gradient primary actions.

Avoid:

- giant empty cards,
- too many outlined boxes,
- excessive padding,
- oversized menu elements,
- generic Material Design,
- bright backgrounds,
- excessive glassmorphism.

---

# 34. Typography

Headings:

- uppercase,
- geometric,
- futuristic,
- bold.

Labels:

- small,
- spaced,
- muted.

Numbers:

- highly readable,
- brighter,
- slightly larger than labels.

Target feeling: similar to an Orbitron-style futuristic interface without sacrificing mobile readability.

---

# 35. Main menu

The main menu should prominently show:

```text
STARFALL
COURIER
```

The selected ship is the primary visual focus.

The **PLAY** action should dominate.

Secondary destinations may include:

- Contracts,
- Hangar,
- Upgrades,
- Missions,
- Stats.

The menu should feel like a spacecraft flight terminal, not a mobile settings page.

---

# 36. Gameplay HUD

Keep the gameplay screen visually clean.

Top HUD:

```text
Pause | Distance | Combo | Cores
```

Rules:

- active power-ups appear only when active,
- bottom lane indicators remain subtle,
- contract objective appears only when relevant,
- center of screen belongs to gameplay.

---

# 37. Route-choice presentation

Route gates should appear directly inside the playfield.

Examples:

```text
SAFE
CORE FIELD
DANGER
```

Color cues:

- Safe -> cyan/green,
- Reward -> gold,
- Danger -> magenta.

A route choice should be understandable within about one second.

---

# 38. Animation and motion feel

Movement should feel:

- smooth,
- fast,
- controlled,
- responsive.

Lane changes should be short and crisp.

Hazards should be predictable/readable.

Collectibles should use gentle float/pulse motion.

Power-ups may use a stronger pulse.

Important events may use short cinematic emphasis but must not interrupt play.

---

# 39. VFX direction

Recommended effects:

- engine trails,
- Core collection burst,
- short Shield impact ring,
- Time Warp distortion,
- Overcharge energy streak,
- Near-Miss flash,
- route-gate pulse,
- sector transition streak,
- collision burst,
- short screen shake.

Avoid constant heavy glow.

The brightest effects should correspond to the most important gameplay information.

---

# 40. Audio direction

Music:

- atmospheric synth,
- futuristic,
- calm baseline,
- gradually increasing intensity,
- not aggressive military music.

SFX:

- short,
- clean,
- electronic,
- satisfying,
- easily distinguishable.

Important sound events:

- lane move,
- Core pickup,
- combo increase,
- Near Miss,
- Shield impact,
- Time Warp,
- Overcharge,
- route selection,
- contract complete,
- crash,
- new record.

---

# 41. Target emotional loop

The intended player experience is:

```text
“I can understand this immediately.”
    ↓
“I nearly hit that asteroid.”
    ↓
“I want that Core.”
    ↓
“I can maintain this combo.”
    ↓
“I can survive the dangerous route.”
    ↓
“I can finish this contract.”
    ↓
“I can go farther next run.”
```

This emotional progression is more important than adding feature quantity.

---

# 42. AI implementation guardrails

Any AI agent working on this repository must preserve these rules.

## Never silently change the game into a shooter

Do not add:

- player guns,
- firing controls,
- ammo systems,
- damage-focused combat loops,
- enemy health/combat progression,

unless the user explicitly requests a design change.

## Do not replace lane movement with free movement

The default player controller is discrete three-lane movement.

## Do not implement the entire design document at once

This file describes the full direction, not the next task.

Implement only the requested milestone.

## Protect fairness

Procedural generation must be designed so at least one route is survivable.

When future procedural patterns are implemented, pattern validation is a gameplay requirement, not optional polish.

## Treat presentation as gameplay readability

VFX, color, animation, backgrounds, and UI must never obscure:

- lane state,
- hazards,
- warnings,
- collectibles,
- route choices.

## Preserve risk/reward

Star Cores, Near Misses, route choices, contracts, extraction, and Threat all exist to make the player choose between safety and value.

Do not flatten these systems into automatic rewards with no meaningful decision.

---

# 43. Core vs future scope map

This section exists to stop AI agents from confusing the full vision with immediate implementation scope.

## Core identity / foundation

- portrait orientation,
- three lanes,
- tap-left/tap-right lane switching,
- continuous forward travel,
- world moving toward the player,
- dodging,
- Star Cores,
- score/distance,
- escalating difficulty,
- fairness rule,
- premium neon courier identity.

## Major gameplay systems in the full concept

- combo,
- Near Misses,
- Shield,
- Time Warp,
- Overcharge,
- multiple hazards,
- sectors,
- route choices,
- contracts,
- extraction,
- Threat Level,
- elite events,
- Star Chips,
- permanent upgrades,
- multiple ships,
- ship mastery,
- reputation,
- missions,
- achievements,
- statistics,
- multiple modes.

## Explicit future candidates

- Core Magnet,
- Stabilizer,
- Phase Shift,
- Emergency Jump,
- Courier Hunter major encounter,
- Hauler,
- Vector,
- Eclipse,
- Pathfinder,
- advanced repeating sector variants.

Presence in this document is **not permission to prebuild these systems**.

---

# 44. Final vision

**Starfall Courier** should evolve from a simple three-lane arcade game into a deeper replayable courier-career game without losing its original simplicity.

Final identity:

> **A premium neon deep-space arcade courier game where simple lane controls support increasingly deep skill, contracts, route decisions, sector progression, risk/reward mastery, and long-term career progression.**

Strongest rule:

> **Add depth around the original gameplay — never replace the original gameplay.**
