extends Guardia_Base

var bullet_count = 25

func _ready() -> void:
	super()

func _on_hearing_range_body_entered(body: Node2D) -> void:
	# Detecting Jose by hearing
	super(body)
	if body.name == "jose":
		$AttackDelay.wait_time = 0.5
		$AttackDelay.start()
		$AttackDelay.wait_time = 2.3
		
func _on_hearing_range_body_exited(body: Node2D) -> void:
	super(body)

func _on_attack_delay_timeout() -> void:
	if vision_ray.get_collider() is CharacterBody2D && vision_ray.get_collider().name == "jose":
		target_position = target.global_position
		for i in bullet_count:
			var bullet = bullet_path.instantiate()
			bullet.rot = get_angle_to(target_position)
			bullet.dir = (target_position - global_position).normalized()
			bullet.pos = global_position
			bullet.origin_category = category
			get_parent().add_child(bullet)
			$WeaponSound.pitch_scale = rng.randf_range(0.2, 0.7)
			$WeaponSound.play()
			await get_tree().create_timer(0.033).timeout
			target_vertical = (target.global_position- target_position)/15
				
			if vision_ray.get_collider() is CharacterBody2D && vision_ray.get_collider().name == "jose":
				target_position = target.global_position
			else:
				target_position += target_vertical
	
