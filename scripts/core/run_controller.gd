class_name StarfallRunController
extends Node2D

@onready var _player: StarfallCourierController = %Player
@onready var _input_router: StarfallRunInputRouter = %InputRouter
@onready var _hud: StarfallRunHud = %RunHud

func _ready() -> void:
	_input_router.lane_change_requested.connect(_on_lane_change_requested)
	_player.lane_changed.connect(_on_player_lane_changed)
	_hud.set_active_lane(_player.get_lane_index())

func _on_lane_change_requested(direction: int) -> void:
	_player.request_lane_change(direction)

func _on_player_lane_changed(lane_index: int) -> void:
	_hud.set_active_lane(lane_index)
