extends Guardia_Base

var bullet_count = 3
var bullet_arc = 30

func _ready() -> void:
	speed = 40
	attk_range = 100
	hear_range = 24
	super()

func _on_hearing_range_body_entered(body: Node2D) -> void:
	# Detecting Jose by hearing
	super(body)
	if body.name == "jose":
		attackDelay.wait_time = attk_speed/3
		attackDelay.start()
		attackDelay.wait_time = attk_speed

func _on_hearing_range_body_exited(body: Node2D) -> void:
	super(body)

func _on_attack_delay_timeout() -> void:
	if vision_ray.get_collider() is CharacterBody2D && vision_ray.get_collider().name == "jose":
		var arc = deg_to_rad(4.0)
		for deg in [-arc, 0, arc]: #5 degree arc
			var bullet = bullet_path.instantiate()
			var rand_sway = Vector2(rng.randf_range(-sway, sway)*4, rng.randf_range(-sway, sway)*4)
			target_position = (target.global_position+rand_sway)
			bullet.rot = get_angle_to(target_position)
			bullet.pos = global_position
			bullet.dir = ((target_position - global_position).normalized()).rotated(deg)
			bullet.origin_category = category
			get_parent().add_child(bullet)
			$WeaponSound.pitch_scale = rng.randf_range(0.8, 1.8)
			$WeaponSound.play()

	
func _physics_process(delta: float) -> void:
	super(delta)
	track(delta)
