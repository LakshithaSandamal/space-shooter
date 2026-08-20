extends SceneTree

func _initialize() -> void:
	call_deferred("_run_validation")

func _run_validation() -> void:
	var failed: bool = false
	failed = _validate_power_up_system() or failed
	failed = _validate_reward_interactions() or failed
	failed = _validate_pickup_and_spawner_rules() or failed

	if not failed:
		print("Phase 4 validation passed: Shield, Time Warp, Overcharge, collision layers, reward interactions, refresh/expiry, and safe-lane placement are deterministic.")
	quit(1 if failed else 0)

func _validate_power_up_system() -> bool:
	var failed: bool = false
	var scene: PackedScene = load("res://scenes/systems/power_up_system.tscn") as PackedScene
	var power: StarfallPowerUpSystem = scene.instantiate() as StarfallPowerUpSystem if scene != null else null
	if power == null:
		push_error("Phase 4 PowerUpSystem failed to instantiate.")
		return true

	power.reset_run()
	if power.has_shield() or power.is_time_warp_active() or power.is_overcharge_active():
		push_error("PowerUpSystem must reset with no active power-ups.")
		failed = true

	power.activate(StarfallPowerUpSystem.PowerUpType.SHIELD)
	if not power.has_shield() or not power.consume_shield_hit():
		push_error("Shield must provide exactly one collision save.")
		failed = true
	if power.has_shield() or not power.is_shield_recovering():
		push_error("Consumed Shield must enter recovery without retaining its charge.")
		failed = true
	if not power.consume_shield_hit():
		push_error("Shield recovery window must suppress immediate repeated collision loss.")
		failed = true
	power.advance(power.shield_recovery_duration + 0.05)
	if power.consume_shield_hit():
		push_error("Shield must stop protecting after its recovery window expires.")
		failed = true

	power.activate(StarfallPowerUpSystem.PowerUpType.TIME_WARP)
	if not power.is_time_warp_active() or not is_equal_approx(power.world_motion_scale(), power.time_warp_world_scale):
		push_error("Time Warp must activate the configured world-motion scale.")
		failed = true
	power.advance(power.time_warp_duration * 0.5)
	if power.time_warp_ratio() < 0.45 or power.time_warp_ratio() > 0.55:
		push_error("Time Warp remaining ratio must track real duration.")
		failed = true
	power.activate(StarfallPowerUpSystem.PowerUpType.TIME_WARP)
	if power.time_warp_ratio() < 0.99:
		push_error("Collecting Time Warp while active must refresh its duration.")
		failed = true
	power.advance(power.time_warp_duration + 0.05)
	if power.is_time_warp_active() or not is_equal_approx(power.world_motion_scale(), 1.0):
		push_error("Time Warp must expire predictably and restore full world motion.")
		failed = true

	power.activate(StarfallPowerUpSystem.PowerUpType.OVERCHARGE)
	if not power.is_overcharge_active() or power.reward_score_multiplier() != 2:
		push_error("Overcharge must activate the x2 reward multiplier.")
		failed = true
	power.advance(power.overcharge_duration + 0.05)
	if power.is_overcharge_active() or power.reward_score_multiplier() != 1:
		push_error("Overcharge must expire back to x1 reward scoring.")
		failed = true

	power.free()
	return failed

func _validate_reward_interactions() -> bool:
	var failed: bool = false
	var skill_scene: PackedScene = load("res://scenes/systems/skill_system.tscn") as PackedScene
	var power_scene: PackedScene = load("res://scenes/systems/power_up_system.tscn") as PackedScene
	var skill: StarfallSkillSystem = skill_scene.instantiate() as StarfallSkillSystem if skill_scene != null else null
	var power: StarfallPowerUpSystem = power_scene.instantiate() as StarfallPowerUpSystem if power_scene != null else null
	if skill == null or power == null:
		push_error("Phase 4 reward interaction systems failed to instantiate.")
		return true

	skill.reset_run()
	power.reset_run()
	power.activate(StarfallPowerUpSystem.PowerUpType.OVERCHARGE)
	var core_award: int = skill.register_core(100) * power.reward_score_multiplier()
	if core_award != 200 or skill.combo_multiplier != 2:
		push_error("Overcharge must double Core reward score without doubling combo growth.")
		failed = true
	var near_miss_award: int = skill.register_near_miss() * power.reward_score_multiplier()
	if near_miss_award != 300 or skill.combo_multiplier != 2:
		push_error("Overcharge must double Near-Miss reward score without increasing combo.")
		failed = true

	skill.free()
	power.free()
	return failed

func _validate_pickup_and_spawner_rules() -> bool:
	var failed: bool = false
	var pickup_scene: PackedScene = load("res://scenes/power_ups/core_power_up.tscn") as PackedScene
	var pickup: StarfallPowerUpPickup = pickup_scene.instantiate() as StarfallPowerUpPickup if pickup_scene != null else null
	if pickup == null:
		push_error("Phase 4 power-up pickup failed to instantiate.")
		return true
	if pickup.collision_layer != 8 or pickup.collision_mask != 1:
		push_error("Power-up pickup must use layer 4 and detect only player layer 1.")
		failed = true
	pickup.free()

	var spawner_scene: PackedScene = load("res://scenes/systems/wave_spawner.tscn") as PackedScene
	var spawner: StarfallWaveSpawner = spawner_scene.instantiate() as StarfallWaveSpawner if spawner_scene != null else null
	var pattern: StarfallLaneWavePattern = load("res://resources/patterns/phase2/wave_left_blocked.tres") as StarfallLaneWavePattern
	if spawner == null or pattern == null:
		push_error("Phase 4 spawner/pattern validation fixtures failed to load.")
		return true

	var normal_speed: float = spawner.current_world_speed()
	var normal_interval: float = spawner.current_spawn_interval()
	spawner.set_world_motion_scale(0.55)
	if spawner.current_world_speed() >= normal_speed:
		push_error("Time Warp motion scale must reduce world speed.")
		failed = true
	if spawner.current_spawn_interval() <= normal_interval:
		push_error("Time Warp must reduce spawn pressure by lengthening the wave interval.")
		failed = true

	var candidate_lanes: Array[int] = spawner.call("_power_up_candidate_lanes", pattern) as Array[int]
	for lane_index: int in candidate_lanes:
		if pattern.blocked_lanes.has(lane_index) or pattern.core_lanes.has(lane_index):
			push_error("Power-up candidate lane overlaps a blocked/Core lane.")
			failed = true
	if candidate_lanes.is_empty():
		push_error("Fair Phase 2 fixture should expose at least one safe power-up lane.")
		failed = true

	spawner.free()
	return failed
