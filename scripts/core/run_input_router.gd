class_name StarfallRunInputRouter
extends Node

signal lane_change_requested(direction: int)
signal restart_requested

@export var enable_mouse_input: bool = true
@export var enable_keyboard_input: bool = true

var _restart_mode: bool = false

func set_restart_mode(enabled: bool) -> void:
	_restart_mode = enabled

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch_event: InputEventScreenTouch = event as InputEventScreenTouch
		if touch_event.pressed:
			if _restart_mode:
				restart_requested.emit()
			else:
				_request_from_screen_x(touch_event.position.x)
			get_viewport().set_input_as_handled()
		return

	if enable_mouse_input and event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			if _restart_mode:
				restart_requested.emit()
			else:
				_request_from_screen_x(mouse_event.position.x)
			get_viewport().set_input_as_handled()
		return

	if enable_keyboard_input and event is InputEventKey:
		var key_event: InputEventKey = event as InputEventKey
		if not key_event.pressed or key_event.echo:
			return

		if _restart_mode:
			if _matches_restart_key(key_event):
				restart_requested.emit()
				get_viewport().set_input_as_handled()
			return

		if _matches_key(key_event, KEY_LEFT, KEY_A):
			lane_change_requested.emit(-1)
			get_viewport().set_input_as_handled()
		elif _matches_key(key_event, KEY_RIGHT, KEY_D):
			lane_change_requested.emit(1)
			get_viewport().set_input_as_handled()

func _request_from_screen_x(screen_x: float) -> void:
	var viewport_width: float = get_viewport().get_visible_rect().size.x
	if viewport_width <= 0.0:
		return
	lane_change_requested.emit(-1 if screen_x < viewport_width * 0.5 else 1)

func _matches_key(event: InputEventKey, primary_key: int, alternate_key: int) -> bool:
	return (
		event.keycode == primary_key
		or event.physical_keycode == primary_key
		or event.keycode == alternate_key
		or event.physical_keycode == alternate_key
	)

func _matches_restart_key(event: InputEventKey) -> bool:
	return (
		event.keycode == KEY_SPACE
		or event.physical_keycode == KEY_SPACE
		or event.keycode == KEY_ENTER
		or event.physical_keycode == KEY_ENTER
		or event.keycode == KEY_R
		or event.physical_keycode == KEY_R
	)
