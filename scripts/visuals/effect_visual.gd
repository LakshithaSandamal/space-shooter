class_name StarfallEffectVisual
extends Node2D

enum EffectType {
	SPAWN,
	DESPAWN,
	CRASH,
	CORE_PICKUP,
	SHIELD_IMPACT,
	NEAR_MISS,
	DANGER_STREAK,
	ENGINE_TRAIL,
	TIME_WARP,
	OVERCHARGE,
	ROUTE_SELECTED,
	EXTRACTION,
	SECTOR_TRANSITION,
	THREAT_PULSE,
	NEW_RECORD,
	ACHIEVEMENT,
	MASTERY,
}

@export var effect_type: EffectType = EffectType.SPAWN
@export_range(0.5, 3.0, 0.05) var display_scale: float = 1.0
@export_range(0, 3, 1) var variant: int = 0
@export var animate: bool = true

var _time: float = 0.0

func _ready() -> void:
	set_process(animate)
	queue_redraw()

func _process(delta: float) -> void:
	_time += delta
	queue_redraw()

func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE * display_scale)
	match effect_type:
		EffectType.SPAWN: _draw_spawn(false)
		EffectType.DESPAWN: _draw_spawn(true)
		EffectType.CRASH: _draw_crash()
		EffectType.CORE_PICKUP: _draw_core_pickup()
		EffectType.SHIELD_IMPACT: _draw_shield_impact()
		EffectType.NEAR_MISS: _draw_near_miss(false)
		EffectType.DANGER_STREAK: _draw_near_miss(true)
		EffectType.ENGINE_TRAIL: _draw_engine_trail()
		EffectType.TIME_WARP: _draw_time_warp()
		EffectType.OVERCHARGE: _draw_overcharge()
		EffectType.ROUTE_SELECTED: _draw_route_selected()
		EffectType.EXTRACTION: _draw_extraction()
		EffectType.SECTOR_TRANSITION: _draw_sector_transition()
		EffectType.THREAT_PULSE: _draw_threat_pulse()
		EffectType.NEW_RECORD: _draw_reward_burst(StarfallVisualTokens.color(&"gold_primary"))
		EffectType.ACHIEVEMENT: _draw_reward_burst(StarfallVisualTokens.color(&"purple_bright"))
		EffectType.MASTERY: _draw_mastery()

func _phase(speed: float = 1.0) -> float:
	return fmod(_time * speed, 1.0)

func _draw_spawn(reverse: bool) -> void:
	var phase := _phase(0.72)
	if reverse:
		phase = 1.0 - phase
	var alpha := 1.0 - absf(phase - 0.5) * 1.25
	var radius := lerpf(6.0, 48.0, phase)
	var cyan := StarfallVisualTokens.alpha(&"cyan_primary", clampf(alpha, 0.0, 0.75))
	var purple := StarfallVisualTokens.alpha(&"purple_primary", clampf(alpha * 0.72, 0.0, 0.62))
	draw_arc(Vector2.ZERO, radius, -2.8, 2.8, 40, cyan, 2.5, true)
	draw_arc(Vector2.ZERO, radius * 0.72, 0.2, 2.94, 34, purple, 2.0, true)
	for index in range(8):
		var angle := TAU * float(index) / 8.0
		var inner := Vector2.from_angle(angle) * radius * 0.78
		var outer := Vector2.from_angle(angle) * radius * 1.12
		draw_line(inner, outer, StarfallVisualTokens.alpha(&"cyan_soft", alpha * 0.42), 1.5, true)

func _draw_crash() -> void:
	var phase := _phase(0.52)
	var fade := 1.0 - phase
	var orange := StarfallVisualTokens.alpha(&"warning_orange", fade * 0.80)
	var magenta := StarfallVisualTokens.alpha(&"magenta_primary", fade * 0.62)
	draw_circle(Vector2.ZERO, 7.0 + phase * 34.0, StarfallVisualTokens.alpha(&"danger_red", fade * 0.11))
	for index in range(10):
		var angle := TAU * float(index) / 10.0 + float(variant) * 0.13
		var start := Vector2.from_angle(angle) * (6.0 + phase * 10.0)
		var finish := Vector2.from_angle(angle + sin(float(index)) * 0.13) * (18.0 + phase * 46.0)
		draw_line(start, finish, orange if index % 2 == 0 else magenta, 2.0, true)
	for index in range(5):
		var fragment_angle := float(index) * 1.31 + 0.4
		var fragment_position := Vector2.from_angle(fragment_angle) * phase * (28.0 + index * 4.0)
		draw_rect(Rect2(fragment_position - Vector2(2.5, 4.0), Vector2(5.0, 8.0)), StarfallVisualTokens.alpha(&"text_primary", fade * 0.70), true)

func _draw_core_pickup() -> void:
	var phase := _phase(1.3)
	var fade := 1.0 - phase
	var gold := StarfallVisualTokens.alpha(&"gold_primary", fade)
	draw_circle(Vector2.ZERO, 5.0 + phase * 17.0, StarfallVisualTokens.alpha(&"gold_primary", fade * 0.08))
	for index in range(8):
		var angle := TAU * float(index) / 8.0
		draw_line(Vector2.from_angle(angle) * (5.0 + phase * 7.0), Vector2.from_angle(angle) * (14.0 + phase * 22.0), gold, 1.8, true)

func _draw_shield_impact() -> void:
	var phase := _phase(0.95)
	var alpha := 1.0 - phase
	var angle_offset := float(variant) * 0.42
	draw_arc(Vector2.ZERO, 34.0 + phase * 12.0, -1.15 + angle_offset, 1.15 + angle_offset, 30, StarfallVisualTokens.alpha(&"cyan_soft", alpha), 4.0 - phase * 2.0, true)
	draw_arc(Vector2.ZERO, 41.0 + phase * 8.0, -0.8 + angle_offset, 0.8 + angle_offset, 24, StarfallVisualTokens.alpha(&"cyan_primary", alpha * 0.42), 2.0, true)

func _draw_near_miss(streak: bool) -> void:
	var phase := _phase(1.15)
	var fade := 1.0 - phase
	var accent := StarfallVisualTokens.color(&"cyan_primary") if not streak else StarfallVisualTokens.color(&"magenta_primary")
	accent.a = fade * 0.82
	var spread := 12.0 + phase * 28.0
	for side in [-1.0, 1.0]:
		var side_value: float = float(side)
		for index in range(3 if not streak else 5):
			var y := -16.0 + float(index) * 8.0
			var x: float = side_value * (18.0 + float(index) * 2.0)
			draw_line(Vector2(x,y), Vector2(x + side_value * spread,y - 8.0), accent, 2.0, true)
	if streak:
		draw_arc(Vector2.ZERO, 37.0 + phase * 9.0, -2.8, 2.8, 34, StarfallVisualTokens.alpha(&"magenta_bright", fade * 0.46), 2.0, true)

func _draw_engine_trail() -> void:
	var pulse := 0.5 + 0.5 * sin(_time * 8.0)
	var length := 44.0 + pulse * 18.0
	draw_colored_polygon(PackedVector2Array([Vector2(-7,-22), Vector2(0,length), Vector2(7,-22)]), StarfallVisualTokens.alpha(&"purple_primary", 0.18))
	draw_colored_polygon(PackedVector2Array([Vector2(-3,-22), Vector2(0,length * 0.78), Vector2(3,-22)]), StarfallVisualTokens.alpha(&"cyan_primary", 0.62))
	draw_line(Vector2(0,-20), Vector2(0,length * 0.62), StarfallVisualTokens.alpha(&"text_primary", 0.58), 1.5, true)

func _draw_time_warp() -> void:
	var phase := _phase(0.34)
	for index in range(5):
		var radius := 12.0 + float(index) * 10.0 + phase * 8.0
		var color := StarfallVisualTokens.alpha(&"purple_bright", 0.52 - float(index) * 0.07)
		if index % 2 == 1:
			color = StarfallVisualTokens.alpha(&"cyan_primary", 0.42 - float(index) * 0.05)
		draw_arc(Vector2.ZERO, radius, phase * TAU + float(index), phase * TAU + float(index) + 4.2, 32, color, 2.0, true)

func _draw_overcharge() -> void:
	var pulse := 0.5 + 0.5 * sin(_time * 7.0)
	for index in range(7):
		var angle := TAU * float(index) / 7.0 + _time * 0.45
		var inner := Vector2.from_angle(angle) * 16.0
		var mid := Vector2.from_angle(angle + 0.17) * (26.0 + pulse * 6.0)
		var outer := Vector2.from_angle(angle - 0.08) * (37.0 + pulse * 10.0)
		draw_polyline(PackedVector2Array([inner, mid, outer]), StarfallVisualTokens.alpha(&"magenta_primary", 0.72), 2.2, true)
	draw_circle(Vector2.ZERO, 10.0 + pulse * 2.0, StarfallVisualTokens.alpha(&"magenta_bright", 0.15))

func _draw_route_selected() -> void:
	var phase := _phase(1.2)
	var fade := 1.0 - phase
	var cyan := StarfallVisualTokens.alpha(&"cyan_primary", fade * 0.82)
	var width := 32.0 + phase * 22.0
	var height := 42.0 + phase * 12.0
	draw_line(Vector2(-width,-height), Vector2(-width*0.45,-height), cyan, 3.0, true)
	draw_line(Vector2(-width,-height), Vector2(-width,-height*0.45), cyan, 3.0, true)
	draw_line(Vector2(width,-height), Vector2(width*0.45,-height), cyan, 3.0, true)
	draw_line(Vector2(width,-height), Vector2(width,-height*0.45), cyan, 3.0, true)
	draw_line(Vector2(-width,height), Vector2(-width*0.45,height), cyan, 3.0, true)
	draw_line(Vector2(width,height), Vector2(width*0.45,height), cyan, 3.0, true)

func _draw_extraction() -> void:
	var phase := _phase(0.62)
	var alpha := 1.0 - phase
	var green := StarfallVisualTokens.alpha(&"success_green", 0.72 * alpha)
	draw_rect(Rect2(-28.0, -60.0 + phase * 22.0, 56.0, 120.0), StarfallVisualTokens.alpha(&"success_green", 0.025 * alpha), true)
	for index in range(5):
		var x := -24.0 + float(index) * 12.0
		draw_line(Vector2(x,40.0), Vector2(x,-34.0 - phase * 35.0), green, 1.5 + float(index % 2), true)
	draw_arc(Vector2.ZERO, 38.0 + phase * 16.0, -2.8, -0.34, 28, StarfallVisualTokens.alpha(&"cyan_primary", alpha * 0.55), 2.0, true)

func _draw_sector_transition() -> void:
	var phase := _phase(0.75)
	for index in range(14):
		var x := -64.0 + float(index) * 10.0
		var shift := fmod(phase * 90.0 + float(index * 17), 88.0)
		var color := StarfallVisualTokens.alpha(&"cyan_primary", 0.18 + float(index % 3) * 0.08)
		if variant % 2 == 1:
			color = StarfallVisualTokens.alpha(&"purple_bright", 0.18 + float(index % 3) * 0.08)
		draw_line(Vector2(x,-44.0 + shift), Vector2(x,10.0 + shift), color, 1.2, true)

func _draw_threat_pulse() -> void:
	var pulse := 0.5 + 0.5 * sin(_time * 5.5)
	var color := StarfallVisualTokens.alpha(&"danger_red", 0.25 + pulse * 0.48)
	var radius := 36.0 + pulse * 8.0
	draw_arc(Vector2.ZERO, radius, -2.8, -1.72, 18, color, 3.0, true)
	draw_arc(Vector2.ZERO, radius, -1.42, -0.34, 18, color, 3.0, true)
	draw_arc(Vector2.ZERO, radius, 0.34, 1.42, 18, color, 3.0, true)
	draw_arc(Vector2.ZERO, radius, 1.72, 2.8, 18, color, 3.0, true)

func _draw_reward_burst(accent: Color) -> void:
	var phase := _phase(0.58)
	var fade := 1.0 - phase
	accent.a = fade * 0.78
	draw_circle(Vector2.ZERO, 13.0 + phase * 15.0, Color(accent, fade * 0.07))
	for index in range(12):
		var angle := TAU * float(index) / 12.0
		var inner := Vector2.from_angle(angle) * (11.0 + phase * 9.0)
		var outer := Vector2.from_angle(angle) * (24.0 + phase * 25.0)
		draw_line(inner, outer, accent, 2.0 if index % 3 == 0 else 1.0, true)

func _draw_mastery() -> void:
	var pulse := 0.5 + 0.5 * sin(_time * 3.0)
	var purple := StarfallVisualTokens.alpha(&"purple_bright", 0.58 + pulse * 0.20)
	var cyan := StarfallVisualTokens.alpha(&"cyan_primary", 0.56)
	for index in range(3):
		var y := 18.0 - float(index) * 13.0
		draw_polyline(PackedVector2Array([Vector2(-22,y), Vector2(0,y-11), Vector2(22,y)]), purple if index % 2 == 0 else cyan, 3.0, true)
	draw_circle(Vector2.ZERO, 36.0 + pulse * 3.0, StarfallVisualTokens.alpha(&"gold_primary", 0.06), false, 2.0, true)