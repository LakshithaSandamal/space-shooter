class_name HazardDirector
extends Node

var active_threat: int = 1

func set_threat(level: int) -> void:
    active_threat = clamp(level, 1, 5)

func can_spawn_hazard(definition: HazardDefinition) -> bool:
    if definition == null:
        return false
    return active_threat >= definition.threat_minimum and active_threat <= definition.threat_maximum
