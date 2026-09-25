extends CharacterBody2D

var is_grabbed: bool = false

# Platform timer
@onready var PlatformTimerBox = $"../../UI/PlatformEditor/TimerInputBox"
var PlatformTimer: float = 5.0

# Signal to send to level manager when platform is grabbed
signal PlatformGrabbed

# Tracking mouse offset to platform centre
var grab_offset: Vector2

# Sound effects
@onready var PlatformGrab = $"../../PlatformGrab"
@onready var PlatformDrop = $"../../PlatformDrop"


func _process(delta: float) -> void:
	if is_grabbed:
		global_position = get_global_mouse_position() + grab_offset


func _input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			PlatformGrab.play()
			
			# Making platform stay offset to mouse position instead of platform snapping to centre
			grab_offset = global_position - get_global_mouse_position()
			
			is_grabbed = true
			PlatformGrabbed.emit(self)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if is_grabbed:
				PlatformDrop.play()
				is_grabbed = false


func rotate_platform(Rotation) -> void:
	rotation_degrees = Rotation


func set_timer(Timer) -> void:
	PlatformTimer = Timer


func start_timer() -> void:
	await get_tree().create_timer(PlatformTimer).timeout
	
	# Disable platform collisions
	var collision = get_node_or_null("CollisionShape2D")
	var collision_polygon = get_node_or_null("CollisionPolygon2D")
	
	if collision:
		collision.disabled = true
	elif collision_polygon:
		collision_polygon.disabled = true
	
	# Hide the platform
	visible = false
