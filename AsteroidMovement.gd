#extends Node2D
#
#var speed: float = 200.0  # Default speed
#
#func _ready():
	#speed = randf_range(150, 300)  # Give random speeds
#
#func _process(delta):
	#position.y += speed * delta  # Move downward
#
	## Destroy asteroid if it moves off-screen
	#if position.y > get_viewport_rect().size.y:
		#queue_free()
