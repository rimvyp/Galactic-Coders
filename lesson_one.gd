
extends Control

var image_paths = []
var current_index = 0
var second_folder_loaded = false
var load_second_folder_flag = false  

@onready var next_button = $Next
@onready var back_button = $Back
@onready var texture_rect = $ImageOnComputer


var lesson_folders = {
	"HelloWorld": "res://LessonsImages/Les1/",
	"Variables": "res://LessonsImages/Les2/",
	"Operators": "res://LessonsImages/Les3/",
	"Loops": "res://LessonsImages/Les4/",
	"Strings": "res://LessonsImages/Les5/",
	"1DArrays": "res://LessonsImages/Les6/",
	"2DArrays": "res://LessonsImages/Les7/"
}

func _ready():
	next_button.visible = false
	back_button.visible = false

	if GameState.button_id in lesson_folders:
		load_second_folder_flag = true  

	$AnimatedSprite2D/AnimationPlayer.play("walk_to_lesson")
	await $AnimatedSprite2D/AnimationPlayer.animation_finished

	load_images_from_folder("res://LessonsImages/DefaultComp/") 
	cycle_images()

func load_images_from_folder(folder_path):
	image_paths.clear()
	current_index = 0

	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".png") or file_name.ends_with(".jpg"):
				image_paths.append(folder_path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Failed to open folder: " + folder_path)

func cycle_images():
	if image_paths.size() > 0:
		var image = Image.load_from_file(image_paths[current_index])
		if image:
			var texture = ImageTexture.create_from_image(image)
			texture_rect.texture = texture

			current_index += 1

			if current_index < image_paths.size():
				await get_tree().create_timer(1.0).timeout
				cycle_images()
			else:
				if load_second_folder_flag: 
					load_second_folder()

func load_second_folder():
	if GameState.button_id in lesson_folders:
		load_images_from_folder(lesson_folders[GameState.button_id])
		second_folder_loaded = true

	next_button.visible = true
	back_button.visible = true
	display_image()

func display_image():

	if current_index < 0:
		current_index = 0
	if current_index >= image_paths.size():
		current_index = image_paths.size() - 1

	
	var image = Image.load_from_file(image_paths[current_index])
	if image:
		var texture = ImageTexture.create_from_image(image)
		texture_rect.texture = texture

	
	back_button.visible = current_index > 0

	
	next_button.visible = current_index < image_paths.size() - 1

func _on_Next_pressed():
	if second_folder_loaded:
		current_index += 1
		if current_index < image_paths.size():
			display_image()
		else:
			current_index = image_paths.size() - 1  

func _on_Back_pressed():
	if second_folder_loaded:
		current_index -= 1
		if current_index >= 0:
			display_image()
		else:
			current_index = 0 

func _on_home_pressed():
	var target_scene = preload("res://welcome_screen.tscn")   
	get_tree().change_scene_to_packed(target_scene)
