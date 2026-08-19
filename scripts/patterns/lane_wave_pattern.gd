class_name StarfallLaneWavePattern
extends Resource

const MIN_LANE: int = 0
const MAX_LANE: int = 2
const LANE_COUNT: int = 3

@export var pattern_id: StringName = &"wave"
@export var blocked_lanes: PackedInt32Array = PackedInt32Array()
@export var core_lanes: PackedInt32Array = PackedInt32Array()
@export_range(0.0, 5000.0, 10.0) var minimum_distance_m: float = 0.0

func safe_lane_count() -> int:
	var unique_blocked: Array[int] = []
	for lane: int in blocked_lanes:
		if lane >= MIN_LANE and lane <= MAX_LANE and not unique_blocked.has(lane):
			unique_blocked.append(lane)
	return LANE_COUNT - unique_blocked.size()

func is_fair() -> bool:
	return validation_error().is_empty() and safe_lane_count() >= 1

func validation_error() -> String:
	var seen_blocked: Array[int] = []
	for lane: int in blocked_lanes:
		if lane < MIN_LANE or lane > MAX_LANE:
			return "Pattern %s has invalid blocked lane %d." % [pattern_id, lane]
		if seen_blocked.has(lane):
			return "Pattern %s repeats blocked lane %d." % [pattern_id, lane]
		seen_blocked.append(lane)

	if seen_blocked.size() >= LANE_COUNT:
		return "Pattern %s blocks all lanes." % pattern_id

	var seen_cores: Array[int] = []
	for lane: int in core_lanes:
		if lane < MIN_LANE or lane > MAX_LANE:
			return "Pattern %s has invalid Star Core lane %d." % [pattern_id, lane]
		if seen_cores.has(lane):
			return "Pattern %s repeats Star Core lane %d." % [pattern_id, lane]
		if seen_blocked.has(lane):
			return "Pattern %s places a Star Core in blocked lane %d." % [pattern_id, lane]
		seen_cores.append(lane)

	return ""
