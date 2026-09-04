extends Area2D

var enemies = []
var puertas = []

var category = "room"

@onready var jose = %jose

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "jose":
		for child in get_children():
			if child is CharacterBody2D and child.category == "Enemy":
				enemies.append(child)
				child.target = jose
			if child.scene_file_path == "res://control/door.tscn":
				puertas.append(child)
				child.closeDoor()
			
func checkEnemies(enemy):
	enemies.erase(enemy)
	if enemies == []:
		for door in puertas:
			door.openDoor()

#func _on_body_exited(body: Node2D) -> void:
	#pass # Replace with function body.
