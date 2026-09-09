extends Area2D

var pos:Vector2
var rot:float
var dir:Vector2
var dmg = 1

var origin_category:String

@onready var speed = 1200
@onready var offscreen_timer := 0.0
@onready var offscreen = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = pos
	global_rotation = rot
	body_entered.connect(_on_body_entered)
	$VisibleNotif.screen_exited.connect(_on_screen_exit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += dir * speed * delta
	if offscreen:
		offscreen_timer += delta
		if offscreen_timer >= 0.5:
			queue_free()
	else:
		offscreen_timer = 0
		

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		if body.category != origin_category:
			#var parent = get_parent()
			body.take_damage(dmg)
			queue_free()
	else:
		visible = false
		queue_free()
		
	
func _on_screen_exit():
	offscreen = true
	
func _on_visible_notif_screen_entered() -> void:
	offscreen = false
