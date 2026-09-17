extends Node2D

@onready var PlatformEditor = $PlatformEditor

func _ready() -> void:
	PlatformEditor.visible = true

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
