extends Camera2D

var _default_limits = []
var default_zoom = zoom

func _ready() -> void:
	# Save initial inspector limits (usually -10000000 to 10000000)
	_default_limits = [limit_left, limit_top, limit_right, limit_bottom]

func set_zone_limits(bounds: Rect2) -> void:
	limit_left = int(bounds.position.x)
	limit_top = int(bounds.position.y)
	limit_right = int(bounds.end.x)
	limit_bottom = int(bounds.end.y)

	var v := get_viewport_rect().size
	var avg_zoom := ((v.x / bounds.size.x) + (v.y / bounds.size.y)) * 0.5 # Average of dimensions
	#var avg_zoom = minf((v.x / bounds.size.x), (v.y / bounds.size.y)) # Minimum of two, larger zoom out
	
	zoom = Vector2(avg_zoom, avg_zoom)

func clear_zone_limits() -> void:
	limit_left = _default_limits[0]
	limit_top = _default_limits[1]
	limit_right = _default_limits[2]
	limit_bottom = _default_limits[3]
	zoom = default_zoom
