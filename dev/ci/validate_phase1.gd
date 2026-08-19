extends SceneTree

func _initialize() -> void:
	call_deferred("_run_validation")

func _run_validation() -> void:
	var resource: Resource = ResourceLoader.load("res://scenes/player/courier.tscn")
	if resource == null or not resource is PackedScene:
		push_error("Phase 1 validation could not load courier scene.")
		quit(1)
		return

	var packed_scene: PackedScene = resource as PackedScene
	var node: Node = packed_scene.instantiate()
	var player: StarfallCourierController = node as StarfallCourierController
	if player == null:
		push_error("Phase 1 courier root is not StarfallCourierController.")
		node.queue_free()
		quit(1)
		return

	root.add_child(player)
	await process_frame

	if player.get_lane_index() != 1:
		_fail("Courier must start in center lane 1.", player)
		return

	if not player.request_lane_change(-1) or player.get_lane_index() != 0:
		_fail("Courier must move from center to left lane.", player)
		return

	if player.request_lane_change(-1) or player.get_lane_index() != 0:
		_fail("Courier must reject movement beyond left lane.", player)
		return

	if not player.request_lane_change(1) or player.get_lane_index() != 1:
		_fail("Courier must move from left to center lane.", player)
		return

	if not player.request_lane_change(1) or player.get_lane_index() != 2:
		_fail("Courier must move from center to right lane.", player)
		return

	if player.request_lane_change(1) or player.get_lane_index() != 2:
		_fail("Courier must reject movement beyond right lane.", player)
		return

	if not player.request_lane_change(-1) or player.get_lane_index() != 1:
		_fail("Courier must return from right to center lane.", player)
		return

	print("Phase 1 lane validation passed.")
	player.queue_free()
	quit(0)

func _fail(message: String, player: Node) -> void:
	push_error(message)
	player.queue_free()
	quit(1)
