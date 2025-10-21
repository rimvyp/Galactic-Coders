extends Node

var password = []  
var attempts_left = 6  
var guessed_positions = []  


var buttons = {}
var labels = [] 
var containers = [] 

func _ready():
	randomize()  


	password.clear()
	for i in range(4):
		password.append(randi() % 10)

	print("Generated Password: ", password)  


	$AttemptsLabel.text = "Attempts left: " + str(attempts_left)

	
	for i in range(1, 10): 
		var button = $HBoxContainer.get_node("B" + str(i))
		var label = button.get_node("Label") if button.has_node("Label") else null  
		if label and label is Label:
			buttons["B" + str(i)] = label
		else:
			print("Warning: Label not found inside ", button.name)

	
	var button_b0 = $B0
	var label_b0 = button_b0.get_node("Label") if button_b0.has_node("Label") else null
	if label_b0 and label_b0 is Label:
		buttons["B0"] = label_b0
	else:
		print("Warning: Label not found inside B0")

	
	labels = [
		$Num1.get_node("Label"),
		$Num2.get_node("Label"),
		$Num3.get_node("Label"),
		$Num4.get_node("Label")
	]

	
	containers = [
		$Num1,
		$Num2,
		$Num3,
		$Num4
	]

	guessed_positions = [false, false, false, false]  

	
	for button_name in buttons.keys():
		var button_node = get_node("HBoxContainer/" + button_name) if button_name != "B0" else $B0
		button_node.pressed.connect(_on_button_pressed.bind(button_name))




func _on_button_pressed(button_name):
	if attempts_left > 0 and button_name in buttons:
		var number_pressed = int(buttons[button_name].text)  
		var found = false 

		
		for i in range(4):
			if password[i] == number_pressed and not guessed_positions[i]:  
				guessed_positions[i] = true 
				labels[i].text = str(number_pressed) 
				containers[i].modulate = Color(0, 1, 0)  
				found = true  

		
		if not found:
			attempts_left -= 1
			$AttemptsLabel.text = "Attempts left: " + str(attempts_left)

		
		if guessed_positions.all(func(g): return g):  
			check_guess()
		elif attempts_left == 0:
			game_over()



func check_guess():
	if guessed_positions.all(func(g): return g):
		print("Correct Password!")
		$PasswordLabel.text = "✅ Correct Password!"
	else:
		print("Wrong Password")
		$PasswordLabel.text = "❌ Wrong Password!"
		reset_game()

func game_over():
	print("Game Over! No attempts left.")
	$PasswordLabel.text = "            OUT OF TRIES"
	
	
	for button_name in buttons.keys():
		var button_node = get_node("HBoxContainer/" + button_name) if button_name != "B0" else $B0
		button_node.disabled = true  


	get_tree().create_timer(10.0).timeout.connect(reset_game)

func reset_game():
	guessed_positions.fill(false) 
	attempts_left = 5  
	$AttemptsLabel.text = "Attempts left: " + str(attempts_left)
	
	
	for label in labels:
		label.text = "_"  
	for container in containers:
		container.modulate = Color(1, 1, 1)  

	
	for button_name in buttons.keys():
		var button_node = get_node("HBoxContainer/" + button_name) if button_name != "B0" else $B0
		button_node.disabled = false  

	
	_ready()  
