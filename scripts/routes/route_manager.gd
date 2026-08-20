class_name RouteManager
extends Node

signal route_selected(node: RouteNode)

var route_map: RouteMap
var current_node_id: String = "start"
var selected_node_id: String = ""

func setup(map: RouteMap) -> void:
	route_map = map
	current_node_id = map.start_node_id

func get_available_routes() -> Array[RouteNode]:
	if route_map == null:
		return []
	return route_map.get_available_nodes(current_node_id)

func select_route(node_id: String) -> bool:
	if route_map == null:
		return false
	var node: RouteNode = route_map.get_node(node_id)
	if node == null:
		return false
	selected_node_id = node.id
	current_node_id = node.id
	route_selected.emit(node)
	return true
