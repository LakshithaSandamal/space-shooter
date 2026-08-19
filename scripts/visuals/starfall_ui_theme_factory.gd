class_name StarfallUIThemeFactory
extends RefCounted

static func create_theme() -> Theme:
	var theme := Theme.new()
	var text_font := StarfallFontRegistry.text_font()
	if text_font != null:
		theme.default_font = text_font
	theme.default_font_size = 16

	theme.set_color("font_color", "Label", StarfallVisualTokens.color(&"text_primary"))
	theme.set_color("font_color", "Button", StarfallVisualTokens.color(&"text_primary"))
	theme.set_color("font_hover_color", "Button", StarfallVisualTokens.color(&"cyan_soft"))
	theme.set_color("font_pressed_color", "Button", StarfallVisualTokens.color(&"hull_highlight"))
	theme.set_color("font_focus_color", "Button", StarfallVisualTokens.color(&"cyan_soft"))
	theme.set_color("font_disabled_color", "Button", StarfallVisualTokens.color(&"text_disabled"))

	theme.set_stylebox("normal", "Button", _button_box(
		StarfallVisualTokens.alpha(&"surface_dark", 0.96),
		StarfallVisualTokens.color(&"line_dark"),
		StarfallVisualTokens.alpha(&"purple_primary", 0.08),
		1
	))
	theme.set_stylebox("hover", "Button", _button_box(
		StarfallVisualTokens.color(&"surface_hover"),
		StarfallVisualTokens.color(&"cyan_deep"),
		StarfallVisualTokens.alpha(&"cyan_primary", 0.11),
		2
	))
	theme.set_stylebox("pressed", "Button", _button_box(
		StarfallVisualTokens.color(&"purple_deep"),
		StarfallVisualTokens.color(&"purple_bright"),
		StarfallVisualTokens.alpha(&"purple_bright", 0.10),
		2
	))
	theme.set_stylebox("focus", "Button", _button_box(
		StarfallVisualTokens.alpha(&"surface_dark", 0.95),
		StarfallVisualTokens.color(&"cyan_primary"),
		StarfallVisualTokens.alpha(&"cyan_primary", 0.10),
		2
	))
	theme.set_stylebox("disabled", "Button", _button_box(
		StarfallVisualTokens.color(&"space_navy_2"),
		StarfallVisualTokens.color(&"line_dark"),
		Color.TRANSPARENT,
		1
	))

	theme.set_stylebox("panel", "PanelContainer", _panel_box())

	var tab_selected := _button_box(
		StarfallVisualTokens.color(&"surface_hover"),
		StarfallVisualTokens.color(&"purple_primary"),
		StarfallVisualTokens.alpha(&"purple_primary", 0.09),
		2
	)
	var tab_unselected := _button_box(
		StarfallVisualTokens.color(&"space_navy_2"),
		StarfallVisualTokens.color(&"line_dark"),
		Color.TRANSPARENT,
		1
	)
	theme.set_stylebox("tab_selected", "TabContainer", tab_selected)
	theme.set_stylebox("tab_unselected", "TabContainer", tab_unselected)

	var progress_background := StyleBoxFlat.new()
	progress_background.bg_color = StarfallVisualTokens.alpha(&"space_void", 0.86)
	progress_background.border_color = StarfallVisualTokens.color(&"line_dark")
	progress_background.set_border_width_all(1)
	progress_background.set_corner_radius_all(5)
	progress_background.content_margin_left = 3.0
	progress_background.content_margin_top = 3.0
	progress_background.content_margin_right = 3.0
	progress_background.content_margin_bottom = 3.0
	theme.set_stylebox("background", "ProgressBar", progress_background)

	var progress_fill := StyleBoxFlat.new()
	progress_fill.bg_color = StarfallVisualTokens.color(&"cyan_deep")
	progress_fill.border_color = StarfallVisualTokens.color(&"cyan_primary")
	progress_fill.set_border_width_all(1)
	progress_fill.set_corner_radius_all(3)
	theme.set_stylebox("fill", "ProgressBar", progress_fill)
	theme.set_color("font_color", "ProgressBar", StarfallVisualTokens.color(&"hull_highlight"))

	theme.set_constant("separation", "VBoxContainer", 12)
	theme.set_constant("separation", "HBoxContainer", 10)
	theme.set_constant("outline_size", "Label", 0)
	return theme

static func _button_box(background: Color, border: Color, glow_hint: Color, width: int) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = background.lerp(glow_hint, glow_hint.a)
	box.border_color = border
	box.set_border_width_all(width)
	box.set_corner_radius_all(10)
	box.content_margin_left = 18.0
	box.content_margin_right = 18.0
	box.content_margin_top = 12.0
	box.content_margin_bottom = 12.0
	return box

static func _panel_box() -> StyleBoxFlat:
	var panel := StyleBoxFlat.new()
	panel.bg_color = StarfallVisualTokens.alpha(&"surface_dark", 0.94)
	panel.border_color = StarfallVisualTokens.alpha(&"line_muted", 0.78)
	panel.set_border_width_all(1)
	panel.border_width_left = 2
	panel.border_width_top = 1
	panel.set_corner_radius_all(12)
	panel.corner_radius_top_left = 3
	panel.corner_radius_bottom_right = 3
	panel.content_margin_left = 18.0
	panel.content_margin_top = 16.0
	panel.content_margin_right = 18.0
	panel.content_margin_bottom = 16.0
	return panel
