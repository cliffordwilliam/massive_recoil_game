extends Area2D


# next room path
export(String, FILE) onready var next_room_scene = load(next_room_scene) as PackedScene

# door shapes
const VERTICAL_SHAPE: Resource = preload("res://door/vertical_shape.tres")
const HORIZONTAL_SHAPE: Resource = preload("res://door/horizontal_shape.tres")

# to set the shape to
onready var collision: CollisionShape2D = $"%collision"

# editor access
export(bool) var is_horizontal = false


# set of collision shape from export for ease of use
func _ready() -> void:
	if is_horizontal == true:
		collision.shape = HORIZONTAL_SHAPE
	elif is_horizontal == false:
		collision.shape = VERTICAL_SHAPE


# when ryoko touch door
func _on_door_body_entered(ryoko: Ryoko) -> void:
	Shared.game.on_door_ryoko_exit(next_room_scene)
