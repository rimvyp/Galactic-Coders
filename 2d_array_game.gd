
extends Node2D

@onready var alien = $Alien
@onready var tilemap = $TileMap
@onready var up = $Up
@onready var down = $Down
@onready var left = $Left
@onready var right = $Right
@onready var location = $Location
@onready var loop = $Loop
@onready var select = $MAKE_CHOICE
@onready var fade = $fade
@onready var progress = $progress

const CELL_SIZE = 270
const GRID_SIZE = 4
var grid_position = Vector2(0, 0)
var moving = false
var speed = 300

var final_position = Vector2(0, 0)
var explored_count = 0  
const TOTAL_EXPLORE = 5  

func _ready() -> void:
	fade.play("fade_in")
	alien.global_position = get_world_position(grid_position)
	
	up.pressed.connect(move_up)
	down.pressed.connect(move_down)
	left.pressed.connect(move_left)
	right.pressed.connect(move_right)
	select.pressed.connect(check_choice)
	
	loop.text = "Help the spaceship explore the area so we can gather information on the surrounding planets!"
	progress.text = "Explored 0/%d" % TOTAL_EXPLORE 
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 5.0  
	timer.one_shot = true
	timer.timeout.connect(generate_loop)
	timer.start()

func get_world_position(grid_pos: Vector2) -> Vector2:
	return Vector2(
		grid_pos.x * CELL_SIZE + CELL_SIZE / 2, 
		grid_pos.y * CELL_SIZE + CELL_SIZE / 2
	)

func move_up():
	if not moving and grid_position.y > 0:
		grid_position.y -= 1
		move_alien()

func move_down():
	if not moving and grid_position.y < GRID_SIZE - 1:
		grid_position.y += 1
		move_alien()

func move_left():
	if not moving and grid_position.x > 0:
		grid_position.x -= 1
		move_alien()

func move_right():
	if not moving and grid_position.x < GRID_SIZE - 1:
		grid_position.x += 1
		move_alien()

func move_alien():
	moving = true
	var target_position = get_world_position(grid_position)

	var tween = create_tween()
	tween.tween_property(alien, "global_position", target_position, 0.3)
	tween.finished.connect(func(): moving = false)

	location.text = "LOCATION [%d][%d]" % [grid_position.x, grid_position.y]

func generate_loop():
	var start_x = randi() % GRID_SIZE
	var start_y = randi() % GRID_SIZE
	var end_x = start_x + (randi() % (GRID_SIZE - start_x))
	var end_y = start_y + (randi() % (GRID_SIZE - start_y))

	end_x = min(end_x, GRID_SIZE - 1)
	end_y = min(end_y, GRID_SIZE - 1)

	var loop_text = "for (int x = %d; x <= %d; x++) {\n    for (int y = %d; y <= %d; y++) {\n        // Move to position (x, y)\n    }\n}" % [start_x, end_x, start_y, end_y]
	loop.text = loop_text

	final_position = Vector2(end_x, end_y)


func check_choice():
	if grid_position == final_position:
		location.text = "Correct! Well done!"
		explored_count += 1
		progress.text = "Explored %d/%d" % [explored_count, TOTAL_EXPLORE]
		
		if explored_count >= TOTAL_EXPLORE:
			loop.text = "Mission Complete! You've explored all areas!"
			select.disabled = true 
			
			var timer = Timer.new()
			add_child(timer)
			timer.wait_time = 3.0  
			timer.one_shot = true
			fade.play("fade_out")
			timer.timeout.connect(func():
				get_tree().change_scene_to_file("res://levelSelector.tscn")
			)
			timer.start()
		else:
			generate_loop()
	else:
		loop.text = "Oh no! Data is corrupted. Return to base and try again!"
		location.text = "Mission Failed!"
		
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 3.0  
		timer.one_shot = true
		fade.play("fade_out")
		timer.timeout.connect(func():
			get_tree().change_scene_to_file("res://levelSelector.tscn")
		)
		timer.start()
