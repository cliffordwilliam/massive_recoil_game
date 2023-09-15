extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Shared.skip_cutscene_prompt = self
