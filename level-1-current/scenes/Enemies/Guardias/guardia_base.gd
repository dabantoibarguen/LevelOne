class_name Guardia_Base
extends CharacterBody2D

# Currently Unused
#@onready var hearing_area = $HearingRange

# For all guards
var bullet_path = preload("res://scenes/Weapons/bullet_0.tscn")

@onready var nav = $NavigationAgent2D
@onready var vision_ray = $"Vision Ray"
@onready var attackDelay = $AttackDelay
@onready var sprite_shader = $AnimatedSprite2D.material as ShaderMaterial

var navigating = false
var hovered = false
var highlighted = false
#var attacking = false

var target
var target_position
#var target_vertical = 0
var startingLocation
var weapon

var rng = RandomNumberGenerator.new()
var category = "Enemy"
var rand_targ = Vector2(0, 0)

# Guard specific
var speed = 40
var HP = 2
var sway = 1 # default sway

@export var attk_speed = 1.5
@export var attk_range = 30
@export var hear_range = 10

# --------------------------------------------------
# SETUP (READY, BASE FUNCTIONS)
# --------------------------------------------------
func _ready() -> void:
	#vision_ray = RayCast2D.new()
	attackDelay.wait_time = attk_speed
	startingLocation = global_position
	nav.target_desired_distance = attk_range
	$HearingRange/Hear.shape = $HearingRange/Hear.shape.duplicate()
	$HearingRange/Hear.shape.radius = hear_range
	input_pickable = true
		
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
	pass
	
	
# --------------------------------------------------
# NAVIGATION (NEEDS SPEED AND ATTACK RANGE)
# --------------------------------------------------

func track(delta):
	var track_speed
	if(!nav.is_target_reached()):
		if vision_ray.get_collider() is CharacterBody2D and vision_ray.get_collider().category == "Player":
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
	



func _on_navigation_agent_2d_target_reached() -> void:
	pass

func _on_navigation_agent_2d_navigation_finished() -> void:
	pass


# --------------------------------------------------
# PHYSICS PROCESS (CONTINUOUS CHECK)
# --------------------------------------------------

# Remember to connect the timeout signal for each inherited scene
func _physics_process(delta: float) -> void:
	# Update vision ray
	if target == null:
		return
	var collider = vision_ray.get_collider()
	vision_ray.target_position = (target.global_position - global_position)
	if navigating:
		nav.target_position = target.global_position + rand_targ
		return		
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
	

func _input(event):
	# 1. Check if the event is a left mouse button press
	if event is InputEventMouseButton and event.pressed and hovered and highlighted:
		if  event.button_index == 1:
			get_viewport().set_input_as_handled()
			take_damage(HP) ## Destroy the body
			%jose.possess(self)
	if event is InputEventKey:
		if event.keycode == KEY_SHIFT:
			if event.pressed:
				highlighted = true
				sprite_shader.set_shader_parameter("highlight_all", true)
			else:
				highlighted = false
				sprite_shader.set_shader_parameter("highlight_all", false)


func _on_mouse_entered() -> void:
	hovered = true


func _on_mouse_exited() -> void:
	hovered = false
