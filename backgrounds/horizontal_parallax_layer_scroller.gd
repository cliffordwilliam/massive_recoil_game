extends ParallaxLayer
# attach to any layer that needs to move (moving car, in elevator, etc)

# moves the layer, by decreasing the motion offset
export(float) var speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	motion_offset.x += speed * delta
