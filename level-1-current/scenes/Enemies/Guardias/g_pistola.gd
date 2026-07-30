extends Guardia_Base

func _ready() -> void:
	super()

func _on_hearing_range_body_entered(body: Node2D) -> void:
	# Detecting Jose by hearing
	super(body)
	if body.name == "jose":
		$AttackDelay.wait_time = 0.5
		$AttackDelay.start()
		$AttackDelay.wait_time = 1.5
		
func _on_hearing_range_body_exited(body: Node2D) -> void:
	super(body)

func _on_attack_delay_timeout() -> void:
	if vision_ray.get_collider() is CharacterBody2D && vision_ray.get_collider().name == "jose":
		for i in 3:
			var bullet = bullet_path.instantiate()
			if vision_ray.get_collider() is CharacterBody2D && vision_ray.get_collider().name == "jose":
				target_position = target.global_position
			else:
				pass
			bullet.rot = get_angle_to(target.global_position)
			bullet.dir = (target.global_position - global_position).normalized()
			bullet.pos = global_position
			bullet.origin_category = category
			get_parent().add_child(bullet)
					
			$WeaponSound.pitch_scale = rng.randf_range(0.4, 1.1)
			$WeaponSound.play()
			
			await get_tree().create_timer(0.08).timeout
	
