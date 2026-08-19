extends SceneTree

const RESOURCES: PackedStringArray = [
	"res://scenes/main.tscn",
	"res://scenes/player/courier.tscn",
	"res://scenes/ui/run_hud.tscn",
	"res://dev/visual_lab/visual_lab.tscn",
	"res://dev/visual_lab/pass1_review.tscn",
	"res://dev/visual_lab/pages/backgrounds.tscn",
	"res://dev/visual_lab/pages/ships.tscn",
	"res://dev/visual_lab/pages/collectibles_powerups.tscn",
	"res://dev/visual_lab/pages/hazards_routes.tscn",
	"res://dev/visual_lab/pages/effects.tscn",
	"res://dev/visual_lab/pages/ui.tscn",
	"res://shaders/visual/space_background.gdshader",
	"res://shaders/visual/neon_energy.gdshader",
	"res://shaders/visual/time_warp.gdshader",
	"res://shaders/visual/sector_grade.gdshader",
	"res://shaders/visual/ui_panel.gdshader",
]

func _initialize() -> void:
	var failed := false
	for resource_path in RESOURCES:
		var resource := ResourceLoader.load(resource_path)
		if resource == null:
			push_error("Failed to load required resource: %s" % resource_path)
			failed = true
		else:
			print("Validated: %s" % resource_path)
	quit(1 if failed else 0)
