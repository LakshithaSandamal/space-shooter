# Phase 5 — Sectors, Threat & Hazard Expansion

## Status

IN PROGRESS

## Current milestone

Phase 5.1 — Sector Runtime + Threat Foundation

## Goals

- Add sector ownership without changing gameplay controls.
- Add threat progression without unfair randomness.
- Prepare scalable hazard registration.
- Preserve Phase 2 fairness, Phase 3 skill systems, and Phase 4 power-up rules.

## Architecture

```
RunController
    |
    +-- SectorManager
    |       |
    |       +-- SectorDefinition
    |
    +-- ThreatController
    |       |
    |       +-- ThreatProfile
    |
    +-- HazardDirector
```

## Sectors

- Courier Corridor
- Wreck Belt
- Ion Reach
- Solar Rift
- Void Passage

## Threat Rules

Threat level affects:

- spawn timing
- hazard combinations
- pattern complexity
- visual intensity

Threat level does not bypass fairness validation.

## Validation Requirements

Every Phase 5 pattern must guarantee:

- at least one safe lane
- no impossible stacking
- collectible accessibility
- power-up accessibility
- deterministic testing
