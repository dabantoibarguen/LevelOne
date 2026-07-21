extends CharacterBody2D
@onready var target=$"../jose"

var bullet_path = preload("res://scenes/weapons/bullet_1.gd.tscn")

var speed = 400 
var HP = 2
var type = "enemy"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func take_damage(dmg):
	self.HP -= dmg
	if HP<= 0:
		queue_free()
		
	
#func shoot():
	#var mouse_pos = get_global_mouse_position()
	#
	#var bullet = bullet_path.instantiate()
	#var angle = get_angle_to(mouse_pos)
#
	#bullet.dir = angle
	#bullet.pos = $Bullet_Pos.global_position
	#bullet.rot = angle
	#
	#self.add_child(bullet)

#func _input(event):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#shoot()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
	#var direction = (target.position-position).normalized()
	#velocity = direction * speed

	#move_and_slide()
