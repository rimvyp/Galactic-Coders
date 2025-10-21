
extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var back = $back
@onready var battery = $Battery
@onready var b1 = $b1
@onready var b2 = $b2
@onready var b3 = $b3
@onready var b4 = $b4
@onready var b5 = $b5
@onready var text_cont = $textCont
@onready var label = $Label
@onready var opt1 = $opt1/Label
@onready var opt2 = $opt2/Label
@onready var left = $left 
@onready var right = $right 
@onready var spaceguy = $space_guy/AnimatedSprite2D
@onready var fade =$fade

var questions = [
	["int x = 10;", "boolean x = yes!"], 
	["String s = \"Hello\";", "String s = Hello;"], 
	["int a = 10;", "int = 45;"], 
	["float number = 3.5;", "float = 3.5;"], 
	["boolean isOn = true;", "bool isOn = yes;"], 
	["char letter = 'A';", "char letter = A;"], 
	["String name = \"John\";", "String name = John;"], 
	["int apples = 5;", "integer apples = 5;"], 
	["boolean light = false;", "bool light = no;"], 
	["double pi = 3.14;", "double = 3.14;"], 
	["var speed = 100;", "variable speed = 100;"], 
	["String car = \"Tesla\";", "String car = Tesla;"], 
	["int total = 20;", "integer total = 20;"], 
	["char symbol = '$';", "char symbol = $;"], 
	["boolean happy = true;", "boolean happy = yes;"], 
	["float temperature = 36.6;", "float temp = hot;"], 
	["String city = \"Dublin\";", "String city = Dublin;"], 
	["int num = 7;", "int = seven;"], 
	["double score = 9.8;", "double score = high;"], 
	["char grade = 'B';", "char grade = Good;"]
]

var correct_answer = "" 
var battery_level = 1 

func _ready() -> void:
	fade.play("fade_in")
	await get_tree().create_timer(3.0).timeout
	spaceguy.play("middle")
	label.text = "Help Power Up The Spaceships Battery By Picking The Correct Variable!"
	
	await get_tree().create_timer(3.0).timeout
	label.text = "If You Answer Wrong Your Battery Will Drain So Be Careful!"
	
	start_game() 
	show_question()


	left.connect("pressed", _on_left_pressed)
	right.connect("pressed", _on_right_pressed)

func start_game():
	animation_player.play("b1in") 
	print("Starting game with battery level: ", battery_level) 

func show_question():
	var question = questions[randi() % questions.size()]
	var correct = question[0]
	var incorrect = question[1]


	if randi() % 2 == 0:
		opt1.text = correct
		opt2.text = incorrect
		correct_answer = correct
	else:
		opt1.text = incorrect
		opt2.text = correct
		correct_answer = correct

	print("New Question: " + opt1.text + " | " + opt2.text)  

func _on_left_pressed():
	animation_player.play("walk_left")
	spaceguy.play("left")
	await get_tree().create_timer(2.0).timeout
	animation_player.play("walk_backleft")
	spaceguy.play("right")
	await get_tree().create_timer(2.0).timeout
	check_answer(opt1.text)

func _on_right_pressed():
	animation_player.play("walk_right")
	spaceguy.play("right")
	await get_tree().create_timer(2.0).timeout
	animation_player.play("walk_backright")
	spaceguy.play("left")
	await get_tree().create_timer(2.0).timeout
	check_answer(opt2.text)

func check_answer(selected_answer):
	if selected_answer == correct_answer:
		label.text = "Correct! The spaceship charges up!"
		battery_increase()
	else:
		label.text = "Wrong! The battery drains!"
		battery_decrease()

	print("Battery Level: ", battery_level) 

	await get_tree().create_timer(2.0).timeout
	show_question()

func battery_increase():
	if battery_level < 5: 
		battery_level += 1
		match battery_level:
			2: animation_player.play("b2in")
			3: animation_player.play("b3in")
			4: animation_player.play("b4in")
			5: 
				animation_player.play("b5in")
				win_game()
	else:
		print("Battery is already full!")

func battery_decrease():
	if battery_level > 1:
		match battery_level:
			5: animation_player.play("b5in_2")
			4: animation_player.play("b4in_2")
			3: animation_player.play("b3in_2")
			2: animation_player.play("b2in_2")
		battery_level -= 1
	else:
		animation_player.play("b1in_2")
		lose_game()

func win_game():
	label.text = "You fully charged the battery! You win!"
	await get_tree().create_timer(2.0).timeout
	fade.play("fade_out")
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://levelSelector.tscn")

func lose_game():
	label.text = "Battery drained! Game Over!"
	await get_tree().create_timer(2.0).timeout
	fade.play("fade_out")
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://levelSelector.tscn")
	
