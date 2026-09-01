extends Area2D

var enemies = []
var puertas = []

var category = "room"

func _ready() -> void:
	for child in get_children():
		if child is CharacterBody2D and child.category == "Enemy":
			enemies.append(child)
		if child.scene_file_path == "res://control/door.tscn":
			puertas.append(child)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "jose" and enemies != []:
		for enemy in enemies:
			enemy.target = body
		for door in puertas:
			door.closeDoor()
			
func checkEnemies(enemy):
	enemies.erase(enemy)
	if enemies == []:
		print("ALL DEAD")
		for door in puertas:
			door.openDoor()

func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
