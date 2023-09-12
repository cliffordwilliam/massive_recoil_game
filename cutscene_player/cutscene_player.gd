extends AnimationPlayer
# the idea is that to store all the game cutscene into tracks in this node
# before starting a track, a initialize func is called to make sure that all of the needed objects are ready
# this node has a speech bubble it can use as well, it is hidden when not in use
# speech bubble are positioned on the talking actors head
# when speech bubble is active the main cutscene track is paused
# this node can control just about anything that exist in the game, camera, room, ryoko, anything
# each actors should have a collection of functions dedicated only for this node to use, jump, roll, eat, sleep, etc
# while conversations are all stored in json for easy use in the long run


func _ready() -> void:
	# add self to shared for rooms or world to use
	Shared.cutscene_player = self


# INTRO ANIMATION
# called by world when first starting the game, that means everyone is ready
# the following are the func called by intro animation

func _remove_ryoko_control() -> void:
	Shared.ryoko.remove_control()

func _remove_camera_limit() -> void:
	# world scene reset camera limit to default
	Shared.tree.current_scene.remove_camera_limit()

func _position_camera_one_screen_higher() -> void:
	# move camera to starting position
	Shared.camera.intro_animation_position_self_to_starting_position()

func _detach_ryoko_remote_transform_from_camera() -> void:
	# detach ryoko remote transform from camera
	Shared.ryoko.detach_camera()

func _intro_fade_out_curtain_from_black() -> void:
	# 50 frames long in 60fps
	Shared.curtain_animator.play("intro_fade_out_curtain_from_black")
	
# 28 frames gap in 60 fps before showing setting name

func _show_stage_title() -> void:
	# 231 frames long in 60fps
	Shared.stage_title.title.text = "Mt. Everwind - Mountain Path"
	Shared.stage_title.animator.play("default")
	
# move camera down to where it is supposed to be at same time show stage title

func _move_camera_down() -> void:
	# 1500 frames long in 60fps
	Shared.camera.intro_animation_move_down()
	
func _set_camera_limit_to_room_limit() -> void:
	# world scene set camera limit to room limit
	Shared.tree.current_scene.update_camera_limit()

func _attach_ryoko_remote_transform_to_camera() -> void:
	# detach ryoko remote transform from camera
	Shared.ryoko.attach_camera()

func _return_ryoko_control() -> void:
	Shared.ryoko.return_control()
	
# fade out curtain from black
# detach camera from player
# remove limit
# have the camera be one screen on top where it is should be in room 0
# move camera down to where it is supposed to be
