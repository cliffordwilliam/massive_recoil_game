extends Node


# tree to get current scene, root, create tweens and timers
onready var tree: SceneTree = get_tree()

# camera
var camera

# player
var ryoko

# some rooms can manipulate background
var forest_background

# cutscene player called by rooms or world
var cutscene_player

# curtain for cutscene player to use
var curtain_animator

# state title text for cutscene player to use
var stage_title
