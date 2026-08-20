class_name StarfallPowerUpSystem
extends Node

signal state_changed
signal power_up_activated(power_up_type: PowerUpType)
signal power_up_expired(power_up_type: PowerUpType)
signal shield_consumed
signal audio_cue_requested(cue_id: StringName, intensity: int)

enum PowerUpType {
	SHIELD,
	TIME_WARP,
	OVERCHARGE,
}

@export_range(0.1, 3.0, 0.05) var shield_recovery_duration: float = 0.85
@export_range(1.0, 12.0, 0.1) var time_warp_duration: float = 5.0
@export_range(0.25, 1.0, 0.05) var time_warp_world_scale: float = 0.55
@export_range(1.0, 12.0, 0.1) var overcharge_duration: float = 6.0
@export_range(1, 4, 1) var overcharge_reward_multiplier: int = 2

var shield_charge: int = 0
var shield_recovery_remaining: float = 0.0
var time_warp_remaining: float = 0.0
var overcharge_remaining: float = 0.0

func reset_run() -> void:
	shield_charge = 0
	shield_recovery_remaining = 0.0
	time_warp_remaining = 0.0
	overcharge_remaining = 0.0
	state_changed.emit()

func advance(delta: float) -> void:
	if delta <= 0.0:
		return

	var changed: bool = false
	if shield_recovery_remaining > 0.0:
		shield_recovery_remaining = maxf(0.0, shield_recovery_remaining - delta)
		changed = true

	if time_warp_remaining > 0.0:
		var was_active: bool = true
		time_warp_remaining = maxf(0.0, time_warp_remaining - delta)
		changed = true
		if was_active and time_warp_remaining <= 0.0:
			power_up_expired.emit(PowerUpType.TIME_WARP)
			audio_cue_requested.emit(&"time_warp_end", 1)

	if overcharge_remaining > 0.0:
		var overcharge_was_active: bool = true
		overcharge_remaining = maxf(0.0, overcharge_remaining - delta)
		changed = true
		if overcharge_was_active and overcharge_remaining <= 0.0:
			power_up_expired.emit(PowerUpType.OVERCHARGE)
			audio_cue_requested.emit(&"overcharge_end", 1)

	if changed:
		state_changed.emit()

func activate(power_up_type: PowerUpType) -> void:
	match power_up_type:
		PowerUpType.SHIELD:
			shield_charge = 1
			shield_recovery_remaining = 0.0
			audio_cue_requested.emit(&"shield_pickup", 1)
		PowerUpType.TIME_WARP:
			time_warp_remaining = time_warp_duration
			audio_cue_requested.emit(&"time_warp_start", 1)
		PowerUpType.OVERCHARGE:
			overcharge_remaining = overcharge_duration
			audio_cue_requested.emit(&"overcharge_start", 1)

	power_up_activated.emit(power_up_type)
	state_changed.emit()

func consume_shield_hit() -> bool:
	if shield_recovery_remaining > 0.0:
		return true
	if shield_charge <= 0:
		return false

	shield_charge = 0
	shield_recovery_remaining = shield_recovery_duration
	shield_consumed.emit()
	state_changed.emit()
	audio_cue_requested.emit(&"shield_save", 1)
	return true

func has_shield() -> bool:
	return shield_charge > 0

func is_shield_recovering() -> bool:
	return shield_recovery_remaining > 0.0

func is_time_warp_active() -> bool:
	return time_warp_remaining > 0.0

func is_overcharge_active() -> bool:
	return overcharge_remaining > 0.0

func world_motion_scale() -> float:
	return time_warp_world_scale if is_time_warp_active() else 1.0

func reward_score_multiplier() -> int:
	return overcharge_reward_multiplier if is_overcharge_active() else 1

func shield_ratio() -> float:
	return 1.0 if has_shield() else 0.0

func time_warp_ratio() -> float:
	if time_warp_duration <= 0.0:
		return 0.0
	return clampf(time_warp_remaining / time_warp_duration, 0.0, 1.0)

func overcharge_ratio() -> float:
	if overcharge_duration <= 0.0:
		return 0.0
	return clampf(overcharge_remaining / overcharge_duration, 0.0, 1.0)
