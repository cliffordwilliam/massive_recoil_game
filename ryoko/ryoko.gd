extends KinematicBody2D


# for cutscene player to use (indirectly through me)
onready var remote_transform: RemoteTransform2D = $"%remote_transform_2d"
onready var text_box: Control = $"%text_box"

# for text_box to find
onready var text_box_tail: Sprite = $"%text_box_tail"

# refs
onready var sprite: Sprite = $"%sprite"
onready var animator: AnimationPlayer = $"%animation_player"

# movement constants
const MAX_HORIZONTAL_VELOCITY: float = 180.0
const HORIZONTAL_WEIGHT: float = 0.2  # movement uses lerp
const SNAP_VECTOR: Vector2 = Vector2(0, 32)  # snap to tiles
const MAX_SLIDES: int = 4  # default value needed for snap argument
const FLOOR_MAX_ANGLE: float = 0.785398  # 45 degrees

# states
var state: int = 0 setget set_state
# 1 = idle
# 2 = run

# to check if there is a change, to start turn animation
var old_sprite_scale_x: int = 1

# movement var
var direction: int = 0
var velocity: Vector2 = Vector2.ZERO

# controllable
var is_controllable: bool = false


func _ready() -> void:
	# player always start at idle state, no need to play intro idle anim
	animator.play("idle")
	# add myself to shared autoload
	Shared.ryoko = self


func _physics_process(_delta: float) -> void:
	# update horizontal velocity
	velocity.x = lerp(velocity.x, direction * MAX_HORIZONTAL_VELOCITY, HORIZONTAL_WEIGHT)
	# move 
	# warning-ignore-all:return_value_discarded
	move_and_slide_with_snap(velocity, SNAP_VECTOR, Vector2.UP, true, 4)
	# update old sprite for turn animation
	old_sprite_scale_x = int(sprite.scale.x)
	# update sprite scale x
	if direction != 0:
		sprite.scale.x = direction
	# get horizontal input
	if is_controllable:
		direction = int(Input.get_axis("left", "right"))
	
	# handle state
	# idle
	if state == 0:
		# in state logic
		# handle exit
		# to run
		if direction != 0:
			self.state = 1
			
	# run
	if state == 1:
		# in state logic
		# turn
		if old_sprite_scale_x != sprite.scale.x:
			animator.play("turn")
		# handle exit
		# to idle
		if direction == 0:
			self.state = 0


func set_state(value):
	# store old state
	var old_state = state
	# update to new state
	state = value
	
	# enter
	# idle
	if state == 0:
		# handle intro animation
		animator.play("toidle")
		
	# run
	elif state == 1:
		# handle intro animation
		if old_sprite_scale_x != sprite.scale.x:
			animator.play("turn")
		elif old_sprite_scale_x == sprite.scale.x:
			animator.play("torun")


func _on_animation_player_animation_finished(anim_name: String) -> void:
	# handle animation transitions
	if anim_name == "torun":
		animator.play("run")
	elif anim_name == "toidle":
		animator.play("idle")
	elif anim_name == "turn":
		animator.play("run")


# for cutscene player to use
func detach_camera() -> void:
	remote_transform.remote_path = ""
	
	
func attach_camera() -> void:
	remote_transform.remote_path = remote_transform.get_path_to(Shared.camera)
	
	
func remove_control() -> void:
	is_controllable = false
	
	
func return_control() -> void:
	is_controllable = true
