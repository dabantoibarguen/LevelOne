extends Area2D
var pos:Vector2
var rot:float
var dir:float

var speed = 25

var offscreen_timer := 0.0
var offscreen = false
var dmg = 1

	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = pos
	global_rotation = rot
	body_entered.connect(_on_body_entered)
	$VisibleNotif.screen_exited.connect(_on_screen_exit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += (Vector2(speed, 0).rotated(dir))
	if offscreen:
		offscreen_timer += delta
		if offscreen_timer >= 1.0:
			queue_free()
		

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		if body != get_parent():
			var parent = get_parent()
			print(parent)
			body.take_damage(dmg)
			queue_free()
	else:
		visible = false
		queue_free()
		
	
func _on_screen_exit():
	offscreen = true
	
