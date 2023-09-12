tool
extends Sprite


const CALL_LIMIT: int = 60
var frame_counter: int = 0


onready var viewport: = get_viewport()


func _ready() -> void:
	# my game camera never zooms in
	material.set_shader_param("y_zoom", 1)


# pass my scale to material
func _on_water_item_rect_changed() -> void:
	material.set_shader_param("scale", scale)


# this is for editor viewing only, can remove at final build
func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return
		
	# reduce calls
	frame_counter += 1
	
	# only every call limit
	if frame_counter % CALL_LIMIT == 0:
		# reset counter to prevent overflow
		frame_counter = 0
		# pass the zoom to shader, if the scene has a viewport (camera)
		if viewport:
			var y_zoom = viewport.global_canvas_transform.y.y
			material.set_shader_param("y_zoom", y_zoom)
