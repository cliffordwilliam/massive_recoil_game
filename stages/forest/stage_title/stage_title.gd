extends Node2D


# for cutscenes to use
onready var title: Label = $"%title"
onready var animator: AnimationPlayer = $"%animator"


# passed to shared for cutscene player to use
func _ready() -> void:
	Shared.stage_title = self
