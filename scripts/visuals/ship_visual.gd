class_name StarfallShipVisual
extends Node2D

enum ShipType {
	COURIER,
	INTERCEPTOR,
	PHANTOM,
	HAULER,
	VECTOR,
	ECLIPSE,
	PATHFINDER,
}

enum VisualState {
	NORMAL,
	SHIELDED,
	TIME_WARP,
	OVERCHARGED,
	IMPACT,
	CRASHED,
	PRESTIGE,
}

@export var ship_type: ShipType = ShipType.COURIER
@export var visual_state: VisualState = VisualState.NORMAL
@export_range(0.4, 4.0, 0.05) var display_scale: float = 1.0
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
	if visual_state == VisualState.CRASHED:
		_draw_crashed_ship()
		return
	_draw_engine_trail()
	_draw_ship_body()
	_draw_state_overlay()

func _draw_ship_body() -> void:
	var hull: PackedVector2Array = _hull_points()
	var left_wing: PackedVector2Array = _left_wing_points()
	var right_wing: PackedVector2Array = _mirror_x(left_wing)
	var frame: Color = _frame_color()

	_draw_wing(left_wing, false, frame)
	_draw_wing(right_wing, true, frame)
	_draw_hull_layers(hull)
	_draw_cockpit_and_spine()
	_draw_reactor_and_engine_housing()
	_draw_panel_detail()
	_draw_ship_signature()

func _draw_wing(points: PackedVector2Array, mirrored: bool, frame: Color) -> void:
	draw_colored_polygon(points, frame.darkened(0.16))
	draw_polyline(_closed(points), StarfallVisualTokens.alpha(&"purple_bright", 0.78), 1.8, true)

	var sign_value: float = 1.0 if mirrored else -1.0
	var inner_panel := PackedVector2Array([
		Vector2(10.0 * sign_value, -13.0),
		Vector2(24.0 * sign_value, 2.0),
		Vector2(21.0 * sign_value, 14.0),
		Vector2(11.0 * sign_value, 8.0),
	])
	draw_colored_polygon(inner_panel, StarfallVisualTokens.color(&"metal_dark"))
	draw_polyline(_closed(inner_panel), StarfallVisualTokens.alpha(&"line_muted", 0.82), 1.1, true)

	var brace_color := StarfallVisualTokens.alpha(&"purple_primary", 0.80)
	draw_line(Vector2(12.0 * sign_value, -9.0), Vector2(26.0 * sign_value, 7.0), brace_color, 1.6, true)
	draw_line(Vector2(13.0 * sign_value, 9.0), Vector2(25.0 * sign_value, 13.0), StarfallVisualTokens.alpha(&"cyan_deep", 0.48), 1.0, true)

func _draw_hull_layers(hull: PackedVector2Array) -> void:
	draw_colored_polygon(hull, StarfallVisualTokens.color(&"hull_mid"))
	draw_polyline(_closed(hull), StarfallVisualTokens.alpha(&"purple_deep", 0.96), 2.1, true)

	var shadow_plane := PackedVector2Array([
		Vector2(0.0, -43.0),
		Vector2(-8.0, -17.0),
		Vector2(-8.0, 19.0),
		Vector2(0.0, 28.0),
	])
	draw_colored_polygon(shadow_plane, StarfallVisualTokens.alpha(&"hull_shadow", 0.56))

	var highlight_plane := PackedVector2Array([
		Vector2(0.0, -43.0),
		Vector2(5.0, -20.0),
		Vector2(5.0, 7.0),
		Vector2(0.0, 15.0),
	])
	draw_colored_polygon(highlight_plane, StarfallVisualTokens.alpha(&"hull_highlight", 0.58))

	var nose_insert := PackedVector2Array([
		Vector2(0.0, -48.0),
		Vector2(-5.5, -31.0),
		Vector2(0.0, -35.0),
		Vector2(5.5, -31.0),
	])
	draw_colored_polygon(nose_insert, StarfallVisualTokens.alpha(&"purple_primary", 0.92))

func _draw_cockpit_and_spine() -> void:
	var cockpit := PackedVector2Array([
		Vector2(0.0, -31.0),
		Vector2(-6.5, -17.0),
		Vector2(-4.5, -8.0),
		Vector2(0.0, -4.0),
		Vector2(4.5, -8.0),
		Vector2(6.5, -17.0),
	])
	draw_colored_polygon(cockpit, StarfallVisualTokens.color(&"space_void"))
	draw_polyline(_closed(cockpit), StarfallVisualTokens.alpha(&"cyan_primary", 0.72), 1.5, true)
	draw_line(Vector2(0.0, -28.0), Vector2(0.0, -9.0), StarfallVisualTokens.alpha(&"cyan_soft", 0.38), 1.0, true)

	var spine := PackedVector2Array([
		Vector2(-3.0, -3.0),
		Vector2(-4.5, 18.0),
		Vector2(0.0, 24.0),
		Vector2(4.5, 18.0),
		Vector2(3.0, -3.0),
	])
	draw_colored_polygon(spine, StarfallVisualTokens.alpha(&"metal_mid", 0.62))
	draw_polyline(_closed(spine), StarfallVisualTokens.alpha(&"line_muted", 0.68), 1.0, true)

func _draw_reactor_and_engine_housing() -> void:
	var reactor_pulse: float = 0.5 + 0.5 * sin(_time * 4.2)
	var housing := PackedVector2Array([
		Vector2(-10.0, 11.0),
		Vector2(-8.0, 26.0),
		Vector2(0.0, 31.0),
		Vector2(8.0, 26.0),
		Vector2(10.0, 11.0),
		Vector2(0.0, 6.0),
	])
	draw_colored_polygon(housing, StarfallVisualTokens.color(&"metal_dark"))
	draw_polyline(_closed(housing), StarfallVisualTokens.alpha(&"purple_primary", 0.72), 1.4, true)

	var reactor_radius: float = 5.2 + reactor_pulse * 1.1
	draw_circle(Vector2(0.0, 15.0), reactor_radius + 7.0, StarfallVisualTokens.alpha(&"cyan_primary", 0.055 + reactor_pulse * 0.035))
	draw_circle(Vector2(0.0, 15.0), reactor_radius + 2.5, StarfallVisualTokens.alpha(&"cyan_deep", 0.48))
	draw_circle(Vector2(0.0, 15.0), reactor_radius, StarfallVisualTokens.color(&"cyan_primary"))
	draw_circle(Vector2(0.0, 15.0), reactor_radius * 0.38, StarfallVisualTokens.color(&"hull_highlight"))

	for side_value in [-1.0, 1.0]:
		var side: float = float(side_value)
		draw_rect(Rect2(Vector2(11.0 * side - 2.0, 18.0), Vector2(4.0, 10.0)), StarfallVisualTokens.color(&"metal_mid"), true)
		draw_line(Vector2(11.0 * side, 20.0), Vector2(11.0 * side, 26.0), StarfallVisualTokens.alpha(&"cyan_primary", 0.45), 1.0, true)

func _draw_panel_detail() -> void:
	var seam := StarfallVisualTokens.alpha(&"line_muted", 0.72)
	draw_line(Vector2(-7.0, -2.0), Vector2(-9.0, 8.0), seam, 1.0, true)
	draw_line(Vector2(7.0, -2.0), Vector2(9.0, 8.0), seam, 1.0, true)
	draw_line(Vector2(-8.0, 3.0), Vector2(-17.0, 7.0), seam, 1.0, true)
	draw_line(Vector2(8.0, 3.0), Vector2(17.0, 7.0), seam, 1.0, true)

	for side_value in [-1.0, 1.0]:
		var side: float = float(side_value)
		var vent_color := StarfallVisualTokens.alpha(&"cyan_deep", 0.52)
		for vent_index in range(3):
			var y: float = 1.0 + float(vent_index) * 4.0
			draw_line(Vector2(15.0 * side, y), Vector2((20.0 + float(vent_index)) * side, y + 1.0), vent_color, 1.0, true)

func _draw_ship_signature() -> void:
	match ship_type:
		ShipType.INTERCEPTOR:
			draw_line(Vector2(-27.0, 3.0), Vector2(-14.0, -5.0), StarfallVisualTokens.color(&"cyan_primary"), 2.0, true)
			draw_line(Vector2(27.0, 3.0), Vector2(14.0, -5.0), StarfallVisualTokens.color(&"cyan_primary"), 2.0, true)
		ShipType.PHANTOM:
			draw_arc(Vector2.ZERO, 26.0, 0.28, 2.86, 24, StarfallVisualTokens.alpha(&"cyan_soft", 0.58), 2.0, true)
		ShipType.HAULER:
			draw_rect(Rect2(-25.0, 2.0, 9.0, 20.0), StarfallVisualTokens.color(&"gold_deep"), true)
			draw_rect(Rect2(16.0, 2.0, 9.0, 20.0), StarfallVisualTokens.color(&"gold_deep"), true)
		ShipType.VECTOR:
			draw_line(Vector2(-31.0, 12.0), Vector2(-40.0, 24.0), StarfallVisualTokens.color(&"cyan_soft"), 2.0, true)
			draw_line(Vector2(31.0, 12.0), Vector2(40.0, 24.0), StarfallVisualTokens.color(&"cyan_soft"), 2.0, true)
		ShipType.ECLIPSE:
			draw_arc(Vector2(0.0, 4.0), 19.0, -2.8, -0.34, 24, StarfallVisualTokens.color(&"magenta_primary"), 2.0, true)
		ShipType.PATHFINDER:
			draw_arc(Vector2(0.0, -8.0), 13.0, -2.7, -0.44, 20, StarfallVisualTokens.color(&"gold_primary"), 1.6, true)
		_:
			draw_line(Vector2(-10.0, 5.0), Vector2(10.0, 5.0), StarfallVisualTokens.alpha(&"purple_primary", 0.82), 1.8, true)
			draw_circle(Vector2(-14.0, -4.0), 1.5, StarfallVisualTokens.alpha(&"cyan_soft", 0.72))
			draw_circle(Vector2(14.0, -4.0), 1.5, StarfallVisualTokens.alpha(&"cyan_soft", 0.72))

func _draw_engine_trail() -> void:
	var pulse: float = 0.5 + 0.5 * sin(_time * 8.0)
	var length: float = 34.0 + pulse * 10.0
	if visual_state == VisualState.OVERCHARGED:
		length *= 1.48
	elif visual_state == VisualState.TIME_WARP:
		length *= 0.78

	var outer := StarfallVisualTokens.alpha(&"purple_primary", 0.16)
	var middle := StarfallVisualTokens.alpha(&"cyan_deep", 0.42)
	var inner := StarfallVisualTokens.alpha(&"cyan_soft", 0.78)
	draw_colored_polygon(PackedVector2Array([
		Vector2(-9.0, 25.0), Vector2(0.0, 25.0 + length), Vector2(9.0, 25.0)
	]), outer)
	draw_colored_polygon(PackedVector2Array([
		Vector2(-5.0, 25.0), Vector2(0.0, 25.0 + length * 0.84), Vector2(5.0, 25.0)
	]), middle)
	draw_colored_polygon(PackedVector2Array([
		Vector2(-2.0, 25.0), Vector2(0.0, 25.0 + length * 0.64), Vector2(2.0, 25.0)
	]), inner)
	draw_line(Vector2(0.0, 27.0), Vector2(0.0, 25.0 + length * 0.52), StarfallVisualTokens.alpha(&"hull_highlight", 0.62), 1.2, true)

	for side_value in [-1.0, 1.0]:
		var side: float = float(side_value)
		var side_length: float = length * 0.40
		draw_colored_polygon(PackedVector2Array([
			Vector2(11.0 * side, 25.0),
			Vector2(12.0 * side, 25.0 + side_length),
			Vector2(15.0 * side, 24.0),
		]), StarfallVisualTokens.alpha(&"purple_bright", 0.20))

func _draw_state_overlay() -> void:
	var pulse: float = 0.5 + 0.5 * sin(_time * 4.0)
	match visual_state:
		VisualState.SHIELDED:
			draw_circle(Vector2.ZERO, 48.0, StarfallVisualTokens.alpha(&"cyan_primary", 0.025 + pulse * 0.025))
			draw_arc(Vector2.ZERO, 47.0, -2.82, -0.42, 28, StarfallVisualTokens.alpha(&"cyan_soft", 0.74), 2.4, true)
			draw_arc(Vector2.ZERO, 47.0, 0.42, 2.82, 28, StarfallVisualTokens.alpha(&"cyan_primary", 0.58), 2.0, true)
			draw_arc(Vector2.ZERO, 52.0 + pulse * 2.0, -1.35, 1.35, 22, StarfallVisualTokens.alpha(&"cyan_deep", 0.26), 1.2, true)
		VisualState.TIME_WARP:
			for index in range(3):
				var radius: float = 47.0 + float(index) * 6.0 + pulse * float(index + 1)
				var alpha: float = 0.56 - float(index) * 0.13
				draw_arc(Vector2.ZERO, radius, -2.85 + float(index) * 0.18, 2.85 - float(index) * 0.18, 48, StarfallVisualTokens.alpha(&"purple_bright", alpha), 1.6, true)
			draw_line(Vector2(-35.0, 18.0), Vector2(-53.0, 32.0), StarfallVisualTokens.alpha(&"cyan_primary", 0.42), 1.5, true)
			draw_line(Vector2(35.0, 18.0), Vector2(53.0, 32.0), StarfallVisualTokens.alpha(&"cyan_primary", 0.42), 1.5, true)
		VisualState.OVERCHARGED:
			for index in range(8):
				var angle: float = _time * 1.8 + TAU * float(index) / 8.0
				var start: Vector2 = Vector2.from_angle(angle) * (31.0 + float(index % 2) * 3.0)
				var middle: Vector2 = Vector2.from_angle(angle + 0.09) * (40.0 + pulse * 5.0)
				var finish: Vector2 = Vector2.from_angle(angle - 0.05) * (51.0 + pulse * 7.0)
				draw_polyline(PackedVector2Array([start, middle, finish]), StarfallVisualTokens.alpha(&"magenta_primary", 0.72), 1.8, true)
			draw_arc(Vector2.ZERO, 45.0, -2.7, 2.7, 44, StarfallVisualTokens.alpha(&"magenta_bright", 0.22 + pulse * 0.18), 1.5, true)
		VisualState.IMPACT:
			draw_circle(Vector2.ZERO, 39.0 + pulse * 5.0, StarfallVisualTokens.alpha(&"hull_highlight", 0.12 + pulse * 0.22), false, 3.0, true)
			draw_arc(Vector2(15.0, -4.0), 24.0 + pulse * 6.0, -1.2, 1.2, 24, StarfallVisualTokens.alpha(&"warning_orange", 0.70), 2.5, true)
		VisualState.PRESTIGE:
			draw_arc(Vector2.ZERO, 49.0, -2.9, 2.9, 56, StarfallVisualTokens.alpha(&"gold_bright", 0.50 + pulse * 0.20), 2.0, true)
			draw_arc(Vector2.ZERO, 55.0, 0.2, 2.94, 36, StarfallVisualTokens.alpha(&"purple_bright", 0.40), 1.4, true)
			for index in range(4):
				var angle: float = _time * 0.5 + TAU * float(index) / 4.0
				draw_circle(Vector2.from_angle(angle) * 58.0, 1.8, StarfallVisualTokens.alpha(&"gold_primary", 0.70))
		_:
			pass

func _draw_crashed_ship() -> void:
	var phase: float = fmod(_time * 0.30, 1.0)
	var fade: float = 1.0 - phase
	var frame: Color = _frame_color()
	frame.a = fade
	var hull_color := StarfallVisualTokens.color(&"hull_mid")
	hull_color.a = fade
	var spread: float = 8.0 + phase * 36.0
	var rotation_amount: float = phase * 0.78

	draw_circle(Vector2.ZERO, 9.0 + phase * 32.0, StarfallVisualTokens.alpha(&"danger_red", fade * 0.08))
	draw_set_transform(Vector2(0.0, -phase * 10.0), rotation_amount * 0.35, Vector2.ONE * display_scale)
	draw_colored_polygon(_hull_points(), hull_color)
	draw_set_transform(Vector2(-spread, phase * 12.0), -rotation_amount * 1.6, Vector2.ONE * display_scale)
	draw_colored_polygon(_left_wing_points(), frame)
	draw_set_transform(Vector2(spread, phase * 12.0), rotation_amount * 1.6, Vector2.ONE * display_scale)
	draw_colored_polygon(_mirror_x(_left_wing_points()), frame)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE * display_scale)

	for index in range(9):
		var angle: float = float(index) * 0.73 + 0.2
		var start: Vector2 = Vector2.from_angle(angle) * (10.0 + phase * 8.0)
		var finish: Vector2 = Vector2.from_angle(angle + 0.08) * (24.0 + phase * 45.0)
		var spark_color: Color = StarfallVisualTokens.alpha(&"warning_orange", fade * 0.72) if index % 2 == 0 else StarfallVisualTokens.alpha(&"magenta_primary", fade * 0.55)
		draw_line(start, finish, spark_color, 1.6, true)

	draw_arc(Vector2.ZERO, 15.0 + phase * 34.0, 0.0, TAU, 36, StarfallVisualTokens.alpha(&"warning_orange", fade * 0.62), 2.2, true)

func _frame_color() -> Color:
	match ship_type:
		ShipType.PHANTOM: return StarfallVisualTokens.color(&"cyan_deep")
		ShipType.HAULER: return Color("7459D4")
		ShipType.VECTOR: return StarfallVisualTokens.color(&"purple_bright")
		ShipType.ECLIPSE: return Color("4E386F")
		ShipType.PATHFINDER: return Color("6E59D7")
		_: return StarfallVisualTokens.color(&"purple_primary")

func _hull_points() -> PackedVector2Array:
	match ship_type:
		ShipType.INTERCEPTOR:
			return PackedVector2Array([Vector2(0,-52), Vector2(-8,-22), Vector2(-7,23), Vector2(0,34), Vector2(7,23), Vector2(8,-22)])
		ShipType.PHANTOM:
			return PackedVector2Array([Vector2(0,-44), Vector2(-14,-20), Vector2(-16,18), Vector2(0,30), Vector2(16,18), Vector2(14,-20)])
		ShipType.HAULER:
			return PackedVector2Array([Vector2(0,-42), Vector2(-17,-16), Vector2(-19,21), Vector2(0,32), Vector2(19,21), Vector2(17,-16)])
		ShipType.VECTOR:
			return PackedVector2Array([Vector2(0,-54), Vector2(-6,-19), Vector2(-5,27), Vector2(0,35), Vector2(5,27), Vector2(6,-19)])
		ShipType.ECLIPSE:
			return PackedVector2Array([Vector2(0,-48), Vector2(-12,-18), Vector2(-13,20), Vector2(0,33), Vector2(13,20), Vector2(12,-18)])
		ShipType.PATHFINDER:
			return PackedVector2Array([Vector2(0,-47), Vector2(-11,-18), Vector2(-12,22), Vector2(0,32), Vector2(12,22), Vector2(11,-18)])
		_:
			return PackedVector2Array([Vector2(0,-48), Vector2(-11,-19), Vector2(-11,21), Vector2(0,32), Vector2(11,21), Vector2(11,-19)])

func _left_wing_points() -> PackedVector2Array:
	match ship_type:
		ShipType.INTERCEPTOR:
			return PackedVector2Array([Vector2(-8,-18), Vector2(-38,7), Vector2(-31,19), Vector2(-9,8)])
		ShipType.PHANTOM:
			return PackedVector2Array([Vector2(-13,-18), Vector2(-31,-2), Vector2(-29,21), Vector2(-12,13)])
		ShipType.HAULER:
			return PackedVector2Array([Vector2(-16,-13), Vector2(-35,-2), Vector2(-36,24), Vector2(-16,22)])
		ShipType.VECTOR:
			return PackedVector2Array([Vector2(-6,-18), Vector2(-35,13), Vector2(-27,20), Vector2(-6,6)])
		ShipType.ECLIPSE:
			return PackedVector2Array([Vector2(-12,-15), Vector2(-34,0), Vector2(-30,22), Vector2(-11,13)])
		ShipType.PATHFINDER:
			return PackedVector2Array([Vector2(-11,-16), Vector2(-33,5), Vector2(-31,21), Vector2(-10,12)])
		_:
			return PackedVector2Array([Vector2(-10,-17), Vector2(-33,9), Vector2(-27,20), Vector2(-9,10)])

func _mirror_x(points: PackedVector2Array) -> PackedVector2Array:
	var mirrored := PackedVector2Array()
	for point in points:
		mirrored.append(Vector2(-point.x, point.y))
	return mirrored

func _closed(points: PackedVector2Array) -> PackedVector2Array:
	var result := PackedVector2Array(points)
	if result.size() > 0:
		result.append(result[0])
	return result
