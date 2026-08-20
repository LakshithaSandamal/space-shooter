extends SceneTree

const PHASE3_PATTERN_PATHS: PackedStringArray = [
	"res://resources/patterns/phase3/wave_reward_center.tres",
	"res://resources/patterns/phase3/wave_reward_outer.tres",
	"res://resources/patterns/phase3/wave_pressure_left_center.tres",
	"res://resources/patterns/phase3/wave_pressure_center_right.tres",
	"res://resources/patterns/phase3/wave_pressure_outer.tres",
]

var _near_miss_events: int = 0
var _hit_events: int = 0

func _initialize() -> void:
	call_deferred("_run_validation")

func _run_validation() -> void:
	var failed: bool = false
	failed = _validate_patterns() or failed
	failed = _validate_skill_system() or failed
	failed = await _validate_near_miss_detector() or failed

	if not failed:
		print("Phase 3 validation passed: combo scoring, grace timing, streak feedback, Near-Miss uniqueness, collision suppression, and pattern fairness are deterministic.")
	quit(1 if failed else 0)

func _validate_patterns() -> bool:
	var failed: bool = false
	for path: String in PHASE3_PATTERN_PATHS:
		var pattern: StarfallLaneWavePattern = load(path) as StarfallLaneWavePattern
		if pattern == null:
			push_error("Phase 3 pattern failed to load: %s" % path)
			failed = true
			continue
		if not pattern.is_fair():
			push_error("Phase 3 pattern is not fair: %s" % pattern.validation_error())
			failed = true
		if pattern.safe_lane_count() < 1:
			push_error("Phase 3 pattern has no survivable lane: %s" % pattern.pattern_id)
			failed = true
	return failed

func _validate_skill_system() -> bool:
	var failed: bool = false
	var scene: PackedScene = load("res://scenes/systems/skill_system.tscn") as PackedScene
	var skill: StarfallSkillSystem = scene.instantiate() as StarfallSkillSystem if scene != null else null
	if skill == null:
		push_error("Phase 3 SkillSystem failed to instantiate.")
		return true

	skill.reset_run()
	if skill.combo_multiplier != 1 or skill.best_combo != 1:
		push_error("SkillSystem must reset to combo x1.")
		failed = true

	var first_core_score: int = skill.register_core(100)
	if first_core_score != 100 or skill.combo_multiplier != 2:
		push_error("First Star Core must score at x1 and advance combo to x2.")
		failed = true

	var second_core_score: int = skill.register_core(100)
	if second_core_score != 200 or skill.combo_multiplier != 3 or skill.best_combo != 3:
		push_error("Second Star Core must score at x2 and advance combo to x3.")
		failed = true

	skill.advance(1.0)
	var grace_before_near_miss: float = skill.combo_grace_remaining
	var near_miss_score: int = skill.register_near_miss()
	if near_miss_score != 225:
		push_error("First Near Miss at combo x3 must score 225 with default Phase 3 tuning.")
		failed = true
	if skill.near_miss_streak != 1 or skill.current_near_miss_feedback() != StarfallSkillSystem.CLOSE_CALL_ID:
		push_error("First Near Miss must produce CLOSE CALL feedback.")
		failed = true
	if skill.combo_grace_remaining <= grace_before_near_miss:
		push_error("Near Miss must restore combo grace while combo is active.")
		failed = true

	skill.register_near_miss()
	skill.register_near_miss()
	if skill.near_miss_streak != 3 or skill.current_near_miss_feedback() != StarfallSkillSystem.DANGER_STREAK_ID:
		push_error("Third consecutive Near Miss must produce DANGER STREAK feedback.")
		failed = true

	skill.register_near_miss()
	skill.register_near_miss()
	if skill.near_miss_streak != 5 or skill.current_near_miss_feedback() != StarfallSkillSystem.EDGE_RUN_ID:
		push_error("Fifth consecutive Near Miss must produce EDGE RUN feedback.")
		failed = true

	skill.advance(skill.combo_grace_duration + 0.1)
	if skill.combo_multiplier != 1 or skill.combo_grace_remaining != 0.0:
		push_error("Expired combo grace must reset combo to x1.")
		failed = true

	skill.reset_run()
	for _index: int in range(30):
		skill.register_core(1)
	if skill.combo_multiplier != skill.maximum_combo or skill.best_combo != skill.maximum_combo:
		push_error("Combo must cap exactly at maximum_combo.")
		failed = true

	skill.free()
	return failed

func _validate_near_miss_detector() -> bool:
	var failed: bool = false
	var asteroid_scene: PackedScene = load("res://scenes/hazards/standard_asteroid.tscn") as PackedScene
	var courier_scene: PackedScene = load("res://scenes/player/courier.tscn") as PackedScene
	if asteroid_scene == null or courier_scene == null:
		push_error("Phase 3 Near-Miss test scenes failed to load.")
		return true

	var courier: StarfallCourierController = courier_scene.instantiate() as StarfallCourierController
	var asteroid: StarfallStandardAsteroid = asteroid_scene.instantiate() as StarfallStandardAsteroid
	if courier == null or asteroid == null:
		push_error("Phase 3 Near-Miss test instances failed to instantiate.")
		return true

	courier.position = Vector2(100.0, 100.0)
	asteroid.position = Vector2(500.0, 500.0)
	root.add_child(courier)
	root.add_child(asteroid)
	await process_frame
	courier.process_mode = Node.PROCESS_MODE_DISABLED
	asteroid.process_mode = Node.PROCESS_MODE_DISABLED

	var hit_shape_node: CollisionShape2D = asteroid.get_node("CollisionShape2D") as CollisionShape2D
	var near_area: Area2D = asteroid.get_node("NearMissArea") as Area2D
	var near_shape_node: CollisionShape2D = asteroid.get_node("NearMissArea/CollisionShape2D") as CollisionShape2D
	var hit_shape: CircleShape2D = hit_shape_node.shape as CircleShape2D if hit_shape_node != null else null
	var near_shape: CircleShape2D = near_shape_node.shape as CircleShape2D if near_shape_node != null else null
	if hit_shape == null or near_shape == null or near_shape.radius <= hit_shape.radius:
		push_error("Near-Miss envelope must be larger than the physical asteroid collision shape.")
		failed = true
	if near_area == null or near_area.collision_layer != 0 or near_area.collision_mask != 1:
		push_error("Near-Miss Area2D must be detection-only and detect player layer 1.")
		failed = true

	_near_miss_events = 0
	_hit_events = 0
	asteroid.near_miss.connect(_on_test_near_miss)
	asteroid.player_hit.connect(_on_test_player_hit)
	asteroid.call("_on_near_miss_body_entered", courier)
	asteroid.call("_on_near_miss_body_exited", courier)
	asteroid.call("_on_near_miss_body_entered", courier)
	asteroid.call("_on_near_miss_body_exited", courier)
	if _near_miss_events != 1:
		push_error("One asteroid must award at most one Near Miss.")
		failed = true

	asteroid.queue_free()
	await process_frame

	var collision_asteroid: StarfallStandardAsteroid = asteroid_scene.instantiate() as StarfallStandardAsteroid
	collision_asteroid.position = Vector2(500.0, 500.0)
	root.add_child(collision_asteroid)
	await process_frame
	collision_asteroid.process_mode = Node.PROCESS_MODE_DISABLED
	collision_asteroid.near_miss.connect(_on_test_near_miss)
	collision_asteroid.player_hit.connect(_on_test_player_hit)
	collision_asteroid.call("_on_near_miss_body_entered", courier)
	collision_asteroid.call("_on_body_entered", courier)
	collision_asteroid.call("_on_near_miss_body_exited", courier)
	if _hit_events != 1:
		push_error("Collision test must emit exactly one player hit.")
		failed = true
	if _near_miss_events != 1:
		push_error("A true collision must suppress the Near-Miss reward.")
		failed = true

	collision_asteroid.queue_free()
	courier.queue_free()
	await process_frame
	return failed

func _on_test_near_miss(_world_position: Vector2) -> void:
	_near_miss_events += 1

func _on_test_player_hit() -> void:
	_hit_events += 1
