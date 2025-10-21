
extends CharacterBody2D

@export var speed: float = 300.0 
var screen_limit_left: float
var screen_limit_right: float

var touch_start_position: Vector2
var touch_end_position: Vector2
var is_swiping: bool = false

func _ready():
	await get_tree().process_frame  

	var screen_width = get_viewport_rect().size.x
	var screen_height = get_viewport_rect().size.y
	var sprite_size = $Sprite2D.texture.get_size() if $Sprite2D else Vector2(64, 64)  

	
	screen_limit_left = 0
	screen_limit_right = screen_width

	
	global_position = Vector2(screen_width / 2, 1500)  

	print("Initial spaceship position:", global_position)  


func _process(delta):
	handle_keyboard_input(delta)


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		touch_start_position = event.position
		is_swiping = true

	elif event is InputEventScreenTouch and not event.pressed:
		touch_end_position = event.position
		is_swiping = false
		handle_swipe()

func handle_keyboard_input(delta):
	var direction = 0

	if Input.is_key_pressed(KEY_LEFT): 
		direction = -1
	elif Input.is_key_pressed(KEY_RIGHT):  
		direction = 1

	position.x += direction * speed * delta  
	position.x = clamp(position.x, screen_limit_left, screen_limit_right) 

func handle_swipe():
	var swipe_direction = touch_end_position.x - touch_start_position.x

	if swipe_direction > 50:  
		move_spaceship(1)
	elif swipe_direction < -50: 
		move_spaceship(-1)

func move_spaceship(direction: int):
	position.x += direction * speed * 0.1  
	position.x = clamp(position.x, screen_limit_left, screen_limit_right) 
