class_name HazardBase
extends Node2D

@export var definition: HazardDefinition

var world_speed_multiplier: float = 1.0

func apply_world_speed(multiplier: float) -> void:
    world_speed_multiplier = multiplier

func activate_hazard() -> void:
    pass

func deactivate_hazard() -> void:
    pass
