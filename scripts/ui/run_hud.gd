class_name StarfallRunHud
extends Control

const LANE_NAMES: PackedStringArray = ["LEFT", "CENTER", "RIGHT"]

var _active_lane: int = 1
var _sector_label: Label
var _lane_label: Label
var _distance_label: Label
var _cores_label: Label
var _score_label: Label
var _hint_label: Label
var _game_over_panel: PanelContainer
var _game_over_stats: Label

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	theme = StarfallUIThemeFactory.create_theme()
	_build_labels()
	_build_game_over_panel()
	resized.connect(_on_resized)
	_layout_controls()
	queue_redraw()

func set_active_lane(lane_index: int) -> void:
	_active_lane = clampi(lane_index, 0, 2)
	if _lane_label != null:
		_lane_label.text = "LANE  •  %s" % LANE_NAMES[_active_lane]
	queue_redraw()

func set_run_metrics(distance_m: float, core_count: int, score: int) -> void:
	if _distance_label != null:
		_distance_label.text = "%04d m" % int(floor(distance_m))
	if _cores_label != null:
		_cores_label.text = "CORES  %02d" % core_count
	if _score_label != null:
		_score_label.text = "SCORE  %06d" % score

func reset_run() -> void:
	if _game_over_panel != null:
		_game_over_panel.visible = false
	if _hint_label != null:
		_hint_label.text = "TAP LEFT / RIGHT"
		_hint_label.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_muted"))

func show_game_over(distance_m: float, core_count: int, score: int) -> void:
	if _game_over_panel == null:
		return
	_game_over_stats.text = "%d m   •   %d CORES   •   %d SCORE" % [int(floor(distance_m)), core_count, score]
	_game_over_panel.visible = true
	_hint_label.text = "TAP OR PRESS SPACE TO RESTART"
	_hint_label.add_theme_color_override("font_color", StarfallVisualTokens.color(&"cyan_soft"))

func _draw() -> void:
	if size.x <= 0.0 or size.y <= 0.0:
		return

	var center_x: float = size.x * 0.5
	var indicator_y: float = size.y - 62.0
	var baseline: Color = StarfallVisualTokens.alpha(&"line_dark", 0.72)
	draw_line(Vector2(center_x - 42.0, indicator_y), Vector2(center_x + 42.0, indicator_y), baseline, 1.5, true)

	for lane_index: int in range(3):
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

	_distance_label = Label.new()
	_distance_label.text = "0000 m"
	_distance_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_distance_label.add_theme_font_size_override("font_size", 24)
	_distance_label.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_primary"))
	add_child(_distance_label)

	_cores_label = Label.new()
	_cores_label.text = "CORES  00"
	_cores_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_cores_label.add_theme_font_size_override("font_size", 15)
	_cores_label.add_theme_color_override("font_color", StarfallVisualTokens.color(&"gold_bright"))
	add_child(_cores_label)

	_score_label = Label.new()
	_score_label.text = "SCORE  000000"
	_score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_score_label.add_theme_font_size_override("font_size", 14)
	_score_label.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_secondary"))
	add_child(_score_label)

	_lane_label = Label.new()
	_lane_label.text = "LANE  •  CENTER"
	_lane_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_lane_label.add_theme_font_size_override("font_size", 15)
	_lane_label.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_secondary"))
	add_child(_lane_label)

	_hint_label = Label.new()
	_hint_label.text = "TAP LEFT / RIGHT"
	_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hint_label.add_theme_font_size_override("font_size", 15)
	_hint_label.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_muted"))
	add_child(_hint_label)

func _build_game_over_panel() -> void:
	_game_over_panel = PanelContainer.new()
	_game_over_panel.visible = false
	_game_over_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_game_over_panel)

	var content := VBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 8)
	_game_over_panel.add_child(content)

	var title := Label.new()
	title.text = "ROUTE LOST"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", StarfallVisualTokens.color(&"danger_red"))
	content.add_child(title)

	_game_over_stats = Label.new()
	_game_over_stats.text = "0 m   •   0 CORES   •   0 SCORE"
	_game_over_stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_game_over_stats.add_theme_font_size_override("font_size", 16)
	_game_over_stats.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_secondary"))
	content.add_child(_game_over_stats)

	var restart := Label.new()
	restart.text = "TAP ANYWHERE TO RUN AGAIN"
	restart.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	restart.add_theme_font_size_override("font_size", 15)
	restart.add_theme_color_override("font_color", StarfallVisualTokens.color(&"cyan_soft"))
	content.add_child(restart)

func _layout_controls() -> void:
	if _sector_label == null:
		return

	_sector_label.position = Vector2(24.0, 22.0)
	_sector_label.size = Vector2(260.0, 32.0)

	_distance_label.position = Vector2(maxf(24.0, size.x - 224.0), 18.0)
	_distance_label.size = Vector2(200.0, 34.0)

	_cores_label.position = Vector2(maxf(24.0, size.x - 224.0), 54.0)
	_cores_label.size = Vector2(200.0, 24.0)

	_score_label.position = Vector2(maxf(24.0, size.x - 224.0), 78.0)
	_score_label.size = Vector2(200.0, 24.0)

	_lane_label.position = Vector2(maxf(0.0, size.x * 0.5 - 110.0), maxf(0.0, size.y - 94.0))
	_lane_label.size = Vector2(220.0, 26.0)

	_hint_label.position = Vector2(maxf(0.0, size.x * 0.5 - 170.0), maxf(0.0, size.y - 132.0))
	_hint_label.size = Vector2(340.0, 28.0)

	_game_over_panel.position = Vector2(maxf(24.0, size.x * 0.5 - 250.0), maxf(140.0, size.y * 0.5 - 95.0))
	_game_over_panel.size = Vector2(minf(500.0, size.x - 48.0), 190.0)

func _on_resized() -> void:
	_layout_controls()
	queue_redraw()
