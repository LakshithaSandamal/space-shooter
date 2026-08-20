class_name StarfallPowerUpFeedbackEmitter
extends Node2D

@export_range(0.2, 2.0, 0.05) var effect_lifetime: float = 0.92

func play_pickup(power_up_type: int, world_position: Vector2) -> void:
	match power_up_type:
		StarfallPowerUpSystem.PowerUpType.SHIELD:
			_spawn_effect(StarfallEffectVisual.EffectType.SHIELD_IMPACT, world_position, 0.82, 0)
		StarfallPowerUpSystem.PowerUpType.TIME_WARP:
			_spawn_effect(StarfallEffectVisual.EffectType.TIME_WARP, world_position, 1.05, 1)
		StarfallPowerUpSystem.PowerUpType.OVERCHARGE:
			_spawn_effect(StarfallEffectVisual.EffectType.OVERCHARGE, world_position, 1.05, 2)

func play_shield_save(world_position: Vector2) -> void:
	_spawn_effect(StarfallEffectVisual.EffectType.SHIELD_IMPACT, world_position, 1.25, 3)

func clear_effects() -> void:
	for child: Node in get_children():
		child.queue_free()

func _spawn_effect(effect_type: int, world_position: Vector2, display_scale: float, variant_index: int) -> void:
	var effect := StarfallEffectVisual.new()
	effect.effect_type = effect_type
	effect.display_scale = display_scale
	effect.variant = posmod(variant_index, 4)
	effect.position = to_local(world_position)
	add_child(effect)

	var tween: Tween = create_tween()
	tween.tween_interval(effect_lifetime)
	tween.tween_callback(Callable(effect, "queue_free"))
