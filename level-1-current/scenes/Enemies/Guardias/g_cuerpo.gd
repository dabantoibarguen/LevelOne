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
	pass
	
func _physics_process(delta: float) -> void:
	super(delta)
	if(!nav.is_target_reached()):
		position += global_position.direction_to(nav.get_next_path_position())*speed*delta


func _on_navigation_agent_2d_navigation_finished() -> void:
	print("GG") # Replace with function body.


func _on_navigation_agent_2d_target_reached() -> void:
	print("AJA") # Replace with function body.
