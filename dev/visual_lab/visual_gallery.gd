class_name StarfallVisualGallery
extends MarginContainer

enum Page {
	BACKGROUNDS,
	SHIPS,
	COLLECTIBLES_POWERUPS,
	HAZARDS_ROUTES,
	EFFECTS,
	UI,
}

@export var page: Page = Page.BACKGROUNDS

const CARD_WIDTH := 320.0
const OBJECT_PREVIEW_SIZE := Vector2(286.0, 184.0)
const BACKGROUND_PREVIEW_SIZE := Vector2(286.0, 390.0)

func _ready() -> void:
	theme = StarfallUIThemeFactory.create_theme()
	add_theme_constant_override("margin_left", 16)
	add_theme_constant_override("margin_top", 16)
	add_theme_constant_override("margin_right", 16)
	add_theme_constant_override("margin_bottom", 22)
	_build_page()

func _build_page() -> void:
	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(root)

	var header := Label.new()
	header.text = _page_title()
	header.add_theme_font_size_override("font_size", 28)
	header.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_primary"))
	root.add_child(header)

	var subtitle := Label.new()
	subtitle.text = _page_subtitle()
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_secondary"))
	root.add_child(subtitle)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 14)
	scroll.add_child(grid)

	match page:
		Page.BACKGROUNDS: _build_backgrounds(grid)
		Page.SHIPS: _build_ships(grid)
		Page.COLLECTIBLES_POWERUPS: _build_collectibles_powerups(grid)
		Page.HAZARDS_ROUTES: _build_hazards_routes(grid)
		Page.EFFECTS: _build_effects(grid)
		Page.UI: _build_ui(grid)

func _build_backgrounds(grid: GridContainer) -> void:
	_add_background_card(grid, "Courier Corridor", StarfallSpaceBackgroundVisual.Sector.COURIER_CORRIDOR)
	_add_background_card(grid, "Wreck Belt", StarfallSpaceBackgroundVisual.Sector.WRECK_BELT)
	_add_background_card(grid, "Ion Reach", StarfallSpaceBackgroundVisual.Sector.ION_REACH)
	_add_background_card(grid, "Solar Rift", StarfallSpaceBackgroundVisual.Sector.SOLAR_RIFT)
	_add_background_card(grid, "Void Passage", StarfallSpaceBackgroundVisual.Sector.VOID_PASSAGE)
	_add_effect_card(grid, "Sector Transition — Cyan", StarfallEffectVisual.EffectType.SECTOR_TRANSITION, 0)
	_add_effect_card(grid, "Sector Transition — Violet", StarfallEffectVisual.EffectType.SECTOR_TRANSITION, 1)

func _build_ships(grid: GridContainer) -> void:
	_add_ship_card(grid, "Courier", StarfallShipVisual.ShipType.COURIER, StarfallShipVisual.VisualState.NORMAL)
	_add_ship_card(grid, "Interceptor", StarfallShipVisual.ShipType.INTERCEPTOR, StarfallShipVisual.VisualState.NORMAL)
	_add_ship_card(grid, "Phantom", StarfallShipVisual.ShipType.PHANTOM, StarfallShipVisual.VisualState.NORMAL)
	_add_ship_card(grid, "Hauler — future slot", StarfallShipVisual.ShipType.HAULER, StarfallShipVisual.VisualState.NORMAL)
	_add_ship_card(grid, "Vector — future slot", StarfallShipVisual.ShipType.VECTOR, StarfallShipVisual.VisualState.NORMAL)
	_add_ship_card(grid, "Eclipse — future slot", StarfallShipVisual.ShipType.ECLIPSE, StarfallShipVisual.VisualState.NORMAL)
	_add_ship_card(grid, "Pathfinder — future slot", StarfallShipVisual.ShipType.PATHFINDER, StarfallShipVisual.VisualState.NORMAL)
	_add_ship_card(grid, "Courier — Shielded", StarfallShipVisual.ShipType.COURIER, StarfallShipVisual.VisualState.SHIELDED)
	_add_ship_card(grid, "Courier — Time Warp", StarfallShipVisual.ShipType.COURIER, StarfallShipVisual.VisualState.TIME_WARP)
	_add_ship_card(grid, "Courier — Overcharged", StarfallShipVisual.ShipType.COURIER, StarfallShipVisual.VisualState.OVERCHARGED)
	_add_ship_card(grid, "Courier — Impact", StarfallShipVisual.ShipType.COURIER, StarfallShipVisual.VisualState.IMPACT)
	_add_ship_card(grid, "Courier — Crashed", StarfallShipVisual.ShipType.COURIER, StarfallShipVisual.VisualState.CRASHED)
	_add_ship_card(grid, "Courier — Prestige", StarfallShipVisual.ShipType.COURIER, StarfallShipVisual.VisualState.PRESTIGE)

func _build_collectibles_powerups(grid: GridContainer) -> void:
	for variant_index in range(3):
		_add_object_card(grid, "Star Core v%d" % (variant_index + 1), StarfallGameObjectVisual.Kind.STAR_CORE, StarfallGameObjectVisual.VisualState.NORMAL, variant_index, 1.65)
	_add_object_card(grid, "Star Chip", StarfallGameObjectVisual.Kind.STAR_CHIP, StarfallGameObjectVisual.VisualState.NORMAL, 0, 1.55)
	_add_object_card(grid, "Shield", StarfallGameObjectVisual.Kind.SHIELD, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.55)
	_add_object_card(grid, "Time Warp", StarfallGameObjectVisual.Kind.TIME_WARP, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.55)
	_add_object_card(grid, "Overcharge", StarfallGameObjectVisual.Kind.OVERCHARGE, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.55)
	_add_object_card(grid, "Core Magnet — future", StarfallGameObjectVisual.Kind.CORE_MAGNET, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.55)
	_add_object_card(grid, "Stabilizer — future", StarfallGameObjectVisual.Kind.STABILIZER, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.55)
	_add_object_card(grid, "Phase Shift — future", StarfallGameObjectVisual.Kind.PHASE_SHIFT, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.55)
	_add_object_card(grid, "Emergency Jump — future", StarfallGameObjectVisual.Kind.EMERGENCY_JUMP, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.55)

func _build_hazards_routes(grid: GridContainer) -> void:
	for variant_index in range(3):
		_add_object_card(grid, "Standard Asteroid v%d" % (variant_index + 1), StarfallGameObjectVisual.Kind.STANDARD_ASTEROID, StarfallGameObjectVisual.VisualState.NORMAL, variant_index, 1.20)
	for variant_index in range(2):
		_add_object_card(grid, "Heavy Asteroid v%d" % (variant_index + 1), StarfallGameObjectVisual.Kind.HEAVY_ASTEROID, StarfallGameObjectVisual.VisualState.NORMAL, variant_index, 1.05)
	_add_object_card(grid, "Fast Debris", StarfallGameObjectVisual.Kind.FAST_DEBRIS, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.30)
	_add_object_card(grid, "Drifting Debris", StarfallGameObjectVisual.Kind.DRIFTING_DEBRIS, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.25)
	_add_object_card(grid, "Energy Mine — Warning", StarfallGameObjectVisual.Kind.ENERGY_MINE, StarfallGameObjectVisual.VisualState.WARNING, 0, 1.25)
	_add_object_card(grid, "Energy Mine — Active", StarfallGameObjectVisual.Kind.ENERGY_MINE, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.25)
	_add_object_card(grid, "Laser Gate — Warning", StarfallGameObjectVisual.Kind.LASER_GATE, StarfallGameObjectVisual.VisualState.WARNING, 0, 1.20)
	_add_object_card(grid, "Laser Gate — Active", StarfallGameObjectVisual.Kind.LASER_GATE, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.20)
	_add_object_card(grid, "Meteor Warning", StarfallGameObjectVisual.Kind.METEOR_WARNING, StarfallGameObjectVisual.VisualState.WARNING, 0, 1.30)
	_add_object_card(grid, "Cargo Wreck", StarfallGameObjectVisual.Kind.CARGO_WRECK, StarfallGameObjectVisual.VisualState.NORMAL, 0, 1.10)
	_add_object_card(grid, "Gravity Anomaly", StarfallGameObjectVisual.Kind.GRAVITY_ANOMALY, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.20)
	_add_object_card(grid, "Safe Route", StarfallGameObjectVisual.Kind.ROUTE_SAFE, StarfallGameObjectVisual.VisualState.NORMAL, 0, 1.15)
	_add_object_card(grid, "Core Field Route", StarfallGameObjectVisual.Kind.ROUTE_CORE, StarfallGameObjectVisual.VisualState.NORMAL, 0, 1.15)
	_add_object_card(grid, "Danger Route", StarfallGameObjectVisual.Kind.ROUTE_DANGER, StarfallGameObjectVisual.VisualState.NORMAL, 0, 1.15)
	_add_object_card(grid, "Contract Route", StarfallGameObjectVisual.Kind.ROUTE_CONTRACT, StarfallGameObjectVisual.VisualState.NORMAL, 0, 1.15)
	_add_object_card(grid, "Elite Route", StarfallGameObjectVisual.Kind.ROUTE_ELITE, StarfallGameObjectVisual.VisualState.SELECTED, 0, 1.15)
	_add_object_card(grid, "Extraction Gate", StarfallGameObjectVisual.Kind.EXTRACTION_GATE, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.10)
	_add_object_card(grid, "Courier Hunter — future encounter", StarfallGameObjectVisual.Kind.COURIER_HUNTER, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.10)

func _build_effects(grid: GridContainer) -> void:
	var effects: Array[Dictionary] = [
		{"name":"Spawn", "type":StarfallEffectVisual.EffectType.SPAWN},
		{"name":"Despawn", "type":StarfallEffectVisual.EffectType.DESPAWN},
		{"name":"Crash / Destruction", "type":StarfallEffectVisual.EffectType.CRASH},
		{"name":"Core Pickup", "type":StarfallEffectVisual.EffectType.CORE_PICKUP},
		{"name":"Shield Impact", "type":StarfallEffectVisual.EffectType.SHIELD_IMPACT},
		{"name":"Near Miss", "type":StarfallEffectVisual.EffectType.NEAR_MISS},
		{"name":"Danger Streak", "type":StarfallEffectVisual.EffectType.DANGER_STREAK},
		{"name":"Engine Trail", "type":StarfallEffectVisual.EffectType.ENGINE_TRAIL},
		{"name":"Time Warp", "type":StarfallEffectVisual.EffectType.TIME_WARP},
		{"name":"Overcharge", "type":StarfallEffectVisual.EffectType.OVERCHARGE},
		{"name":"Route Selected", "type":StarfallEffectVisual.EffectType.ROUTE_SELECTED},
		{"name":"Extraction", "type":StarfallEffectVisual.EffectType.EXTRACTION},
		{"name":"Sector Transition", "type":StarfallEffectVisual.EffectType.SECTOR_TRANSITION},
		{"name":"Threat Pulse", "type":StarfallEffectVisual.EffectType.THREAT_PULSE},
		{"name":"New Record", "type":StarfallEffectVisual.EffectType.NEW_RECORD},
		{"name":"Achievement", "type":StarfallEffectVisual.EffectType.ACHIEVEMENT},
		{"name":"Mastery / Reputation", "type":StarfallEffectVisual.EffectType.MASTERY},
	]
	for definition in effects:
		_add_effect_card(grid, definition["name"], int(definition["type"]), 0)

func _build_ui(grid: GridContainer) -> void:
	_add_font_status_card(grid)
	_add_button_catalog_card(grid)
	_add_hud_card(grid)
	_add_route_choice_card(grid)
	_add_contract_card(grid)
	_add_progression_card(grid)
	_add_settings_card(grid)
	_add_end_run_card(grid)

func _add_background_card(grid: GridContainer, title: String, sector: int) -> void:
	var content := _create_card(grid, title)
	var preview := Control.new()
	preview.custom_minimum_size = BACKGROUND_PREVIEW_SIZE
	preview.clip_contents = true
	content.add_child(preview)
	var visual := StarfallSpaceBackgroundVisual.new()
	visual.preview_size = BACKGROUND_PREVIEW_SIZE
	visual.sector = sector as StarfallSpaceBackgroundVisual.Sector
	preview.add_child(visual)

func _add_ship_card(grid: GridContainer, title: String, ship: int, state: int) -> void:
	var content := _create_card(grid, title)
	var preview := _preview_control()
	content.add_child(preview)
	var visual := StarfallShipVisual.new()
	visual.ship_type = ship as StarfallShipVisual.ShipType
	visual.visual_state = state as StarfallShipVisual.VisualState
	visual.display_scale = 1.35
	visual.position = OBJECT_PREVIEW_SIZE * 0.5 + Vector2(0.0, -4.0)
	preview.add_child(visual)

func _add_object_card(grid: GridContainer, title: String, object_kind: int, state: int, visual_variant: int, scale_value: float) -> void:
	var content := _create_card(grid, title)
	var preview := _preview_control()
	content.add_child(preview)
	var visual := StarfallGameObjectVisual.new()
	visual.kind = object_kind as StarfallGameObjectVisual.Kind
	visual.visual_state = state as StarfallGameObjectVisual.VisualState
	visual.variant = visual_variant
	visual.display_scale = scale_value
	visual.position = OBJECT_PREVIEW_SIZE * 0.5
	preview.add_child(visual)

func _add_effect_card(grid: GridContainer, title: String, effect: int, visual_variant: int) -> void:
	var content := _create_card(grid, title)
	var preview := _preview_control()
	content.add_child(preview)
	var visual := StarfallEffectVisual.new()
	visual.effect_type = effect as StarfallEffectVisual.EffectType
	visual.variant = visual_variant
	visual.display_scale = 1.35
	visual.position = OBJECT_PREVIEW_SIZE * 0.5
	preview.add_child(visual)

func _add_font_status_card(grid: GridContainer) -> void:
	var content := _create_card(grid, "Typography & icon-font checks")
	_add_status_row(content, "Oxanium Variable", StarfallFontRegistry.has_text_font(), StarfallFontRegistry.TEXT_FONT_PATH)
	_add_status_row(content, "Material Symbols Sharp Variable", StarfallFontRegistry.has_icon_font(), StarfallFontRegistry.ICON_FONT_PATH)
	var specimen := Label.new()
	specimen.text = "STARFALL COURIER  •  THREAT 4  •  2,480 m  •  x12"
	specimen.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	specimen.add_theme_font_size_override("font_size", 18)
	content.add_child(specimen)

	if StarfallFontRegistry.has_icon_font():
		var icon_font := StarfallFontRegistry.icon_font()
		var icons := Label.new()
		icons.text = "play_arrow  pause  settings  route  shield  bolt"
		icons.add_theme_font_override("font", icon_font)
		icons.add_theme_font_size_override("font_size", 28)
		content.add_child(icons)
	else:
		var missing := Label.new()
		missing.text = "Icon glyph preview activates automatically when the configured font file exists."
		missing.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		missing.add_theme_color_override("font_color", StarfallVisualTokens.color(&"warning_orange"))
		content.add_child(missing)

func _add_button_catalog_card(grid: GridContainer) -> void:
	var content := _create_card(grid, "Buttons / actions")
	var play := Button.new()
	play.text = "PLAY"
	play.custom_minimum_size.y = 66.0
	content.add_child(play)
	var secondary := Button.new()
	secondary.text = "CONTRACTS"
	secondary.custom_minimum_size.y = 54.0
	content.add_child(secondary)
	var row := HBoxContainer.new()
	content.add_child(row)
	for label_text in ["HANGAR", "UPGRADES", "STATS"]:
		var button := Button.new()
		button.text = label_text
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(button)

func _add_hud_card(grid: GridContainer) -> void:
	var content := _create_card(grid, "Gameplay HUD")
	var hud := HBoxContainer.new()
	content.add_child(hud)
	for value in ["PAUSE", "2,480 m", "x12", "86 CORES"]:
		var label := Label.new()
		label.text = value
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_primary"))
		hud.add_child(label)
	var power := Label.new()
	power.text = "ACTIVE  •  SHIELD  01"
	power.add_theme_color_override("font_color", StarfallVisualTokens.color(&"cyan_primary"))
	content.add_child(power)
	var objective := Label.new()
	objective.text = "CONTRACT  •  Reach 3,000 m   83%"
	objective.add_theme_color_override("font_color", StarfallVisualTokens.color(&"gold_primary"))
	content.add_child(objective)

func _add_route_choice_card(grid: GridContainer) -> void:
	var content := _create_card(grid, "Route choice UI language")
	var routes := HBoxContainer.new()
	content.add_child(routes)
	_add_route_chip(routes, "SAFE", StarfallVisualTokens.color(&"success_green"))
	_add_route_chip(routes, "CORE FIELD", StarfallVisualTokens.color(&"gold_primary"))
	_add_route_chip(routes, "DANGER", StarfallVisualTokens.color(&"magenta_primary"))

func _add_contract_card(grid: GridContainer) -> void:
	var content := _create_card(grid, "Contract card")
	var title := Label.new()
	title.text = "FRAGILE CARGO"
	title.add_theme_font_size_override("font_size", 20)
	content.add_child(title)
	var detail := Label.new()
	detail.text = "Reach 2,500 m without losing Shield protection."
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_secondary"))
	content.add_child(detail)
	var reward := Label.new()
	reward.text = "REWARD  +420 STAR CHIPS   +180 REP"
	reward.add_theme_color_override("font_color", StarfallVisualTokens.color(&"gold_primary"))
	content.add_child(reward)

func _add_progression_card(grid: GridContainer) -> void:
	var content := _create_card(grid, "Upgrades / mastery / reputation")
	for entry in ["HANDLING  •  LV 3 / 5", "TIME WARP  •  LV 2 / 5", "COURIER MASTERY  •  7 / 10", "REPUTATION  •  ELITE COURIER"]:
		var label := Label.new()
		label.text = entry
		content.add_child(label)
		var progress := ProgressBar.new()
		progress.show_percentage = false
		progress.value = 55.0 + float(content.get_child_count() % 4) * 10.0
		progress.custom_minimum_size.y = 8.0
		content.add_child(progress)

func _add_settings_card(grid: GridContainer) -> void:
	var content := _create_card(grid, "Settings rows")
	for setting_name in ["MUSIC", "SFX", "SCREEN SHAKE", "REDUCED MOTION"]:
		var row := HBoxContainer.new()
		content.add_child(row)
		var label := Label.new()
		label.text = setting_name
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(label)
		var toggle := CheckButton.new()
		toggle.button_pressed = setting_name != "REDUCED MOTION"
		row.add_child(toggle)

func _add_end_run_card(grid: GridContainer) -> void:
	var content := _create_card(grid, "Run summary / record")
	var title := Label.new()
	title.text = "DELIVERY RUN COMPLETE"
	title.add_theme_font_size_override("font_size", 20)
	content.add_child(title)
	for line in ["DISTANCE        4,860 m", "BEST COMBO          x24", "NEAR MISSES          18", "STAR CORES           164", "NEW RECORD       +1,240"]:
		var label := Label.new()
		label.text = line
		if line.begins_with("NEW RECORD"):
			label.add_theme_color_override("font_color", StarfallVisualTokens.color(&"gold_primary"))
		content.add_child(label)

func _add_status_row(content: VBoxContainer, name_text: String, available: bool, path_text: String) -> void:
	var status := Label.new()
	status.text = ("READY  •  " if available else "MISSING  •  ") + name_text
	status.add_theme_color_override("font_color", StarfallVisualTokens.color(&"success_green") if available else StarfallVisualTokens.color(&"warning_orange"))
	content.add_child(status)
	var path_label := Label.new()
	path_label.text = path_text
	path_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	path_label.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_muted"))
	content.add_child(path_label)

func _add_route_chip(parent: HBoxContainer, text_value: String, accent: Color) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var style := StyleBoxFlat.new()
	style.bg_color = Color(accent, 0.08)
	style.border_color = Color(accent, 0.72)
	style.set_border_width_all(2)
	style.set_corner_radius_all(12)
	style.content_margin_left = 10.0
	style.content_margin_right = 10.0
	style.content_margin_top = 10.0
	style.content_margin_bottom = 10.0
	panel.add_theme_stylebox_override("panel", style)
	parent.add_child(panel)
	var label := Label.new()
	label.text = text_value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", accent)
	panel.add_child(label)

func _create_card(grid: GridContainer, title_text: String) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size.x = CARD_WIDTH
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_child(panel)
	var content := VBoxContainer.new()
	panel.add_child(content)
	var title := Label.new()
	title.text = title_text
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_primary"))
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(title)
	return content

func _preview_control() -> Control:
	var preview := Control.new()
	preview.custom_minimum_size = OBJECT_PREVIEW_SIZE
	preview.clip_contents = true
	var background := ColorRect.new()
	background.color = StarfallVisualTokens.color(&"space_black")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview.add_child(background)
	background.show_behind_parent = true
	return preview

func _page_title() -> String:
	match page:
		Page.BACKGROUNDS: return "BACKGROUND / SECTOR VISUALS"
		Page.SHIPS: return "SHIP FAMILIES / STATES"
		Page.COLLECTIBLES_POWERUPS: return "COLLECTIBLES / POWER-UPS"
		Page.HAZARDS_ROUTES: return "HAZARDS / ROUTES / ENCOUNTERS"
		Page.EFFECTS: return "ANIMATION / VFX INVENTORY"
		Page.UI: return "UI / TYPOGRAPHY / ICON SYSTEM"
		_: return "VISUAL INVENTORY"

func _page_subtitle() -> String:
	match page:
		Page.BACKGROUNDS: return "Five coherent sector atmospheres plus transition motion. Backgrounds must remain quieter than gameplay objects."
		Page.SHIPS: return "All ship silhouette slots and the complete Courier visual-state set. Future ships are visual slots only, not gameplay implementations."
		Page.COLLECTIBLES_POWERUPS: return "Reward and power-up readability at gameplay scale, including reserved future power-up identities."
		Page.HAZARDS_ROUTES: return "Every hazard family, route-gate language, extraction, and future Hunter silhouette. Compare warning versus active states side-by-side."
		Page.EFFECTS: return "All effects loop automatically. Use this page to inspect timing, brightness hierarchy, clutter, and reduced-motion candidates."
		Page.UI: return "Production UI language and font-path checks. Missing configured font files are deliberately surfaced as issues."
		_: return ""
