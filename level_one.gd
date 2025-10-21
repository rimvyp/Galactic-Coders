

extends Node2D

@onready var animation_playerP = $the_player/AnimationPlayer
@onready var animation_playerE = $the_enemy/AnimationPlayer
@onready var player_hearts = $PlayerHearts
@onready var enemy_hearts = $EnemyHearts
@onready var fade = $CanvasLayer/AnimationPlayer
@onready var question_image = $QuestionImage
@onready var laser = $the_player/AnimationPlayer/attack
@onready var answer_buttons = [
	$Answer1,
	$Answer2,
	$Answer3,
	$Answer4
]

var questions = [
	{
		"image": "res://questions/L1Q1.png",
		"answers": ["void", "file", "class", "null"],
		"correct": "class"
	},
	{
		"image": "res://questions/L1Q2.png",
		"answers": ["An Image", "Hello World!", "An Error", "A Working Car"],
		"correct": "An Error"
	},
	{
		"image": "res://questions/L1Q3.png",
		"answers": ["Opens file.java", "Prints location of file.java", "Just the word: file.java", "The code in file.java"],
		"correct": "Just the word: file.java"
	},
	{
		"image": "res://questions/L1Q4.png",
		"answers": [";", "java", ":", "@"],
		"correct": ";"
	}
]

var current_question_index = 0

func _ready():
	laser.visible = false
	fade.play("fade_in")
	$Timer.start()
	await $Timer.timeout
	animation_playerP.play("move_player_onto_screen")
	animation_playerE.play("move_enemey_onto_screen")

	for button in answer_buttons:
		button.pressed.connect(_on_answer_selected.bind(button))
	
	update_question()

func update_question():
	var question_data = questions[current_question_index]
	question_image.texture = load(question_data["image"])

	for i in range(4):
		var label = answer_buttons[i].get_node("Label")
		label.text = "[center]" + question_data["answers"][i]
		label.bbcode_enabled = true

func _on_answer_selected(button):
	var selected_answer = button.get_node("Label").text.replace("[center]", "")
	var correct_answer = questions[current_question_index]["correct"]

	if selected_answer == correct_answer:
		animation_playerP.play("player_atk")
		current_question_index += 1
		remove_heart(enemy_hearts)
		if current_question_index < questions.size():
			update_question()
		else:
			get_tree().change_scene_to_file("res://asteroidMinigame.tscn")
	else:
		animation_playerE.play("enemy_attack")
		remove_heart(player_hearts)

func remove_heart(heart_container: Control):
	var hearts = heart_container.get_children()
	for i in range(hearts.size() - 1, -1, -1):
		if hearts[i] is TextureRect and hearts[i].visible:
			hearts[i].visible = false
			break

	var hearts_left = 0
	for heart in hearts:
		if heart.visible:
			hearts_left += 1

	if hearts_left == 0:
		if heart_container == player_hearts:
			print("Game Over: You lost!")
			$Timer.start()
			await $Timer.timeout
			fade.play("fade_out")
			await fade.animation_finished
			
			var target_scene = preload("res://levelSelector.tscn")   
			get_tree().change_scene_to_packed(target_scene)
		elif heart_container == enemy_hearts:
			print("You won!")
			#await animation_playerE.animation_finished
			$Timer.start()
			await $Timer.timeout
			fade.play("fade_out")
			await fade.animation_finished
			var target_scene = preload("res://levelSelector.tscn")   
			get_tree().change_scene_to_packed(target_scene)
