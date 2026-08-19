class_name StarfallRunHud
extends Control

const LANE_NAMES: PackedStringArray = ["LEFT", "CENTER", "RIGHT"]

var _active_lane: int = 1
var _sector_label: Label
var _lane_label: Label
var _hint_label: Label

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	theme = StarfallUIThemeFactory.create_theme()
	_build_labels()
	resized.connect(_on_resized)
	_layout_labels()
	queue_redraw()

func set_active_lane(lane_index: int) -> void:
	_active_lane = clampi(lane_index, 0, 2)
	if _lane_label != null:
		_lane_label.text = "LANE  •  %s" % LANE_NAMES[_active_lane]
	queue_redraw()

func _draw() -> void:
	if size.x <= 0.0 or size.y <= 0.0:
		return

	var center_x: float = size.x * 0.5
	var indicator_y: float = size.y - 62.0
	var baseline := StarfallVisualTokens.alpha(&"line_dark", 0.72)
	draw_line(Vector2(center_x - 42.0, indicator_y), Vector2(center_x + 42.0, indicator_y), baseline, 1.5, true)

	for lane_index in range(3):
		var lane_x: float = center_x + float(lane_index - 1) * 28.0
		var radius: float = 7.0 if lane_index == _active_lane else 4.0
		var fill: Color = StarfallVisualTokens.color(&"cyan_primary") if lane_index == _active_lane else StarfallVisualTokens.color(&"line_muted")
		if lane_index == _active_lane:
			draw_circle(Vector2(lane_x, indicator_y), radius + 6.0, StarfallVisualTokens.alpha(&"cyan_primary", 0.08))
		draw_circle(Vector2(lane_x, indicator_y), radius, fill)

func _build_labels() -> void:
	_sector_label = Label.new()
	_sector_label.text = "COURIER CORRIDOR"
	_sector_label.add_theme_font_size_override("font_size", 18)
	_sector_label.add_theme_color_override("font_color", StarfallVisualTokens.color(&"cyan_soft"))
	add_child(_sector_label)

	_lane_label = Label.new()
	_lane_label.text = "LANE  •  CENTER"
	_lane_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_lane_label.add_theme_font_size_override("font_size", 16)
	_lane_label.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_secondary"))
	add_child(_lane_label)

	_hint_label = Label.new()
	_hint_label.text = "TAP LEFT / RIGHT"
	_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hint_label.add_theme_font_size_override("font_size", 15)
	_hint_label.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_muted"))
	add_child(_hint_label)

func _layout_labels() -> void:
	if _sector_label == null:
		return

	_sector_label.position = Vector2(24.0, 22.0)
	_sector_label.size = Vector2(260.0, 32.0)

	_lane_label.position = Vector2(maxf(24.0, size.x - 220.0), 24.0)
	_lane_label.size = Vector2(196.0, 28.0)

	_hint_label.position = Vector2(maxf(0.0, size.x * 0.5 - 150.0), maxf(0.0, size.y - 112.0))
	_hint_label.size = Vector2(300.0, 28.0)

func _on_resized() -> void:
	_layout_labels()
	queue_redraw()
