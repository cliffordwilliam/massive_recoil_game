extends Node2D
# this room removes the canopy and top light


onready var spawn_point: Position2D = $"%spawn_point"


func _ready() -> void:
	# wait for everyone to be ready
	if not Shared.forest_background:
		yield(Shared.tree.root, "ready")
		Shared.forest_background.canopy_cover.visible = false
		Shared.forest_background.canopy.visible = false
		Shared.forest_background.tall_trees.visible = false
		Shared.forest_background.top_light.visible = false
	elif Shared.forest_background:
		Shared.forest_background.canopy_cover.visible = false
		Shared.forest_background.canopy.visible = false
		Shared.forest_background.tall_trees.visible = false
		Shared.forest_background.top_light.visible = false


func _on_room_0_tree_exiting() -> void:
	# return to be visible again on leave
	Shared.forest_background.canopy_cover.visible = true
	Shared.forest_background.canopy.visible = true
	Shared.forest_background.tall_trees.visible = true
	Shared.forest_background.top_light.visible = true
