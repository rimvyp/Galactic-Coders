
extends Node2D  

@onready var space_guy = $space_guy  
@onready var animation_player = $AnimationPlayer 
@onready var anim_spaceguy = $space_guy/AnimatedSprite2D
@onready var lesson_label = $Label/RichTextLabel  

@onready var planet_one = $lvl_one/planet_one 
@onready var planet_two = $lvl_two/planet_two 
@onready var planet_three = $lvl_three/planet_three
@onready var planet_four = $lvl_four/planet_four
@onready var planet_five = $lvl_five/planet_five
@onready var planet_six = $lvl_six/planet_six
@onready var planet_seven = $lvl_seven/planet_seven
@onready var play_button = $Play
var swipe_threshold = 100
var swipe_start_position = Vector2()
var current_planet = 1
var moving = false

var lesson_texts = {
	1: "Hello World",
	2: "Variables",
	3: "Operators",
	4: "Loops",
	5: "Strings",
	6: "1D Arrays",
	7: "2D Arrays"
}

func _ready() -> void:
	anim_spaceguy.play("default")
	space_guy.position = planet_one.position
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	play_button.connect("pressed", Callable(self, "enter_level"))  
	update_lesson_text() 

func move_to_planet(from_planet: int, to_planet: int):
	moving = true
	if from_planet < to_planet:
		match to_planet:
			2: animation_player.play("MoveToPlanetTwo")
			3: animation_player.play("MoveToPlanetThree")
			4: animation_player.play("MoveToPlanetFour")
			5: animation_player.play("MoveToPlanetFive")
			6: animation_player.play("MoveToPlanetSix")
			7: animation_player.play("MoveToPlanetSeven")
	else:
		match to_planet:
			1: animation_player.play("MoveFromPlanetTwo")
			2: animation_player.play("MoveFromPlanetThree")
			3: animation_player.play("MoveFromPlanetFour")
			4: animation_player.play("MoveFromPlanetFive")
			5: animation_player.play("MoveFromPlanetSix")
			6: animation_player.play("MoveFromPlanetSeven")

func _input(event):
	if moving:
		return

	if event is InputEventScreenTouch:
		if event.pressed:
			swipe_start_position = event.position
			
	elif event is InputEventScreenDrag: 		
		if event.position.distance_to(swipe_start_position) > swipe_threshold:
			if event.position.y < swipe_start_position.y:
				if current_planet < 7:
					move_to_planet(current_planet, current_planet + 1)
					current_planet += 1
			elif event.position.y > swipe_start_position.y:
				if current_planet > 1:
					move_to_planet(current_planet, current_planet - 1)
					current_planet -= 1

	if Input.is_action_just_pressed("ui_up"):
		if current_planet < 7:
			move_to_planet(current_planet, current_planet + 1)
			current_planet += 1
	
	if Input.is_action_just_pressed("ui_down"):
		if current_planet > 1:
			move_to_planet(current_planet, current_planet - 1)
			current_planet -= 1

	if Input.is_action_just_pressed("ui_accept"):  
		enter_level()

	if event is InputEventScreenTouch and not event.pressed:
		if is_planet_clicked(event.position):
			enter_level()

func is_planet_clicked(click_position: Vector2) -> bool:
	match current_planet:
		1: return planet_one.get_global_rect().has_point(click_position)
		2: return planet_two.get_global_rect().has_point(click_position)
		3: return planet_three.get_global_rect().has_point(click_position)
		4: return planet_four.get_global_rect().has_point(click_position)
		5: return planet_five.get_global_rect().has_point(click_position)
		6: return planet_six.get_global_rect().has_point(click_position)
		7: return planet_seven.get_global_rect().has_point(click_position)
	return false

func enter_level():
	match current_planet:
		7:
			get_tree().change_scene_to_file("res://2d_array_game.tscn")
		6: 
			get_tree().change_scene_to_file("res://array_lesson.tscn")
		5: 
			get_tree().change_scene_to_file("res://StringsGame.tscn")
		4:
			get_tree().change_scene_to_file("res://loopGame.tscn")
		3:
			get_tree().change_scene_to_file("res://OperatorGame.tscn")
		2:
			get_tree().change_scene_to_file("res://var_game.tscn")
		_:
			get_tree().change_scene_to_file("res://level_one.tscn")

func _on_animation_finished(anim_name):
	moving = false  
	match anim_name:
		"MoveToPlanetTwo": space_guy.position = planet_two.position  
		"MoveToPlanetThree": space_guy.position = planet_three.position
		"MoveToPlanetFour": space_guy.position = planet_four.position
		"MoveToPlanetFive": space_guy.position = planet_five.position
		"MoveToPlanetSix": space_guy.position = planet_six.position
		"MoveToPlanetSeven": space_guy.position = planet_seven.position
		"MoveFromPlanetTwo": space_guy.position = planet_one.position
		"MoveFromPlanetThree": space_guy.position = planet_two.position
		"MoveFromPlanetFour": space_guy.position = planet_three.position
		"MoveFromPlanetFive": space_guy.position = planet_four.position
		"MoveFromPlanetSix": space_guy.position = planet_five.position
		"MoveFromPlanetSeven": space_guy.position = planet_six.position
	

	anim_spaceguy.play("default")
	update_lesson_text()

func update_lesson_text():
	if current_planet in lesson_texts:
		lesson_label.text = lesson_texts[current_planet]
