class_name StarfallGameObjectVisual
extends Node2D

enum Kind {
	STAR_CORE,
	STAR_CHIP,
	SHIELD,
	TIME_WARP,
	OVERCHARGE,
	CORE_MAGNET,
	STABILIZER,
	PHASE_SHIFT,
	EMERGENCY_JUMP,
	STANDARD_ASTEROID,
	HEAVY_ASTEROID,
	FAST_DEBRIS,
	DRIFTING_DEBRIS,
	ENERGY_MINE,
	LASER_GATE,
	METEOR_WARNING,
	CARGO_WRECK,
	GRAVITY_ANOMALY,
	ROUTE_SAFE,
	ROUTE_CORE,
	ROUTE_DANGER,
	ROUTE_CONTRACT,
	ROUTE_ELITE,
	EXTRACTION_GATE,
	COURIER_HUNTER,
}

enum VisualState {
	NORMAL,
	WARNING,
	ACTIVE,
	SELECTED,
	DISABLED,
	IMPACT,
}

@export var kind: Kind = Kind.STAR_CORE
@export var visual_state: VisualState = VisualState.NORMAL
@export_range(0, 4, 1) var variant: int = 0
@export_range(0.5, 3.0, 0.05) var display_scale: float = 1.0
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
	match kind:
		Kind.STAR_CORE: _draw_star_core()
		Kind.STAR_CHIP: _draw_star_chip()
		Kind.SHIELD: _draw_shield_pickup()
		Kind.TIME_WARP: _draw_time_warp()
		Kind.OVERCHARGE: _draw_overcharge()
		Kind.CORE_MAGNET: _draw_core_magnet()
		Kind.STABILIZER: _draw_stabilizer()
		Kind.PHASE_SHIFT: _draw_phase_shift()
		Kind.EMERGENCY_JUMP: _draw_emergency_jump()
		Kind.STANDARD_ASTEROID: _draw_asteroid(31.0, false)
		Kind.HEAVY_ASTEROID: _draw_asteroid(49.0, true)
		Kind.FAST_DEBRIS: _draw_fast_debris()
		Kind.DRIFTING_DEBRIS: _draw_drifting_debris()
		Kind.ENERGY_MINE: _draw_energy_mine()
		Kind.LASER_GATE: _draw_laser_gate()
		Kind.METEOR_WARNING: _draw_meteor_warning()
		Kind.CARGO_WRECK: _draw_cargo_wreck()
		Kind.GRAVITY_ANOMALY: _draw_gravity_anomaly()
		Kind.ROUTE_SAFE: _draw_route_gate(StarfallVisualTokens.color(&"success_green"))
		Kind.ROUTE_CORE: _draw_route_gate(StarfallVisualTokens.color(&"gold_primary"))
		Kind.ROUTE_DANGER: _draw_route_gate(StarfallVisualTokens.color(&"magenta_primary"))
		Kind.ROUTE_CONTRACT: _draw_route_gate(StarfallVisualTokens.color(&"purple_primary"))
		Kind.ROUTE_ELITE: _draw_route_gate(StarfallVisualTokens.color(&"magenta_bright"))
		Kind.EXTRACTION_GATE: _draw_extraction_gate()
		Kind.COURIER_HUNTER: _draw_courier_hunter()

func _state_alpha() -> float:
	if visual_state == VisualState.DISABLED:
		return 0.30
	return 1.0

func _pulse() -> float:
	return 0.5 + 0.5 * sin(_time * 4.0 + float(variant) * 0.7)

func _draw_star_core() -> void:
	var pulse := _pulse()
	var gold := StarfallVisualTokens.color(&"gold_primary")
	gold.a *= _state_alpha()
	var glow := StarfallVisualTokens.alpha(&"gold_primary", (0.10 + pulse * 0.08) * _state_alpha())
	var radius := 12.0 + float(variant % 3) * 1.5
	draw_circle(Vector2.ZERO, radius + 9.0, glow)
	draw_colored_polygon(PackedVector2Array([
		Vector2(0,-radius), Vector2(radius * 0.65,0), Vector2(0,radius), Vector2(-radius * 0.65,0)
	]), gold)
	draw_circle(Vector2.ZERO, 4.0 + pulse, StarfallVisualTokens.alpha(&"text_primary", _state_alpha()))
	draw_arc(Vector2.ZERO, radius + 5.0, _time, _time + 4.7, 24, StarfallVisualTokens.alpha(&"gold_bright", 0.65 * _state_alpha()), 1.5, true)

func _draw_star_chip() -> void:
	var radius := 14.0 + float(variant % 2) * 2.0
	var points := PackedVector2Array()
	for index in range(6):
		points.append(Vector2.from_angle(-PI * 0.5 + TAU * float(index) / 6.0) * radius)
	draw_colored_polygon(points, StarfallVisualTokens.color(&"gold_deep"))
	draw_polyline(_closed(points), StarfallVisualTokens.color(&"gold_bright"), 2.0, true)
	draw_circle(Vector2.ZERO, 4.5, StarfallVisualTokens.color(&"gold_bright"))
	draw_line(Vector2(-5,0), Vector2(5,0), StarfallVisualTokens.color(&"text_primary"), 1.5, true)

func _draw_shield_pickup() -> void:
	var cyan := StarfallVisualTokens.alpha(&"cyan_primary", _state_alpha())
	draw_circle(Vector2.ZERO, 20.0, StarfallVisualTokens.alpha(&"cyan_primary", 0.08 * _state_alpha()))
	for index in range(3):
		var start := -2.55 + float(index) * 2.05
		draw_arc(Vector2.ZERO, 15.0 + float(index % 2) * 2.0, start, start + 1.55, 18, cyan, 2.5, true)
	draw_circle(Vector2.ZERO, 4.0, StarfallVisualTokens.color(&"cyan_soft"))

func _draw_time_warp() -> void:
	var pulse := _pulse()
	var purple := StarfallVisualTokens.alpha(&"purple_bright", 0.78 * _state_alpha())
	draw_arc(Vector2.ZERO, 17.0 + pulse * 2.0, -2.8, 2.8, 30, purple, 2.0, true)
	draw_arc(Vector2.ZERO, 10.0, _time, _time + 4.4, 22, StarfallVisualTokens.alpha(&"cyan_primary", 0.75 * _state_alpha()), 2.0, true)
	draw_line(Vector2.ZERO, Vector2(0,-9), StarfallVisualTokens.color(&"text_primary"), 1.5, true)
	draw_line(Vector2.ZERO, Vector2(7,2), StarfallVisualTokens.color(&"text_primary"), 1.5, true)

func _draw_overcharge() -> void:
	var magenta := StarfallVisualTokens.alpha(&"magenta_primary", _state_alpha())
	draw_circle(Vector2.ZERO, 21.0, StarfallVisualTokens.alpha(&"magenta_primary", 0.08 * _state_alpha()))
	var bolt := PackedVector2Array([Vector2(4,-18), Vector2(-7,-2), Vector2(1,-2), Vector2(-5,17), Vector2(10,-5), Vector2(2,-5)])
	draw_colored_polygon(bolt, magenta)
	draw_polyline(_closed(bolt), StarfallVisualTokens.alpha(&"text_primary", 0.75), 1.2, true)

func _draw_core_magnet() -> void:
	var gold := StarfallVisualTokens.color(&"gold_primary")
	var cyan := StarfallVisualTokens.color(&"cyan_primary")
	draw_arc(Vector2.ZERO, 15.0, 0.05, PI - 0.05, 28, cyan, 3.0, true)
	draw_line(Vector2(-15,0), Vector2(-15,9), cyan, 3.0, true)
	draw_line(Vector2(15,0), Vector2(15,9), cyan, 3.0, true)
	draw_circle(Vector2(0,-3), 4.0 + _pulse(), gold)

func _draw_stabilizer() -> void:
	var purple := StarfallVisualTokens.color(&"purple_primary")
	draw_colored_polygon(PackedVector2Array([Vector2(0,-17), Vector2(15,-8), Vector2(10,12), Vector2(0,18), Vector2(-10,12), Vector2(-15,-8)]), StarfallVisualTokens.alpha(&"purple_primary", 0.20))
	draw_polyline(PackedVector2Array([Vector2(0,-17), Vector2(15,-8), Vector2(10,12), Vector2(0,18), Vector2(-10,12), Vector2(-15,-8), Vector2(0,-17)]), purple, 2.0, true)
	draw_line(Vector2(-8,0), Vector2(8,0), StarfallVisualTokens.color(&"cyan_soft"), 2.0, true)

func _draw_phase_shift() -> void:
	var offset := sin(_time * 3.0) * 3.0
	for index in range(3):
		var alpha := 0.70 - float(index) * 0.20
		var x := offset + float(index - 1) * 4.0
		draw_colored_polygon(PackedVector2Array([Vector2(x,-17), Vector2(x+11,0), Vector2(x,17), Vector2(x-11,0)]), StarfallVisualTokens.alpha(&"purple_bright", alpha * 0.35))
		draw_polyline(PackedVector2Array([Vector2(x,-17), Vector2(x+11,0), Vector2(x,17), Vector2(x-11,0), Vector2(x,-17)]), StarfallVisualTokens.alpha(&"cyan_primary", alpha), 1.5, true)

func _draw_emergency_jump() -> void:
	var green := StarfallVisualTokens.color(&"success_green")
	draw_arc(Vector2.ZERO, 17.0, -2.7, 2.7, 30, green, 2.5, true)
	draw_colored_polygon(PackedVector2Array([Vector2(0,-14), Vector2(7,1), Vector2(2,1), Vector2(2,13), Vector2(-2,13), Vector2(-2,1), Vector2(-7,1)]), StarfallVisualTokens.color(&"text_primary"))

func _draw_asteroid(radius: float, heavy: bool) -> void:
	var points := PackedVector2Array()
	var count := 9 if heavy else 8
	for index in range(count):
		var angle := TAU * float(index) / float(count)
		var wobble := 0.78 + 0.18 * sin(float(index * 5 + variant * 7))
		points.append(Vector2.from_angle(angle) * radius * wobble)
	var body := Color("29253A") if not heavy else Color("30283C")
	body.a = _state_alpha()
	draw_colored_polygon(points, body)
	draw_polyline(_closed(points), StarfallVisualTokens.alpha(&"purple_deep", 0.80 * _state_alpha()), 2.0 if not heavy else 3.0, true)
	var crack := StarfallVisualTokens.alpha(&"magenta_primary", (0.40 + _pulse() * 0.22) * _state_alpha())
	draw_polyline(PackedVector2Array([Vector2(-radius*0.35,-radius*0.25), Vector2(-2,0), Vector2(radius*0.12,radius*0.16), Vector2(radius*0.34,radius*0.07)]), crack, 1.5, true)
	if heavy:
		draw_circle(Vector2(radius * 0.18, -radius * 0.23), radius * 0.13, Color("1A1827"))

func _draw_fast_debris() -> void:
	var dark := Color("25283A")
	var accent := StarfallVisualTokens.color(&"magenta_primary")
	draw_colored_polygon(PackedVector2Array([Vector2(0,-18), Vector2(10,12), Vector2(-7,16), Vector2(-12,-7)]), dark)
	draw_line(Vector2(-8,-4), Vector2(8,8), accent, 1.5, true)
	for index in range(3):
		draw_line(Vector2(-6 + index * 6,20), Vector2(-6 + index * 6,34 + index * 4), StarfallVisualTokens.alpha(&"text_muted", 0.28), 1.0, true)

func _draw_drifting_debris() -> void:
	draw_colored_polygon(PackedVector2Array([Vector2(-20,-9), Vector2(13,-15), Vector2(22,9), Vector2(-9,17)]), Color("2B2B42"))
	draw_polyline(PackedVector2Array([Vector2(-20,-9), Vector2(13,-15), Vector2(22,9), Vector2(-9,17), Vector2(-20,-9)]), StarfallVisualTokens.alpha(&"warning_orange", 0.48), 1.5, true)
	var drift := sin(_time * 2.0) * 5.0
	draw_line(Vector2(-31,drift), Vector2(-22,drift), StarfallVisualTokens.alpha(&"cyan_primary", 0.45), 2.0, true)

func _draw_energy_mine() -> void:
	var warning_strength := 0.35 + _pulse() * 0.55
	var accent := StarfallVisualTokens.color(&"magenta_primary")
	if visual_state == VisualState.WARNING:
		accent = StarfallVisualTokens.color(&"warning_orange")
	for index in range(8):
		var angle := TAU * float(index) / 8.0
		draw_line(Vector2.from_angle(angle) * 12.0, Vector2.from_angle(angle) * 23.0, StarfallVisualTokens.alpha(&"magenta_primary", warning_strength), 2.0, true)
	draw_circle(Vector2.ZERO, 11.0, StarfallVisualTokens.alpha(&"space_navy_2", 0.96))
	draw_circle(Vector2.ZERO, 6.0 + _pulse() * 1.5, accent)
	draw_arc(Vector2.ZERO, 27.0 + _pulse() * 3.0, 0.0, TAU, 36, StarfallVisualTokens.alpha(&"danger_red", 0.18 + _pulse() * 0.22), 1.5, true)

func _draw_laser_gate() -> void:
	var active := visual_state == VisualState.ACTIVE or visual_state == VisualState.IMPACT
	var color := StarfallVisualTokens.color(&"danger_red") if active else StarfallVisualTokens.color(&"magenta_primary")
	var beam_alpha := 0.72 if active else 0.22 + _pulse() * 0.18
	draw_line(Vector2(-39,-30), Vector2(-39,30), StarfallVisualTokens.alpha(&"line_muted", 0.85), 5.0, true)
	draw_line(Vector2(39,-30), Vector2(39,30), StarfallVisualTokens.alpha(&"line_muted", 0.85), 5.0, true)
	draw_line(Vector2(-37,0), Vector2(37,0), StarfallVisualTokens.alpha(&"danger_red", beam_alpha), 4.0 if active else 2.0, true)
	draw_circle(Vector2(-39,0), 5.0, color)
	draw_circle(Vector2(39,0), 5.0, color)

func _draw_meteor_warning() -> void:
	var pulse := _pulse()
	var orange := StarfallVisualTokens.alpha(&"warning_orange", 0.62 + pulse * 0.30)
	draw_circle(Vector2.ZERO, 24.0 + pulse * 5.0, StarfallVisualTokens.alpha(&"warning_orange", 0.06 + pulse * 0.05))
	draw_arc(Vector2.ZERO, 21.0 + pulse * 3.0, 0.0, TAU, 36, orange, 2.0, true)
	draw_line(Vector2(-9,0), Vector2(9,0), orange, 2.0, true)
	draw_line(Vector2(0,-9), Vector2(0,9), orange, 2.0, true)

func _draw_cargo_wreck() -> void:
	var body := Color("2A2939")
	var wreck := PackedVector2Array([Vector2(-43,-17), Vector2(-15,-27), Vector2(28,-21), Vector2(44,-5), Vector2(31,21), Vector2(4,16), Vector2(-22,28), Vector2(-39,12)])
	draw_colored_polygon(wreck, body)
	draw_polyline(_closed(wreck), StarfallVisualTokens.alpha(&"gold_deep", 0.40), 2.0, true)
	draw_line(Vector2(-17,-19), Vector2(7,14), StarfallVisualTokens.alpha(&"warning_orange", 0.48), 2.0, true)
	draw_rect(Rect2(13,-11,15,8), StarfallVisualTokens.alpha(&"cyan_deep", 0.44), true)

func _draw_gravity_anomaly() -> void:
	var pulse := _pulse()
	for index in range(4):
		var radius := 12.0 + float(index) * 9.0 + pulse * 2.0
		var start := _time * (0.35 + float(index) * 0.08) + float(index) * 0.7
		var color := StarfallVisualTokens.alpha(&"purple_bright", 0.52 - float(index) * 0.08)
		if index % 2 == 1:
			color = StarfallVisualTokens.alpha(&"cyan_primary", 0.42 - float(index) * 0.05)
		draw_arc(Vector2.ZERO, radius, start, start + 4.5, 30, color, 2.0, true)
	draw_circle(Vector2.ZERO, 6.0 + pulse * 2.0, Color("03040B"))

func _draw_route_gate(accent: Color) -> void:
	accent.a *= _state_alpha()
	var width := 72.0
	var height := 68.0
	var pulse := _pulse()
	if visual_state == VisualState.SELECTED:
		width += 4.0 + pulse * 3.0
		height += 4.0 + pulse * 3.0
	draw_line(Vector2(-width*0.5,height*0.5), Vector2(-width*0.5,-height*0.35), accent, 3.0, true)
	draw_line(Vector2(width*0.5,height*0.5), Vector2(width*0.5,-height*0.35), accent, 3.0, true)
	draw_line(Vector2(-width*0.5,-height*0.35), Vector2(-width*0.26,-height*0.5), accent, 3.0, true)
	draw_line(Vector2(width*0.5,-height*0.35), Vector2(width*0.26,-height*0.5), accent, 3.0, true)
	draw_line(Vector2(-width*0.26,-height*0.5), Vector2(width*0.26,-height*0.5), accent, 3.0, true)
	draw_arc(Vector2.ZERO, width * 0.36, 0.3, 2.84, 24, Color(accent, 0.25), 1.0, true)

func _draw_extraction_gate() -> void:
	var pulse := _pulse()
	var green := StarfallVisualTokens.alpha(&"success_green", 0.75)
	var cyan := StarfallVisualTokens.alpha(&"cyan_primary", 0.48)
	draw_arc(Vector2.ZERO, 52.0 + pulse * 3.0, -2.9, -0.24, 38, green, 4.0, true)
	draw_arc(Vector2.ZERO, 43.0, 0.20, 2.94, 34, cyan, 2.0, true)
	draw_line(Vector2(-48,22), Vector2(-28,43), green, 3.0, true)
	draw_line(Vector2(48,22), Vector2(28,43), green, 3.0, true)
	draw_circle(Vector2.ZERO, 8.0 + pulse * 2.0, StarfallVisualTokens.alpha(&"success_bright", 0.12))

func _draw_courier_hunter() -> void:
	var body := Color("1B1726")
	var hunter := PackedVector2Array([Vector2(0,-44), Vector2(17,-15), Vector2(40,2), Vector2(23,14), Vector2(13,8), Vector2(0,28), Vector2(-13,8), Vector2(-23,14), Vector2(-40,2), Vector2(-17,-15)])
	draw_colored_polygon(hunter, body)
	draw_polyline(_closed(hunter), StarfallVisualTokens.alpha(&"magenta_primary", 0.82), 2.5, true)
	draw_circle(Vector2.ZERO, 7.0 + _pulse(), StarfallVisualTokens.color(&"danger_red"))
	draw_line(Vector2(-31,3), Vector2(-18,0), StarfallVisualTokens.color(&"magenta_bright"), 2.0, true)
	draw_line(Vector2(31,3), Vector2(18,0), StarfallVisualTokens.color(&"magenta_bright"), 2.0, true)

func _closed(points: PackedVector2Array) -> PackedVector2Array:
	var result := PackedVector2Array()
	for point in points:
		result.append(point)
	if result.size() > 0:
		result.append(result[0])
	return result
