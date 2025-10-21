
extends CharacterBody2D  

@export var fall_speed: float = 200.0  
@export var gravity: float = 500.0  

@onready var target = $AnimatedSprite2D


func fall_towards_player():
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity += Vector2(0, gravity * get_process_delta_time()) 
		velocity = direction * fall_speed  
		move_and_slide()
