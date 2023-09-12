extends Camera2D


func _ready() -> void:
	Shared.camera = self


# functions below are for cutscenes

# position self one screen higher
func intro_animation_position_self_to_starting_position() -> void:
	global_position = Vector2(320.0, -180.0)
	# update camera position to within limit without smoothing

# move down by 640 px in 2.5 seconds
func intro_animation_move_down() -> void:
	var tw = create_tween()
	tw.tween_property(self, "position:y", 360.0, 2.5).as_relative().set_trans(Tween.EASE_IN_OUT)
