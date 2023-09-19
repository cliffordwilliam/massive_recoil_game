extends ParallaxBackground


# things room may or may not have
export(NodePath) onready var grounded_layer = get_node(grounded_layer) as ParallaxLayer if grounded_layer else null


onready var viewport = get_viewport()
onready var half_viewport_width = viewport.size / 2

onready var layers: Array = get_children()


func _ready() -> void:
	for layer in layers:
		layer.motion_offset = -(half_viewport_width) + ((half_viewport_width) * layer.motion_scale)


func update_background_origin(background_origin) -> void:
	var multiplier: float = background_origin.global_position.x / viewport.size.x
	var flip_offset: float = 0 if int(background_origin.global_position.x) % 640 == 0 else 320

	for layer in layers:
		# reset to origin
		layer.motion_offset = -(half_viewport_width) + ((half_viewport_width) * layer.motion_scale)
		# apply offset horizontal
		var gap = (1 - layer.motion_scale.x) * viewport.size.x
		layer.motion_offset.x -= multiplier * gap
		layer.motion_offset.x -= flip_offset
	
	if grounded_layer != null:
		var multiplier_y: float = (background_origin.global_position.y / 352) - 1
		# apply offset
		var gap_y = (1 - grounded_layer.motion_scale.y) * 352
		grounded_layer.motion_offset.y += gap_y * multiplier_y
