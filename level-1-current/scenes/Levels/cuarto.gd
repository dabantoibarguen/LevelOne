extends Area2D

var enemies = []
var puertas = []

var category = "room"
var completed = false

@onready var jose = %jose
@onready var cam = %Camera
@onready var roomLim = $RoomLimits


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
		cam.set_zone_limits(roomLim.global_transform * roomLim.shape.get_rect())
		while !completed:
			await get_tree().create_timer(2).timeout
			enemies = enemies.filter(func(item): return is_instance_valid(item))	
			checkEnemies()
			
func checkEnemies(enemy = ""):
	enemies.erase(enemy)
	if enemies == []:
		print(self)
		print(puertas)
		cam.clear_zone_limits()
		for door in puertas:
			door.openDoor()
		completed = true
		queue_free()

#func _on_body_exited(body: Node2D) -> void:
	#pass # Replace with function body.
