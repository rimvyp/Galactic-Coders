extends Node2D


const GRID_SIZE = 32  

var target_position: Vector2  
var can_move: bool = true  

func _ready():
	target_position = position  

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and can_move:
		var direction = Vector2.ZERO
		
		if event.keycode == KEY_W:
			direction = Vector2.UP
		elif event.keycode == KEY_S:
			direction = Vector2.DOWN
		elif event.keycode == KEY_A:
			direction = Vector2.LEFT
		elif event.keycode == KEY_D:
			direction = Vector2.RIGHT

		if direction != Vector2.ZERO:
			move_player(direction)

func move_player(direction: Vector2):
	var new_position = target_position + direction * GRID_SIZE
	target_position = new_position
	position = target_position  
