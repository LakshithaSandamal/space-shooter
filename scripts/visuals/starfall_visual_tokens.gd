class_name StarfallVisualTokens
extends RefCounted

const DESIGN_SIZE := Vector2(720.0, 1280.0)

static func color(token: StringName) -> Color:
	match token:
		&"space_black": return Color("050711")
		&"space_void": return Color("02040A")
		&"space_navy": return Color("080D1D")
		&"space_navy_2": return Color("0D1428")
		&"surface_dark": return Color("111A31")
		&"surface_hover": return Color("17213C")
		&"line_dark": return Color("26324F")
		&"line_muted": return Color("394462")
		&"metal_dark": return Color("20263A")
		&"metal_mid": return Color("30384F")
		&"metal_light": return Color("65708A")
		&"hull_shadow": return Color("9CA8BF")
		&"hull_mid": return Color("DDE4F2")
		&"hull_highlight": return Color("FFFFFF")
		&"purple_primary": return Color("8B5CFF")
		&"purple_bright": return Color("A784FF")
		&"purple_deep": return Color("5C3FC8")
		&"cyan_primary": return Color("27E7FF")
		&"cyan_soft": return Color("83F4FF")
		&"cyan_deep": return Color("1593B3")
		&"magenta_primary": return Color("FF3EA5")
		&"magenta_bright": return Color("FF79C6")
		&"danger_red": return Color("FF5364")
		&"warning_orange": return Color("FF9D45")
		&"gold_primary": return Color("FFC857")
		&"gold_bright": return Color("FFE08A")
		&"gold_deep": return Color("C98A2D")
		&"success_green": return Color("4EE6A8")
		&"success_bright": return Color("8AF5C7")
		&"text_primary": return Color("F5F7FF")
		&"text_secondary": return Color("B9C1D9")
		&"text_muted": return Color("7F89A6")
		&"text_disabled": return Color("566078")
		_: return Color("FF00FF")

static func alpha(token: StringName, value: float) -> Color:
	var result := color(token)
	result.a = clampf(value, 0.0, 1.0)
	return result

static func sector_primary(sector: int) -> Color:
	match sector:
		0: return color(&"cyan_primary")
		1: return color(&"purple_primary")
		2: return color(&"cyan_soft")
		3: return color(&"warning_orange")
		4: return color(&"purple_bright")
		_: return color(&"cyan_primary")

static func sector_secondary(sector: int) -> Color:
	match sector:
		0: return color(&"purple_primary")
		1: return color(&"gold_deep")
		2: return color(&"purple_bright")
		3: return color(&"magenta_primary")
		4: return color(&"cyan_primary")
		_: return color(&"purple_primary")
