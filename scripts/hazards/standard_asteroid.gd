class_name StarfallStandardAsteroid
extends Area2D

signal player_hit

@export var fall_speed: float = 420.0
@export_range(0, 5, 1) var visual_variant: int = 0
@export var despawn_y: float = 1380.0

@onready var _visual: StarfallGameObjectVisual = %Visual

var _active: bool = true

func _ready() -> void:
	_visual.kind = StarfallGameObjectVisual.Kind.STANDARD_ASTEROID
	_visual.variant = visual_variant
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if not _active:
		return
	position.y += fall_speed * delta
	if position.y > despawn_y:
		queue_free()

func configure(speed: float, variant_index: int) -> void:
	fall_speed = maxf(speed, 0.0)
	visual_variant = posmod(variant_index, 6)
	if is_node_ready():
		_visual.variant = visual_variant

func _on_body_entered(body: Node2D) -> void:
	if not _active:
		return
	if body is StarfallCourierController:
		_active = false
		monitoring = false
		player_hit.emit()
