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
@export var star_count: int = 72
@export var animate: bool = true

var _time: float = 0.0
var _stars: Array[Vector3] = []

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
	_draw_planet()
	_draw_shipping_routes()
	_draw_stars()
	_draw_speed_dust()

func _rebuild_starfield() -> void:
	_stars.clear()
	var rng := RandomNumberGenerator.new()
	rng.seed = 7000 + int(sector) * 911
	for index in range(maxi(star_count, 0)):
		_stars.append(Vector3(
			rng.randf_range(0.0, preview_size.x),
			rng.randf_range(0.0, preview_size.y),
			rng.randf_range(0.7, 3.2)
		))

func _draw_base() -> void:
	var top := StarfallVisualTokens.color(&"space_black")
	var bottom := StarfallVisualTokens.color(&"space_navy")
	match sector:
		Sector.WRECK_BELT:
			bottom = StarfallVisualTokens.color(&"space_navy_2")
		Sector.ION_REACH:
			bottom = Color("07172A")
		Sector.SOLAR_RIFT:
			bottom = Color("181121")
		Sector.VOID_PASSAGE:
			bottom = Color("04050C")
		_:
			pass

	var strips := 18
	for index in range(strips):
		var ratio := float(index) / float(strips - 1)
		var strip_color := top.lerp(bottom, ratio)
		var strip_height := preview_size.y / float(strips)
		draw_rect(Rect2(0.0, index * strip_height, preview_size.x, strip_height + 1.0), strip_color)

func _draw_nebula_haze() -> void:
	var primary := StarfallVisualTokens.sector_primary(int(sector))
	var secondary := StarfallVisualTokens.sector_secondary(int(sector))
	var pulse := 0.5 + 0.5 * sin(_time * 0.22)
	primary.a = 0.045 + pulse * 0.025
	secondary.a = 0.035
	draw_circle(Vector2(preview_size.x * 0.25, preview_size.y * 0.28), preview_size.x * 0.42, primary)
	draw_circle(Vector2(preview_size.x * 0.82, preview_size.y * 0.66), preview_size.x * 0.34, secondary)

func _draw_planet() -> void:
	var center := Vector2(preview_size.x * 0.86, preview_size.y * 0.18)
	var radius := minf(preview_size.x, preview_size.y) * 0.12
	var body := StarfallVisualTokens.alpha(&"space_navy_2", 0.82)
	var rim := StarfallVisualTokens.sector_primary(int(sector))
	rim.a = 0.20
	draw_circle(center, radius, body)
	draw_arc(center, radius + 1.5, -2.5, 0.65, 42, rim, 2.0, true)
	if sector == Sector.WRECK_BELT:
		var ring := StarfallVisualTokens.alpha(&"gold_deep", 0.16)
		draw_arc(center, radius * 1.45, -0.18, 3.0, 46, ring, 2.0, true)

func _draw_shipping_routes() -> void:
	var route_color := StarfallVisualTokens.alpha(&"cyan_primary", 0.10)
	var half_width := preview_size.x * 0.29
	var bottom_y := preview_size.y
	var vanishing := Vector2(preview_size.x * 0.5, preview_size.y * 0.04)
	for lane_offset in [-1.0, 0.0, 1.0]:
		var start := Vector2(preview_size.x * 0.5 + half_width * lane_offset, bottom_y)
		draw_line(start, vanishing, route_color, 1.0, true)

func _draw_stars() -> void:
	for index in range(_stars.size()):
		var data := _stars[index]
		var twinkle := 0.65 + 0.35 * sin(_time * (0.7 + data.z * 0.15) + float(index) * 0.73)
		var star_color := StarfallVisualTokens.alpha(&"text_primary", 0.20 + 0.45 * twinkle)
		if index % 17 == 0:
			star_color = StarfallVisualTokens.alpha(&"cyan_soft", 0.34 + 0.34 * twinkle)
		elif index % 29 == 0:
			star_color = StarfallVisualTokens.alpha(&"purple_bright", 0.26 + 0.30 * twinkle)
		draw_circle(Vector2(data.x, data.y), data.z * 0.52, star_color)

func _draw_speed_dust() -> void:
	var accent := StarfallVisualTokens.sector_primary(int(sector))
	accent.a = 0.13
	for index in range(14):
		var seed := float(index) * 37.17
		var x := fmod(seed * 3.41 + 23.0, preview_size.x)
		var travel := fmod(_time * (30.0 + float(index % 5) * 8.0) + seed * 5.0, preview_size.y + 30.0) - 15.0
		var length := 5.0 + float(index % 4) * 3.0
		draw_line(Vector2(x, travel), Vector2(x, travel + length), accent, 1.0, true)
