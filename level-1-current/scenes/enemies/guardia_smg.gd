extends CharacterBody2D
@onready var target=$"../jose"
@onready var nav_agent = $NavigationAgent2D
@onready var vision_ray = $VisionRay
@onready var hearing_area = $HearingRange
@onready var memory_timer = $DetectionTimer

@onready var category = "Enemy"


enum State {
	PATROL,
	INVESTIGATE,
	ENGAGE,
	RETURN
}

var speed = 400
var HP = 2
var type = "enemy"
var heard = false # Jose within hearing range
@export var patrol_points: Array[Vector2]
@export var suspicion := 0.0

var state = State.PATROL
var last_known_position: Vector2
var patrol_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func take_damage(dmg):
	self.HP -= dmg
	if HP<= 0:
		queue_free()
		
		
		
# -------------------------
# DETECTION SYSTEM (Hearing and Visual)
# -------------------------

func _on_hearing_range_body_entered(body: Node2D) -> void:
	if body.name == "jose":
		heard = true
		#print(suspicion)

func _on_hearing_range_body_exited(body: Node2D) -> void:
	if body.name == "jose":
		heard = false
	#print(suspicion)
		
# -------------------------
# SUSPICION SYSTEM
# -------------------------

func update_suspicion(delta):
	# Decay suspicion if not seeing player
	if !heard:
		suspicion -= 10 * delta
		
	suspicion = clamp(suspicion, 0, 100)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#detect_player(delta) # Vision based
	update_suspicion(delta) 
	#update_state()
	#run_state(delta)
	#move_and_slide()
	if heard:
		suspicion += 15*delta # Hearing detection
	
	#var direction = (target.position-position).normalized()
	#velocity = direction * speed

	#move_and_slide()
