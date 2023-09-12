extends Area2D
# watches out for player
# on player entry sets the world next room


const horizontal_shape: Resource = preload("res://door/horizontal_shape.tres")
const vertical_shape: Resource = preload("res://door/vertical_shape.tres")

onready var collider: CollisionShape2D = $"%collision_shape_2d"


enum DOOR_SHAPE { HORIZONTAL, VERTICAL }
export(DOOR_SHAPE) var door_shape = DOOR_SHAPE.HORIZONTAL


export(String, FILE) onready var next_room = load(next_room)


func _ready() -> void:
	if door_shape == DOOR_SHAPE.HORIZONTAL:
		collider.set_shape(horizontal_shape)
	elif door_shape == DOOR_SHAPE.VERTICAL:
		collider.set_shape(vertical_shape)


func _on_door_body_entered(_ryoko: Node) -> void:
	# this activates the setter
	Shared.tree.current_scene.next_room = next_room
