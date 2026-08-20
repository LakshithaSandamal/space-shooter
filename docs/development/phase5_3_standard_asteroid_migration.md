# Phase 5.3 — Standard Asteroid Hazard Migration

## Goal
Migrate the existing Standard Asteroid from a standalone obstacle into the Phase 5 hazard framework.

## Requirements
- Preserve Phase 2 collision behavior.
- Preserve Phase 3 Near Miss behavior.
- Preserve Phase 4 Time Warp speed scaling.
- Use HazardBase lifecycle.
- Use HazardDefinition data configuration.

## Validation
- Collision still ends run when Shield is unavailable.
- Near Miss remains single-award per asteroid.
- Time Warp changes movement speed through shared world speed.
- HazardDirector can register the asteroid.
