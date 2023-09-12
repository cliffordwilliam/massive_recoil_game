extends AnimationPlayer


# give self to share for cutscene player to use
func _ready() -> void:
	Shared.curtain_animator = self
