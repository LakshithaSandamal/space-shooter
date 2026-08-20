class_name RouteMap
extends Resource

@export var start_node_id: String = "start"
@export var nodes: Array[RouteNode] = []

func get_node(node_id: String) -> RouteNode:
	for node: RouteNode in nodes:
		if node.id == node_id:
			return node
	return null

func get_available_nodes(current_id: String) -> Array[RouteNode]:
	var current: RouteNode = get_node(current_id)
	var result: Array[RouteNode] = []
	if current == null:
		return result
	for next_id: String in current.next_nodes:
		var next_node: RouteNode = get_node(next_id)
		if next_node != null:
			result.append(next_node)
	return result
