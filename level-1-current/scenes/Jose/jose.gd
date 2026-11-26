extends CharacterBody2D
class_name Player

var bullet_path = preload("res://scenes/Weapons/bullet_0.tscn")

var HP = 3
var SPEED = 325.0

var max_magazine = 6
var magazine = 6

@onready var weapon = "Pistol"
@onready var category = "Player"
@onready var swing = $swing0
@onready var UI = %UI
@onready var gunSound = $RevolverSound
@onready var meleeSound = $MeleeSound
@onready var reloadSound = $ReloadSound

# Weapon_Name: [attack speed, sway]. 
var weapon_types = {
	"Pistol": [0.3, 7, 1],
	"SMG": [0.15, 10, 1.5],
	"Shotgun": [0.5, 0.008333333, 1.3],
	"Knife": [0.3, 0.0, 0]
}

var weapon_lock = false
var inv_frames = false

var dash_cooldown = false
var possess_cooldown = false

var idle_dir:String
var moving_dir:String
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	weapon_lock = false
	inv_frames = false
	$AnimatedSprite2D.play("idle_up")
	

func _physics_process(delta: float) -> void:
	var input = Input
	if input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		attack()	
	var direction = input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#look_at(get_global_mouse_position()) # Current position of mouse, makes sprite rotate. Goofyx
	
	velocity = direction * SPEED

	if direction.y == -1.0:
		moving_dir = "move_up"
		idle_dir = "idle_up"
	elif direction.y == 1.0:
		moving_dir = "move_down"
		idle_dir = "idle_down"
	elif direction.x > 0.7: #Takes care of right diagonals too
		moving_dir = "move_right"
		idle_dir = "idle_right"
	elif direction.x < -0.7: #Takes care of left diagonals
		moving_dir = "move_left"
		idle_dir = "idle_left"
	$AnimatedSprite2D.play(moving_dir)
		
	if direction == Vector2.ZERO:
		$AnimatedSprite2D.play(idle_dir)
	
	if input.is_key_pressed(KEY_SHIFT) and !dash_cooldown:
		dash(direction, moving_dir)
		return

	move_and_slide()

func dash(dash_direction, anim):
	if dash_direction == Vector2(0,0) or dash_cooldown:
		return
	if anim == "":
		return
	inv_frames = true
	set_collision_mask_value(2, false)
	dash_cooldown = true
	UI.cdDash()
	for i in range(5):
		#self.global_position = global_position + (dash_direction*15)
		await get_tree().create_timer(0.03).timeout
		$AnimatedSprite2D.play(anim)
		velocity = dash_direction * SPEED*6
		move_and_slide()
	
	# Pair this with the visual cooldown for precision later
	inv_frames = false
	set_collision_mask_value(2, true)
	await get_tree().create_timer(2).timeout	
	dash_cooldown = false

func possess(enemy):
	if(possess_cooldown):
		return
	possess_cooldown = true	
	UI.cdPossess()
	# Absorb attributes
	HP = enemy.HP
	SPEED = enemy.speed * 8 # Really need to fix the speed of Jose vs enemies
	weapon = enemy.weapon
	match weapon:
		"Shotgun":
			max_magazine = 2
		"Pistol":
			max_magazine = 6
		"SMG":
			max_magazine = 20
		"Knife":
			max_magazine = "X"
	magazine = max_magazine
	UI.updateAmmo(magazine)
	
	global_position = enemy.global_position
	await get_tree().create_timer(3).timeout
	possess_cooldown = false

func take_damage(dmg):
	if !inv_frames:
		self.HP -= dmg
		UI.updateHP(HP)
		inv_frames = true
		await get_tree().create_timer(0.1).timeout
		inv_frames = false
		if HP<= 0:
			pass
	
func shoot(sway, mouse_pos, deg):
	var rand_sway = Vector2(rng.randf_range(-sway, sway)*2, rng.randf_range(-sway, sway)*2)
	var bullet = bullet_path.instantiate() # Get bullet instance
	bullet.dir = ((mouse_pos+rand_sway - $Bullet_Pos.global_position).normalized()).rotated(deg)
	bullet.pos = global_position
	bullet.rot = get_angle_to(mouse_pos + rand_sway)
	bullet.origin_category = category
	bullet.speed = bullet.speed + 300
	get_parent().add_child(bullet)	
	gunSound.pitch_scale = rng.randf_range(0.9, 1.5)
	gunSound.play()
	
func reload(reload_speed):
	reloadSound.play()
	await get_tree().create_timer(reload_speed).timeout
	magazine = max_magazine
	UI.updateAmmo(magazine)
	if reloadSound.playing:
		reloadSound.stop()
	weapon_lock = false
	
func attack():
	if weapon_lock:
		return
	var weapon_params = weapon_types.get(weapon)
	var attk_speed = weapon_params[0]
	var sway = weapon_params[1]
	var reload_speed = weapon_params[2]
	var mouse_pos = get_global_mouse_position()
	weapon_lock = true
	
	match weapon:
		"Shotgun":
			var arc = deg_to_rad(4.0)
			for deg in [-arc, 0, arc]: #5 degree arc
				shoot(sway, mouse_pos, deg)
			magazine -= 1
		"Pistol", "SMG":
			shoot(sway, mouse_pos, 0)
			magazine -= 1
		"Knife":
			swing.play_anim()
			swing.dir = (mouse_pos - global_position).normalized()
			swing.rotation = get_angle_to(mouse_pos)
			meleeSound.pitch_scale = rng.randf_range(0.7, 1.3)
			meleeSound.play()

	UI.updateAmmo(magazine)
	if !(magazine is String) and magazine == 0:
		reload(reload_speed)
	else:		
		await get_tree().create_timer(attk_speed).timeout
		weapon_lock = false
		if meleeSound.playing:
			meleeSound.stop()
	
		

func _input(ev):
	
	if ev is InputEventMouseButton: #Mouse clicks
		# Mouse 1 = L. Click; Mouse 2 = R. Click
		# Mouse 3 = Wheel click, Mouse 4 = Scroll up; Mouse 5 = Scroll down
		pass
	if ev is InputEventKey: #Mouse clicks
		match ev.keycode:
			KEY_R:
				if magazine < max_magazine and !weapon_lock:
					weapon_lock = true
					reload(weapon_types.get(weapon)[2])
		# Mouse 1 = L. Click; Mouse 2 = R. Click
		# Mouse 3 = Wheel click, Mouse 4 = Scroll up; Mouse 5 = Scroll down
		pass
