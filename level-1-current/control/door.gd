extends StaticBody2D
class_name Door

@onready var collision = $CollisionShape2D


func closeDoor():
	collision.set_deferred("disabled", false)
	
func openDoor():
	collision.set_deferred("disabled", true)
