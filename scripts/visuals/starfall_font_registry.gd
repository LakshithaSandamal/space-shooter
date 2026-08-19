class_name StarfallFontRegistry
extends RefCounted

const TEXT_FONT_PATH := "res://assets/fonts/text/oxanium/Oxanium[wght].ttf"
const ICON_FONT_PATH := "res://assets/fonts/icons/material_symbols/MaterialSymbolsSharp[FILL,GRAD,opsz,wght].ttf"

static func has_text_font() -> bool:
	return ResourceLoader.exists(TEXT_FONT_PATH)

static func has_icon_font() -> bool:
	return ResourceLoader.exists(ICON_FONT_PATH)

static func text_font() -> Font:
	if not has_text_font():
		return null
	return load(TEXT_FONT_PATH) as Font

static func icon_font() -> Font:
	if not has_icon_font():
		return null
	return load(ICON_FONT_PATH) as Font
