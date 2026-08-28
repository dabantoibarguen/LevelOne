class_name Guardia_Base
extends CharacterBody2D

# Currently Unused
#@onready var hearing_area = $HearingRange

# For all guards
var bullet_path = preload("res://scenes/Weapons/bullet_0.tscn")

@onready var nav = $NavigationAgent2D
@onready var attackDelay = $AttackDelay
@onready var navReset = $NavReset

var navigating = false
#var attacking = false

var vision_ray
var target
var target_position
#var target_vertical = 0
var startingLocation

var rng = RandomNumberGenerator.new()
var category = "Enemy"
var rand_targ = Vector2(0, 0)

# Guard specific
var speed = 40
var HP = 2
var sway

@export var attk_speed = 1.5
@export var attk_range = 30
@export var hear_range = 10

# --------------------------------------------------
# SETUP (READY, BASE FUNCTIONS)
# --------------------------------------------------
		
func _ready() -> void:
	vision_ray = RayCast2D.new()
	attackDelay.wait_time = attk_speed
	navReset.wait_time = 2
	startingLocation = global_position
	nav.target_desired_distance = attk_range
	$HearingRange/Hear.shape = $HearingRange/Hear.shape.duplicate()
	$HearingRange/Hear.shape.radius = hear_range
	add_child(vision_ray)
		
func take_damage(dmg):
	self.HP -= dmg
	if HP<= 0:
		queue_free()
		get_parent().checkEnemies(self)
		
# --------------------------------------------------
# HEARING AND VISION (FOR NAVIGATION AND ATTACKS)
# --------------------------------------------------
		
# Remember to connect the enter signal for each inherited scene
func _on_hearing_range_body_entered(body: Node2D) -> void:
	# Detecting Jose by hearing
	pass
		
			
		
# Remember to connect the exit signal for each inherited scene
func _on_hearing_range_body_exited(body: Node2D) -> void:
	# Jose leaving the hearing range
	if body.name == "jose":
		#navigating = false
		#remove_child(vision_ray) # Agregar timer
		attackDelay.stop()
# --------------------------------------------------
# NAVIGATION (NEEDS SPEED AND ATTACK RANGE)
# --------------------------------------------------

func track(delta):
	var track_speed
	if(!nav.is_target_reached()):
		if (vision_ray in self.get_children()) and (vision_ray.get_collider() is CharacterBody2D) and (vision_ray.get_collider().name == "jose"):
			nav.target_desired_distance = attk_range
			track_speed = speed*2
			if(global_position.distance_to(target.global_position) < attk_range*2):
				if(attackDelay.is_stopped()):
					attackDelay.start()
		else:
			nav.target_desired_distance = 1
			track_speed = speed
		velocity = global_position.direction_to(nav.get_next_path_position())*track_speed*delta
		move_and_collide(velocity)
	else:
		if !vision_ray in self.get_children():
			attackDelay.stop()
			return
		elif (vision_ray.get_collider().name == "jose") and (global_position.distance_to(target.global_position) < attk_range+1):
			nav.target_position = global_position
		else:
			#attacking = false
			nav.target_desired_distance = 1
			nav.target_position = target.global_position + rand_targ
			navReset.stop()


func _on_navigation_agent_2d_target_reached() -> void:
	pass

func _on_navigation_agent_2d_navigation_finished() -> void:
	if(global_position.distance_to(startingLocation) < 2):
		nav.target_position = global_position
	else:
		navReset.start()

func _on_nav_reset_timeout() -> void:
	nav.target_desired_distance = 1
	navReset.stop()
	nav.target_position = startingLocation


# --------------------------------------------------
# PHYSICS PROCESS (CONTINUOUS CHECK)
# --------------------------------------------------

# Remember to connect the timeout signal for each inherited scene
func _physics_process(delta: float) -> void:
	# Update vision ray
	if vision_ray != null and target != null:
		vision_ray.target_position = (target.global_position - global_position)
		var collider = vision_ray.get_collider()
		if collider is CharacterBody2D:
			if collider.category == "Enemy":
				vision_ray.add_exception(collider)
				vision_ray.force_raycast_update()
			elif !navigating and collider.category == "Player":
				navigating = true
				while true:
					rand_targ = rng.randf_range(0.1, 0.25) * rng.randf_range(100, 400) * [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN].pick_random()
					await get_tree().create_timer(3).timeout
					if !navigating:
						break
	# Move the enemy
	if navigating:
		nav.target_position = target.global_position + rand_targ
