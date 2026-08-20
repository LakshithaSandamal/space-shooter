class_name StarfallSkillSystem
extends Node

signal combo_changed(multiplier: int)
signal combo_broken(previous_multiplier: int)
signal core_awarded(multiplier_used: int, awarded_score: int)
signal near_miss_awarded(streak_count: int, awarded_score: int, feedback_id: StringName)
signal audio_cue_requested(cue_id: StringName, intensity: int)

const CLOSE_CALL_ID: StringName = &"close_call"
const DANGER_STREAK_ID: StringName = &"danger_streak"
const EDGE_RUN_ID: StringName = &"edge_run"

@export_range(1, 50, 1) var maximum_combo: int = 20
@export_range(0.5, 8.0, 0.1) var combo_grace_duration: float = 2.6
@export_range(0.0, 4.0, 0.1) var near_miss_grace_restore: float = 1.0
@export_range(0, 1000, 5) var near_miss_base_score: int = 75
@export_range(0, 500, 5) var near_miss_streak_step_score: int = 25
@export_range(0.5, 5.0, 0.1) var near_miss_streak_window: float = 1.6
@export_range(2, 8, 1) var danger_streak_threshold: int = 3
@export_range(3, 12, 1) var edge_run_threshold: int = 5

var combo_multiplier: int = 1
var combo_grace_remaining: float = 0.0
var best_combo: int = 1
var near_miss_count: int = 0
var near_miss_streak: int = 0
var _near_miss_window_remaining: float = 0.0

func reset_run() -> void:
	combo_multiplier = 1
	combo_grace_remaining = 0.0
	best_combo = 1
	near_miss_count = 0
	near_miss_streak = 0
	_near_miss_window_remaining = 0.0
	combo_changed.emit(combo_multiplier)

func advance(delta: float) -> void:
	if delta <= 0.0:
		return

	if combo_multiplier > 1:
		combo_grace_remaining = maxf(0.0, combo_grace_remaining - delta)
		if combo_grace_remaining <= 0.0:
			var previous_multiplier: int = combo_multiplier
			combo_multiplier = 1
			combo_grace_remaining = 0.0
			combo_broken.emit(previous_multiplier)
			combo_changed.emit(combo_multiplier)
			audio_cue_requested.emit(&"combo_break", previous_multiplier)

	if _near_miss_window_remaining > 0.0:
		_near_miss_window_remaining = maxf(0.0, _near_miss_window_remaining - delta)
		if _near_miss_window_remaining <= 0.0:
			near_miss_streak = 0

func register_core(base_value: int) -> int:
	var multiplier_used: int = maxi(combo_multiplier, 1)
	var awarded_score: int = maxi(base_value, 0) * multiplier_used

	combo_multiplier = mini(maximum_combo, combo_multiplier + 1)
	best_combo = maxi(best_combo, combo_multiplier)
	combo_grace_remaining = combo_grace_duration

	core_awarded.emit(multiplier_used, awarded_score)
	combo_changed.emit(combo_multiplier)
	audio_cue_requested.emit(&"combo_core", combo_multiplier)
	return awarded_score

func register_near_miss() -> int:
	if _near_miss_window_remaining > 0.0:
		near_miss_streak += 1
	else:
		near_miss_streak = 1

	near_miss_count += 1
	_near_miss_window_remaining = near_miss_streak_window

	if combo_multiplier > 1:
		combo_grace_remaining = minf(
			combo_grace_duration,
			combo_grace_remaining + near_miss_grace_restore
		)

	var capped_streak_bonus: int = mini(maxi(near_miss_streak - 1, 0), 4)
	var weighted_base: int = near_miss_base_score + capped_streak_bonus * near_miss_streak_step_score
	var awarded_score: int = weighted_base * maxi(combo_multiplier, 1)
	var feedback_id: StringName = current_near_miss_feedback()

	near_miss_awarded.emit(near_miss_streak, awarded_score, feedback_id)
	audio_cue_requested.emit(feedback_id, near_miss_streak)
	return awarded_score

func current_near_miss_feedback() -> StringName:
	if near_miss_streak >= edge_run_threshold:
		return EDGE_RUN_ID
	if near_miss_streak >= danger_streak_threshold:
		return DANGER_STREAK_ID
	return CLOSE_CALL_ID

func combo_grace_ratio() -> float:
	if combo_multiplier <= 1 or combo_grace_duration <= 0.0:
		return 0.0
	return clampf(combo_grace_remaining / combo_grace_duration, 0.0, 1.0)
