extends Node
# this node add and removes rooms.
# handle when first starting the game in starting area or save room
# handle switching to new rooms


# the first room and background should be decided by the load data later
var room_scene: PackedScene = preload("res://stages/forest/rooms/room_0.tscn")
var background_scene: PackedScene = preload("res://stages/forest/background/forest_background.tscn")

onready var camera: Camera2D = $"%camera"
onready var curtain_animator: AnimationPlayer = $"%curtain_animator"

# for room switching
var room : Node2D
var next_room: PackedScene setget set_new_room


# handle the first spawn, either in save room or starting intro position
func _ready() -> void:
	# the following is for starting the game for the first time
	# instance the first room
	room = room_scene.instance()
	add_child(room)
	# instance the first background
	var background: ParallaxBackground = background_scene.instance()
	add_child(background)
	# position ryoko to spawn point, make her face left
	Shared.ryoko.global_position = room.spawn_point.global_position
	Shared.ryoko.sprite.scale.x = -1
	# update camera to room limit
	update_camera_limit()
	# play intro cutscene (will set camera to its cutscene starting location)
	Shared.cutscene_player.play("intro")


# uses the room reference rect
func update_camera_limit() -> void:
	# get room limit
	var room_camera_limit: ReferenceRect = room.get_node("camera_limits")
	# get room camera limit data
	var room_camera_limit_left: int = room_camera_limit.rect_position.x
	var room_camera_limit_top: int = room_camera_limit.rect_position.y
	var room_camera_limit_right: int = room_camera_limit.rect_position.x + room_camera_limit.rect_size.x
	var room_camera_limit_bottom: int = room_camera_limit.rect_position.y + room_camera_limit.rect_size.y
	# update camera to room limit
	camera.limit_left = room_camera_limit_left
	camera.limit_top = room_camera_limit_top
	camera.limit_right = room_camera_limit_right
	camera.limit_bottom = room_camera_limit_bottom
	# update camera position to within limit without smoothing
	camera.reset_smoothing()


# this setter calls the room curtain fade animation
func set_new_room(value) -> void:
	next_room = value
	# this animation calls the room switch function
	curtain_animator.play("room_fade")


# switch room
func switch_room() -> void:
	# remove old room
	room.queue_free()
	# instance the next room and update room
	room = next_room.instance()
	add_child(room)
	update_camera_limit()


# func for cutscene player to use

func remove_camera_limit() -> void:
	camera.limit_left = -10000000
	camera.limit_top = -10000000
	camera.limit_right = 10000000
	camera.limit_bottom = 10000000
