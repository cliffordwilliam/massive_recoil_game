extends ParallaxBackground
# to give self to shared for rooms to use


# for rooms to manipulate
onready var sky: ParallaxLayer = $"%sky"
onready var canopy_cover: ParallaxLayer = $"%canopy_cover"
onready var canopy: ParallaxLayer = $"%canopy"
onready var tall_trees: ParallaxLayer = $"%tall_trees"
onready var top_light: ParallaxLayer = $"%top_light"

# give self to be shared, for rooms to manipulate
func _ready() -> void:
	Shared.forest_background = self
