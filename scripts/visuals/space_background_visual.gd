class_name StarfallSpaceBackgroundVisual
extends Node2D

enum Sector {
	COURIER_CORRIDOR,
	WRECK_BELT,
	ION_REACH,
	SOLAR_RIFT,
	VOID_PASSAGE,
}

@export var sector: Sector = Sector.COURIER_CORRIDOR
@export var preview_size := Vector2(320.0, 480.0)
@export var star_count: int = 88
@export var animate: bool = true

var _time: float = 0.0
var _stars: Array[Vector4] = []

func _ready() -> void:
	_rebuild_starfield()
	set_process(animate)
	queue_redraw()

func _process(delta: float) -> void:
	_time += delta
	queue_redraw()

func _draw() -> void:
	_draw_base()
	_draw_nebula_haze()
	_draw_distant_landmark()
	_draw_sector_structure()
	_draw_shipping_routes()
	_draw_stars()
	_draw_navigation_beacons()
	_draw_speed_dust()
	_draw_edge_vignette()

func _rebuild_starfield() -> void:
	_stars.clear()
	var rng := RandomNumberGenerator.new()
	rng.seed = 7000 + int(sector) * 911
	for index in range(maxi(star_count, 0)):
		_stars.append(Vector4(
			rng.randf_range(0.0, preview_size.x),
			rng.randf_range(0.0, preview_size.y),
			rng.randf_range(0.65, 3.1),
			rng.randf_range(0.15, 1.0)
		))

func _draw_base() -> void:
	var top := StarfallVisualTokens.color(&"space_black")
	var bottom := StarfallVisualTokens.color(&"space_navy")
	match sector:
		Sector.WRECK_BELT:
			bottom = Color("101528")
		Sector.ION_REACH:
			bottom = Color("06182B")
		Sector.SOLAR_RIFT:
			bottom = Color("1B101D")
		Sector.VOID_PASSAGE:
			bottom = Color("03040B")
		_:
			pass

	var strips: int = 24
	var strip_height: float = preview_size.y / float(strips)
	for index in range(strips):
		var ratio: float = float(index) / float(strips - 1)
		var eased_ratio: float = ratio * ratio * (3.0 - 2.0 * ratio)
		var strip_color: Color = top.lerp(bottom, eased_ratio)
		draw_rect(Rect2(0.0, float(index) * strip_height, preview_size.x, strip_height + 1.0), strip_color)

func _draw_nebula_haze() -> void:
	var primary := StarfallVisualTokens.sector_primary(int(sector))
	var secondary := StarfallVisualTokens.sector_secondary(int(sector))
	var pulse: float = 0.5 + 0.5 * sin(_time * 0.22)
	primary.a = 0.026 + pulse * 0.018
	secondary.a = 0.020

	var haze_centers: Array[Vector2] = [
		Vector2(preview_size.x * 0.14, preview_size.y * 0.23),
		Vector2(preview_size.x * 0.36, preview_size.y * 0.34),
		Vector2(preview_size.x * 0.84, preview_size.y * 0.66),
	]
	var haze_scales: Array[float] = [0.43, 0.31, 0.36]
	for index in range(haze_centers.size()):
		var haze_color: Color = primary if index < 2 else secondary
		var radius: float = preview_size.x * haze_scales[index]
		draw_circle(haze_centers[index], radius, haze_color)
		draw_circle(haze_centers[index] + Vector2(radius * 0.18, -radius * 0.05), radius * 0.64, Color(haze_color, haze_color.a * 0.56))

func _draw_distant_landmark() -> void:
	var center := Vector2(preview_size.x * 0.84, preview_size.y * 0.17)
	var radius: float = minf(preview_size.x, preview_size.y) * 0.115
	var rim := StarfallVisualTokens.sector_primary(int(sector))
	rim.a = 0.20

	match sector:
		Sector.COURIER_CORRIDOR:
			draw_circle(center, radius, StarfallVisualTokens.alpha(&"space_navy_2", 0.92))
			draw_circle(center + Vector2(-radius * 0.18, -radius * 0.18), radius * 0.74, StarfallVisualTokens.alpha(&"metal_dark", 0.46))
			draw_arc(center, radius + 1.5, -2.5, 0.65, 42, rim, 2.0, true)
			draw_arc(center, radius * 1.32, -0.10, 2.95, 50, StarfallVisualTokens.alpha(&"cyan_primary", 0.08), 1.0, true)
		Sector.WRECK_BELT:
			draw_circle(center, radius, Color("171523"))
			draw_arc(center, radius * 1.48, -0.18, 3.0, 46, StarfallVisualTokens.alpha(&"gold_deep", 0.18), 2.0, true)
			for index in range(6):
				var angle: float = float(index) * 0.77
				var fragment: Vector2 = center + Vector2.from_angle(angle) * radius * (1.35 + float(index % 2) * 0.22)
				draw_circle(fragment, 2.0 + float(index % 3), StarfallVisualTokens.alpha(&"metal_light", 0.16))
		Sector.ION_REACH:
			draw_circle(center, radius * 0.78, StarfallVisualTokens.alpha(&"cyan_deep", 0.05))
			for index in range(4):
				var arc_radius: float = radius * (0.7 + float(index) * 0.22)
				draw_arc(center, arc_radius, -2.7 + float(index) * 0.2, 1.4 + float(index) * 0.18, 36, StarfallVisualTokens.alpha(&"cyan_soft", 0.09 + float(index) * 0.02), 1.3, true)
		Sector.SOLAR_RIFT:
			draw_circle(center, radius * 0.72, StarfallVisualTokens.alpha(&"warning_orange", 0.12))
			draw_circle(center, radius * 0.42, StarfallVisualTokens.alpha(&"gold_bright", 0.16))
			for index in range(5):
				var angle: float = -1.0 + float(index) * 0.42
				draw_line(center + Vector2.from_angle(angle) * radius * 0.74, center + Vector2.from_angle(angle + 0.08) * radius * 1.42, StarfallVisualTokens.alpha(&"warning_orange", 0.10), 2.0, true)
		Sector.VOID_PASSAGE:
			draw_circle(center, radius * 0.96, StarfallVisualTokens.alpha(&"space_void", 0.96))
			draw_arc(center, radius * 1.12, -2.9, 2.9, 48, StarfallVisualTokens.alpha(&"purple_bright", 0.12), 1.5, true)

func _draw_sector_structure() -> void:
	match sector:
		Sector.COURIER_CORRIDOR:
			_draw_corridor_frames()
		Sector.WRECK_BELT:
			_draw_wreck_silhouettes()
		Sector.ION_REACH:
			_draw_ion_filaments()
		Sector.SOLAR_RIFT:
			_draw_solar_ribbons()
		Sector.VOID_PASSAGE:
			_draw_void_rings()

func _draw_corridor_frames() -> void:
	var vanishing := Vector2(preview_size.x * 0.5, preview_size.y * 0.07)
	for frame_index in range(5):
		var depth: float = float(frame_index + 1) / 6.0
		var y: float = lerpf(preview_size.y * 0.18, preview_size.y * 0.88, depth)
		var half_width: float = lerpf(24.0, preview_size.x * 0.42, depth)
		var frame_color := StarfallVisualTokens.alpha(&"cyan_deep", 0.035 + depth * 0.035)
		draw_line(Vector2(vanishing.x - half_width, y), Vector2(vanishing.x - half_width * 0.88, y + 18.0), frame_color, 1.0, true)
		draw_line(Vector2(vanishing.x + half_width, y), Vector2(vanishing.x + half_width * 0.88, y + 18.0), frame_color, 1.0, true)

func _draw_wreck_silhouettes() -> void:
	var body := StarfallVisualTokens.alpha(&"metal_dark", 0.22)
	for index in range(5):
		var x: float = 22.0 + float(index) * 67.0
		var y: float = preview_size.y * (0.54 + float(index % 3) * 0.11)
		var size: float = 10.0 + float(index % 2) * 7.0
		draw_colored_polygon(PackedVector2Array([
			Vector2(x - size, y - size * 0.25),
			Vector2(x + size * 0.4, y - size),
			Vector2(x + size, y + size * 0.35),
			Vector2(x - size * 0.3, y + size),
		]), body)

func _draw_ion_filaments() -> void:
	for index in range(6):
		var y: float = preview_size.y * (0.18 + float(index) * 0.12)
		var wave: float = sin(_time * 0.45 + float(index)) * 8.0
		var points := PackedVector2Array([
			Vector2(-20.0, y + wave),
			Vector2(preview_size.x * 0.28, y - 8.0 - wave * 0.3),
			Vector2(preview_size.x * 0.62, y + 5.0 + wave * 0.4),
			Vector2(preview_size.x + 20.0, y - wave),
		])
		draw_polyline(points, StarfallVisualTokens.alpha(&"cyan_soft", 0.045 + float(index % 2) * 0.018), 1.2, true)

func _draw_solar_ribbons() -> void:
	for index in range(4):
		var base_y: float = preview_size.y * (0.28 + float(index) * 0.15)
		var shift: float = sin(_time * 0.30 + float(index) * 0.9) * 12.0
		draw_polyline(PackedVector2Array([
			Vector2(-20.0, base_y + shift),
			Vector2(preview_size.x * 0.35, base_y - 18.0),
			Vector2(preview_size.x * 0.70, base_y + 12.0),
			Vector2(preview_size.x + 20.0, base_y - shift),
		]), StarfallVisualTokens.alpha(&"warning_orange", 0.045 + float(index) * 0.008), 2.0, true)

func _draw_void_rings() -> void:
	var center := Vector2(preview_size.x * 0.24, preview_size.y * 0.58)
	for index in range(4):
		var radius: float = 38.0 + float(index) * 20.0 + sin(_time * 0.25 + float(index)) * 4.0
		draw_arc(center, radius, -2.6, 2.4, 44, StarfallVisualTokens.alpha(&"purple_bright", 0.028 + float(index) * 0.009), 1.2, true)

func _draw_shipping_routes() -> void:
	var vanishing := Vector2(preview_size.x * 0.5, preview_size.y * 0.055)
	var bottom_y: float = preview_size.y
	var lane_half_width: float = preview_size.x * 0.30
	for lane_offset_value in [-1.0, 0.0, 1.0]:
		var lane_offset: float = float(lane_offset_value)
		var start := Vector2(preview_size.x * 0.5 + lane_half_width * lane_offset, bottom_y)
		var route_color := StarfallVisualTokens.alpha(&"cyan_primary", 0.075 if lane_offset != 0.0 else 0.095)
		draw_line(start, vanishing, route_color, 1.0, true)

	for rung_index in range(7):
		var t: float = float(rung_index + 1) / 8.0
		var eased: float = t * t
		var y: float = lerpf(vanishing.y + 18.0, preview_size.y, eased)
		var width: float = lerpf(18.0, lane_half_width * 2.0, eased)
		draw_line(Vector2(preview_size.x * 0.5 - width, y), Vector2(preview_size.x * 0.5 + width, y), StarfallVisualTokens.alpha(&"line_muted", 0.032 + eased * 0.035), 1.0, true)

func _draw_stars() -> void:
	for index in range(_stars.size()):
		var data: Vector4 = _stars[index]
		var depth: float = data.w
		var twinkle: float = 0.62 + 0.38 * sin(_time * (0.55 + data.z * 0.17) + float(index) * 0.73)
		var base_alpha: float = 0.16 + depth * 0.34
		var star_color := StarfallVisualTokens.alpha(&"text_primary", base_alpha * twinkle)
		if index % 19 == 0:
			star_color = StarfallVisualTokens.alpha(&"cyan_soft", (0.24 + depth * 0.28) * twinkle)
		elif index % 31 == 0:
			star_color = StarfallVisualTokens.alpha(&"purple_bright", (0.20 + depth * 0.24) * twinkle)
		var radius: float = data.z * (0.32 + depth * 0.34)
		draw_circle(Vector2(data.x, data.y), radius, star_color)
		if index % 23 == 0 and depth > 0.55:
			var glint := Color(star_color, star_color.a * 0.42)
			draw_line(Vector2(data.x - radius * 3.2, data.y), Vector2(data.x + radius * 3.2, data.y), glint, 0.8, true)
			draw_line(Vector2(data.x, data.y - radius * 2.4), Vector2(data.x, data.y + radius * 2.4), glint, 0.8, true)

func _draw_navigation_beacons() -> void:
	if sector != Sector.COURIER_CORRIDOR:
		return
	var pulse: float = 0.5 + 0.5 * sin(_time * 2.2)
	for index in range(6):
		var side: float = -1.0 if index % 2 == 0 else 1.0
		var row: int = index / 2
		var depth: float = float(row + 1) / 4.0
		var y: float = lerpf(preview_size.y * 0.25, preview_size.y * 0.76, depth)
		var x: float = preview_size.x * 0.5 + side * lerpf(54.0, preview_size.x * 0.42, depth)
		var size: float = 1.8 + depth * 1.6
		draw_circle(Vector2(x, y), size + 3.5, StarfallVisualTokens.alpha(&"cyan_primary", 0.025 + pulse * 0.015))
		draw_circle(Vector2(x, y), size, StarfallVisualTokens.alpha(&"cyan_soft", 0.40 + pulse * 0.22))
		draw_line(Vector2(x, y + size + 2.0), Vector2(x, y + size + 9.0), StarfallVisualTokens.alpha(&"purple_primary", 0.20), 1.0, true)

func _draw_speed_dust() -> void:
	var accent := StarfallVisualTokens.sector_primary(int(sector))
	accent.a = 0.10
	for index in range(18):
		var seed: float = float(index) * 37.17
		var x: float = fmod(seed * 3.41 + 23.0, preview_size.x)
		var travel: float = fmod(_time * (25.0 + float(index % 5) * 8.0) + seed * 5.0, preview_size.y + 30.0) - 15.0
		var length: float = 4.0 + float(index % 4) * 3.0
		draw_line(Vector2(x, travel), Vector2(x, travel + length), accent, 0.8 + float(index % 2) * 0.4, true)

func _draw_edge_vignette() -> void:
	var edge := StarfallVisualTokens.alpha(&"space_black", 0.18)
	var edge_width: float = maxf(10.0, preview_size.x * 0.035)
	draw_rect(Rect2(0.0, 0.0, edge_width, preview_size.y), edge)
	draw_rect(Rect2(preview_size.x - edge_width, 0.0, edge_width, preview_size.y), edge)
