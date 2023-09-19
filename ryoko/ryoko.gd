extends KinematicBody2D
class_name Ryoko


# movement
var velocity: Vector2 = Vector2.ZERO
var direction: int = 0

# movement
const MAX_HORIZONTAL_SPEED: float = 300.0
const SLOPE_SNAP_VECTOR: Vector2 = Vector2(0, 32.0)
const FLOOR_NORMAL = Vector2.UP
const STOP_ON_SLOPE: bool = true
const MAX_SLIDES: int = 4
const FLOOR_MAX_ANGLE: float = deg2rad(90.0)

# switch room
var is_switching_room: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Shared.ryoko = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_switching_room:
		return
		
	# debug movement for now
	velocity = Vector2(Input.get_axis("left", "right"), (Input.get_axis("up", "down")))
	velocity *= MAX_HORIZONTAL_SPEED
	move_and_slide(velocity)
	
	if Input.is_action_just_pressed("ui_right"):
		global_position.x += 1
	
	elif Input.is_action_just_pressed("ui_left"):
		global_position.x -= 1
	
	elif Input.is_action_just_pressed("ui_down"):
		global_position.y += 1
	
	elif Input.is_action_just_pressed("ui_up"):
		global_position.y -= 1
	return
	
	# listen for left and right input, update direction
	direction = int(Input.get_axis("left", "right"))
	
	# update velocity with direction
	velocity.x = direction * MAX_HORIZONTAL_SPEED
	
	# move
	velocity = move_and_slide_with_snap(
		velocity, 
		SLOPE_SNAP_VECTOR, 
		FLOOR_NORMAL, 
		STOP_ON_SLOPE, 
		MAX_SLIDES, 
		FLOOR_MAX_ANGLE
		)
