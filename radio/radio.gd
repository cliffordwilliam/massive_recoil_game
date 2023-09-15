extends Node2D


onready var text_box: Control = $"%text_box"
onready var text_box_tail: AnimatedSprite = $"%text_box_tail"


# give self to shared for cutscene player to use
func _ready() -> void:
	Shared.radio = self
	# radio don't need tail
	text_box_tail.hidden = true
