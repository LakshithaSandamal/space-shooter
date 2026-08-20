class_name StarfallCourierController
extends CharacterBody2D

signal lane_changed(lane_index: int)
signal lane_reached(lane_index: int)

const MIN_LANE: int = 0
const MAX_LANE: int = 2
const CENTER_LANE: int = 1

@export_range(MIN_LANE, MAX_LANE, 1) var starting_lane: int = CENTER_LANE
@export var lane_center_x: float = 360.0
@export var lane_spacing: float = 180.0
@export var lane_change_speed: float = 1125.0
@export_range(0.0, 0.25, 0.01) var visual_bank_radians: float = 0.08

@onready var _visual: StarfallShipVisual = %Visual

var current_lane: int = CENTER_LANE
var _target_x: float = 360.0
var _is_changing_lane: bool = false
var _active: bool = true

func _ready() -> void:
	reset_for_run()

func _physics_process(delta: float) -> void:
	if not _active:
		velocity = Vector2.ZERO
		_update_visual_bank(delta)
		return
	_update_lane_motion(delta)
	_update_visual_bank(delta)

func request_lane_change(direction: int) -> bool:
	if not _active or direction == 0:
		return false

	var lane_step: int = -1 if direction < 0 else 1
	var next_lane: int = clampi(current_lane + lane_step, MIN_LANE, MAX_LANE)
	if next_lane == current_lane:
		return false

	current_lane = next_lane
	_target_x = _lane_x(current_lane)
	_is_changing_lane = true
	lane_changed.emit(current_lane)
	return true

func reset_for_run() -> void:
	_active = true
	current_lane = clampi(starting_lane, MIN_LANE, MAX_LANE)
	_target_x = _lane_x(current_lane)
	position.x = _target_x
	velocity = Vector2.ZERO
	_is_changing_lane = false
	collision_layer = 1
	if is_node_ready():
		_visual.rotation = 0.0
		_visual.visual_state = StarfallShipVisual.VisualState.NORMAL
		_visual.queue_redraw()
	lane_changed.emit(current_lane)

func crash() -> void:
	if not _active:
		return
	_active = false
	velocity = Vector2.ZERO
	_is_changing_lane = false
	collision_layer = 0
	_visual.rotation = 0.0
	_visual.visual_state = StarfallShipVisual.VisualState.CRASHED
	_visual.queue_redraw()

func set_power_visuals(shielded: bool, time_warped: bool, overcharged: bool) -> void:
	if not _active:
		return
	var next_state: int = StarfallShipVisual.VisualState.NORMAL
	if shielded:
		next_state = StarfallShipVisual.VisualState.SHIELDED
	elif overcharged:
		next_state = StarfallShipVisual.VisualState.OVERCHARGED
	elif time_warped:
		next_state = StarfallShipVisual.VisualState.TIME_WARP
	if _visual.visual_state != next_state:
		_visual.visual_state = next_state
		_visual.queue_redraw()

func flash_impact() -> void:
	if not _active:
		return
	_visual.visual_state = StarfallShipVisual.VisualState.IMPACT
	_visual.queue_redraw()

func get_lane_index() -> int:
	return current_lane

func get_lane_center_x(lane_index: int) -> float:
	return _lane_x(clampi(lane_index, MIN_LANE, MAX_LANE))

func is_changing_lane() -> bool:
	return _is_changing_lane

func is_active() -> bool:
	return _active

func _update_lane_motion(delta: float) -> void:
	if not _is_changing_lane:
		velocity = Vector2.ZERO
		return

	var distance_to_target: float = _target_x - position.x
	var maximum_step: float = lane_change_speed * delta
	if absf(distance_to_target) <= maximum_step:
		position.x = _target_x
		velocity = Vector2.ZERO
		_is_changing_lane = false
		lane_reached.emit(current_lane)
		return

	velocity = Vector2(signf(distance_to_target) * lane_change_speed, 0.0)
	move_and_slide()

func _update_visual_bank(delta: float) -> void:
	var target_rotation: float = 0.0
	if _active and _is_changing_lane:
		target_rotation = signf(_target_x - position.x) * visual_bank_radians
	_visual.rotation = lerp_angle(_visual.rotation, target_rotation, minf(1.0, delta * 12.0))

func _lane_x(lane_index: int) -> float:
	return lane_center_x + float(lane_index - CENTER_LANE) * lane_spacing
