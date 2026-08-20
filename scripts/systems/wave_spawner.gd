class_name StarfallWaveSpawner
extends Node

signal player_hit
signal core_collected(value: int)
signal near_miss_detected(world_position: Vector2)
signal power_up_collected(power_up_type: int)
signal wave_spawned(pattern_id: StringName)

const DEFAULT_PATTERN_PATHS: PackedStringArray = [
	"res://resources/patterns/phase2/wave_left_blocked.tres",
	"res://resources/patterns/phase2/wave_right_blocked.tres",
	"res://resources/patterns/phase2/wave_center_blocked.tres",
	"res://resources/patterns/phase2/wave_left_center_blocked.tres",
	"res://resources/patterns/phase2/wave_center_right_blocked.tres",
	"res://resources/patterns/phase2/wave_left_right_blocked.tres",
	"res://resources/patterns/phase3/wave_reward_center.tres",
	"res://resources/patterns/phase3/wave_reward_outer.tres",
	"res://resources/patterns/phase3/wave_pressure_left_center.tres",
	"res://resources/patterns/phase3/wave_pressure_center_right.tres",
	"res://resources/patterns/phase3/wave_pressure_outer.tres",
]

@export var patterns: Array[StarfallLaneWavePattern] = []
@export var asteroid_scene: PackedScene
@export var star_core_scene: PackedScene
@export var power_up_scene: PackedScene
@export var lane_center_x: float = 360.0
@export var lane_spacing: float = 180.0
@export var spawn_y: float = -86.0
@export var base_world_speed: float = 390.0
@export var maximum_world_speed: float = 650.0
@export var distance_for_maximum_speed_m: float = 2500.0
@export var base_spawn_interval: float = 1.15
@export var minimum_spawn_interval: float = 0.62
@export var minimum_power_up_distance_m: float = 180.0
@export_range(3, 12, 1) var power_up_wave_interval: int = 6

@onready var _wave_timer: Timer = %WaveTimer

var _hazards_root: Node2D
var _collectibles_root: Node2D
var _power_ups_root: Node2D
var _distance_m: float = 0.0
var _pattern_cursor: int = 0
var _wave_index: int = 0
var _power_up_cursor: int = 0
var _running: bool = false
var _world_motion_scale: float = 1.0

func _ready() -> void:
	_wave_timer.timeout.connect(_on_wave_timer_timeout)
	if patterns.is_empty():
		_load_default_patterns()

func configure(hazards_root: Node2D, collectibles_root: Node2D, power_ups_root: Node2D = null) -> void:
	_hazards_root = hazards_root
	_collectibles_root = collectibles_root
	_power_ups_root = power_ups_root

func start_run() -> void:
	if _hazards_root == null or _collectibles_root == null:
		push_error("WaveSpawner must be configured with hazard and collectible roots before start_run().")
		return
	if asteroid_scene == null or star_core_scene == null:
		push_error("WaveSpawner requires asteroid_scene and star_core_scene.")
		return
	if _power_ups_root != null and power_up_scene == null:
		push_error("WaveSpawner requires power_up_scene when a power-up root is configured.")
		return
	if patterns.is_empty():
		push_error("WaveSpawner requires at least one valid lane pattern.")
		return
	_distance_m = 0.0
	_pattern_cursor = 0
	_wave_index = 0
	_power_up_cursor = 0
	_world_motion_scale = 1.0
	_running = true
	_wave_timer.start(0.85)

func stop_run() -> void:
	_running = false
	_wave_timer.stop()

func set_distance_m(value: float) -> void:
	_distance_m = maxf(value, 0.0)

func set_world_motion_scale(value: float) -> void:
	_world_motion_scale = clampf(value, 0.25, 1.0)
	_apply_motion_scale_to_root(_hazards_root)
	_apply_motion_scale_to_root(_collectibles_root)
	_apply_motion_scale_to_root(_power_ups_root)

func current_world_speed() -> float:
	return current_base_world_speed() * _world_motion_scale

func current_base_world_speed() -> float:
	var ratio: float = _difficulty_ratio()
	return lerpf(base_world_speed, maximum_world_speed, ratio)

func current_spawn_interval() -> float:
	var ratio: float = _difficulty_ratio()
	var base_interval: float = lerpf(base_spawn_interval, minimum_spawn_interval, ratio)
	return base_interval / maxf(_world_motion_scale, 0.25)

func _difficulty_ratio() -> float:
	if distance_for_maximum_speed_m <= 0.0:
		return 1.0
	return clampf(_distance_m / distance_for_maximum_speed_m, 0.0, 1.0)

func _load_default_patterns() -> void:
	for path: String in DEFAULT_PATTERN_PATHS:
		var resource: Resource = load(path)
		var pattern: StarfallLaneWavePattern = resource as StarfallLaneWavePattern
		if pattern == null:
			push_error("Failed to load lane wave pattern: %s" % path)
			continue
		patterns.append(pattern)

func _on_wave_timer_timeout() -> void:
	if not _running:
		return

	var pattern: StarfallLaneWavePattern = _next_pattern()
	if pattern != null:
		_spawn_pattern(pattern)

	_wave_timer.start(current_spawn_interval())

func _next_pattern() -> StarfallLaneWavePattern:
	if patterns.is_empty():
		return null

	for offset: int in range(patterns.size()):
		var index: int = (_pattern_cursor + offset) % patterns.size()
		var candidate: StarfallLaneWavePattern = patterns[index]
		if candidate == null:
			continue
		if candidate.minimum_distance_m > _distance_m:
			continue
		if not candidate.is_fair():
			continue
		_pattern_cursor = (index + 1) % patterns.size()
		return candidate

	return null

func _spawn_pattern(pattern: StarfallLaneWavePattern) -> void:
	var base_speed: float = current_base_world_speed()

	for lane: int in pattern.blocked_lanes:
		_spawn_asteroid(lane, base_speed)

	for lane: int in pattern.core_lanes:
		_spawn_star_core(lane, base_speed)

	_try_spawn_power_up(pattern, base_speed)
	wave_spawned.emit(pattern.pattern_id)
	_wave_index += 1

func _spawn_asteroid(lane_index: int, speed: float) -> void:
	var asteroid: StarfallStandardAsteroid = asteroid_scene.instantiate() as StarfallStandardAsteroid
	if asteroid == null:
		push_error("Configured asteroid scene does not instantiate StarfallStandardAsteroid.")
		return
	_hazards_root.add_child(asteroid)
	asteroid.position = Vector2(_lane_x(lane_index), spawn_y)
	asteroid.configure(speed, _wave_index + lane_index)
	asteroid.set_motion_scale(_world_motion_scale)
	asteroid.player_hit.connect(_on_asteroid_player_hit)
	asteroid.near_miss.connect(_on_asteroid_near_miss)

func _spawn_star_core(lane_index: int, speed: float) -> void:
	var star_core: StarfallStarCore = star_core_scene.instantiate() as StarfallStarCore
	if star_core == null:
		push_error("Configured Star Core scene does not instantiate StarfallStarCore.")
		return
	_collectibles_root.add_child(star_core)
	star_core.position = Vector2(_lane_x(lane_index), spawn_y)
	star_core.configure(speed, _wave_index + lane_index)
	star_core.set_motion_scale(_world_motion_scale)
	star_core.collected.connect(_on_star_core_collected)

func _try_spawn_power_up(pattern: StarfallLaneWavePattern, speed: float) -> void:
	if _power_ups_root == null or power_up_scene == null:
		return
	if _distance_m < minimum_power_up_distance_m:
		return
	if power_up_wave_interval <= 0 or _wave_index <= 0 or _wave_index % power_up_wave_interval != 0:
		return

	var lanes: Array[int] = _power_up_candidate_lanes(pattern)
	if lanes.is_empty():
		return

	var pickup: StarfallPowerUpPickup = power_up_scene.instantiate() as StarfallPowerUpPickup
	if pickup == null:
		push_error("Configured power-up scene does not instantiate StarfallPowerUpPickup.")
		return

	var lane_index: int = lanes[_power_up_cursor % lanes.size()]
	var power_up_type: int = _power_up_cursor % 3
	_power_ups_root.add_child(pickup)
	pickup.position = Vector2(_lane_x(lane_index), spawn_y)
	pickup.configure(speed, power_up_type)
	pickup.set_motion_scale(_world_motion_scale)
	pickup.collected.connect(_on_power_up_collected)
	_power_up_cursor += 1

func _power_up_candidate_lanes(pattern: StarfallLaneWavePattern) -> Array[int]:
	var lanes: Array[int] = []
	for lane_index: int in range(3):
		if pattern.blocked_lanes.has(lane_index):
			continue
		if pattern.core_lanes.has(lane_index):
			continue
		lanes.append(lane_index)
	return lanes

func _apply_motion_scale_to_root(root: Node2D) -> void:
	if root == null:
		return
	for child: Node in root.get_children():
		if child.has_method("set_motion_scale"):
			child.call("set_motion_scale", _world_motion_scale)

func _lane_x(lane_index: int) -> float:
	return lane_center_x + float(clampi(lane_index, 0, 2) - 1) * lane_spacing

func _on_asteroid_player_hit() -> void:
	if _running:
		player_hit.emit()

func _on_asteroid_near_miss(world_position: Vector2) -> void:
	if _running:
		near_miss_detected.emit(world_position)

func _on_star_core_collected(value: int) -> void:
	if _running:
		core_collected.emit(value)

func _on_power_up_collected(power_up_type: int) -> void:
	if _running:
		power_up_collected.emit(power_up_type)
