extends MarginContainer

const CARD_SIZE := Vector2(300.0, 190.0)
const BACKGROUND_SIZE := Vector2(300.0, 390.0)

func _ready() -> void:
	theme = StarfallUIThemeFactory.create_theme()
	add_theme_constant_override("margin_left", 18)
	add_theme_constant_override("margin_top", 18)
	add_theme_constant_override("margin_right", 18)
	add_theme_constant_override("margin_bottom", 24)
	_build()

func _build() -> void:
	var root := VBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(root)

	var title := Label.new()
	title.text = "VISUAL PRODUCTION PASS 1"
	title.add_theme_font_size_override("font_size", 30)
	root.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Hero readability review • structural detail • materials • variants • motion"
	subtitle.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_secondary"))
	root.add_child(subtitle)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)

	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 22)
	scroll.add_child(content)

	_build_background_section(content)
	_build_ship_section(content)
	_build_collectible_section(content)
	_build_asteroid_section(content)
	_build_route_section(content)
	_build_effect_section(content)
	_build_ui_section(content)

func _build_background_section(parent: VBoxContainer) -> void:
	var grid := _section(parent, "01 • COURIER CORRIDOR")
	var card := _card(grid, "Layered production background")
	var preview := Control.new()
	preview.custom_minimum_size = BACKGROUND_SIZE
	preview.clip_contents = true
	card.add_child(preview)
	var visual := StarfallSpaceBackgroundVisual.new()
	visual.preview_size = BACKGROUND_SIZE
	visual.sector = StarfallSpaceBackgroundVisual.Sector.COURIER_CORRIDOR
	preview.add_child(visual)

func _build_ship_section(parent: VBoxContainer) -> void:
	var grid := _section(parent, "02 • COURIER HERO STATES")
	var states: Array[Dictionary] = [
		{"name":"Courier • Normal", "state":StarfallShipVisual.VisualState.NORMAL},
		{"name":"Courier • Shielded", "state":StarfallShipVisual.VisualState.SHIELDED},
		{"name":"Courier • Time Warp", "state":StarfallShipVisual.VisualState.TIME_WARP},
		{"name":"Courier • Overcharged", "state":StarfallShipVisual.VisualState.OVERCHARGED},
		{"name":"Courier • Impact", "state":StarfallShipVisual.VisualState.IMPACT},
		{"name":"Courier • Crash", "state":StarfallShipVisual.VisualState.CRASHED},
		{"name":"Courier • Prestige", "state":StarfallShipVisual.VisualState.PRESTIGE},
	]
	for definition in states:
		_add_ship_card(grid, str(definition["name"]), int(definition["state"]))

func _build_collectible_section(parent: VBoxContainer) -> void:
	var grid := _section(parent, "03 • REWARD + POWER SYSTEM")
	for variant_index in range(3):
		_add_object_card(grid, "Star Core • Facet %d" % (variant_index + 1), StarfallGameObjectVisual.Kind.STAR_CORE, StarfallGameObjectVisual.VisualState.NORMAL, variant_index, 1.75)
	_add_object_card(grid, "Star Chip", StarfallGameObjectVisual.Kind.STAR_CHIP, StarfallGameObjectVisual.VisualState.NORMAL, 0, 1.60)
	_add_object_card(grid, "Shield", StarfallGameObjectVisual.Kind.SHIELD, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.60)
	_add_object_card(grid, "Time Warp", StarfallGameObjectVisual.Kind.TIME_WARP, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.60)
	_add_object_card(grid, "Overcharge", StarfallGameObjectVisual.Kind.OVERCHARGE, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.60)

func _build_asteroid_section(parent: VBoxContainer) -> void:
	var grid := _section(parent, "04 • ASTEROID SILHOUETTE + SURFACE VARIANTS")
	for variant_index in range(6):
		_add_object_card(grid, "Standard • %d/6" % (variant_index + 1), StarfallGameObjectVisual.Kind.STANDARD_ASTEROID, StarfallGameObjectVisual.VisualState.NORMAL, variant_index, 1.28)
	for variant_index in range(4):
		_add_object_card(grid, "Heavy • %d/4" % (variant_index + 1), StarfallGameObjectVisual.Kind.HEAVY_ASTEROID, StarfallGameObjectVisual.VisualState.NORMAL, variant_index, 1.05)

func _build_route_section(parent: VBoxContainer) -> void:
	var grid := _section(parent, "05 • ROUTE / HAZARD MACHINERY")
	_add_object_card(grid, "Energy Mine • Warning", StarfallGameObjectVisual.Kind.ENERGY_MINE, StarfallGameObjectVisual.VisualState.WARNING, 0, 1.28)
	_add_object_card(grid, "Energy Mine • Active", StarfallGameObjectVisual.Kind.ENERGY_MINE, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.28)
	_add_object_card(grid, "Laser Gate • Warning", StarfallGameObjectVisual.Kind.LASER_GATE, StarfallGameObjectVisual.VisualState.WARNING, 0, 1.18)
	_add_object_card(grid, "Laser Gate • Active", StarfallGameObjectVisual.Kind.LASER_GATE, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.18)
	_add_object_card(grid, "Safe Route", StarfallGameObjectVisual.Kind.ROUTE_SAFE, StarfallGameObjectVisual.VisualState.NORMAL, 0, 1.12)
	_add_object_card(grid, "Core Route", StarfallGameObjectVisual.Kind.ROUTE_CORE, StarfallGameObjectVisual.VisualState.NORMAL, 0, 1.12)
	_add_object_card(grid, "Danger Route", StarfallGameObjectVisual.Kind.ROUTE_DANGER, StarfallGameObjectVisual.VisualState.NORMAL, 0, 1.12)
	_add_object_card(grid, "Contract Route", StarfallGameObjectVisual.Kind.ROUTE_CONTRACT, StarfallGameObjectVisual.VisualState.NORMAL, 0, 1.12)
	_add_object_card(grid, "Elite Route • Selected", StarfallGameObjectVisual.Kind.ROUTE_ELITE, StarfallGameObjectVisual.VisualState.SELECTED, 0, 1.12)
	_add_object_card(grid, "Extraction Gate", StarfallGameObjectVisual.Kind.EXTRACTION_GATE, StarfallGameObjectVisual.VisualState.ACTIVE, 0, 1.02)

func _build_effect_section(parent: VBoxContainer) -> void:
	var grid := _section(parent, "06 • MOTION + FEEDBACK")
	var effects: Array[Dictionary] = [
		{"name":"Spawn", "type":StarfallEffectVisual.EffectType.SPAWN},
		{"name":"Crash / breakup", "type":StarfallEffectVisual.EffectType.CRASH},
		{"name":"Core pickup", "type":StarfallEffectVisual.EffectType.CORE_PICKUP},
		{"name":"Shield impact", "type":StarfallEffectVisual.EffectType.SHIELD_IMPACT},
		{"name":"Near Miss", "type":StarfallEffectVisual.EffectType.NEAR_MISS},
		{"name":"Danger Streak", "type":StarfallEffectVisual.EffectType.DANGER_STREAK},
		{"name":"Engine trail", "type":StarfallEffectVisual.EffectType.ENGINE_TRAIL},
		{"name":"Time Warp", "type":StarfallEffectVisual.EffectType.TIME_WARP},
		{"name":"Overcharge", "type":StarfallEffectVisual.EffectType.OVERCHARGE},
		{"name":"Route selected", "type":StarfallEffectVisual.EffectType.ROUTE_SELECTED},
	]
	for definition in effects:
		_add_effect_card(grid, str(definition["name"]), int(definition["type"]))

func _build_ui_section(parent: VBoxContainer) -> void:
	var grid := _section(parent, "07 • COCKPIT UI MATERIALS")
	var card := _card(grid, "Primary actions + status hierarchy")
	var button := Button.new()
	button.text = "START COURIER RUN"
	button.custom_minimum_size.y = 62.0
	card.add_child(button)
	var secondary := Button.new()
	secondary.text = "CONTRACTS"
	secondary.custom_minimum_size.y = 50.0
	card.add_child(secondary)
	var status := Label.new()
	status.text = "THREAT 04   •   2,480 m   •   x12 COMBO"
	status.add_theme_color_override("font_color", StarfallVisualTokens.color(&"cyan_soft"))
	card.add_child(status)
	var progress := ProgressBar.new()
	progress.min_value = 0.0
	progress.max_value = 100.0
	progress.value = 68.0
	progress.show_percentage = false
	progress.custom_minimum_size.y = 18.0
	card.add_child(progress)
	var note := Label.new()
	note.text = "Check panel hierarchy, clipped-corner feel, border restraint, value contrast, and font fallback."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_secondary"))
	card.add_child(note)

func _section(parent: VBoxContainer, title_text: String) -> GridContainer:
	var title := Label.new()
	title.text = title_text
	title.add_theme_font_size_override("font_size", 21)
	title.add_theme_color_override("font_color", StarfallVisualTokens.color(&"cyan_soft"))
	parent.add_child(title)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 14)
	parent.add_child(grid)
	return grid

func _card(grid: GridContainer, title_text: String) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size.x = 318.0
	grid.add_child(panel)
	var content := VBoxContainer.new()
	panel.add_child(content)
	var title := Label.new()
	title.text = title_text
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", StarfallVisualTokens.color(&"text_primary"))
	content.add_child(title)
	return content

func _preview() -> Control:
	var preview := Control.new()
	preview.custom_minimum_size = CARD_SIZE
	preview.clip_contents = true
	return preview

func _add_ship_card(grid: GridContainer, title_text: String, state: int) -> void:
	var content := _card(grid, title_text)
	var preview := _preview()
	content.add_child(preview)
	var visual := StarfallShipVisual.new()
	visual.ship_type = StarfallShipVisual.ShipType.COURIER
	visual.visual_state = state
	visual.display_scale = 1.48
	visual.position = CARD_SIZE * 0.5 + Vector2(0.0, -5.0)
	preview.add_child(visual)

func _add_object_card(grid: GridContainer, title_text: String, object_kind: int, state: int, visual_variant: int, scale_value: float) -> void:
	var content := _card(grid, title_text)
	var preview := _preview()
	content.add_child(preview)
	var visual := StarfallGameObjectVisual.new()
	visual.kind = object_kind
	visual.visual_state = state
	visual.variant = visual_variant
	visual.display_scale = scale_value
	visual.position = CARD_SIZE * 0.5
	preview.add_child(visual)

func _add_effect_card(grid: GridContainer, title_text: String, effect_type: int) -> void:
	var content := _card(grid, title_text)
	var preview := _preview()
	content.add_child(preview)
	var visual := StarfallEffectVisual.new()
	visual.effect_type = effect_type
	visual.display_scale = 1.42
	visual.position = CARD_SIZE * 0.5
	preview.add_child(visual)
