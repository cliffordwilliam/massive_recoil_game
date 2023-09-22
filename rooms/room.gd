extends Node2D


# things room may or may not have
export(NodePath) onready var camera_limit = get_node(camera_limit) as ReferenceRect if camera_limit else null
export(NodePath) onready var ryoko_spawn_point = get_node(ryoko_spawn_point) as Position2D if ryoko_spawn_point else null
export(NodePath) onready var background_origin = get_node(background_origin) as Position2D if background_origin else null
export(NodePath) onready var background = get_node(background) as ParallaxBackground if background else null

# set this for room that changes the repeating background (like the first room of a new stage)
enum NEW_BACKGROUND { none, forest, fortress }
export(NEW_BACKGROUND) var new_background = NEW_BACKGROUND.none
