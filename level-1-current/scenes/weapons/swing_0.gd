extends Area2D

var pos:Vector2
var rot:float
var dir:Vector2
var dmg = 1

var origin_category:String

@onready var speed = 600

@onready var offscreen_timer := 0.0
@onready var offscreen = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = pos+dir*5
	global_rotation = rot
	body_entered.connect(_on_body_entered)
	#$VisibleNotif.screen_exited.connect(_on_screen_exit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
		

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		if body.category != origin_category:
			#var parent = get_parent()
			body.take_damage(dmg)
			queue_free()
	else:
		#visible = false
		queue_free()
		
