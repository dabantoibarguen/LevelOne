extends Area2D

var parent:CharacterBody2D
var dir:Vector2
var dmg = 1

var origin_category:String


func play_anim():
	visible = true
	$AnimatedSprite2D.play("default")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	visible = false
	#$VisibleNotif.screen_exited.connect(_on_screen_exit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if visible:
		self.position = get_parent().global_position + dir * 30
	else:
		self.position = parent.global_position


func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		if visible and body.category != "Enemy":
			#var parent = get_parent()
			body.take_damage(dmg)
		


func _on_animated_sprite_2d_animation_finished() -> void:
	visible = false # Replace with function body.
