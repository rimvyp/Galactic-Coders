extends Node2D  

const GRID_SIZE = 100  
const GRID_WIDTH = 10  

var current_index: int = 0  
var is_moving: bool = false  
var grid_start_x: float = 0  
var grid_start_y: float = 600  

var tile_texture: ImageTexture  
var current_question_index: int = 0  
var correct_answers: int = 0 
var wrong_answers: int = 3


var fruit_textures = []
var fruit_sprites = []



@onready var sprite = $AnimatedSprite2D  
@onready var question_label = $TextureRect/RichTextLabel  
@onready var next_button = $Next  
@onready var back_button = $Back  
@onready var score_label = $ScoreLabel 
@onready var make_choice_button = $MAKE_CHOICE 
@onready var feedback_label = $FeedbackLabel  
@onready var falling_sprite = $SpaceGuy/CharacterBody2D
@onready var alien = $alien/AnimationPlayer
@onready var fade = $fade


var questions = [
	{"question": "Move to the first element of the array.", "answer": 0},
	{"question": "Move to the last element of the array.", "answer": GRID_WIDTH - 1},
	{"question": "Move to the index where the cherry is stored in.", "answer": 2},
	{"question": "Move to the element before the watermelon in the array.", "answer": GRID_WIDTH - 2},
	{"question": "Move to index 4!", "answer": 4},
	{"question": "Move to the index between the orange and the grape ", "answer": 4}
]



func _ready():
	
	fade.play("fade_in")
	var screen_width = get_viewport_rect().size.x 
	grid_start_x = (screen_width - (GRID_WIDTH * GRID_SIZE)) / 2  

	var offset_x = 50  
	sprite.position = Vector2(grid_start_x + (current_index * GRID_SIZE) + offset_x, grid_start_y)  
	sprite.play("idle")  


	load_fruit_images()
	create_fruit_sprites()

	var image = load("res://arrays/tile.png").get_image()
	if image:
		tile_texture = ImageTexture.create_from_image(image)
		tile_texture.set_size_override(Vector2(GRID_SIZE, GRID_SIZE))  

	queue_redraw()  

	await _move_loop()
	display_question()
	update_score_display()
	feedback_label.text = ""  

	next_button.pressed.connect(_on_Next_pressed)
	back_button.pressed.connect(_on_Back_pressed)
	make_choice_button.pressed.connect(_on_MakeChoice_pressed)



func load_fruit_images():
	var fruit_dir = "res://assets/Fruits/Fruits/Fruits_Separated/"
	var dir = DirAccess.open(fruit_dir)
	
	if dir:
		dir.list_dir_begin()
		var file_names = []
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".png"):  
				file_names.append(file_name)
			file_name = dir.get_next()
		
		
		file_names.sort()
		
		
		for name in file_names:
			var texture = load(fruit_dir + name)
			fruit_textures.append(texture)




func create_fruit_sprites():
	
	if fruit_textures.size() != GRID_WIDTH:
		print("Warning: Number of fruit images does not match GRID_WIDTH")

	for i in range(GRID_WIDTH):
		var sprite = Sprite2D.new()
		sprite.texture = fruit_textures[i] 
		

		sprite.scale = Vector2(2, 2)  


		sprite.position = Vector2(grid_start_x + i * GRID_SIZE + GRID_SIZE / 2, grid_start_y - 150)  
		
		add_child(sprite)
		fruit_sprites.append(sprite)


func display_question():
	question_label.text = questions[current_question_index]["question"]  
	queue_redraw() 

func cycle_question():
	current_question_index = (current_question_index + 1) % questions.size() 
	display_question()  
	feedback_label.text = ""  

func update_score_display():
	score_label.text = "Lives: " + str(wrong_answers)  

func _draw():
	var screen_size = get_viewport_rect().size  
	var screen_rect = Rect2(Vector2.ZERO, screen_size)  

	var font: Font = ThemeDB.fallback_font
	var font_size = 20  

	for i in range(GRID_WIDTH):
		var x = grid_start_x + i * GRID_SIZE
		var tile_position = Vector2(x, grid_start_y)  
		var tile_rect = Rect2(tile_position, Vector2(GRID_SIZE, GRID_SIZE))  

		if tile_texture:
			draw_texture_rect(tile_texture, tile_rect, false)  

		var text = str(i)
		var text_size = font.get_string_size(text, font_size)  
		var text_position = Vector2(x + (GRID_SIZE / 2) - (text_size.x / 2), grid_start_y + GRID_SIZE + 20)  

		draw_string(font, text_position, text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_A and current_index > 0 and not is_moving:  
			move_player(-1, "walk_left")
		elif event.keycode == KEY_D and current_index < GRID_WIDTH - 1 and not is_moving: 
			move_player(1, "walk_right")

func move_player(direction: int, animation: String):
	if is_moving:
		return  

	current_index += direction  
	var offset_x = 50  
	var new_position = Vector2(grid_start_x + (current_index * GRID_SIZE) + offset_x, grid_start_y)  

	sprite.play(animation)  

	is_moving = true
	var tween = create_tween()
	tween.tween_property(sprite, "position", new_position, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)  
	await tween.finished  

	sprite.play("idle")  
	is_moving = false

	queue_redraw()  

func _on_Next_pressed():
	if current_index < GRID_WIDTH - 1 and not is_moving:
		move_player(1, "walk_right")

func _on_Back_pressed():
	if current_index > 0 and not is_moving:
		move_player(-1, "walk_left")

func _on_MakeChoice_pressed():
	check_answer()

func _move_loop():
	for i in range(1, GRID_WIDTH):
		await move_player(1, "walk_right")

	for i in range(1, GRID_WIDTH):
		await move_player(-1, "walk_left")

func check_answer():
	var correct_index = questions[current_question_index]["answer"]
	
	if current_index == correct_index:
		correct_answers += 1  
		update_score_display()  
		feedback_label.text = "Correct!"  
		await get_tree().create_timer(1.0).timeout  
		
	
		if correct_answers == questions.size():
			declare_victory()
			return
		
		cycle_question()  
	else:
		wrong_answers -= 1  
		update_score_display()  
		feedback_label.text = "Wrong answer!"
		
		if wrong_answers <= 0:
			alien.play("alien_attack")
			await alien.animation_finished
			feedback_label.text = ""
			question_label.text= "Game Over! The alien attacked! 👽"
			next_button.disabled = true
			back_button.disabled = true
			make_choice_button.disabled = true
			fade.play("fade_out")
			await fade.animation_finished
			get_tree().change_scene_to_file("res://levelSelector.tscn")  


func declare_victory():
	question_label.text = "Victory! You answered all questions correctly!"
	await get_tree().create_timer(2.0).timeout  

	fade.play("fade_out")
	await fade.animation_finished
	get_tree().change_scene_to_file("res://levelSelector.tscn")  
