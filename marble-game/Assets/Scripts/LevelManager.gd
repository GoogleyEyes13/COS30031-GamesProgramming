extends Node2D

@onready var PlatformEditor = $UI/PlatformEditor
var SelectedPlatform = null

# Rotation and timer labels
@onready var RotationInputBox = $UI/PlatformEditor/RotationInputBox
@onready var TimerInputBox = $UI/PlatformEditor/TimerInputBox

# Setting default Platform Time
@onready var PlatformTimer: float = 5.0

@onready var LevelStarted = false
signal StartLevel


func _ready() -> void:
	PlatformEditor.visible = false
	
	# Connecting signal from platforms
	for child in get_children():
		if child.has_signal("PlatformGrabbed"):
			child.PlatformGrabbed.connect(_on_platform_grabbed)

	var ScreenSize = get_viewport_rect().size


func _input(event) -> void:
	if event.is_action_pressed("Space"):
		LevelStarted = true
		StartLevel.emit()
	
	if event.is_action_pressed("Menu"):
		_on_menu_button_pressed()
	
	if event.is_action_pressed("Restart"):
		_on_restart_button_pressed()


func _on_menu_button_pressed() -> void:
	# Change scene to menu scene
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_restart_button_pressed() -> void:
	# Restart the level
	get_tree().reload_current_scene()


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
	
	# Update input label
	RotationInputBox.text = str(int(fmod(SelectedPlatform.rotation_degrees, 360.0)))


func _on_timer_input_box_text_submitted(new_text: String) -> void:
	if SelectedPlatform == null:
		return
	
	var PlatformTimer = float(new_text)

	# Update input label
	TimerInputBox.text = str(PlatformTimer)
