extends AnimatedSprite


# radio does not need to have tail
var hidden: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# hide myself at start
	visible = false


# hide animation is played by the text box, hide tail when it is done with the hide anim
func _on_text_box_tail_animation_finished() -> void:
	if animation == "hide":
		visible = false
