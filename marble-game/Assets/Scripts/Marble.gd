extends Node2D

@onready var LevelManager = $".."
@onready var RigidBody: RigidBody2D = $RigidBody2D
@onready var MarbleFrame: AnimatedSprite2D = $RigidBody2D/Marble

# Pickups
@onready var Pickups = $"../Pickups"
var BeigeUnlocked = false
var GreenUnlocked = false
var OrangeUnlocked = false


func _ready() -> void:
	LevelManager.StartLevel.connect(_on_level_started)

	# Connecting signal from pickups
	for pickup in Pickups.get_children():
		if pickup.has_signal("ColourPickedUp"):
			pickup.ColourPickedUp.connect(_on_colour_picked_up)
	
	RigidBody.freeze = true


func _on_level_started():
	RigidBody.freeze = false


func _on_colour_picked_up(PickedType):
	print(PickedType, " received")
	
	# Set the colour as unlocked
	match PickedType:
		"Beige":
			BeigeUnlocked = true
		"Green":
			GreenUnlocked = true
		"Orange":
			OrangeUnlocked = true
	
	# Determine marble frame based on colour combination
	match [BeigeUnlocked, GreenUnlocked, OrangeUnlocked]:
		[false, false, false]:
			MarbleFrame.frame = 0
		[true, false, false]:
			MarbleFrame.frame = 1
		[false, true, false]:
			MarbleFrame.frame = 2
		[false, false, true]:
			MarbleFrame.frame = 3
		[true, true, false]:
			MarbleFrame.frame = 4
		[true, false, true]:
			MarbleFrame.frame = 5
		[false, true, true]:
			MarbleFrame.frame = 6
		[true, true, true]:
			MarbleFrame.frame = 7
