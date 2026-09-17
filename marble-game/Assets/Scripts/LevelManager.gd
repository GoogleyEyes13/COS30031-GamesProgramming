extends Node2D

@onready var PlatformEditor = $PlatformEditor

# Setting grid size
var GridColumns: int = 24
var GridSize: float


func _ready() -> void:
	PlatformEditor.visible = true

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


func _on_exit_button_pressed() -> void:
	# Closing the Platform editor
	PlatformEditor.visible = false
	print("Platform editor exited")
