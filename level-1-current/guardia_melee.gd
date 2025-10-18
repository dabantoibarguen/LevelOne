extends CharacterBody2D
@onready var target=$"../jose"

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
	#var direction = (target.position-position).normalized()
	#velocity = direction * speed

	#move_and_slide()
