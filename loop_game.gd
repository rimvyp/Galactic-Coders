extends Node2D

var angle = 0  
var radius = 400  
var speed = 5 
var center = Vector2.ZERO  
var loops_completed = 0  
var max_loops = 3  
var stopping = false 
var awaiting_answer = false  
@onready var alien = $alien/AnimationPlayer
@onready var loop = $loop  
@onready var opt1 = $option1  
@onready var opt2 = $option2  
@onready var question = $question  
@onready var spaceship = $spaceship  
@onready var fade = $fade
@onready var timer = $Timer
@onready var intro = $Intro

var loop_texts = [
	{ "code": """int x = 0
while(x < 10){
   x++;
}""", "correct": 10, "wrong": 9 },

	{ "code": """int x = 3
for(int i = 0; i < 3; i++){
   x++;
}""", "correct": 6, "wrong": 5 },

	{ "code": """int x = 5
while(x >= 2){
   x--;
}""", "correct": 2, "wrong": 3 }
]

var current_loop_index = 0

func _ready():
	fade.play("fade_in")
	intro.text = "You need to guess the right number of orbits our spaceship needs to do, to protect from an alien invader!"
	center = spaceship.position  
	loop.visible = false  
	question.visible = false  
	opt1.visible = false  
	opt2.visible = false
	awaiting_answer = false  
	opt1.pressed.connect(_on_option1_pressed)
	opt2.pressed.connect(_on_option2_pressed)

func _process(delta):
	if not awaiting_answer and (loops_completed < max_loops or not stopping):
		angle += speed * delta  
		var x = center.x + cos(angle) * radius
		var y = center.y + sin(angle) * radius
		spaceship.position = Vector2(x, y)  
		if angle >= TAU:  
			angle -= TAU  
			loops_completed += 1  
		if loops_completed >= max_loops and abs(angle - PI / 2) < 0.05:
			stopping = true  
			angle = PI / 2  
			awaiting_answer = true  
			intro.visible = false 
			display_loop()
	else:
		spaceship.position = Vector2(center.x, center.y + radius)

func display_loop():
	loop.visible = true
	question.visible = true
	opt1.visible = true
	opt2.visible = true
	loop.text = loop_texts[current_loop_index]["code"]
	question.text = "What is the final value of x?"
	var correct = str(loop_texts[current_loop_index]["correct"])
	var wrong = str(loop_texts[current_loop_index]["wrong"])
	if randi() % 2 == 0:
		opt1.text = correct
		opt2.text = wrong
		opt1.set_meta("correct", true)
		opt2.set_meta("correct", false)
	else:
		opt1.text = wrong
		opt2.text = correct
		opt1.set_meta("correct", false)
		opt2.set_meta("correct", true)

func _on_option1_pressed():
	if opt1.get_meta("correct"):
		start_movement(int(opt1.text))
	else:
		display_invader_message()

func _on_option2_pressed():
	if opt2.get_meta("correct"):
		start_movement(int(opt2.text))
	else:
		display_invader_message()

func start_movement(correct_loops: int):
	loop.visible = false
	question.visible = false
	opt1.visible = false
	opt2.visible = false
	max_loops = correct_loops
	loops_completed = 0
	stopping = false
	awaiting_answer = false  
	await wait_for_loops_to_finish()
	next_loop()

func display_invader_message():
	question.text = "Aliens have invaded!"
	alien.play("alien_attack")
	question.visible = true  
	awaiting_answer = true
	stopping = true
	timer.start()
	await timer.timeout
	fade.play("fade_out")
	await fade.animation_finished
	get_tree().change_scene_to_file("res://levelSelector.tscn")  

func wait_for_loops_to_finish():
	while loops_completed < max_loops:
		await get_tree().process_frame

func next_loop():
	current_loop_index += 1
	
	if current_loop_index < loop_texts.size():
		display_loop() 
	else:
		current_loop_index = loop_texts.size() - 1  
		loop.visible = false
		opt1.visible = false
		opt2.visible = false
		question.text = "You have completed all loops!"
		question.visible = true 
		awaiting_answer = true
		stopping = true  
		await get_tree().create_timer(2.0).timeout  
		fade.play("fade_out")
		await fade.animation_finished
		get_tree().change_scene_to_file("res://levelSelector.tscn")
