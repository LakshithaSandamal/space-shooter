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
	theme.set_color("font_pressed_color", "Button", StarfallVisualTokens.color(&"text_primary"))
	theme.set_color("font_disabled_color", "Button", StarfallVisualTokens.color(&"text_disabled"))

	theme.set_stylebox("normal", "Button", _button_box(StarfallVisualTokens.color(&"surface_dark"), StarfallVisualTokens.color(&"line_dark"), 2))
	theme.set_stylebox("hover", "Button", _button_box(StarfallVisualTokens.color(&"surface_hover"), StarfallVisualTokens.color(&"cyan_deep"), 2))
	theme.set_stylebox("pressed", "Button", _button_box(StarfallVisualTokens.color(&"purple_deep"), StarfallVisualTokens.color(&"purple_bright"), 2))
	theme.set_stylebox("disabled", "Button", _button_box(StarfallVisualTokens.color(&"space_navy_2"), StarfallVisualTokens.color(&"line_dark"), 1))

	var panel := StyleBoxFlat.new()
	panel.bg_color = StarfallVisualTokens.alpha(&"surface_dark", 0.94)
	panel.border_color = StarfallVisualTokens.color(&"line_dark")
	panel.set_border_width_all(1)
	panel.set_corner_radius_all(16)
	panel.content_margin_left = 18.0
	panel.content_margin_top = 16.0
	panel.content_margin_right = 18.0
	panel.content_margin_bottom = 16.0
	theme.set_stylebox("panel", "PanelContainer", panel)

	var tab_selected := _button_box(StarfallVisualTokens.color(&"surface_hover"), StarfallVisualTokens.color(&"purple_primary"), 2)
	var tab_unselected := _button_box(StarfallVisualTokens.color(&"space_navy_2"), StarfallVisualTokens.color(&"line_dark"), 1)
	theme.set_stylebox("tab_selected", "TabContainer", tab_selected)
	theme.set_stylebox("tab_unselected", "TabContainer", tab_unselected)

	theme.set_constant("separation", "VBoxContainer", 12)
	theme.set_constant("separation", "HBoxContainer", 10)
	return theme

static func _button_box(background: Color, border: Color, width: int) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = background
	box.border_color = border
	box.set_border_width_all(width)
	box.set_corner_radius_all(14)
	box.content_margin_left = 18.0
	box.content_margin_right = 18.0
	box.content_margin_top = 12.0
	box.content_margin_bottom = 12.0
	return box
