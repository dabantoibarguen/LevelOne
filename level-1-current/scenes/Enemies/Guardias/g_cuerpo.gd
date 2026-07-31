extends Guardia_Base

func _ready() -> void:
	attk_speed = 0.5
	attk_range = 50
	super()

func _on_hearing_range_body_entered(body: Node2D) -> void:
	# Detecting Jose by hearing
	super(body)
		
func _on_hearing_range_body_exited(body: Node2D) -> void:
	super(body)
	
func _physics_process(delta: float) -> void:
	super(delta)
	track(delta)


func _on_navigation_agent_2d_navigation_finished() -> void:
	if(global_position.distance_to(startingLocation) < 2):
		nav.target_position = global_position
	else:
		navReset.start()

func _on_navigation_agent_2d_target_reached() -> void:
	pass

func _on_attack_delay_timeout() -> void:
		print("Swish")
		if vision_ray.get_collider() is CharacterBody2D && vision_ray.get_collider().name == "jose":
			target_position = target.global_position
			var swing = swing_path.instantiate()
			swing.rot = get_angle_to(target.global_position)
			swing.dir = (target_position - global_position).normalized()
			swing.pos = global_position
			swing.origin_category = category
			get_parent().add_child(swing)
					
			$WeaponSound.pitch_scale = rng.randf_range(0.4, 1.1)
			$WeaponSound.play()
		else:
			pass
		
		
		await get_tree().create_timer(0.08).timeout
