
extends Node2D

@export var image_paths: Array[String] = [
	"res://speechBox/speech_....png",
	"res://speechBox/speech_welcome.png",
	"res://speechBox/sp_letsLook.png",
	"res://speechBox/sp_boilerPlate.png",
	"res://speechBox/sp_whatIsThis.png",
	"res://speechBox/sp_dontworry.png",
	"res://speechBox/sp_justKnow.png",
	"res://speechBox/sp_everyJava.png",
	"res://speechBox/speech_var.png"
]

@export var captions: Array[String] = [
	"THIS IS WHERE YOU WILL SEE CODE",
	"",
	"The following code is needed for\nany java file to run!",
	"public class (the name of your .java file){\n\tpublic static void main(String args []){\n\t}\n}",
	"public class (the name of your .java file){\n\tpublic static void main(String args []){\n\t\t-->we write all our code here!\n\t}\n}",
	"public class (the name of your .java file){\n\tpublic static void main(String args []){\n\t\tSystem.out.println(\"Hello World\")\n\t}\n}",
	"public class (the name of your .java file){\n\tpublic static void main(String args []){\n\t\tSystem.out.println(\"Hello World\")\n\t\t//anything written in comments\n\t\t//is ignored by java\n\t\t//so feel free to write descriptions\n\t\t//like this!\n\t}\n}",
	"public class (the name of your .java file){\n\tpublic static void main(String args []){\n\t\tSystem.out.println(\"Hello World\")\n\t\t/*\n\t\tmultiline comments can be \n\t\tadded simply as such!\n\t\t*/\n\t}\n}",
	"Variable Explanation"
]

var images: Array[Texture2D] = []
var current_image_index: int = 0
var sprite: Sprite2D
var label: Label
var quiz_timer: Timer
var quiz_active: bool = false
var quiz_options: Array[Button] = []
var quiz_correct_option: int = 0




func _ready():
	
	for path in image_paths:
		var image = load(path) as Texture2D
		if image:
			images.append(image)
		else:
			print("Failed to load image: " + path)
	
	
	sprite = $Node2D/ImageSprite as Sprite2D
	label = $Node2D/TextLabel as Label
	quiz_timer = $Node2D/QuizTimer as Timer
	quiz_options = [
		$Node2D/ButtonContainer/OptionButton1,
		$Node2D/ButtonContainer/OptionButton2,
		$Node2D/ButtonContainer/OptionButton3,
		$Node2D/ButtonContainer/OptionButton4
	]


	quiz_timer.wait_time = 10
	quiz_timer.one_shot = true
	quiz_timer.connect("timeout", Callable(self, "_on_quiz_timeout"))
	

	var options_text = ["public", "class", "comment", "domain"]
	quiz_correct_option = 0  
	for i in range(quiz_options.size()):
		var btn = quiz_options[i]
		btn.text = options_text[i]
		btn.visible = false
		btn.connect("pressed", Callable(self, "_on_quiz_option_selected").bind(i))

	
	if images.size() > 0:
		set_image(sprite, images[current_image_index])
		update_caption()
	else:
		print("No images were loaded successfully.")


func _input(event: InputEvent):
	if !quiz_active:
	
		if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
			
				if images.size() > 0 and sprite != null:
					current_image_index = (current_image_index + 1) % images.size()
					set_image(sprite, images[current_image_index])
					update_caption()
					if current_image_index == 7:  
						start_quiz()

func set_image(sprite_node: Sprite2D, texture: Texture2D):
	sprite_node.texture = texture
	adjust_position(sprite_node)

func adjust_position(sprite_node: Sprite2D):
	var base_position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 1.5)
	sprite_node.position = base_position
	
	if sprite_node.texture:
		var size = sprite_node.texture.get_size()
		sprite_node.offset = -size / 2.0
	else:
		sprite_node.offset = Vector2.ZERO

func update_caption():
	if label != null and current_image_index < captions.size():
		label.text = captions[current_image_index]

func start_quiz():
	quiz_active = true
	label.text = "Fill in the blank:\n_____ static void main"
	label.visible = true
	for btn in quiz_options:
		btn.visible = true
	quiz_timer.start()

func _on_quiz_option_selected(selected_index: int):
	if quiz_active:
		if selected_index == quiz_correct_option:
			print("Correct answer!")
		else:
			print("Wrong answer!")
		end_quiz()

func _on_quiz_timeout():
	if quiz_active:
		print("Time's up!")
		end_quiz()

func end_quiz():
	quiz_active = false
	label.visible = false
	for btn in quiz_options:
		btn.visible = false
	quiz_timer.stop()
