extends CharacterBody2D

var is_grabbed: bool = false

# Signal to send to level manager when platform is grabbed
signal PlatformGrabbed


func _process(delta: float) -> void:
	if is_grabbed:
		global_position = get_global_mouse_position()


func _input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			is_grabbed = true
			PlatformGrabbed.emit(self)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if is_grabbed:
				is_grabbed = false


func rotate_platform(Rotation) -> void:
	rotation_degrees = Rotation
