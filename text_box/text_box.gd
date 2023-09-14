extends Control

# always need a parent
onready var parent: = get_parent()

# refs
onready var label: Label = $"%label"
onready var background: NinePatchRect = $"%background"
onready var background_tween: NinePatchRect = $"%background_tween"
onready var indicator: TextureRect = $"%indicator"
onready var typer: AnimationPlayer = $"%typer"

# travel through the sentences
var sentence_index: int = 0
# this is supposed to be passed by someone outside not here (the values)
var sentences: Array

# tween
var old_background_global_position: Vector2
var old_background_size: Vector2


func _ready() -> void:
	# move myself manually to deal with camera boundaries
	set_as_toplevel(true)
	# hide the background tween at start
	background_tween.visible = false
	# hide the indicator too
	indicator.visible = false
	# hide myself and scale me to 0, need to activate to revert this
	visible = false
	rect_scale = Vector2.ZERO
	# input is false until the pop up anim is finished from activate func
	set_process_input(false)


# attach myself to parent's text box tail
func _process(delta: float) -> void:
	# get the camera rect
	var camera_rect: Rect2 = Rect2(Shared.camera.get_camera_screen_center() - get_viewport_rect().size / 2, get_viewport_rect().size)
	# get half of my width
	var my_half_width: float = background.rect_size.x / 2
	# get the camera boundaries
	var left_boundary: float = camera_rect.position.x
	var right_boundary: float = camera_rect.position.x + camera_rect.size.x
	# get my right and left sides
	var text_box_left_size: float = parent.global_position.x - my_half_width
	var text_box_right_size: float = parent.global_position.x + my_half_width
	# always follow the parent tail y global position
	rect_global_position.y = parent.text_box_tail.global_position.y
	# only update my x global position to parent if based on parent my right and left sides are within camera
	if text_box_left_size >= left_boundary and text_box_right_size <= right_boundary:
		rect_global_position.x = parent.text_box_tail.global_position.x
	# when a new sentence is set, i might be positioned outside
	# find the overshoot on either side and move me back in camera
	elif text_box_right_size > right_boundary:
		rect_global_position.x = (right_boundary - my_half_width)
	elif text_box_left_size < left_boundary:
		rect_global_position.x = (left_boundary + my_half_width)
		
	# check if the label has been updated
	# the size determines when a new sentence has been added, position is not used as actors may move around while talking
	if old_background_size != background.rect_size:
		# start the background tween procedure
		# show the background tween only
		background.visible = false
		background_tween.visible = true
		# tween the background tween from old to new position
		var tw = create_tween()
		# no need to tween the position, tween the min_size and set the grow to either sides. This way it can grow on the move
		tw.tween_property(background_tween, "rect_min_size", background.rect_size, 0.1).from(old_background_size).set_trans(Tween.TRANS_LINEAR)
		# if this is the first sentence, I need to tween from scale 0
		if sentence_index == 1:
			tw.set_parallel().tween_property(self, "rect_scale", Vector2.ONE, 0.1).from(Vector2.ZERO).set_trans(Tween.TRANS_LINEAR)
		tw.connect("finished", self, "_on_tween_finished")
		# update old background size to updated value
		old_background_size = background.rect_size


func _on_tween_finished() -> void:
	# show the background only
	background.visible = true
	background_tween.visible = false
	# start typing
	typer.play("default")


# set the label text to the next sentence
func set_next_sentence(value) -> void:
	# store the old position for tween
	old_background_global_position = background.rect_global_position
	old_background_size = background.rect_size
	# set the new sentence to label and hide it, the typer will reveal it one by one after tween
	label.text = value
	label.visible_characters = 0
	# hide the indicator, revealed after typing finished
	indicator.visible = false


# called by typer default animation every 2 frames
func type_letter() -> void:
	# there are more letters to reveal
	if label.visible_characters < len(label.text):
		label.visible_characters += 1
	# no more hidden letters, wait for player input
	elif label.visible_characters == len(label.text):
		typer.stop(true)
		indicator.visible = true
		

# called by cutscene player, wakes me up and give me my sentences
func activate(given_sentences) -> void:
	sentences = given_sentences
	visible = true
	# show parent text box tail
	parent.text_box_tail.visible = true
	# turn on input and set the next first sentence
	set_process_input(true)
	set_next_sentence(sentences[sentence_index])
	sentence_index += 1
	
	

# DEBUG
func _input(event: InputEvent) -> void:
	# player press accept
	if event.is_action_pressed("ui_accept"):
		# more sentences to say
		if sentence_index < len(sentences):
			# send new sentence to func and update the sentence counter
			set_next_sentence(sentences[sentence_index])
			sentence_index += 1
		elif sentence_index == len(sentences):
			# tween root from scale 1 to 0
			var tw = create_tween()
			# no need to tween the position, tween the min_size and set the grow to either sides. This way it can grow on the move
			tw.tween_property(self, "rect_scale", Vector2.ZERO, 0.2).from(Vector2.ONE).set_trans(Tween.TRANS_LINEAR)
			tw.connect("finished", self, "_on_deactivate_tween_finished")
			# no more sentence to say then tell cutscene player to continue its timeline


func _on_deactivate_tween_finished() -> void:
	# hide parent text box tail
	parent.text_box_tail.visible = false
	Shared.cutscene_player.text_box_done()
