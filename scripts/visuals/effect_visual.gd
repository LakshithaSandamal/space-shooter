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
	var phase: float = _phase(0.72)
	if reverse:
		phase = 1.0 - phase
	var fade: float = clampf(1.0 - absf(phase - 0.55) * 1.55, 0.0, 1.0)
	var radius: float = lerpf(8.0, 52.0, phase)

	draw_circle(Vector2.ZERO, radius + 8.0, StarfallVisualTokens.alpha(&"cyan_primary", fade * 0.025))
	draw_arc(Vector2.ZERO, radius, -2.85, 2.85, 42, StarfallVisualTokens.alpha(&"cyan_primary", fade * 0.72), 2.2, true)
	draw_arc(Vector2.ZERO, radius * 0.74, 0.18, 3.00, 34, StarfallVisualTokens.alpha(&"purple_primary", fade * 0.56), 1.8, true)
	draw_arc(Vector2.ZERO, radius * 0.48, -1.9, 1.9, 28, StarfallVisualTokens.alpha(&"hull_highlight", fade * 0.42), 1.0, true)

	for index in range(10):
		var angle: float = TAU * float(index) / 10.0 + float(variant) * 0.08
		var inner: Vector2 = Vector2.from_angle(angle) * radius * 0.72
		var outer: Vector2 = Vector2.from_angle(angle) * radius * (1.08 + float(index % 3) * 0.05)
		var ray_color: Color = StarfallVisualTokens.alpha(&"cyan_soft", fade * (0.24 + float(index % 2) * 0.12))
		draw_line(inner, outer, ray_color, 1.2, true)

	for index in range(4):
		var y: float = -18.0 + float(index) * 12.0
		var half_width: float = 16.0 + phase * 18.0 - float(index) * 2.0
		draw_line(Vector2(-half_width, y), Vector2(half_width, y), StarfallVisualTokens.alpha(&"purple_bright", fade * 0.16), 1.0, true)

func _draw_crash() -> void:
	var phase: float = _phase(0.52)
	var fade: float = 1.0 - phase
	draw_circle(Vector2.ZERO, 7.0 + phase * 38.0, StarfallVisualTokens.alpha(&"danger_red", fade * 0.08))
	draw_arc(Vector2.ZERO, 11.0 + phase * 43.0, 0.0, TAU, 42, StarfallVisualTokens.alpha(&"warning_orange", fade * 0.68), 2.2, true)
	draw_arc(Vector2.ZERO, 18.0 + phase * 34.0, -2.8, 2.8, 38, StarfallVisualTokens.alpha(&"magenta_primary", fade * 0.34), 1.3, true)

	for index in range(12):
		var angle: float = TAU * float(index) / 12.0 + float(variant) * 0.11
		var start: Vector2 = Vector2.from_angle(angle) * (7.0 + phase * 8.0)
		var mid: Vector2 = Vector2.from_angle(angle + sin(float(index)) * 0.11) * (18.0 + phase * 22.0)
		var finish: Vector2 = Vector2.from_angle(angle - 0.05) * (28.0 + phase * 48.0)
		var spark: Color = StarfallVisualTokens.alpha(&"warning_orange", fade * 0.82) if index % 3 != 0 else StarfallVisualTokens.alpha(&"magenta_primary", fade * 0.62)
		draw_polyline(PackedVector2Array([start, mid, finish]), spark, 1.6 if index % 2 == 0 else 1.0, true)

	for index in range(7):
		var fragment_angle: float = float(index) * 0.91 + 0.3
		var fragment_position: Vector2 = Vector2.from_angle(fragment_angle) * phase * (26.0 + float(index) * 5.0)
		var fragment_size := Vector2(4.0 + float(index % 2), 7.0 + float(index % 3))
		draw_rect(Rect2(fragment_position - fragment_size * 0.5, fragment_size), StarfallVisualTokens.alpha(&"hull_mid", fade * 0.62), true)
		draw_line(fragment_position, fragment_position + Vector2.from_angle(fragment_angle) * 7.0, StarfallVisualTokens.alpha(&"cyan_primary", fade * 0.22), 0.8, true)

func _draw_core_pickup() -> void:
	var phase: float = _phase(1.3)
	var fade: float = 1.0 - phase
	var gold := StarfallVisualTokens.alpha(&"gold_primary", fade)
	draw_circle(Vector2.ZERO, 5.0 + phase * 20.0, StarfallVisualTokens.alpha(&"gold_primary", fade * 0.05))
	draw_arc(Vector2.ZERO, 10.0 + phase * 24.0, -2.7, 2.7, 34, StarfallVisualTokens.alpha(&"gold_bright", fade * 0.62), 1.7, true)

	for index in range(10):
		var angle: float = TAU * float(index) / 10.0
		var inner: Vector2 = Vector2.from_angle(angle) * (5.0 + phase * 7.0)
		var outer: Vector2 = Vector2.from_angle(angle) * (15.0 + phase * 28.0)
		draw_line(inner, outer, gold, 1.6 if index % 2 == 0 else 1.0, true)
		if index % 2 == 0:
			draw_circle(outer, 1.5 * fade, StarfallVisualTokens.alpha(&"hull_highlight", fade * 0.62))

	var core_scale: float = maxf(0.0, 1.0 - phase * 1.15)
	if core_scale > 0.0:
		var r: float = 8.0 * core_scale
		draw_colored_polygon(PackedVector2Array([Vector2(0,-r), Vector2(r*0.7,0), Vector2(0,r), Vector2(-r*0.7,0)]), StarfallVisualTokens.alpha(&"gold_bright", fade))

func _draw_shield_impact() -> void:
	var phase: float = _phase(0.95)
	var alpha_value: float = 1.0 - phase
	var angle_offset: float = float(variant) * 0.42
	draw_circle(Vector2.ZERO, 34.0 + phase * 12.0, StarfallVisualTokens.alpha(&"cyan_primary", alpha_value * 0.025))
	draw_arc(Vector2.ZERO, 34.0 + phase * 12.0, -1.20 + angle_offset, 1.20 + angle_offset, 30, StarfallVisualTokens.alpha(&"cyan_soft", alpha_value), 4.2 - phase * 2.0, true)
	draw_arc(Vector2.ZERO, 42.0 + phase * 9.0, -0.82 + angle_offset, 0.82 + angle_offset, 24, StarfallVisualTokens.alpha(&"cyan_primary", alpha_value * 0.44), 2.0, true)
	for index in range(4):
		var angle: float = angle_offset - 0.55 + float(index) * 0.35
		var start: Vector2 = Vector2.from_angle(angle) * (31.0 + phase * 8.0)
		var finish: Vector2 = Vector2.from_angle(angle + 0.08) * (48.0 + phase * 12.0)
		draw_line(start, finish, StarfallVisualTokens.alpha(&"cyan_soft", alpha_value * 0.46), 1.2, true)

func _draw_near_miss(streak: bool) -> void:
	var phase: float = _phase(1.15)
	var fade: float = 1.0 - phase
	var accent: Color = StarfallVisualTokens.color(&"cyan_primary") if not streak else StarfallVisualTokens.color(&"magenta_primary")
	accent.a = fade * 0.82
	var spread: float = 12.0 + phase * 31.0
	var line_count: int = 4 if not streak else 6

	for side_entry in [-1.0, 1.0]:
		var side: float = float(side_entry)
		for index in range(line_count):
			var y: float = -20.0 + float(index) * 7.0
			var x: float = side * (17.0 + float(index % 3) * 3.0)
			var start := Vector2(x, y)
			var finish := Vector2(x + side * spread, y - 8.0 - float(index % 2) * 4.0)
			draw_line(start, finish, accent, 2.0 if index % 2 == 0 else 1.2, true)

	draw_arc(Vector2.ZERO, 35.0 + phase * 8.0, -2.65, -0.48, 24, Color(accent, fade * 0.36), 1.4, true)
	if streak:
		draw_arc(Vector2.ZERO, 41.0 + phase * 11.0, 0.34, 2.78, 30, StarfallVisualTokens.alpha(&"magenta_bright", fade * 0.48), 2.0, true)
		for index in range(3):
			var angle: float = -0.6 + float(index) * 0.6
			draw_line(Vector2.from_angle(angle) * 38.0, Vector2.from_angle(angle) * (48.0 + phase * 9.0), StarfallVisualTokens.alpha(&"warning_orange", fade * 0.34), 1.0, true)

func _draw_engine_trail() -> void:
	var pulse: float = 0.5 + 0.5 * sin(_time * 8.0)
	var length: float = 50.0 + pulse * 18.0
	draw_colored_polygon(PackedVector2Array([Vector2(-10,-22), Vector2(0,length), Vector2(10,-22)]), StarfallVisualTokens.alpha(&"purple_primary", 0.13))
	draw_colored_polygon(PackedVector2Array([Vector2(-6,-22), Vector2(0,length * 0.86), Vector2(6,-22)]), StarfallVisualTokens.alpha(&"cyan_deep", 0.34))
	draw_colored_polygon(PackedVector2Array([Vector2(-2.5,-22), Vector2(0,length * 0.68), Vector2(2.5,-22)]), StarfallVisualTokens.alpha(&"cyan_soft", 0.70))
	draw_line(Vector2(0,-20), Vector2(0,length * 0.58), StarfallVisualTokens.alpha(&"hull_highlight", 0.56), 1.3, true)
	for index in range(3):
		var y: float = 12.0 + float(index) * 14.0 + pulse * 3.0
		draw_line(Vector2(-3.0, y), Vector2(3.0, y), StarfallVisualTokens.alpha(&"cyan_primary", 0.18), 0.8, true)

func _draw_time_warp() -> void:
	var phase: float = _phase(0.34)
	draw_circle(Vector2.ZERO, 16.0 + phase * 9.0, StarfallVisualTokens.alpha(&"purple_primary", 0.03))
	for index in range(6):
		var radius: float = 12.0 + float(index) * 9.0 + phase * (6.0 + float(index))
		var color: Color = StarfallVisualTokens.alpha(&"purple_bright", 0.50 - float(index) * 0.055)
		if index % 2 == 1:
			color = StarfallVisualTokens.alpha(&"cyan_primary", 0.40 - float(index) * 0.045)
		var start: float = phase * TAU + float(index) * 0.73
		draw_arc(Vector2.ZERO, radius, start, start + 4.25, 34, color, 1.8, true)
	if phase > 0.45:
		var streak_alpha: float = (phase - 0.45) * 0.60
		draw_line(Vector2(-54, -9), Vector2(-24, -2), StarfallVisualTokens.alpha(&"cyan_soft", streak_alpha), 1.2, true)
		draw_line(Vector2(54, 12), Vector2(25, 3), StarfallVisualTokens.alpha(&"purple_bright", streak_alpha), 1.2, true)

func _draw_overcharge() -> void:
	var pulse: float = 0.5 + 0.5 * sin(_time * 7.0)
	draw_circle(Vector2.ZERO, 17.0 + pulse * 3.0, StarfallVisualTokens.alpha(&"magenta_primary", 0.045))
	for index in range(9):
		var angle: float = TAU * float(index) / 9.0 + _time * 0.45
		var inner: Vector2 = Vector2.from_angle(angle) * 15.0
		var mid: Vector2 = Vector2.from_angle(angle + 0.17) * (26.0 + pulse * 6.0)
		var outer: Vector2 = Vector2.from_angle(angle - 0.08) * (39.0 + pulse * 11.0)
		draw_polyline(PackedVector2Array([inner, mid, outer]), StarfallVisualTokens.alpha(&"magenta_primary", 0.72), 2.0 if index % 2 == 0 else 1.2, true)
	draw_arc(Vector2.ZERO, 33.0 + pulse * 3.0, -2.7, 2.7, 36, StarfallVisualTokens.alpha(&"magenta_bright", 0.24 + pulse * 0.14), 1.4, true)
	draw_circle(Vector2.ZERO, 8.0 + pulse * 2.0, StarfallVisualTokens.alpha(&"magenta_bright", 0.18))

func _draw_route_selected() -> void:
	var phase: float = _phase(1.2)
	var fade: float = 1.0 - phase
	var cyan := StarfallVisualTokens.alpha(&"cyan_primary", fade * 0.82)
	var width: float = 32.0 + phase * 23.0
	var height: float = 42.0 + phase * 13.0
	_draw_corner_bracket(Vector2(-width, -height), Vector2(1, 1), cyan)
	_draw_corner_bracket(Vector2(width, -height), Vector2(-1, 1), cyan)
	_draw_corner_bracket(Vector2(-width, height), Vector2(1, -1), cyan)
	_draw_corner_bracket(Vector2(width, height), Vector2(-1, -1), cyan)
	draw_arc(Vector2.ZERO, 26.0 + phase * 16.0, -2.75, 2.75, 34, StarfallVisualTokens.alpha(&"purple_primary", fade * 0.36), 1.4, true)

func _draw_corner_bracket(origin: Vector2, direction: Vector2, color: Color) -> void:
	draw_line(origin, origin + Vector2(direction.x * 16.0, 0.0), color, 2.4, true)
	draw_line(origin, origin + Vector2(0.0, direction.y * 16.0), color, 2.4, true)

func _draw_extraction() -> void:
	var phase: float = _phase(0.62)
	var alpha_value: float = 1.0 - phase
	var green := StarfallVisualTokens.alpha(&"success_green", 0.72 * alpha_value)
	draw_rect(Rect2(-30.0, -62.0 + phase * 22.0, 60.0, 124.0), StarfallVisualTokens.alpha(&"success_green", 0.022 * alpha_value), true)
	for index in range(7):
		var x: float = -27.0 + float(index) * 9.0
		var strength: float = 0.44 + float(index % 3) * 0.10
		draw_line(Vector2(x,43.0), Vector2(x,-36.0 - phase * 38.0), Color(green, alpha_value * strength), 1.1 + float(index % 2) * 0.5, true)
	draw_arc(Vector2.ZERO, 38.0 + phase * 17.0, -2.8, -0.34, 30, StarfallVisualTokens.alpha(&"cyan_primary", alpha_value * 0.56), 2.0, true)
	draw_arc(Vector2.ZERO, 31.0 + phase * 11.0, 0.34, 2.8, 28, StarfallVisualTokens.alpha(&"success_bright", alpha_value * 0.46), 1.4, true)

func _draw_sector_transition() -> void:
	var phase: float = _phase(0.75)
	for index in range(18):
		var x: float = -78.0 + float(index) * 9.0
		var shift: float = fmod(phase * 104.0 + float(index * 17), 100.0)
		var color := StarfallVisualTokens.alpha(&"cyan_primary", 0.14 + float(index % 3) * 0.06)
		if variant % 2 == 1:
			color = StarfallVisualTokens.alpha(&"purple_bright", 0.14 + float(index % 3) * 0.06)
		var length: float = 36.0 + float(index % 4) * 7.0
		draw_line(Vector2(x,-50.0 + shift), Vector2(x, -50.0 + shift + length), color, 1.0 + float(index % 2) * 0.4, true)
	if phase > 0.58:
		var flash: float = (phase - 0.58) * 0.10
		draw_rect(Rect2(-88.0, -54.0, 176.0, 108.0), StarfallVisualTokens.alpha(&"hull_highlight", flash), true)

func _draw_threat_pulse() -> void:
	var pulse: float = 0.5 + 0.5 * sin(_time * 5.5)
	var color := StarfallVisualTokens.alpha(&"danger_red", 0.25 + pulse * 0.48)
	var radius: float = 36.0 + pulse * 8.0
	draw_circle(Vector2.ZERO, radius + 5.0, StarfallVisualTokens.alpha(&"danger_red", 0.018 + pulse * 0.015))
	draw_arc(Vector2.ZERO, radius, -2.8, -1.72, 18, color, 3.0, true)
	draw_arc(Vector2.ZERO, radius, -1.42, -0.34, 18, color, 3.0, true)
	draw_arc(Vector2.ZERO, radius, 0.34, 1.42, 18, color, 3.0, true)
	draw_arc(Vector2.ZERO, radius, 1.72, 2.8, 18, color, 3.0, true)
	for index in range(4):
		var angle: float = PI * 0.25 + float(index) * PI * 0.5
		draw_line(Vector2.from_angle(angle) * (radius - 8.0), Vector2.from_angle(angle) * (radius + 8.0), StarfallVisualTokens.alpha(&"warning_orange", 0.18 + pulse * 0.16), 1.0, true)

func _draw_reward_burst(accent: Color) -> void:
	var phase: float = _phase(0.58)
	var fade: float = 1.0 - phase
	accent.a = fade * 0.78
	draw_circle(Vector2.ZERO, 13.0 + phase * 17.0, Color(accent, fade * 0.055))
	draw_arc(Vector2.ZERO, 18.0 + phase * 20.0, -2.8, 2.8, 30, Color(accent, fade * 0.42), 1.4, true)
	for index in range(14):
		var angle: float = TAU * float(index) / 14.0
		var inner: Vector2 = Vector2.from_angle(angle) * (10.0 + phase * 9.0)
		var outer: Vector2 = Vector2.from_angle(angle) * (24.0 + phase * 27.0)
		draw_line(inner, outer, accent, 2.0 if index % 3 == 0 else 1.0, true)

func _draw_mastery() -> void:
	var pulse: float = 0.5 + 0.5 * sin(_time * 3.0)
	var purple := StarfallVisualTokens.alpha(&"purple_bright", 0.58 + pulse * 0.20)
	var cyan := StarfallVisualTokens.alpha(&"cyan_primary", 0.56)
	var gold := StarfallVisualTokens.alpha(&"gold_primary", 0.48 + pulse * 0.16)
	for index in range(3):
		var y: float = 18.0 - float(index) * 13.0
		draw_polyline(PackedVector2Array([Vector2(-22,y), Vector2(0,y-11), Vector2(22,y)]), purple if index % 2 == 0 else cyan, 3.0, true)
	draw_arc(Vector2.ZERO, 36.0 + pulse * 3.0, -2.75, 2.75, 38, gold, 1.5, true)
	for index in range(4):
		var angle: float = _time * 0.35 + TAU * float(index) / 4.0
		draw_circle(Vector2.from_angle(angle) * 41.0, 1.6, StarfallVisualTokens.alpha(&"gold_bright", 0.58))
