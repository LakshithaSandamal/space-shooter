class_name StarfallWaveSpawner
extends Node

signal player_hit
signal core_collected(value: int)
signal wave_spawned(pattern_id: StringName)

@export var patterns: Array[StarfallLaneWavePattern] = []
@export var asteroid_scene: PackedScene
@export var star_core_scene: PackedScene
@export var lane_center_x: float = 360.0
@export var lane_spacing: float = 180.0
@export var spawn_y: float = -86.0
@export var base_world_speed: float = 390.0
@export var maximum_world_speed: float = 650.0
@export var distance_for_maximum_speed_m: float = 2500.0
@export var base_spawn_interval: float = 1.15
@export var minimum_spawn_interval: float = 0.62

@onready var _wave_timer: Timer = %WaveTimer

var _hazards_root: Node2D
var _collectibles_root: Node2D
var _distance_m: float = 0.0
var _pattern_cursor: int = 0
var _wave_index: int = 0
var _running: bool = false

func _ready() -> void:
	_wave_timer.timeout.connect(_on_wave_timer_timeout)

func configure(hazards_root: Node2D, collectibles_root: Node2D) -> void:
	_hazards_root = hazards_root
	_collectibles_root = collectibles_root

func start_run() -> void:
	if _hazards_root == null or _collectibles_root == null:
		push_error("WaveSpawner must be configured with hazard and collectible roots before start_run().")
		return
	if asteroid_scene == null or star_core_scene == null:
		push_error("WaveSpawner requires asteroid_scene and star_core_scene.")
		return
	_distance_m = 0.0
	_pattern_cursor = 0
	_wave_index = 0
	_running = true
	_wave_timer.start(0.85)

func stop_run() -> void:
	_running = false
	_wave_timer.stop()

func set_distance_m(value: float) -> void:
	_distance_m = maxf(value, 0.0)

func current_world_speed() -> float:
	var ratio: float = _difficulty_ratio()
	return lerpf(base_world_speed, maximum_world_speed, ratio)

func current_spawn_interval() -> float:
	var ratio: float = _difficulty_ratio()
	return lerpf(base_spawn_interval, minimum_spawn_interval, ratio)

func _difficulty_ratio() -> float:
	if distance_for_maximum_speed_m <= 0.0:
		return 1.0
	return clampf(_distance_m / distance_for_maximum_speed_m, 0.0, 1.0)

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
	var speed: float = current_world_speed()

	for lane: int in pattern.blocked_lanes:
		_spawn_asteroid(lane, speed)

	for lane: int in pattern.core_lanes:
		_spawn_star_core(lane, speed)

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
	asteroid.player_hit.connect(_on_asteroid_player_hit)

func _spawn_star_core(lane_index: int, speed: float) -> void:
	var star_core: StarfallStarCore = star_core_scene.instantiate() as StarfallStarCore
	if star_core == null:
		push_error("Configured Star Core scene does not instantiate StarfallStarCore.")
		return
	_collectibles_root.add_child(star_core)
	star_core.position = Vector2(_lane_x(lane_index), spawn_y)
	star_core.configure(speed, _wave_index + lane_index)
	star_core.collected.connect(_on_star_core_collected)

func _lane_x(lane_index: int) -> float:
	return lane_center_x + float(clampi(lane_index, 0, 2) - 1) * lane_spacing

func _on_asteroid_player_hit() -> void:
	if _running:
		player_hit.emit()

func _on_star_core_collected(value: int) -> void:
	if _running:
		core_collected.emit(value)
