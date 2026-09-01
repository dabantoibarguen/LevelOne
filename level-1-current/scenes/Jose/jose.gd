extends CharacterBody2D

var bullet_path = preload("res://scenes/weapons/bullet_0.tscn")

const SPEED = 325.0
var idle_dir:String
var type = "player"
var HP = 3
var weapon_lock
var inv_frames

# Weapon_Name: [attack speed, sway, ranged/melee]. Add speed?
var weapon_types = {
	"Pistol": [0.3, 1],
	"SMG": [0.08, 2],
	"Shotgun": [0.5, 0.008333333],
	"Knife": [0.15, 0.0]
}

@onready var category = "Player"
@onready var weapon = "Pistol"

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	weapon_lock = false
	inv_frames = false
	$AnimatedSprite2D.play("idle_up")
	

func _physics_process(delta: float) -> void:
	var input = Input
	if input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !weapon_lock:
		attack()
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
	
func take_damage(dmg):
	if !inv_frames:
		self.HP -= dmg
		inv_frames = true
		await get_tree().create_timer(0.4).timeout
		inv_frames = false
		if HP<= 0:
			pass
	
func shoot(sway, mouse_pos, deg):
	var rand_sway = Vector2(rng.randf_range(-sway, sway)*4, rng.randf_range(-sway, sway)*4)
	var bullet = bullet_path.instantiate() # Get bullet instance
	bullet.dir = ((mouse_pos+rand_sway - $Bullet_Pos.global_position).normalized()).rotated(deg)
	bullet.pos = global_position
	bullet.rot = get_angle_to(mouse_pos)
	bullet.origin_category = category
	get_parent().add_child(bullet)	
	
	

func attack():
	var weapon_params = weapon_types.get(weapon)
	var attk_speed = weapon_params[0]
	var sway = weapon_params[1]
	var mouse_pos = get_global_mouse_position()
	
	match weapon:
		"Shotgun":
			var arc = deg_to_rad(4.0)
			for deg in [-arc, 0, arc]: #5 degree arc
				shoot(sway, mouse_pos, deg)
		"Pistol", "SMG":
			shoot(sway, mouse_pos, 0)
				
	
	weapon_lock = true
	await get_tree().create_timer(attk_speed).timeout
	weapon_lock = false
		

func _input(ev):
	if ev is InputEventMouseButton: #Mouse clicks
		# Mouse 1 = L. Click; Mouse 2 = R. Click
		# Mouse 3 = Wheel click, Mouse 4 = Scroll up; Mouse 5 = Scroll down
		pass
	if ev is InputEventKey and ev.pressed:
		if ev.keycode == KEY_1:
			weapon = "Pistol"
		if ev.keycode == KEY_2:
			weapon = "Shotgun"
		if ev.keycode == KEY_3:
			weapon = "SMG"

	
	
