


extends CharacterBody2D

@export var gravity: float = 1000.0
@export var jump_force: float = -300.0

func _physics_process(delta):

	velocity.y += gravity * delta

	move_and_slide()

func _input(event):

	if event is InputEventScreenTouch and event.pressed:
		velocity.y = jump_force
	elif event is InputEventMouseButton and event.pressed:
		velocity.y = jump_force
