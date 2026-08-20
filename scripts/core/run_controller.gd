class_name StarfallRunController
extends Node2D

signal audio_cue_requested(cue_id: StringName, intensity: int)

enum RunState {
	RUNNING,
	GAME_OVER,
}

const PIXELS_PER_METER: float = 36.0
const DISTANCE_SCORE_PER_METER: int = 5

@onready var _player: StarfallCourierController = %Player
@onready var _input_router: StarfallRunInputRouter = %InputRouter
@onready var _hud: StarfallRunHud = %RunHud
@onready var _wave_spawner: StarfallWaveSpawner = %WaveSpawner
@onready var _skill_system: StarfallSkillSystem = %SkillSystem
@onready var _skill_effects: StarfallSkillFeedbackEmitter = %SkillEffects
@onready var _hazards: Node2D = %Hazards
@onready var _collectibles: Node2D = %Collectibles

var _run_state: RunState = RunState.RUNNING
var _distance_m: float = 0.0
var _core_count: int = 0
var _skill_score: int = 0
var _score: int = 0

func _ready() -> void:
	_input_router.lane_change_requested.connect(_on_lane_change_requested)
	_input_router.restart_requested.connect(_on_restart_requested)
	_player.lane_changed.connect(_on_player_lane_changed)
	_wave_spawner.player_hit.connect(_on_player_hit)
	_wave_spawner.core_collected.connect(_on_core_collected)
	_wave_spawner.near_miss_detected.connect(_on_near_miss_detected)
	_skill_system.combo_broken.connect(_on_combo_broken)
	_skill_system.audio_cue_requested.connect(_on_skill_audio_cue_requested)
	_wave_spawner.configure(_hazards, _collectibles)
	_start_run()

func _physics_process(delta: float) -> void:
	if _run_state != RunState.RUNNING:
		return

	_skill_system.advance(delta)
	var world_speed: float = _wave_spawner.current_world_speed()
	_distance_m += (world_speed / PIXELS_PER_METER) * delta
	_wave_spawner.set_distance_m(_distance_m)
	_recalculate_score()
	_hud.set_run_metrics(_distance_m, _core_count, _score)
	_hud.set_combo_state(_skill_system.combo_multiplier, _skill_system.combo_grace_ratio())

func _start_run() -> void:
	_clear_spawned_objects()
	_skill_effects.clear_effects()
	_run_state = RunState.RUNNING
	_distance_m = 0.0
	_core_count = 0
	_skill_score = 0
	_score = 0
	_skill_system.reset_run()
	_player.reset_for_run()
	_input_router.set_restart_mode(false)
	_hud.reset_run()
	_hud.set_active_lane(_player.get_lane_index())
	_hud.set_run_metrics(_distance_m, _core_count, _score)
	_hud.set_combo_state(_skill_system.combo_multiplier, _skill_system.combo_grace_ratio())
	_wave_spawner.start_run()

func _finish_run() -> void:
	if _run_state != RunState.RUNNING:
		return
	_run_state = RunState.GAME_OVER
	_wave_spawner.stop_run()
	_player.crash()
	_input_router.set_restart_mode(true)
	_hud.show_game_over(
		_distance_m,
		_core_count,
		_score,
		_skill_system.best_combo,
		_skill_system.near_miss_count
	)

func _clear_spawned_objects() -> void:
	_clear_node_children(_hazards)
	_clear_node_children(_collectibles)

func _clear_node_children(root: Node) -> void:
	for child: Node in root.get_children():
		child.process_mode = Node.PROCESS_MODE_DISABLED
		if child is Area2D:
			var area: Area2D = child as Area2D
			area.monitoring = false
		child.queue_free()

func _recalculate_score() -> void:
	_score = int(floor(_distance_m)) * DISTANCE_SCORE_PER_METER + _skill_score

func _on_lane_change_requested(direction: int) -> void:
	if _run_state == RunState.RUNNING:
		_player.request_lane_change(direction)

func _on_player_lane_changed(lane_index: int) -> void:
	_hud.set_active_lane(lane_index)

func _on_core_collected(value: int) -> void:
	if _run_state != RunState.RUNNING:
		return
	_core_count += 1
	_skill_score += _skill_system.register_core(value)
	_recalculate_score()
	_hud.set_run_metrics(_distance_m, _core_count, _score)
	_hud.set_combo_state(_skill_system.combo_multiplier, _skill_system.combo_grace_ratio())
	_skill_effects.play_core_pickup(_player.global_position)

func _on_near_miss_detected(_hazard_position: Vector2) -> void:
	if _run_state != RunState.RUNNING:
		return

	var awarded_score: int = _skill_system.register_near_miss()
	_skill_score += awarded_score
	_recalculate_score()
	var streak_count: int = _skill_system.near_miss_streak
	var feedback_id: StringName = _skill_system.current_near_miss_feedback()
	_hud.set_run_metrics(_distance_m, _core_count, _score)
	_hud.set_combo_state(_skill_system.combo_multiplier, _skill_system.combo_grace_ratio())
	_hud.show_skill_feedback(feedback_id, awarded_score, streak_count)
	_skill_effects.play_near_miss(_player.global_position, streak_count)

func _on_combo_broken(previous_multiplier: int) -> void:
	_hud.set_combo_state(_skill_system.combo_multiplier, 0.0)
	_hud.show_combo_break(previous_multiplier)

func _on_skill_audio_cue_requested(cue_id: StringName, intensity: int) -> void:
	audio_cue_requested.emit(cue_id, intensity)

func _on_player_hit() -> void:
	_finish_run()

func _on_restart_requested() -> void:
	if _run_state == RunState.GAME_OVER:
		_start_run()
