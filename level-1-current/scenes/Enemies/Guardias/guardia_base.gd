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

# Guard specific
var speed = 30
var HP = 2
var sway

@export var attk_speed = 1.5
@export var attk_range = 30
@export var hear_range = 10

# --------------------------------------------------
# SETUP (READY, BASE FUNCTIONS)
# --------------------------------------------------
		
func _ready() -> void:
	attackDelay.wait_time = attk_speed
	navReset.wait_time = 2
	startingLocation = global_position
	nav.target_desired_distance = attk_range
	$HearingRange/Hear.shape = $HearingRange/Hear.shape.duplicate()
	$HearingRange/Hear.shape.radius = hear_range
		
func take_damage(dmg):
	self.HP -= dmg
	if HP<= 0:
		queue_free()
		
# --------------------------------------------------
# HEARING AND VISION (FOR NAVIGATION AND ATTACKS)
# --------------------------------------------------
		
# Remember to connect the enter signal for each inherited scene
func _on_hearing_range_body_entered(body: Node2D) -> void:
	# Detecting Jose by hearing
	if body.name == "jose":
		navigating = true
		target = body
		vision_ray = RayCast2D.new()
		nav.target_desired_distance = attk_range
		add_child(vision_ray)
		
# Remember to connect the exit signal for each inherited scene
func _on_hearing_range_body_exited(body: Node2D) -> void:
	# Jose leaving the hearing range
	if body.name == "jose":
		navigating = false
		remove_child(vision_ray)
		attackDelay.stop()
# --------------------------------------------------
# NAVIGATION (NEEDS SPEED AND ATTACK RANGE)
# --------------------------------------------------

func track(delta):
	var track_speed
	if(!nav.is_target_reached()):
		if vision_ray in self.get_children() and vision_ray.get_collider() is CharacterBody2D and vision_ray.get_collider().name == "jose":
			track_speed = speed*2
			if(global_position.distance_to(target.global_position) < attk_range*2):
				if(attackDelay.is_stopped()):
					attackDelay.start()
		else:
			track_speed = speed
		velocity = global_position.direction_to(nav.get_next_path_position())*track_speed*delta
		move_and_collide(velocity)
	else:
		if(global_position.distance_to(target.global_position) < attk_range+1):
			nav.target_position = global_position
		elif !vision_ray in self.get_children():
			attackDelay.stop()
			return
		else:
			#attacking = false
			nav.target_position = target.global_position
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
	if vision_ray != null:
		vision_ray.target_position = (target.global_position - global_position)
		var collider = vision_ray.get_collider()
		if collider is CharacterBody2D:
			if collider.category == "Enemy":
				vision_ray.add_exception(collider)
				vision_ray.force_raycast_update()
	if navigating:
		if(nav.is_navigation_finished() and nav.is_target_reached()):
			pass
			#if(!attacking):
				#attackDelay.start()
				#attacking = true
		else:
			nav.target_position = target.global_position
