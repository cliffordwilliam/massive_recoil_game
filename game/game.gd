extends Node


# the default values when starting the game for the first time
var data: Dictionary = {
	"room" : 0
}

# list all the loadable rooms here (room with save points or room 0)
const ROOM_0_SCENE: PackedScene = preload("res://rooms/room_0.tscn")

# list all the backgrounds here associated with each room
const FOREST_BACKGROUND_SCENE: PackedScene = preload("res://backgrounds/forest_background.tscn")
const FORTRESS_BACKGROUND_SCENE: PackedScene = preload("res://backgrounds/fortress_background.tscn")


var next_room
var room
var next_background setget set_next_background
var background


# read / write the save data
func _ready() -> void:
	# give myself to shared
	Shared.game = self
	
	###############
	# load / save #
	###############
	
	# try to load
	var result: bool = load_data(0)
	# not found?
	if result == false:
		# save data instead
		save_data(0)
	
	##############
	# spawn room #
	##############
	
	# handle the rest of the room_0 / save rooms here
	if data.room == 0:
		room = ROOM_0_SCENE.instance()
		add_child(room)
	
	####################
	# spawn background #
	####################
	
	# handle the rest of the backgrounds here
	if room.new_background == room.NEW_BACKGROUND.forest:
		background = FOREST_BACKGROUND_SCENE.instance()
		add_child(background)
	
	#########################
	# set background origin #
	#########################
		
	background.update_background_origin(room.background_origin)
		
	# room has background?
	if room.background != null:
		# update room background origin too
		room.background.update_background_origin(room.background_origin)
		# hide the default repeated background
		background.visible = false
	
	##################
	# position ryoko #
	##################
		
	# room_0 and save rooms need to specify where ryoko is
	var ryoko_spawn: Position2D = room.get_node("ryoko_spawn")
	Shared.ryoko.global_position = ryoko_spawn.global_position
	
	#######################
	# update camera limit #
	#######################
	
	# handle camera limit
	update_camera_limit()
 

# called when player select a save slot
# write the data var into disk
func save_data(slot: int) -> void:
	# get path based on slot
	var save_path: String = get_save_path(slot)
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()


# called when player select a load slot
# read the disk and update the data var
func load_data(slot: int) -> bool:
	# get path based on slot
	var save_path: String = get_save_path(slot)
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			data = file.get_var()
			file.close()
			return true
		return false
	else:
		return false


# return save path based on given slot
func get_save_path(slot: int) -> String:
	return "user://save_" + str(slot) + ".dat"


# called by door when ryoko touches it
func on_door_ryoko_exit(next_room_scene: PackedScene) -> void:
	# stop ryoko physics_process
	Shared.ryoko.is_switching_room = true
	
	# play the curtain
	Shared.curtain_animator.play("switch_room_fade")
	
	# instance the next room to be added during middle of curtain animation
	next_room = next_room_scene.instance()


# called by curtain middle frame when curtain is fully black
func on_curtain_animator_switch_room_fade_middle() -> void:
	# unhide the original background if it was hidden
	background.visible = true
	
	# remove old room
	room.queue_free()
	
	# update room reference and add it as child
	room = next_room
	add_child(room)
	
	# instance the next background (if a room has a new one)
	if room.new_background == room.NEW_BACKGROUND.none:
		pass
	elif room.new_background == room.NEW_BACKGROUND.forest:
		self.next_background = FOREST_BACKGROUND_SCENE.instance()
	elif room.new_background == room.NEW_BACKGROUND.fortress:
		self.next_background = FORTRESS_BACKGROUND_SCENE.instance()
	
	# update background offset
	background.update_background_origin(room.background_origin)
		
	# room has background?
	if room.background != null:
		# update room background origin too
		room.background.update_background_origin(room.background_origin)
		# hide the default repeated background
		background.visible = false
	
	# handle camera limit
	update_camera_limit()
	
	# stop ryoko physics_process
	Shared.ryoko.is_switching_room = false


func set_next_background(value) -> void:
	# update next background with the new instance
	next_background = value
	# remove old background
	background.queue_free()
	# update background reference and add it as child
	background = next_background
	add_child(background)


func update_camera_limit() -> void:
	# get the room camera limit
	var camera_limit = room.get_node("camera_limit")
	var camera_limit_left: int = int(camera_limit.rect_global_position.x)
	var camera_limit_top: int = int(camera_limit.rect_global_position.y)
	var camera_limit_right: int = int(camera_limit_left + camera_limit.rect_size.x)
	var camera_limit_bottom: int = int(camera_limit_top + camera_limit.rect_size.y)
	
	# handle camera limit
	Shared.camera.limit_left = camera_limit_left
	Shared.camera.limit_top = camera_limit_top
	Shared.camera.limit_right = camera_limit_right
	Shared.camera.limit_bottom = camera_limit_bottom
