extends StaticBody2D
class_name Door

@onready var collision = $CollisionShape2D

func closeDoor():
	visible = true
	collision.set_deferred("disabled", false)
	
func openDoor():
	visible = false
	collision.set_deferred("disabled", true)
