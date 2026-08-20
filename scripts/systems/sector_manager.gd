class_name SectorManager
extends Node

signal sector_changed(sector_id: String)

const DEFAULT_SECTOR: String = "courier_corridor"

var current_sector: String = DEFAULT_SECTOR
var sector_progress: float = 0.0

func set_sector(sector_id: String) -> void:
	if sector_id == current_sector:
		return
	current_sector = sector_id
	sector_progress = 0.0
	sector_changed.emit(current_sector)

func add_progress(amount: float) -> void:
	sector_progress = maxf(0.0, sector_progress + amount)

func get_sector() -> String:
	return current_sector
