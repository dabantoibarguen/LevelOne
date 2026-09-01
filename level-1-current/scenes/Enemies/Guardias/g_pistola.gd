extends Guardia_Base

func _ready() -> void:
	attk_range = 200
	hear_range = 20
	super()

func _on_hearing_range_body_entered(body: Node2D) -> void:
	# Detecting Jose by hearing
	super(body)
		
func _on_hearing_range_body_exited(body: Node2D) -> void:
	super(body)

func _on_attack_delay_timeout() -> void:
	if vision_ray.get_collider() is CharacterBody2D && vision_ray.get_collider().name == "jose":
		for i in 3:
			var bullet = bullet_path.instantiate()
			var rand_sway = Vector2(rng.randf_range(-sway, sway)*4, rng.randf_range(-sway, sway)*4)
			if vision_ray.get_collider() is CharacterBody2D && vision_ray.get_collider().name == "jose":
				target_position = target.global_position
			else:
				pass
			bullet.rot = get_angle_to(target.global_position)
			bullet.dir = (target_position+rand_sway - global_position).normalized()
			bullet.pos = global_position
			bullet.origin_category = category
			get_parent().add_child(bullet)
					
			$WeaponSound.pitch_scale = rng.randf_range(0.4, 1.1)
			$WeaponSound.play()
			
			await get_tree().create_timer(0.08).timeout
	
func _physics_process(delta: float) -> void:
	super(delta)
	track(delta)
