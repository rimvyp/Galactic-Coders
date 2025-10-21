extends Node2D

@onready var gun = $gun
@onready var left = $left
@onready var right = $right
@onready var text = $Text
@onready var makeChoice = $MAKE_CHOICE
@onready var bullet = $bullet

@onready var text1 = $box1/label
@onready var text2 = $box2/label
@onready var animations = $AnimationPlayer
@onready var fade = $fade
@onready var score = $score

const ROTATION_LEFT := -30.0  
const ROTATION_RIGHT := 30.0  
const ROTATION_TIME := 0.2 
const BULLET_SPEED := 750  
const BULLET_DURATION := 0.7  
const INTRO_DELAY := 5.0  

var current_rotation := 0  
var current_question = {}
var ui_locked: bool = false
var correct_answers := 0

var questions = [
	{
		"question": "int a = 5;\nint b = 3;\nSystem.out.println(a + b);",
		"correct": "8",
		"wrong": "15"
	},
	{
		"question": "int a = 8;\nint b = 2;\nSystem.out.println(a - b);",
		"correct": "6",
		"wrong": "10"
	},
	{
		"question": "int a = 4;\nint b = 3;\nSystem.out.println(a * b);",
		"correct": "12",
		"wrong": "7"
	},
	{
		"question": "int a = 9;\nint b = 3;\nSystem.out.println(a / b);",
		"correct": "3",
		"wrong": "6"
	},
	{
		"question": "boolean result = (5 > 3);\nSystem.out.println(result);",
		"correct": "true",
		"wrong": "false"
	},
	{
		"question": "boolean result = (4 < 2);\nSystem.out.println(result);",
		"correct": "false",
		"wrong": "true"
	},
	{
		"question": "boolean result = (6 == 6);\nSystem.out.println(result);",
		"correct": "true",
		"wrong": "false"
	},
	{
		"question": "boolean result = (7 != 5);\nSystem.out.println(result);",
		"correct": "true",
		"wrong": "false"
	}
]

func _ready() -> void:
	fade.play("fade_in")
	text.text = "The ship is broken, help select which shipment is correct and don't let in aliens, they snuck in fakes!"
	_disable_choices()  
	score.text = ""  

	await get_tree().create_timer(INTRO_DELAY).timeout

	_enable_choices()
	_generate_question()
	_update_score_label()

	left.pressed.connect(_rotate_left)
	right.pressed.connect(_rotate_right)
	makeChoice.pressed.connect(_shoot_bullet)

func _disable_choices() -> void:
	text1.text = ""
	text2.text = ""
	ui_locked = true

func _enable_choices() -> void:
	ui_locked = false

func _generate_question() -> void:
	current_question = questions.pick_random()
	text.text = current_question["question"]

	if randi() % 2 == 0:
		text1.text = current_question["correct"]
		text2.text = current_question["wrong"]
	else:
		text1.text = current_question["wrong"]
		text2.text = current_question["correct"]

	current_rotation = 0
	_rotate_gun(0)

func _update_score_label() -> void:
	score.text = "Parts collected: %d/%d" % [correct_answers, questions.size()]

func _rotate_left() -> void:
	if ui_locked:
		return
	if current_rotation != -1: 
		current_rotation = -1
		_rotate_gun(ROTATION_LEFT)

func _rotate_right() -> void:
	if ui_locked:
		return
	if current_rotation != 1: 
		current_rotation = 1
		_rotate_gun(ROTATION_RIGHT)

func _rotate_gun(target_rotation: float) -> void:
	var tween = create_tween()
	tween.tween_property(gun, "rotation_degrees", target_rotation, ROTATION_TIME)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _shoot_bullet() -> void:
	if ui_locked or current_rotation == 0:
		return

	ui_locked = true

	var new_bullet = bullet.duplicate()
	new_bullet.position = gun.position  
	new_bullet.rotation_degrees = gun.rotation_degrees  
	get_parent().add_child(new_bullet)

	var bullet_direction = Vector2.UP.rotated(gun.rotation)  
	var tween = new_bullet.create_tween()
	tween.tween_property(new_bullet, "position", new_bullet.position + bullet_direction * BULLET_SPEED, BULLET_DURATION)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT) 

	await get_tree().create_timer(BULLET_DURATION).timeout
	new_bullet.queue_free()

	var selected_answer: String
	if current_rotation == -1:
		selected_answer = text1.text
	elif current_rotation == 1:
		selected_answer = text2.text
	else:
		ui_locked = false
		return

	if selected_answer == current_question["correct"]:
		correct_answers += 1
		_update_score_label()
		text.text = "Correct, part for ship collected!"
		animations.play("part")
		await animations.animation_finished

		if correct_answers == questions.size():
			text.text = "Congratulations, the ship is repaired!"
			_disable_choices()
			await get_tree().create_timer(2.0).timeout
			fade.play("fade_out")
			await get_tree().create_timer(2.0).timeout
			get_tree().change_scene_to_file("res://levelSelector.tscn")
		else:
			await get_tree().create_timer(1.5).timeout
			_generate_question()
	else:
		text.text = "Oh no! You let an alien in!"
		animations.play("enemy")
		await animations.animation_finished
		await get_tree().create_timer(1.0).timeout
		fade.play("fade_out")
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://levelSelector.tscn")

	ui_locked = false
