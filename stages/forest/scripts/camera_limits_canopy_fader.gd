extends ReferenceRect
# attach this to root room limit that needs to fade the canopy cover and top light to reveal the sky
# needs ryoko and top light and canopy cover
# changes the canopy cover and top light alpha based on ryoko position


onready var room_camera_limit_left: int = rect_position.x
onready var room_camera_limit_right: int = rect_position.x + rect_size.x

const MIN_ALPHA: float = 0.0
const MAX_ALPHA: float = 1.0

const CALL_LIMIT: int = 15
var frame_counter: int = 0

var first_found: bool = true


func _process(_delta: float) -> void:
	# early exits
	if not Shared.ryoko:
		return
	if not Shared.forest_background:
		return
		
	# update as soon as it is found, then use limiter
	if first_found:
		# update flag
		first_found = false
		# the closer ryoko is to the right side of room, the closer is the alpha to 1
		var alpha = range_lerp(Shared.ryoko.position.x, room_camera_limit_left, room_camera_limit_right, 0.0, 1.0)

		# set the alpha of the canopy_cover and top light
		Shared.forest_background.canopy_cover.modulate.a = alpha
		Shared.forest_background.top_light.modulate.a = alpha
		
	# reduce calls
	frame_counter += 1
	
	# only every call limit
	if frame_counter % CALL_LIMIT == 0:
		# reset counter to prevent overflow
		frame_counter = 0
		
		# the closer ryoko is to the right side of room, the closer is the alpha to 1
		var alpha = range_lerp(Shared.ryoko.position.x, room_camera_limit_left, room_camera_limit_right, 0.0, 1.0)

		# set the alpha of the canopy_cover and top light
		Shared.forest_background.canopy_cover.modulate.a = alpha
		Shared.forest_background.top_light.modulate.a = alpha
