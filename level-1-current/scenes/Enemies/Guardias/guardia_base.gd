class_name Guardia_Base
extends CharacterBody2D

# Currently Unused
#@onready var hearing_area = $HearingRange

# For all guards
var bullet_path = preload("res://scenes/Weapons/bullet_0.gd.tscn")
@onready var nav = $NavigationAgent2D

var navigating = false
var vision_ray
var target
var target_position
var target_vertical = 0
var direction
var rng = RandomNumberGenerator.new()
var category = "Enemy"

# Guard specific
var speed = 50
var HP = 2

@export var attk_speed :float = 1.5

# -------------------------
# SETUP
# -------------------------
		
func _ready() -> void:
	$AttackDelay.wait_time = attk_speed
		
func take_damage(dmg):
	self.HP -= dmg
	if HP<= 0:
		queue_free()
		
# Remember to connect the enter signal for each inherited scene
func _on_hearing_range_body_entered(body: Node2D) -> void:
	# Detecting Jose by hearing
	if body.name == "jose":
		navigating = true
		target = body
		vision_ray = RayCast2D.new()
		add_child(vision_ray)
		
# Remember to connect the exit signal for each inherited scene
func _on_hearing_range_body_exited(body: Node2D) -> void:
	# Jose leaving the hearing range
	if body.name == "jose":
		navigating = false
		remove_child(vision_ray)
		$AttackDelay.stop()

# Remember to connect the timeout signal for each inherited scene
		
func _physics_process(delta: float) -> void:
	if vision_ray != null:
		vision_ray.target_position = (target.global_position - global_position)
	if navigating:
		if(nav.is_navigation_finished() and nav.is_target_reached()):
			pass
		else:
			nav.target_position = target.global_position
