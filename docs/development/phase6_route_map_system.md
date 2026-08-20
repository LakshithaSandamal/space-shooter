# Phase 6 — Route Map System

## Scope

Foundation for route selection before entering gameplay sectors.

## Phase 6.1 Goals

- Route map data model
- Route nodes
- Route selection flow
- Sector transition contract
- Validation rules

## Architecture

RouteMap

```
Run Flow
  |
  v
RouteManager
  |
  +-- RouteNode
  |
  +-- Sector Reference
  |
  +-- Reward Metadata
```

## Validation

- Route selection must be deterministic.
- Invalid routes must be rejected.
- Existing gameplay phases must remain unchanged.
- No contracts, economy, or progression are included in Phase 6.1.
