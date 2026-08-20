class_name StarfallSkillFeedbackEmitter
extends Node2D

@export_range(0.2, 2.0, 0.05) var effect_lifetime: float = 0.78

func play_core_pickup(world_position: Vector2) -> void:
	_spawn_effect(
		StarfallEffectVisual.EffectType.CORE_PICKUP,
		world_position,
		1.0,
		0
	)

func play_near_miss(world_position: Vector2, streak_count: int) -> void:
	var is_danger_streak: bool = streak_count >= 3
	var effect_type: StarfallEffectVisual.EffectType = (
		StarfallEffectVisual.EffectType.DANGER_STREAK
		if is_danger_streak
		else StarfallEffectVisual.EffectType.NEAR_MISS
	)
	_spawn_effect(effect_type, world_position, 1.1, streak_count)

func _spawn_effect(
	effect_type: StarfallEffectVisual.EffectType,
	world_position: Vector2,
	display_scale: float,
	variant_index: int
) -> void:
	var effect := StarfallEffectVisual.new()
	effect.effect_type = effect_type
	effect.display_scale = display_scale
	effect.variant = posmod(variant_index, 4)
	effect.position = to_local(world_position)
	add_child(effect)

	var tween: Tween = create_tween()
	tween.tween_interval(effect_lifetime)
	tween.tween_callback(Callable(effect, "queue_free"))
