# Starfall Courier — Visual Design Index

This directory contains the canonical visual-art direction and production inventory for Starfall Courier.

Godot does not scan this documentation because the parent `docs/` directory contains `.gdignore`.

## Current read order

For any visual, UI, animation, VFX, shader, or procedural-art task, read:

1. `../game_design/game_concept_v0.md` — what the game is and what gameplay is allowed.
2. `visual_system_v0.md` — semantic palette, sizing baseline, typography/icon policy, procedural-first visual direction.
3. `asset_drawing_system_v1.md` — **how production assets must be drawn and polished**.
4. `final_visual_inventory_v1.md` — **what final visual families, variants, states, animations, and QA coverage must exist**.
5. `../godot_architecture.md` — how production code/scenes are structured.
6. `../node_selection_guide.md` — which Godot nodes fit each requirement.
7. `../../instructions/visual_ai_instructions.md` — AI operating rules for visual work.
8. Existing affected code and the relevant `dev/visual_lab/` page.

The user's current explicit task always defines what should be implemented now.

---

## Current canonical files

### `visual_system_v0.md`

Defines the base Starfall visual system:

- procedural/vector/canvas-first rendering,
- 720 × 1280 portrait reference,
- semantic colors,
- typography and icon-font policy,
- base sizes,
- sectors,
- UI/VFX/shader direction.

This remains the semantic foundation.

### `asset_drawing_system_v1.md`

Defines the senior production drawing standard:

- silhouette hierarchy,
- structural planes,
- material separation,
- functional accents,
- controlled glow,
- detail-density budgets,
- sector-specific background construction,
- ship anatomy and family differentiation,
- collectible/power-up construction,
- hazard detailing,
- route/extraction/Hunter drawing language,
- VFX timing and motion grammar,
- shader discipline,
- premium UI construction,
- typography/icon use,
- procedural implementation rules,
- anti-patterns and QA checklist.

Use this file when an asset feels too simple or prototype-like.

### `final_visual_inventory_v1.md`

Defines the final production inventory:

- all supported visual families,
- target sizes,
- minimum variant counts,
- required states,
- animation requirements,
- quality tiers,
- production ownership,
- visual-lab coverage,
- QA gates,
- explicit exclusions under the current game concept.

Use this file to determine whether the final product has complete visual coverage.

---

## Historical files

### `final_visual_inventory_v0.md`

Initial implementation manifest used to create the first procedural visual lab.

Keep it for history/reference, but **new visual work should follow `final_visual_inventory_v1.md`**.

`v1` deliberately demands richer geometry, stronger materials, more variants, better state differentiation, and more rigorous visual QA than `v0`.

---

## Production paths

Reusable procedural visual code:

```text
res://scripts/visuals/
```

Shared shaders:

```text
res://shaders/visual/
```

Visual review/test harness:

```text
res://dev/visual_lab/
```

Production code must never depend on `dev/`.

---

## Core art rule

> Do not improve a simple visual by adding random glow or noise. Improve it through stronger silhouette, layered structure, material hierarchy, functional detail, and deliberate motion.

---

## Game-scope guardrail

The visual inventory must not silently change gameplay.

Under the current design, do not add standard production inventory for:

- player guns,
- player bullets,
- ammunition,
- weapon upgrade UI,
- aiming systems,
- generic shooter enemy waves,
- free-flight controls.

Starfall Courier is a courier-survival game. The visual system should deepen that identity rather than convert it into a shooter.