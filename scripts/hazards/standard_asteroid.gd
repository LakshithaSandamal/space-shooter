class_name StarfallStandardAsteroid
extends Area2D

signal player_hit
signal near_miss(world_position: Vector2)

@export var fall_speed: float = 420.0
@export_range(0, 5, 1) var visual_variant: int = 0
@export var despawn_y: float = 1380.0

@onready var _visual: StarfallGameObjectVisual = %Visual
@onready var _near_miss_area: Area2D = %NearMissArea

var _active: bool = true
var _near_miss_candidate: bool = false
var _near_miss_awarded: bool = false
var _player_collided: bool = false
var _motion_scale: float = 1.0

func _ready() -> void:
	_visual.kind = StarfallGameObjectVisual.Kind.STANDARD_ASTEROID
	_visual.variant = visual_variant
	body_entered.connect(_on_body_entered)
	_near_miss_area.body_entered.connect(_on_near_miss_body_entered)
	_near_miss_area.body_exited.connect(_on_near_miss_body_exited)

func _physics_process(delta: float) -> void:
	if not _active:
		return
	position.y += fall_speed * _motion_scale * delta
	if position.y > despawn_y:
		queue_free()

func configure(speed: float, variant_index: int) -> void:
	fall_speed = maxf(speed, 0.0)
	visual_variant = posmod(variant_index, 6)
	if is_node_ready():
		_visual.variant = visual_variant

func set_motion_scale(value: float) -> void:
	_motion_scale = clampf(value, 0.25, 1.0)

func _on_body_entered(body: Node2D) -> void:
	if not _active:
		return
	if body is StarfallCourierController:
		_player_collided = true
		_near_miss_candidate = false
		_active = false
		set_deferred("monitoring", false)
		_near_miss_area.set_deferred("monitoring", false)
		player_hit.emit()
		queue_free()

func _on_near_miss_body_entered(body: Node2D) -> void:
	if not _active or _near_miss_awarded or _player_collided:
		return
	if body is StarfallCourierController:
		_near_miss_candidate = true

func _on_near_miss_body_exited(body: Node2D) -> void:
	if not _active or _near_miss_awarded or _player_collided:
		return
	if body is not StarfallCourierController or not _near_miss_candidate:
		return

	_near_miss_candidate = false
	_near_miss_awarded = true
	near_miss.emit(global_position)
