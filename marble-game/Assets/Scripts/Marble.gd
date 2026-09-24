extends Node2D

@onready var LevelManager = $".."
@onready var RigidBody: RigidBody2D = $RigidBody2D


func _ready() -> void:
	LevelManager.StartLevel.connect(_on_level_started)
	
	RigidBody.freeze = true


func _on_level_started():
	RigidBody.freeze = false
