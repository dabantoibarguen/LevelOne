extends Guardia_Base

var bullet_count = 25

func _ready() -> void:
	attk_range = 150
	hear_range = 32
	super()

func _on_hearing_range_body_entered(body: Node2D) -> void:
	# Detecting Jose by hearing
	super(body)
	if body.name == "jose":
		attackDelay.wait_time = 0.5
		attackDelay.start()
		attackDelay.wait_time = 2.3
		sway = 0.0166666667
		
func _on_hearing_range_body_exited(body: Node2D) -> void:
	super(body)

func _on_attack_delay_timeout() -> void:
	if vision_ray.get_collider() is CharacterBody2D && vision_ray.get_collider().name == "jose":
		target_position = target.global_position
		for i in bullet_count:
			print(sway)
			var bullet = bullet_path.instantiate()
			var rand_sway = rng.randf_range(1-sway, 1+sway)
			bullet.rot = get_angle_to(target_position)
			bullet.pos = global_position
			bullet.origin_category = category
			bullet.dir = (target_position*rand_sway - global_position).normalized()
			get_parent().add_child(bullet)
			
			$WeaponSound.pitch_scale = rng.randf_range(0.2, 0.7)
			$WeaponSound.play()
			
			await get_tree().create_timer(0.033).timeout
			#target_vertical = (target.global_position- target_position)/20
			if vision_ray in self.get_children() and vision_ray.get_collider().name == "jose":
				target_position = target.global_position
				sway = 0.0166666667
			else:
				#target_position += target_vertical
				sway = 0.05
	
	
func _physics_process(delta: float) -> void:
	super(delta)
	track(delta)
