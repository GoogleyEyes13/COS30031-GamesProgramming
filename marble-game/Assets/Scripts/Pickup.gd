extends Sprite2D

@export var PickupType: String

signal ColourPickedUp

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Checking that its the marble (Not a platform)
	if body is RigidBody2D:
		print(body, " picked up ", PickupType)
		ColourPickedUp.emit(PickupType)
	
		visible = false
