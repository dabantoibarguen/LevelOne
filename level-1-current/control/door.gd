extends StaticBody2D

@onready var collision = $CollisionShape2D


func closeDoor():
	collision.set_deferred("disabled", false)
	
func openDoor():
	collision.set_deferred("disabled", true)
