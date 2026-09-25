extends Node2D

@onready var PlatformEditor = $UI/PlatformEditor
var SelectedPlatform = null
var MovedPlatforms: Array = []

# Platform selections
@onready var PlatformSelection = $"UI/Platform Selection"
@onready var Platforms = $PlatformSelections

# Rotation and timer labels
@onready var RotationInputBox = $UI/PlatformEditor/RotationInputBox
@onready var TimerInputBox = $UI/PlatformEditor/TimerInputBox

# Setting default Platform Time
@onready var PlatformTimer: float = 5.0

# Sound effects
@onready var ButtonClick = $ButtonClick

# Music
@onready var BackgroundMusic = $SwinGameBeat

@onready var LevelStarted = false
signal StartLevel


func _ready() -> void:
	PlatformEditor.visible = false
	
	# Connecting signal from platforms
	for platform in Platforms.get_children():
		if platform.has_signal("PlatformGrabbed"):
			platform.PlatformGrabbed.connect(_on_platform_grabbed)
	
	var ScreenSize = get_viewport_rect().size


func _input(event) -> void:
	if event.is_action_pressed("Space"):
		LevelStarted = true
		
		# Removing the platform selection
		PlatformSelection.visible = false
		PlatformEditor.visible = false
		
		# Hide and disable platforms that haven't been moved
		for platform in Platforms.get_children():
			if platform not in MovedPlatforms:
				platform.visible = false
				
				var collision = platform.get_node_or_null("CollisionShape2D")
				var collision_polygon = platform.get_node_or_null("CollisionPolygon2D")
				if collision:
					collision.disabled = true
				elif collision_polygon:
					collision_polygon.disabled = true
		
		# Emitting level start signal to drop the marble
		StartLevel.emit()
		
		# Start timers for all moved platforms
		for platform in MovedPlatforms:
			platform.start_timer()
	
	if event.is_action_pressed("Menu"):
		_on_menu_button_pressed()
	
	if event.is_action_pressed("Restart"):
		_on_restart_button_pressed()


func _on_menu_button_pressed() -> void:
	ButtonClick.play()
	await get_tree().create_timer(0.4).timeout
	
	# Change scene to menu scene
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_restart_button_pressed() -> void:
	ButtonClick.play()
	await get_tree().create_timer(0.4).timeout
	
	# Restart the level
	get_tree().reload_current_scene()


func _on_platform_grabbed(Platform):
	print("Platform grabbed: ", Platform.name)
	
	SelectedPlatform = Platform
	
	# Keeping track of platforms that have been grabbed
	if Platform not in MovedPlatforms:
		MovedPlatforms.append(Platform)
	
	match Platform.name:
		"Basic Platform":
			PlatformEditor.frame = 0
		"SquarePlatform":
			PlatformEditor.frame = 1
		"OneByThreePlatform":
			PlatformEditor.frame = 2
		"Curve":
			PlatformEditor.frame = 3
	
	# Update the rotation text box to match the selected platform
	RotationInputBox.text = str(int(round(fmod(Platform.rotation_degrees, 360.0))))
	# Update the timer text box to match the selected platform
	TimerInputBox.text = str(Platform.PlatformTimer)
	
	PlatformEditor.visible = true


func _on_exit_button_pressed() -> void:
	ButtonClick.play()
	# Closing the Platform editor
	PlatformEditor.visible = false
	print("Platform editor exited")


func _on_rotation_input_box_text_submitted(new_text: String) -> void:
	if SelectedPlatform == null:
		return
	
	var Rotation = float(new_text)
	SelectedPlatform.rotate_platform(Rotation)
	
	# Update input label
	RotationInputBox.text = str(int(round(SelectedPlatform.rotation_degrees)))


func _on_timer_input_box_text_submitted(new_text: String) -> void:
	if SelectedPlatform == null:
		return
	
	PlatformTimer = float(new_text)
	SelectedPlatform.set_timer(PlatformTimer)

	# Update input label
	TimerInputBox.text = str(PlatformTimer)
