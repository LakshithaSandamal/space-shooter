class_name RouteNode
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export var sector_id: String = "courier_corridor"
@export var risk_level: int = 1
@export var reward_multiplier: float = 1.0
@export var next_nodes: Array[String] = []

func is_valid() -> bool:
	return not id.is_empty() and not sector_id.is_empty()
