extends CharacterBody2D

var is_grabbed: bool = false

# Signal to send to level manager when platform is grabbed
signal PlatformGrabbed


func _process(delta: float) -> void:
	if is_grabbed:
		global_position = get_global_mouse_position()


func _input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_grabbed = true
				print("Grabbed: ", name)
				PlatformGrabbed.emit(name)
			else:
				is_grabbed = false
