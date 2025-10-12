extends Area2D
var pos:Vector2
var rot:float
var dir:float
var jose_id:int

var speed = 2000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = pos
	global_rotation = rot


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += (Vector2(speed, 0).rotated(dir))/50
	
