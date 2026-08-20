class_name StarfallPowerUpPickup
extends Area2D

signal collected(power_up_type: int)

@export_enum("Shield", "Time Warp", "Overcharge") var power_up_type: int = StarfallPowerUpSystem.PowerUpType.SHIELD
@export var fall_speed: float = 420.0
@export var despawn_y: float = 1380.0

@onready var _visual: StarfallGameObjectVisual = %Visual

var _active: bool = true
var _motion_scale: float = 1.0

func _ready() -> void:
	_apply_visual_kind()
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if not _active:
		return
	position.y += fall_speed * _motion_scale * delta
	if position.y > despawn_y:
		queue_free()

func configure(speed: float, pickup_type: int) -> void:
	fall_speed = maxf(speed, 0.0)
	power_up_type = clampi(pickup_type, StarfallPowerUpSystem.PowerUpType.SHIELD, StarfallPowerUpSystem.PowerUpType.OVERCHARGE)
	if is_node_ready():
		_apply_visual_kind()

func set_motion_scale(value: float) -> void:
	_motion_scale = clampf(value, 0.25, 1.0)

func _apply_visual_kind() -> void:
	match power_up_type:
		StarfallPowerUpSystem.PowerUpType.SHIELD:
			_visual.kind = StarfallGameObjectVisual.Kind.SHIELD
		StarfallPowerUpSystem.PowerUpType.TIME_WARP:
			_visual.kind = StarfallGameObjectVisual.Kind.TIME_WARP
		StarfallPowerUpSystem.PowerUpType.OVERCHARGE:
			_visual.kind = StarfallGameObjectVisual.Kind.OVERCHARGE
	_visual.visual_state = StarfallGameObjectVisual.VisualState.ACTIVE
	_visual.queue_redraw()

func _on_body_entered(body: Node2D) -> void:
	if not _active:
		return
	if body is StarfallCourierController:
		_active = false
		set_deferred("monitoring", false)
		collected.emit(power_up_type)
		queue_free()
