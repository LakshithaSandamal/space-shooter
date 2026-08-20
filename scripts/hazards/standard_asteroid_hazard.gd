class_name StandardAsteroidHazard
extends HazardBase

## Phase 5 migration adapter.
## Gameplay-specific asteroid behavior remains compatible with:
## - Near Miss
## - Shield
## - Time Warp

func get_hazard_id() -> String:
    return "standard_asteroid"

func can_near_miss() -> bool:
    return true
