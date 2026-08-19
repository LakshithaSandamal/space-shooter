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
@export_range(0, 7, 1) var variant: int = 0
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
		Kind.STANDARD_ASTEROID: _draw_asteroid(32.0, false)
		Kind.HEAVY_ASTEROID: _draw_asteroid(51.0, true)
		Kind.FAST_DEBRIS: _draw_fast_debris()
		Kind.DRIFTING_DEBRIS: _draw_drifting_debris()
		Kind.ENERGY_MINE: _draw_energy_mine()
		Kind.LASER_GATE: _draw_laser_gate()
		Kind.METEOR_WARNING: _draw_meteor_warning()
		Kind.CARGO_WRECK: _draw_cargo_wreck()
		Kind.GRAVITY_ANOMALY: _draw_gravity_anomaly()
		Kind.ROUTE_SAFE: _draw_route_gate(StarfallVisualTokens.color(&"success_green"), &"safe")
		Kind.ROUTE_CORE: _draw_route_gate(StarfallVisualTokens.color(&"gold_primary"), &"core")
		Kind.ROUTE_DANGER: _draw_route_gate(StarfallVisualTokens.color(&"magenta_primary"), &"danger")
		Kind.ROUTE_CONTRACT: _draw_route_gate(StarfallVisualTokens.color(&"purple_primary"), &"contract")
		Kind.ROUTE_ELITE: _draw_route_gate(StarfallVisualTokens.color(&"magenta_bright"), &"elite")
		Kind.EXTRACTION_GATE: _draw_extraction_gate()
		Kind.COURIER_HUNTER: _draw_courier_hunter()

func _state_alpha() -> float:
	if visual_state == VisualState.DISABLED:
		return 0.30
	return 1.0

func _pulse(speed: float = 4.0) -> float:
	return 0.5 + 0.5 * sin(_time * speed + float(variant) * 0.7)

func _draw_star_core() -> void:
	var pulse: float = _pulse(3.6)
	var alpha_value: float = _state_alpha()
	var radius: float = 13.0 + float(variant % 3) * 1.5
	var rotation_offset: float = _time * (0.45 + float(variant % 2) * 0.12)

	draw_circle(Vector2.ZERO, radius + 14.0, StarfallVisualTokens.alpha(&"gold_primary", (0.035 + pulse * 0.025) * alpha_value))
	draw_circle(Vector2.ZERO, radius + 7.0, StarfallVisualTokens.alpha(&"gold_deep", 0.10 * alpha_value))

	var outer_points := PackedVector2Array([
		Vector2(0.0, -radius * 1.15),
		Vector2(radius * 0.82, -radius * 0.26),
		Vector2(radius * 0.62, radius * 0.78),
		Vector2(0.0, radius * 1.02),
		Vector2(-radius * 0.62, radius * 0.78),
		Vector2(-radius * 0.82, -radius * 0.26),
	])
	draw_colored_polygon(outer_points, StarfallVisualTokens.alpha(&"gold_deep", 0.94 * alpha_value))
	draw_polyline(_closed(outer_points), StarfallVisualTokens.alpha(&"gold_bright", 0.92 * alpha_value), 1.5, true)

	var left_facet := PackedVector2Array([
		Vector2(0.0, -radius * 0.96),
		Vector2(-radius * 0.65, -radius * 0.20),
		Vector2(-radius * 0.46, radius * 0.58),
		Vector2(0.0, radius * 0.34),
	])
	var right_facet := PackedVector2Array([
		Vector2(0.0, -radius * 0.96),
		Vector2(radius * 0.65, -radius * 0.20),
		Vector2(radius * 0.46, radius * 0.58),
		Vector2(0.0, radius * 0.34),
	])
	draw_colored_polygon(left_facet, StarfallVisualTokens.alpha(&"gold_primary", 0.68 * alpha_value))
	draw_colored_polygon(right_facet, StarfallVisualTokens.alpha(&"gold_bright", 0.76 * alpha_value))
	draw_line(Vector2(0.0, -radius * 0.88), Vector2(0.0, radius * 0.62), StarfallVisualTokens.alpha(&"hull_highlight", 0.54 * alpha_value), 1.0, true)

	for orbit_index in range(2):
		var orbit_radius: float = radius + 5.0 + float(orbit_index) * 5.0
		var orbit_color: Color = StarfallVisualTokens.alpha(&"gold_bright", (0.46 - float(orbit_index) * 0.14) * alpha_value)
		draw_arc(Vector2.ZERO, orbit_radius, rotation_offset + float(orbit_index), rotation_offset + float(orbit_index) + 4.4, 28, orbit_color, 1.2, true)

	draw_circle(Vector2.ZERO, 4.0 + pulse * 1.2, StarfallVisualTokens.alpha(&"hull_highlight", alpha_value))
	draw_circle(Vector2.ZERO, 2.0 + pulse * 0.6, StarfallVisualTokens.alpha(&"gold_bright", alpha_value))

func _draw_star_chip() -> void:
	var radius: float = 15.0 + float(variant % 2) * 2.0
	var points: PackedVector2Array = _regular_polygon(6, radius, -PI * 0.5)
	draw_circle(Vector2.ZERO, radius + 7.0, StarfallVisualTokens.alpha(&"gold_primary", 0.055))
	draw_colored_polygon(points, StarfallVisualTokens.color(&"metal_dark"))
	draw_polyline(_closed(points), StarfallVisualTokens.color(&"gold_bright"), 2.0, true)
	var inner := _regular_polygon(6, radius * 0.62, -PI * 0.5)
	draw_colored_polygon(inner, StarfallVisualTokens.alpha(&"gold_deep", 0.72))
	draw_polyline(_closed(inner), StarfallVisualTokens.alpha(&"gold_primary", 0.82), 1.0, true)
	draw_circle(Vector2.ZERO, 4.0 + _pulse(3.0), StarfallVisualTokens.color(&"gold_bright"))
	draw_line(Vector2(-6.0, 0.0), Vector2(6.0, 0.0), StarfallVisualTokens.alpha(&"hull_highlight", 0.72), 1.3, true)

func _draw_shield_pickup() -> void:
	var pulse: float = _pulse(3.4)
	var alpha_value: float = _state_alpha()
	draw_circle(Vector2.ZERO, 24.0, StarfallVisualTokens.alpha(&"cyan_primary", 0.045 * alpha_value))
	draw_circle(Vector2.ZERO, 18.0, StarfallVisualTokens.alpha(&"space_navy_2", 0.84 * alpha_value))
	for index in range(4):
		var start: float = -2.75 + float(index) * 1.52 + _time * 0.08
		draw_arc(Vector2.ZERO, 17.0 + float(index % 2) * 3.0, start, start + 1.05, 16, StarfallVisualTokens.alpha(&"cyan_primary", (0.54 + pulse * 0.22) * alpha_value), 2.3, true)
	var shield_face := PackedVector2Array([Vector2(0,-11), Vector2(9,-6), Vector2(7,5), Vector2(0,12), Vector2(-7,5), Vector2(-9,-6)])
	draw_colored_polygon(shield_face, StarfallVisualTokens.alpha(&"cyan_deep", 0.48 * alpha_value))
	draw_polyline(_closed(shield_face), StarfallVisualTokens.alpha(&"cyan_soft", 0.88 * alpha_value), 1.5, true)
	draw_line(Vector2(0,-7), Vector2(0,7), StarfallVisualTokens.alpha(&"hull_highlight", 0.70 * alpha_value), 1.1, true)

func _draw_time_warp() -> void:
	var pulse: float = _pulse(2.8)
	var alpha_value: float = _state_alpha()
	draw_circle(Vector2.ZERO, 23.0, StarfallVisualTokens.alpha(&"purple_primary", 0.035 * alpha_value))
	for index in range(3):
		var radius: float = 10.0 + float(index) * 6.0 + pulse * float(index)
		var accent: Color = StarfallVisualTokens.alpha(&"purple_bright", (0.70 - float(index) * 0.14) * alpha_value) if index % 2 == 0 else StarfallVisualTokens.alpha(&"cyan_primary", 0.55 * alpha_value)
		draw_arc(Vector2.ZERO, radius, _time * 0.55 + float(index), _time * 0.55 + float(index) + 4.35, 26, accent, 1.8, true)
	draw_colored_polygon(PackedVector2Array([Vector2(0,-10), Vector2(6,-2), Vector2(3,9), Vector2(-4,9), Vector2(-7,-1)]), StarfallVisualTokens.alpha(&"space_void", 0.92))
	draw_line(Vector2(0,-7), Vector2(0,1), StarfallVisualTokens.color(&"hull_highlight"), 1.4, true)
	draw_line(Vector2(0,1), Vector2(6,4), StarfallVisualTokens.color(&"hull_highlight"), 1.4, true)

func _draw_overcharge() -> void:
	var pulse: float = _pulse(5.2)
	var alpha_value: float = _state_alpha()
	draw_circle(Vector2.ZERO, 24.0, StarfallVisualTokens.alpha(&"magenta_primary", 0.045 * alpha_value))
	draw_circle(Vector2.ZERO, 17.0, StarfallVisualTokens.alpha(&"space_navy_2", 0.86 * alpha_value))
	var bolt := PackedVector2Array([Vector2(4,-18), Vector2(-7,-2), Vector2(1,-2), Vector2(-5,17), Vector2(10,-5), Vector2(2,-5)])
	draw_colored_polygon(bolt, StarfallVisualTokens.alpha(&"magenta_primary", alpha_value))
	draw_polyline(_closed(bolt), StarfallVisualTokens.alpha(&"hull_highlight", 0.76 * alpha_value), 1.2, true)
	for index in range(5):
		var angle: float = _time * 0.7 + TAU * float(index) / 5.0
		var start: Vector2 = Vector2.from_angle(angle) * 18.0
		var middle: Vector2 = Vector2.from_angle(angle + 0.12) * (22.0 + pulse * 3.0)
		var finish: Vector2 = Vector2.from_angle(angle - 0.08) * (29.0 + pulse * 4.0)
		draw_polyline(PackedVector2Array([start, middle, finish]), StarfallVisualTokens.alpha(&"magenta_bright", 0.52 * alpha_value), 1.2, true)

func _draw_core_magnet() -> void:
	var pulse: float = _pulse(3.0)
	draw_circle(Vector2.ZERO, 23.0, StarfallVisualTokens.alpha(&"cyan_primary", 0.035))
	draw_arc(Vector2.ZERO, 16.0, 0.06, PI - 0.06, 28, StarfallVisualTokens.color(&"cyan_primary"), 3.2, true)
	draw_line(Vector2(-16,0), Vector2(-16,10), StarfallVisualTokens.color(&"cyan_primary"), 3.2, true)
	draw_line(Vector2(16,0), Vector2(16,10), StarfallVisualTokens.color(&"cyan_primary"), 3.2, true)
	draw_rect(Rect2(-19.0, 8.0, 6.0, 7.0), StarfallVisualTokens.color(&"metal_mid"), true)
	draw_rect(Rect2(13.0, 8.0, 6.0, 7.0), StarfallVisualTokens.color(&"metal_mid"), true)
	draw_circle(Vector2(0,-3), 4.0 + pulse, StarfallVisualTokens.color(&"gold_primary"))
	draw_arc(Vector2(0,-3), 8.0 + pulse * 2.0, -2.3, 0.9, 20, StarfallVisualTokens.alpha(&"gold_bright", 0.38), 1.0, true)

func _draw_stabilizer() -> void:
	var frame := _regular_polygon(6, 19.0, -PI * 0.5)
	draw_colored_polygon(frame, StarfallVisualTokens.alpha(&"metal_dark", 0.92))
	draw_polyline(_closed(frame), StarfallVisualTokens.color(&"purple_primary"), 2.0, true)
	var inner := _regular_polygon(6, 11.0, -PI * 0.5)
	draw_polyline(_closed(inner), StarfallVisualTokens.alpha(&"cyan_soft", 0.62), 1.3, true)
	draw_line(Vector2(-9,0), Vector2(9,0), StarfallVisualTokens.color(&"cyan_soft"), 2.0, true)
	draw_circle(Vector2.ZERO, 3.5 + _pulse(2.5), StarfallVisualTokens.alpha(&"purple_bright", 0.76))

func _draw_phase_shift() -> void:
	var offset: float = sin(_time * 3.0) * 3.0
	draw_circle(Vector2.ZERO, 23.0, StarfallVisualTokens.alpha(&"purple_primary", 0.03))
	for index in range(3):
		var alpha_value: float = 0.70 - float(index) * 0.20
		var x: float = offset + float(index - 1) * 4.5
		var diamond := PackedVector2Array([Vector2(x,-17), Vector2(x+11,0), Vector2(x,17), Vector2(x-11,0)])
		draw_colored_polygon(diamond, StarfallVisualTokens.alpha(&"purple_bright", alpha_value * 0.20))
		draw_polyline(_closed(diamond), StarfallVisualTokens.alpha(&"cyan_primary", alpha_value), 1.4, true)

func _draw_emergency_jump() -> void:
	var pulse: float = _pulse(3.2)
	draw_circle(Vector2.ZERO, 23.0, StarfallVisualTokens.alpha(&"success_green", 0.035))
	draw_arc(Vector2.ZERO, 18.0 + pulse * 2.0, -2.7, 2.7, 30, StarfallVisualTokens.color(&"success_green"), 2.5, true)
	draw_colored_polygon(PackedVector2Array([Vector2(0,-14), Vector2(7,1), Vector2(2,1), Vector2(2,13), Vector2(-2,13), Vector2(-2,1), Vector2(-7,1)]), StarfallVisualTokens.color(&"hull_highlight"))
	draw_line(Vector2(-10,12), Vector2(0,18), StarfallVisualTokens.alpha(&"cyan_primary", 0.50), 1.3, true)
	draw_line(Vector2(10,12), Vector2(0,18), StarfallVisualTokens.alpha(&"cyan_primary", 0.50), 1.3, true)

func _draw_asteroid(radius: float, heavy: bool) -> void:
	var point_count: int = 11 if heavy else 9
	var points: PackedVector2Array = _asteroid_points(radius, point_count, variant, heavy)
	var body: Color = Color("302A3F") if heavy else Color("29263A")
	var shadow: Color = Color("191825") if heavy else Color("1B1B2A")
	body.a = _state_alpha()
	shadow.a = _state_alpha()

	draw_circle(Vector2.ZERO, radius * 1.08, StarfallVisualTokens.alpha(&"purple_primary", 0.018))
	draw_colored_polygon(points, body)
	draw_polyline(_closed(points), StarfallVisualTokens.alpha(&"purple_deep", 0.72 * _state_alpha()), 2.3 if heavy else 1.7, true)

	var facet_a := PackedVector2Array([
		points[0], points[1], Vector2(radius * 0.15, -radius * 0.05), points[point_count - 1]
	])
	var facet_b := PackedVector2Array([
		points[3], points[4], points[5], Vector2(radius * 0.08, radius * 0.12)
	])
	draw_colored_polygon(facet_a, StarfallVisualTokens.alpha(&"metal_mid", 0.32 * _state_alpha()))
	draw_colored_polygon(facet_b, Color(shadow, 0.72 * _state_alpha()))

	var crater_count: int = 3 if heavy else 2
	for crater_index in range(crater_count):
		var angle: float = float(variant + crater_index * 3) * 1.17
		var crater_pos: Vector2 = Vector2.from_angle(angle) * radius * (0.24 + float(crater_index) * 0.13)
		var crater_radius: float = radius * (0.095 + float((variant + crater_index) % 3) * 0.018)
		draw_circle(crater_pos, crater_radius + 1.8, StarfallVisualTokens.alpha(&"metal_light", 0.12 * _state_alpha()))
		draw_circle(crater_pos + Vector2(1.2, 1.4), crater_radius, Color(shadow, 0.88 * _state_alpha()))

	var crack_color := StarfallVisualTokens.alpha(&"magenta_primary", (0.28 + _pulse(2.2) * 0.18) * _state_alpha())
	var crack_shift: float = float((variant % 3) - 1) * radius * 0.08
	draw_polyline(PackedVector2Array([
		Vector2(-radius * 0.46, -radius * 0.24 + crack_shift),
		Vector2(-radius * 0.14, -radius * 0.05),
		Vector2(radius * 0.02, radius * 0.15),
		Vector2(radius * 0.30, radius * 0.04),
		Vector2(radius * 0.45, radius * 0.20),
	]), crack_color, 1.35 if not heavy else 1.8, true)
	if heavy:
		draw_polyline(PackedVector2Array([
			Vector2(radius * 0.05, radius * 0.13),
			Vector2(radius * 0.16, radius * 0.35),
			Vector2(radius * 0.08, radius * 0.56),
		]), StarfallVisualTokens.alpha(&"warning_orange", 0.18 * _state_alpha()), 1.2, true)

func _asteroid_points(radius: float, point_count: int, variant_index: int, heavy: bool) -> PackedVector2Array:
	var points := PackedVector2Array()
	var seed_factor: float = 0.47 + float(variant_index) * 0.61
	for index in range(point_count):
		var angle: float = TAU * float(index) / float(point_count)
		var harmonic_a: float = sin(float(index * 5) + seed_factor * 3.1)
		var harmonic_b: float = cos(float(index * 3) + seed_factor * 1.7)
		var wobble: float = 0.78 + harmonic_a * 0.11 + harmonic_b * 0.075
		if heavy:
			wobble += sin(float(index * 7 + variant_index)) * 0.035
		points.append(Vector2.from_angle(angle) * radius * wobble)
	return points

func _draw_fast_debris() -> void:
	var body := PackedVector2Array([Vector2(0,-20), Vector2(11,-3), Vector2(8,14), Vector2(-8,18), Vector2(-14,-8)])
	draw_colored_polygon(body, StarfallVisualTokens.color(&"metal_dark"))
	draw_polyline(_closed(body), StarfallVisualTokens.alpha(&"metal_light", 0.62), 1.4, true)
	draw_colored_polygon(PackedVector2Array([Vector2(-8,-7), Vector2(5,-10), Vector2(8,-3), Vector2(-2,2)]), StarfallVisualTokens.alpha(&"metal_mid", 0.72))
	draw_line(Vector2(-9,-3), Vector2(8,8), StarfallVisualTokens.alpha(&"magenta_primary", 0.72), 1.4, true)
	for index in range(3):
		var x: float = -6.0 + float(index) * 6.0
		draw_line(Vector2(x,21), Vector2(x,34 + float(index) * 4.0), StarfallVisualTokens.alpha(&"text_muted", 0.24), 1.0, true)

func _draw_drifting_debris() -> void:
	var drift: float = sin(_time * 2.0) * 5.0
	var body := PackedVector2Array([Vector2(-22,-10), Vector2(4,-17), Vector2(20,-5), Vector2(23,10), Vector2(-8,19), Vector2(-20,7)])
	draw_colored_polygon(body, StarfallVisualTokens.color(&"metal_dark"))
	draw_polyline(_closed(body), StarfallVisualTokens.alpha(&"warning_orange", 0.42), 1.4, true)
	draw_colored_polygon(PackedVector2Array([Vector2(-12,-8), Vector2(3,-11), Vector2(9,-4), Vector2(-3,1)]), StarfallVisualTokens.alpha(&"metal_mid", 0.56))
	draw_line(Vector2(-10,8), Vector2(12,4), StarfallVisualTokens.alpha(&"line_muted", 0.72), 1.0, true)
	draw_line(Vector2(-33,drift), Vector2(-24,drift), StarfallVisualTokens.alpha(&"cyan_primary", 0.45), 2.0, true)

func _draw_energy_mine() -> void:
	var pulse: float = _pulse(5.0)
	var active: bool = visual_state == VisualState.ACTIVE or visual_state == VisualState.IMPACT
	var accent: Color = StarfallVisualTokens.color(&"danger_red") if active else StarfallVisualTokens.color(&"warning_orange")
	var ring_alpha: float = 0.34 + pulse * 0.30

	draw_circle(Vector2.ZERO, 31.0 + pulse * 3.0, Color(accent, 0.035 + pulse * 0.018))
	for index in range(8):
		var angle: float = TAU * float(index) / 8.0
		var inner: Vector2 = Vector2.from_angle(angle) * 12.0
		var outer: Vector2 = Vector2.from_angle(angle) * (25.0 + float(index % 2) * 3.0)
		draw_line(inner, outer, Color(accent, 0.48 + pulse * 0.28), 2.0, true)
		draw_circle(outer, 1.8, Color(accent, 0.70))

	var shell := _regular_polygon(8, 13.0, PI * 0.125)
	draw_colored_polygon(shell, StarfallVisualTokens.color(&"metal_dark"))
	draw_polyline(_closed(shell), StarfallVisualTokens.alpha(&"metal_light", 0.72), 1.2, true)
	draw_circle(Vector2.ZERO, 8.0, StarfallVisualTokens.color(&"space_void"))
	draw_circle(Vector2.ZERO, 5.0 + pulse * 1.5, accent)
	draw_circle(Vector2.ZERO, 2.0 + pulse * 0.5, StarfallVisualTokens.color(&"hull_highlight"))
	draw_arc(Vector2.ZERO, 29.0 + pulse * 3.0, 0.0, TAU, 36, Color(accent, ring_alpha), 1.4, true)

func _draw_laser_gate() -> void:
	var pulse: float = _pulse(4.8)
	var active: bool = visual_state == VisualState.ACTIVE or visual_state == VisualState.IMPACT
	var accent: Color = StarfallVisualTokens.color(&"danger_red") if active else StarfallVisualTokens.color(&"warning_orange")
	var beam_alpha: float = 0.78 if active else 0.22 + pulse * 0.24

	for side_value in [-1.0, 1.0]:
		var side: float = float(side_value)
		var x: float = side * 41.0
		var pylon := PackedVector2Array([
			Vector2(x - side * 6.0, -35.0),
			Vector2(x + side * 5.0, -30.0),
			Vector2(x + side * 5.0, 30.0),
			Vector2(x - side * 6.0, 35.0),
		])
		draw_colored_polygon(pylon, StarfallVisualTokens.color(&"metal_dark"))
		draw_polyline(_closed(pylon), StarfallVisualTokens.alpha(&"metal_light", 0.62), 1.5, true)
		draw_line(Vector2(x, -22.0), Vector2(x, 22.0), StarfallVisualTokens.alpha(&"line_muted", 0.72), 1.0, true)
		draw_circle(Vector2(x, 0.0), 8.0, StarfallVisualTokens.color(&"space_void"))
		draw_circle(Vector2(x, 0.0), 5.0 + pulse, accent)
		draw_circle(Vector2(x, 0.0), 2.0, StarfallVisualTokens.color(&"hull_highlight"))

	draw_line(Vector2(-36,0), Vector2(36,0), Color(accent, beam_alpha * 0.25), 8.0 if active else 4.0, true)
	draw_line(Vector2(-36,0), Vector2(36,0), Color(accent, beam_alpha), 3.5 if active else 1.8, true)
	if active:
		draw_line(Vector2(-33,-3), Vector2(33,-3), StarfallVisualTokens.alpha(&"hull_highlight", 0.20 + pulse * 0.16), 1.0, true)

func _draw_meteor_warning() -> void:
	var pulse: float = _pulse(4.2)
	var orange := StarfallVisualTokens.alpha(&"warning_orange", 0.62 + pulse * 0.28)
	draw_circle(Vector2.ZERO, 27.0 + pulse * 5.0, StarfallVisualTokens.alpha(&"warning_orange", 0.025 + pulse * 0.02))
	draw_arc(Vector2.ZERO, 24.0 + pulse * 5.0, 0.0, TAU, 36, orange, 2.1, true)
	draw_arc(Vector2.ZERO, 17.0 + pulse * 3.0, -2.8, -0.35, 22, StarfallVisualTokens.alpha(&"danger_red", 0.58), 1.6, true)
	draw_colored_polygon(PackedVector2Array([Vector2(0,-12), Vector2(10,9), Vector2(-10,9)]), StarfallVisualTokens.alpha(&"space_void", 0.86))
	draw_line(Vector2(0,-7), Vector2(0,3), orange, 2.0, true)
	draw_circle(Vector2(0,7), 1.8, orange)

func _draw_cargo_wreck() -> void:
	var body := PackedVector2Array([Vector2(-39,-18), Vector2(-12,-30), Vector2(34,-20), Vector2(43,4), Vector2(18,28), Vector2(-30,24), Vector2(-45,5)])
	draw_colored_polygon(body, StarfallVisualTokens.color(&"metal_dark"))
	draw_polyline(_closed(body), StarfallVisualTokens.alpha(&"metal_light", 0.58), 1.7, true)
	draw_colored_polygon(PackedVector2Array([Vector2(-30,-13), Vector2(-5,-20), Vector2(8,-4), Vector2(-18,4)]), StarfallVisualTokens.alpha(&"metal_mid", 0.62))
	draw_rect(Rect2(-13.0, 4.0, 28.0, 12.0), StarfallVisualTokens.alpha(&"space_void", 0.82), true)
	for index in range(3):
		var x: float = -9.0 + float(index) * 9.0
		draw_line(Vector2(x,6), Vector2(x,14), StarfallVisualTokens.alpha(&"warning_orange", 0.44), 1.2, true)
	draw_line(Vector2(-31,17), Vector2(-17,8), StarfallVisualTokens.alpha(&"magenta_primary", 0.40), 1.5, true)

func _draw_gravity_anomaly() -> void:
	var pulse: float = _pulse(1.8)
	draw_circle(Vector2.ZERO, 20.0, StarfallVisualTokens.alpha(&"space_void", 0.98))
	draw_circle(Vector2.ZERO, 13.0, StarfallVisualTokens.alpha(&"purple_deep", 0.09 + pulse * 0.04))
	for index in range(5):
		var radius: float = 24.0 + float(index) * 9.0 + pulse * float(index + 1)
		var start: float = _time * (0.22 + float(index) * 0.025) + float(index) * 0.55
		var color: Color = StarfallVisualTokens.alpha(&"purple_bright", 0.38 - float(index) * 0.05) if index % 2 == 0 else StarfallVisualTokens.alpha(&"cyan_deep", 0.30 - float(index) * 0.04)
		draw_arc(Vector2.ZERO, radius, start, start + 4.6, 42, color, 1.4, true)
	for index in range(6):
		var angle: float = -1.0 + float(index) * 0.43 + _time * 0.08
		var inner: Vector2 = Vector2.from_angle(angle) * 22.0
		var outer: Vector2 = Vector2.from_angle(angle + 0.08) * 54.0
		draw_line(outer, inner, StarfallVisualTokens.alpha(&"text_muted", 0.13), 1.0, true)

func _draw_route_gate(accent: Color, route_kind: StringName) -> void:
	var pulse: float = _pulse(2.4)
	var selected: bool = visual_state == VisualState.SELECTED
	var frame_alpha: float = 0.74 + (0.18 if selected else pulse * 0.08)
	var half_width: float = 35.0
	var half_height: float = 47.0

	draw_rect(Rect2(-half_width, -half_height, half_width * 2.0, half_height * 2.0), Color(accent, 0.018 + pulse * 0.01), true)
	for side_value in [-1.0, 1.0]:
		var side: float = float(side_value)
		var x: float = side * half_width
		var pylon := PackedVector2Array([
			Vector2(x - side * 4.0, -half_height),
			Vector2(x + side * 6.0, -half_height + 8.0),
			Vector2(x + side * 6.0, half_height - 8.0),
			Vector2(x - side * 4.0, half_height),
		])
		draw_colored_polygon(pylon, StarfallVisualTokens.color(&"metal_dark"))
		draw_polyline(_closed(pylon), Color(accent, frame_alpha), 2.0, true)
		draw_line(Vector2(x, -30.0), Vector2(x, 30.0), StarfallVisualTokens.alpha(&"line_muted", 0.72), 1.0, true)

	var top_frame := PackedVector2Array([
		Vector2(-half_width + 4.0, -half_height),
		Vector2(-18.0, -half_height - 7.0),
		Vector2(18.0, -half_height - 7.0),
		Vector2(half_width - 4.0, -half_height),
	])
	draw_polyline(top_frame, Color(accent, frame_alpha), 2.0, true)
	draw_line(Vector2(-half_width + 5.0, half_height), Vector2(-12.0, half_height + 4.0), Color(accent, frame_alpha * 0.70), 1.5, true)
	draw_line(Vector2(half_width - 5.0, half_height), Vector2(12.0, half_height + 4.0), Color(accent, frame_alpha * 0.70), 1.5, true)

	_draw_route_glyph(route_kind, accent, pulse)
	draw_arc(Vector2.ZERO, 27.0 + pulse * 2.0, -2.65, 2.65, 36, Color(accent, 0.25 + pulse * 0.12), 1.2, true)
	if selected:
		draw_arc(Vector2.ZERO, 41.0 + pulse * 3.0, -2.8, 2.8, 44, Color(accent, 0.62), 2.0, true)

func _draw_route_glyph(route_kind: StringName, accent: Color, pulse: float) -> void:
	match route_kind:
		&"safe":
			draw_polyline(PackedVector2Array([Vector2(-11,1), Vector2(-3,9), Vector2(13,-10)]), Color(accent, 0.86), 3.0, true)
		&"core":
			draw_colored_polygon(PackedVector2Array([Vector2(0,-13), Vector2(9,0), Vector2(0,13), Vector2(-9,0)]), Color(accent, 0.72))
			draw_circle(Vector2.ZERO, 3.5 + pulse, StarfallVisualTokens.color(&"hull_highlight"))
		&"danger":
			draw_colored_polygon(PackedVector2Array([Vector2(0,-14), Vector2(13,11), Vector2(-13,11)]), StarfallVisualTokens.alpha(&"space_void", 0.90))
			draw_polyline(PackedVector2Array([Vector2(0,-14), Vector2(13,11), Vector2(-13,11), Vector2(0,-14)]), Color(accent, 0.88), 2.0, true)
			draw_line(Vector2(0,-7), Vector2(0,4), Color(accent, 0.90), 2.0, true)
			draw_circle(Vector2(0,8), 1.7, Color(accent, 0.90))
		&"contract":
			draw_rect(Rect2(-10.0, -12.0, 20.0, 24.0), StarfallVisualTokens.alpha(&"space_void", 0.88), true)
			draw_rect(Rect2(-10.0, -12.0, 20.0, 24.0), Color(accent, 0.82), false, 2.0, true)
			draw_line(Vector2(-5,-5), Vector2(5,-5), Color(accent, 0.75), 1.5, true)
			draw_line(Vector2(-5,1), Vector2(5,1), Color(accent, 0.75), 1.5, true)
		&"elite":
			var crown := PackedVector2Array([Vector2(-13,8), Vector2(-9,-8), Vector2(-2,1), Vector2(0,-12), Vector2(6,0), Vector2(12,-7), Vector2(10,8)])
			draw_colored_polygon(crown, Color(accent, 0.58))
			draw_polyline(_closed(crown), StarfallVisualTokens.alpha(&"gold_bright", 0.70), 1.4, true)

func _draw_extraction_gate() -> void:
	var pulse: float = _pulse(2.0)
	var green := StarfallVisualTokens.color(&"success_green")
	var cyan := StarfallVisualTokens.color(&"cyan_primary")
	draw_rect(Rect2(-43.0, -65.0, 86.0, 130.0), StarfallVisualTokens.alpha(&"success_green", 0.018), true)
	for side_value in [-1.0, 1.0]:
		var side: float = float(side_value)
		var x: float = side * 43.0
		draw_colored_polygon(PackedVector2Array([
			Vector2(x - side * 6.0, -61.0),
			Vector2(x + side * 7.0, -53.0),
			Vector2(x + side * 7.0, 53.0),
			Vector2(x - side * 6.0, 61.0),
		]), StarfallVisualTokens.color(&"metal_dark"))
		draw_line(Vector2(x, -54.0), Vector2(x, 54.0), StarfallVisualTokens.alpha(&"metal_light", 0.68), 2.0, true)
		draw_circle(Vector2(x, -35.0), 3.0 + pulse, Color(green, 0.76))
		draw_circle(Vector2(x, 35.0), 3.0 + pulse, Color(cyan, 0.62))

	for index in range(5):
		var x: float = -24.0 + float(index) * 12.0
		draw_line(Vector2(x,48), Vector2(x,-42), StarfallVisualTokens.alpha(&"success_green", 0.20 + float(index % 2) * 0.10), 1.2, true)
	draw_arc(Vector2.ZERO, 36.0 + pulse * 2.0, -2.8, 2.8, 44, StarfallVisualTokens.alpha(&"success_bright", 0.68), 2.0, true)
	draw_arc(Vector2.ZERO, 29.0, 0.2, 2.94, 32, StarfallVisualTokens.alpha(&"cyan_primary", 0.48), 1.4, true)
	draw_colored_polygon(PackedVector2Array([Vector2(0,-12), Vector2(10,5), Vector2(3,5), Vector2(3,14), Vector2(-3,14), Vector2(-3,5), Vector2(-10,5)]), StarfallVisualTokens.alpha(&"hull_highlight", 0.84))

func _draw_courier_hunter() -> void:
	var pulse: float = _pulse(3.8)
	var hull := PackedVector2Array([Vector2(0,-45), Vector2(-12,-19), Vector2(-33,-5), Vector2(-24,22), Vector2(-8,14), Vector2(0,31), Vector2(8,14), Vector2(24,22), Vector2(33,-5), Vector2(12,-19)])
	draw_circle(Vector2.ZERO, 45.0, StarfallVisualTokens.alpha(&"danger_red", 0.018 + pulse * 0.012))
	draw_colored_polygon(hull, StarfallVisualTokens.color(&"metal_dark"))
	draw_polyline(_closed(hull), StarfallVisualTokens.alpha(&"magenta_primary", 0.82), 2.0, true)
	draw_colored_polygon(PackedVector2Array([Vector2(0,-31), Vector2(-7,-16), Vector2(0,-7), Vector2(7,-16)]), StarfallVisualTokens.color(&"space_void"))
	draw_polyline(PackedVector2Array([Vector2(0,-31), Vector2(-7,-16), Vector2(0,-7), Vector2(7,-16), Vector2(0,-31)]), StarfallVisualTokens.alpha(&"danger_red", 0.76), 1.4, true)
	for side_value in [-1.0, 1.0]:
		var side: float = float(side_value)
		draw_line(Vector2(11.0 * side, -6.0), Vector2(27.0 * side, 4.0), StarfallVisualTokens.alpha(&"magenta_primary", 0.62), 1.5, true)
		draw_circle(Vector2(19.0 * side, 10.0), 3.0 + pulse, StarfallVisualTokens.alpha(&"danger_red", 0.72))
	draw_circle(Vector2(0,12), 5.0 + pulse, StarfallVisualTokens.color(&"magenta_primary"))
	draw_circle(Vector2(0,12), 2.0, StarfallVisualTokens.color(&"hull_highlight"))
	draw_arc(Vector2.ZERO, 48.0 + pulse * 3.0, -2.5, -0.6, 22, StarfallVisualTokens.alpha(&"danger_red", 0.30), 1.5, true)

func _regular_polygon(point_count: int, radius: float, rotation: float = 0.0) -> PackedVector2Array:
	var points := PackedVector2Array()
	for index in range(point_count):
		var angle: float = rotation + TAU * float(index) / float(point_count)
		points.append(Vector2.from_angle(angle) * radius)
	return points

func _closed(points: PackedVector2Array) -> PackedVector2Array:
	var result := PackedVector2Array(points)
	if result.size() > 0:
		result.append(result[0])
	return result
