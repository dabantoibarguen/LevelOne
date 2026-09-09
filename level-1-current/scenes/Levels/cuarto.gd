extends Area2D

var enemies = []
var puertas = []

var category = "room"
var completed = false

@onready var jose = %jose

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if completed:
		return
	if body.name == "jose":
		for child in get_children():
			if child is Guardia:
				enemies.append(child)
				child.target = jose
			if child is Door:
				puertas.append(child)
				child.closeDoor()
			
func checkEnemies(enemy):
	enemies.erase(enemy)
	if enemies == []:
		for door in puertas:
			door.openDoor()
		completed = true
	else:
		print(enemies)
		enemies = enemies.filter(func(item): return is_instance_valid(item))
				

#func _on_body_exited(body: Node2D) -> void:
	#pass # Replace with function body.
