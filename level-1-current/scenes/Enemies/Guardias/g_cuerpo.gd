extends Guardia_Base

@onready var swing = $swing0

func _ready() -> void:
	HP = 3
	speed = 75
	attk_speed = 0.8
	hear_range = 15
	super()

func _on_hearing_range_body_entered(body: Node2D) -> void:
	# Detecting Jose by hearing
	super(body)
	if body.name == "jose":
		sprite_shader.set_shader_parameter("highlight", "true")
		$AnimatedSprite2D.queue_redraw()
		
func _on_hearing_range_body_exited(body: Node2D) -> void:
	super(body)
	if body.name == "jose":
		sprite_shader.set_shader_parameter("highlight", "false")
		$AnimatedSprite2D.queue_redraw()

func _on_navigation_agent_2d_navigation_finished() -> void:
	if(global_position.distance_to(startingLocation) < 2):
		nav.target_position = global_position
	else:
		navReset.start()

func _on_navigation_agent_2d_target_reached() -> void:
	pass

func _on_attack_delay_timeout() -> void:
	if vision_ray.get_collider() is CharacterBody2D && vision_ray.get_collider().name == "jose":
		target_position = target.global_position
		swing.play_anim()
		swing.dir = (target_position - global_position).normalized()
		swing.rotation = get_angle_to(target_position)
		
		$WeaponSound.pitch_scale = rng.randf_range(3.9, 4.2)
		$WeaponSound.play()
			
func _physics_process(delta: float) -> void:
	super(delta)
	if navigating:
		track(delta)
