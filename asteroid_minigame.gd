extends Node2D

@onready var animation_player = $AnimationPlayer
@export var spawn_interval: float = 0.60  
@export var spawn_area_width: float = 1080  
@onready var asteroid = $Asteroid  

var countdown_time: int = 16 
var game_over_state: bool = false  

@onready var timer_label = $CanvasLayer2/TimerLabel
@onready var game_timer = Timer.new()  


	
func _ready():
	asteroid.visible = false  

	animation_player.play("fade_in")
	await get_tree().create_timer(6.0).timeout  

	start_timer()
	start_spawning()


func start_timer():
	game_timer.wait_time = 1.0  
	game_timer.timeout.connect(_on_Timer_timeout)
	add_child(game_timer)
	game_timer.start()


func _on_Timer_timeout():
	if game_over_state:
		return  

	countdown_time -= 1  
	timer_label.text = str(countdown_time) 

	if countdown_time <= 0:
		on_victory() 
		


func start_spawning():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn_asteroid)
	timer.start()



func spawn_asteroid():
		if game_over_state:
				return  

		var new_asteroid = asteroid.duplicate()  
		new_asteroid.visible = true
		new_asteroid.global_position = Vector2(randi_range(0, spawn_area_width), -50)  
		new_asteroid.add_to_group("asteroids")  

		new_asteroid.connect("body_entered", Callable(self, "_on_asteroid_collided"))

		add_child(new_asteroid)  



func _on_asteroid_collided(body):
	if body.name == "SpaceshipForMinigame":
		freeze_objects() 
		on_game_over()




func freeze_objects():
	for asteroid in get_tree().get_nodes_in_group("asteroids"):
		if asteroid is RigidBody2D:
#			
			asteroid.linear_velocity = Vector2.ZERO  
			asteroid.angular_velocity = 0 
			asteroid.gravity_scale = 0  
		
		
		asteroid.set_physics_process(false)
		asteroid.set_process(false)


	var spaceship = get_node_or_null("SpaceshipForMinigame")  
	if spaceship and spaceship is RigidBody2D:
		spaceship.freeze = true
		spaceship.linear_velocity = Vector2.ZERO
		spaceship.angular_velocity = 0
		spaceship.gravity_scale = 0  
		spaceship.set_physics_process(false)
		spaceship.set_process(false)


func on_game_over():
	if game_over_state:
		return  

	game_over_state = true  
	game_timer.stop()  

	timer_label.text = "You\nLost!"  

	
	timer_label.position.x -= 120

	animation_player.play("fade_out") 

	await animation_player.animation_finished  
	
	get_tree().paused = false 
	
	get_tree().change_scene_to_file("res://levelSelector.tscn")

func on_victory():
	if game_over_state:
		return  

	game_over_state = true  
	game_timer.stop()  

	
	timer_label.text = "You\nWon!"  
	timer_label.position.x -= 120 

	animation_player.play("fade_out")  

	await animation_player.animation_finished  
	#get_tree().change_scene_to_file("res://levelSelector.tscn")
	get_tree().paused = true 
