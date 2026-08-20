class_name ThreatController
extends Node

signal threat_changed(level: int)

const MIN_LEVEL: int = 1
const MAX_LEVEL: int = 5

var level: int = MIN_LEVEL

func set_level(value: int) -> void:
	var next_level: int = clampi(value, MIN_LEVEL, MAX_LEVEL)
	if next_level == level:
		return
	level = next_level
	threat_changed.emit(level)

func increase() -> void:
	set_level(level + 1)

func get_level() -> int:
	return level
