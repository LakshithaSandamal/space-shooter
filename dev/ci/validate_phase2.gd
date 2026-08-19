extends SceneTree

const PATTERN_PATHS: PackedStringArray = [
	"res://resources/patterns/phase2/wave_left_blocked.tres",
	"res://resources/patterns/phase2/wave_right_blocked.tres",
	"res://resources/patterns/phase2/wave_center_blocked.tres",
	"res://resources/patterns/phase2/wave_left_center_blocked.tres",
	"res://resources/patterns/phase2/wave_center_right_blocked.tres",
	"res://resources/patterns/phase2/wave_left_right_blocked.tres",
]

func _initialize() -> void:
	var failed: bool = false

	for path: String in PATTERN_PATHS:
		var pattern: StarfallLaneWavePattern = load(path) as StarfallLaneWavePattern
		if pattern == null:
			push_error("Phase 2 pattern failed to load: %s" % path)
			failed = true
			continue

		var error_message: String = pattern.validation_error()
		if not error_message.is_empty():
			push_error(error_message)
			failed = true
		if pattern.safe_lane_count() < 1:
			push_error("Phase 2 pattern has no survivable lane: %s" % pattern.pattern_id)
			failed = true

	var asteroid_scene: PackedScene = load("res://scenes/hazards/standard_asteroid.tscn") as PackedScene
	var asteroid: StarfallStandardAsteroid = asteroid_scene.instantiate() as StarfallStandardAsteroid if asteroid_scene != null else null
	if asteroid == null:
		push_error("Standard Asteroid scene failed to instantiate.")
		failed = true
	else:
		if asteroid.collision_layer != 2 or asteroid.collision_mask != 1:
			push_error("Standard Asteroid must use hazard layer 2 and detect player layer 1.")
			failed = true
		asteroid.free()

	var core_scene: PackedScene = load("res://scenes/collectibles/star_core.tscn") as PackedScene
	var core: StarfallStarCore = core_scene.instantiate() as StarfallStarCore if core_scene != null else null
	if core == null:
		push_error("Star Core scene failed to instantiate.")
		failed = true
	else:
		if core.collision_layer != 4 or core.collision_mask != 1:
			push_error("Star Core must use collectible layer 3 and detect player layer 1.")
			failed = true
		core.free()

	var spawner_scene: PackedScene = load("res://scenes/systems/wave_spawner.tscn") as PackedScene
	var spawner: StarfallWaveSpawner = spawner_scene.instantiate() as StarfallWaveSpawner if spawner_scene != null else null
	if spawner == null:
		push_error("Wave Spawner scene failed to instantiate.")
		failed = true
	else:
		spawner.set_distance_m(0.0)
		var starting_speed: float = spawner.current_world_speed()
		var starting_interval: float = spawner.current_spawn_interval()
		spawner.set_distance_m(spawner.distance_for_maximum_speed_m)
		var maximum_speed: float = spawner.current_world_speed()
		var minimum_interval: float = spawner.current_spawn_interval()
		if maximum_speed <= starting_speed:
			push_error("Phase 2 difficulty ramp must increase world speed with distance.")
			failed = true
		if minimum_interval >= starting_interval:
			push_error("Phase 2 difficulty ramp must reduce wave interval with distance.")
			failed = true
		spawner.free()

	if not failed:
		print("Phase 2 validation passed: authored patterns are fair, collision layers are intentional, and difficulty increases monotonically.")
	quit(1 if failed else 0)
