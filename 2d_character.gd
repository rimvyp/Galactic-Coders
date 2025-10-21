extends Node2D

# Declare a speed variable for controlling movement speed
var speed = 200

# The _process function runs every frame
func _process(delta):
	# Create a vector for movement
	var movement = Vector2.ZERO
	
	# Handle input: check if arrow keys are pressed
	if Input.is_action_pressed("ui_right"):
		movement.x += 1  # Move right
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1  # Move left
	if Input.is_action_pressed("ui_down"):
		movement.y += 1  # Move down
	if Input.is_action_pressed("ui_up"):
		movement.y -= 1  # Move up
	
	# Normalize movement vector to ensure uniform speed when moving diagonally
	if movement.length() > 0:
		movement = movement.normalized()

	# Update the position based on the movement and delta time
	position += movement * speed * delta
