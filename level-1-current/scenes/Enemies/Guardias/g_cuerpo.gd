extends Guardia_Base

func _ready() -> void:
	super()

func _on_hearing_range_body_entered(body: Node2D) -> void:
	# Detecting Jose by hearing
	super(body)
	if body.name == "jose":
		nav.target_desired_distance = 50
		
func _on_hearing_range_body_exited(body: Node2D) -> void:
	super(body)

func _on_attack_delay_timeout() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	super(delta)
	if(!nav.is_target_reached()):
		if vision_ray in self.get_children() and vision_ray.get_collider() is CharacterBody2D and vision_ray.get_collider().name == "jose":
			speed = 120
		else:
			speed = 50
		velocity = global_position.direction_to(nav.get_next_path_position())*speed*delta
		move_and_collide(velocity)
	else:
		if(global_position.distance_to(target.global_position) < 51):
			nav.target_position = global_position
		elif !vision_ray in self.get_children():
			return
		else:
			nav.target_position = target.global_position
			navReset.stop()


func _on_navigation_agent_2d_navigation_finished() -> void:
	if(global_position.distance_to(startingLocation) < 2):
		nav.target_position = global_position
	else:
		navReset.start()

func _on_navigation_agent_2d_target_reached() -> void:
	pass
	
func _on_nav_reset_timeout() -> void:
	nav.target_desired_distance = 1
	navReset.stop()
	nav.target_position = startingLocation
