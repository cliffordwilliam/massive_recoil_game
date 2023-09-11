extends Node


# tree to get current scene, root, create tweens and timers
onready var tree: SceneTree = get_tree()

# player
var ryoko

# some rooms can manipulate background
var forest_background
