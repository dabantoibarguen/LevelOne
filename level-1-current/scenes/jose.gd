extends CharacterBody2D

var bullet_path = preload("res://bullet_1.tscn")

const SPEED = 450.0
var idle_dir:String
var type = "player"

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	#look_at(get_global_mouse_position()) # Current position of mouse, makes sprite rotate. Goofyx
	
	velocity = direction * SPEED
	
	
	if direction.y == -1.0:
		$AnimatedSprite2D.play("move_up")
		idle_dir = "idle_up"
	elif direction.y == 1.0:
		$AnimatedSprite2D.play("move_down")
		idle_dir = "idle_down"
	elif direction.x > 0.7: #Takes care of right diagonals too
		$AnimatedSprite2D.play("move_right")
		idle_dir = "idle_right"
	elif direction.x < -0.7: #Takes care of left diagonals
		$AnimatedSprite2D.play("move_left")
		idle_dir = "idle_left"
	elif direction == Vector2.ZERO:
		$AnimatedSprite2D.play(idle_dir)
	else:
		$AnimatedSprite2D.play(idle_dir)
	
	move_and_slide()
	
func _input(ev):
	if ev is InputEventMouseButton: #Mouse clicks
		# Mouse 1 = L. Click; Mouse 2 = R. Click
		# Mouse 3 = Wheel click, Mouse 4 = Scroll up; Mouse 5 = Scroll down
		if ev.button_index == 1 and ev.button_mask == 1: # button mask 1 is click down, 0 is up
			var mouse_pos = get_global_mouse_position()
			var bullet = bullet_path.instantiate() # Get bullet instance
			bullet.dir = get_angle_to(mouse_pos)
			bullet.pos = $Bullet_Pos.global_position
			bullet.rot = get_angle_to(mouse_pos)
			self.add_child(bullet)
	
	
