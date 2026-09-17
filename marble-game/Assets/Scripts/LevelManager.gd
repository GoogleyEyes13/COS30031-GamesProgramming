extends Node2D

@onready var PlatformEditor = $PlatformEditor
var SelectedPlatform = null

# Rotation and timer labels
@onready var RotationInputBox = $PlatformEditor/RotationInputBox
@onready var TimerInputBox = $PlatformEditor/TimerInputBox

# Setting grid size
var GridColumns: int = 26
var GridSize: float


func _ready() -> void:
	PlatformEditor.visible = false
	
	# Connecting signal from platforms
	for child in get_children():
		if child.has_signal("PlatformGrabbed"):
			child.PlatformGrabbed.connect(_on_platform_grabbed)

	var ScreenSize = get_viewport_rect().size
	GridSize = ScreenSize.x / GridColumns

	queue_redraw()


func _draw() -> void:
	var ScreenSize = get_viewport_rect().size

	# Vertical lines
	for x in range(GridColumns + 1):
		var x_position = x * GridSize

		draw_line(Vector2(x_position, 0), Vector2(x_position, ScreenSize.y), Color(0.337, 0.173, 0.0, 0.667), 1.0)

	# Horizontal lines
	var rows = int(ceil(ScreenSize.y / GridSize))

	for y in range(rows + 1):
		var y_position = y * GridSize

		draw_line(Vector2(0, y_position), Vector2(ScreenSize.x, y_position), Color(0.337, 0.173, 0.0, 0.667), 1.0)


func _on_menu_button_pressed() -> void:
	# This is where the options menu / pause menu will go
	print("Menu button pressed")


func _on_restart_button_pressed() -> void:
	# This is where the code to restart the level will go
	print("Restart button pressed")


func _on_platform_grabbed(Platform):
	print("Platform grabbed: ", Platform.name)
	
	SelectedPlatform = Platform
	
	match Platform.name:
		"Basic Platform":
			PlatformEditor.frame = 0
		"Basic Platform2":
			PlatformEditor.frame = 0
		"Basic Platform3":
			PlatformEditor.frame = 0
		"SquarePlatform":
			PlatformEditor.frame = 1
		"OneByThreePlatform":
			PlatformEditor.frame = 2
	
	# Update the rotation text box to match the selected platform
	RotationInputBox.text = str(int(fmod(Platform.rotation_degrees, 360.0)))
	
	PlatformEditor.visible = true


func _on_exit_button_pressed() -> void:
	# Closing the Platform editor
	PlatformEditor.visible = false
	print("Platform editor exited")


func _on_rotation_input_box_text_submitted(new_text: String) -> void:
	if SelectedPlatform == null:
		return
	
	var Rotation = float(new_text)
	SelectedPlatform.rotate_platform(Rotation)
	
	# Update input labels
	RotationInputBox.text = str(int(fmod(SelectedPlatform.rotation_degrees, 360.0)))
	
