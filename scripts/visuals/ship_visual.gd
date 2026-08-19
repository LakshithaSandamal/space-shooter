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
	else:
		_draw_engine_trail()
		_draw_ship_body()
		_draw_state_overlay()

func _draw_ship_body() -> void:
	var hull := _hull_points()
	var left_wing := _left_wing_points()
	var right_wing := _mirror_x(left_wing)
	var frame := _frame_color()
	var hull_color := StarfallVisualTokens.color(&"text_primary")
	var hull_shadow := Color("C7CDDD")

	draw_colored_polygon(left_wing, frame)
	draw_colored_polygon(right_wing, frame)
	draw_colored_polygon(hull, hull_color)

	var hull_outline := _closed(hull)
	draw_polyline(hull_outline, StarfallVisualTokens.alpha(&"purple_deep", 0.92), 2.0, true)
	draw_line(Vector2(0.0, -34.0), Vector2(0.0, 17.0), hull_shadow, 1.5, true)

	var cockpit_color := StarfallVisualTokens.color(&"space_navy_2")
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, -30.0),
		Vector2(-6.0, -16.0),
		Vector2(0.0, -7.0),
		Vector2(6.0, -16.0),
	]), cockpit_color)
	draw_polyline(PackedVector2Array([
		Vector2(0.0, -30.0), Vector2(-6.0, -16.0), Vector2(0.0, -7.0), Vector2(6.0, -16.0), Vector2(0.0, -30.0)
	]), StarfallVisualTokens.alpha(&"cyan_primary", 0.72), 1.5, true)

	var reactor_radius := 5.5 + sin(_time * 4.0) * 0.7
	draw_circle(Vector2(0.0, 16.0), reactor_radius + 4.0, StarfallVisualTokens.alpha(&"cyan_primary", 0.12))
	draw_circle(Vector2(0.0, 16.0), reactor_radius, StarfallVisualTokens.color(&"cyan_primary"))
	draw_circle(Vector2(0.0, 16.0), reactor_radius * 0.42, StarfallVisualTokens.color(&"text_primary"))
	_draw_ship_signature()

func _draw_ship_signature() -> void:
	match ship_type:
		ShipType.INTERCEPTOR:
			draw_line(Vector2(-25.0, 5.0), Vector2(-12.0, -3.0), StarfallVisualTokens.color(&"cyan_primary"), 2.0, true)
			draw_line(Vector2(25.0, 5.0), Vector2(12.0, -3.0), StarfallVisualTokens.color(&"cyan_primary"), 2.0, true)
		ShipType.PHANTOM:
			draw_arc(Vector2.ZERO, 25.0, 0.2, 2.94, 22, StarfallVisualTokens.alpha(&"cyan_soft", 0.55), 2.0, true)
		ShipType.HAULER:
			draw_rect(Rect2(-22.0, 5.0, 8.0, 17.0), StarfallVisualTokens.color(&"gold_deep"), true)
			draw_rect(Rect2(14.0, 5.0, 8.0, 17.0), StarfallVisualTokens.color(&"gold_deep"), true)
		ShipType.VECTOR:
			draw_line(Vector2(-31.0, 13.0), Vector2(-39.0, 23.0), StarfallVisualTokens.color(&"cyan_soft"), 2.0, true)
			draw_line(Vector2(31.0, 13.0), Vector2(39.0, 23.0), StarfallVisualTokens.color(&"cyan_soft"), 2.0, true)
		ShipType.ECLIPSE:
			draw_arc(Vector2(0.0, 5.0), 18.0, -2.8, -0.34, 24, StarfallVisualTokens.color(&"magenta_primary"), 2.0, true)
		ShipType.PATHFINDER:
			draw_arc(Vector2(0.0, -8.0), 13.0, -2.7, -0.44, 20, StarfallVisualTokens.color(&"gold_primary"), 1.5, true)
		_:
			draw_line(Vector2(-10.0, 7.0), Vector2(10.0, 7.0), StarfallVisualTokens.alpha(&"purple_primary", 0.72), 2.0, true)

func _draw_engine_trail() -> void:
	var pulse := 0.82 + sin(_time * 8.0) * 0.14
	var length := 34.0 * pulse
	if visual_state == VisualState.OVERCHARGED:
		length *= 1.45
	elif visual_state == VisualState.TIME_WARP:
		length *= 0.72
	var outer := StarfallVisualTokens.alpha(&"purple_primary", 0.26)
	var inner := StarfallVisualTokens.alpha(&"cyan_primary", 0.72)
	draw_colored_polygon(PackedVector2Array([
		Vector2(-7.0, 25.0), Vector2(0.0, 25.0 + length), Vector2(7.0, 25.0)
	]), outer)
	draw_colored_polygon(PackedVector2Array([
		Vector2(-3.0, 24.0), Vector2(0.0, 24.0 + length * 0.78), Vector2(3.0, 24.0)
	]), inner)

func _draw_state_overlay() -> void:
	var pulse := 0.5 + 0.5 * sin(_time * 4.0)
	match visual_state:
		VisualState.SHIELDED:
			draw_circle(Vector2.ZERO, 46.0, StarfallVisualTokens.alpha(&"cyan_primary", 0.035 + pulse * 0.025))
			draw_arc(Vector2.ZERO, 46.0, -2.75, 2.75, 54, StarfallVisualTokens.alpha(&"cyan_soft", 0.62 + pulse * 0.18), 2.0, true)
		VisualState.TIME_WARP:
			draw_arc(Vector2.ZERO, 47.0 + pulse * 3.0, -2.8, 2.8, 48, StarfallVisualTokens.alpha(&"purple_bright", 0.62), 2.0, true)
			draw_arc(Vector2.ZERO, 54.0 - pulse * 2.0, -2.2, 2.2, 42, StarfallVisualTokens.alpha(&"cyan_primary", 0.32), 1.5, true)
		VisualState.OVERCHARGED:
			var energy := StarfallVisualTokens.alpha(&"magenta_primary", 0.72)
			for index in range(6):
				var angle := _time * 1.8 + TAU * float(index) / 6.0
				var start := Vector2.from_angle(angle) * 34.0
				var finish := Vector2.from_angle(angle + 0.12) * (48.0 + pulse * 5.0)
				draw_line(start, finish, energy, 2.0, true)
		VisualState.IMPACT:
			var flash := StarfallVisualTokens.alpha(&"text_primary", 0.35 + pulse * 0.35)
			draw_circle(Vector2.ZERO, 38.0 + pulse * 4.0, flash, false, 3.0, true)
		VisualState.PRESTIGE:
			var prestige := StarfallVisualTokens.alpha(&"gold_bright", 0.50 + pulse * 0.25)
			draw_arc(Vector2.ZERO, 48.0, -2.9, 2.9, 56, prestige, 2.0, true)
			draw_arc(Vector2.ZERO, 53.0, 0.2, 2.94, 36, StarfallVisualTokens.alpha(&"purple_bright", 0.45), 1.5, true)
		_:
			pass

func _draw_crashed_ship() -> void:
	var phase := fmod(_time * 0.28, 1.0)
	var fade := 1.0 - phase
	var frame := _frame_color()
	frame.a = fade
	var hull_color := StarfallVisualTokens.color(&"text_primary")
	hull_color.a = fade
	var spread := 8.0 + phase * 30.0
	var rotation_amount := phase * 0.65

	draw_set_transform(Vector2(0.0, -phase * 8.0), rotation_amount, Vector2.ONE * display_scale)
	draw_colored_polygon(_hull_points(), hull_color)
	draw_set_transform(Vector2(-spread, phase * 10.0), -rotation_amount * 1.7, Vector2.ONE * display_scale)
	draw_colored_polygon(_left_wing_points(), frame)
	draw_set_transform(Vector2(spread, phase * 10.0), rotation_amount * 1.7, Vector2.ONE * display_scale)
	draw_colored_polygon(_mirror_x(_left_wing_points()), frame)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE * display_scale)
	var burst := StarfallVisualTokens.alpha(&"warning_orange", 0.55 * fade)
	draw_circle(Vector2.ZERO, 8.0 + phase * 26.0, burst, false, 3.0, true)

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
