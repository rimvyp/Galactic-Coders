extends CharacterBody2D

@export var movement_speed: float = 200.0
@export var black_bar_top: float = 0.0
@export var black_bar_height: float = 0.0


func _ready():
	
	print("Received black_bar_top:", black_bar_top)

func _process(delta: float) -> void:
	print("Spaceship Y Position:", position.y)
	print("Spaceship X Position:", position.x)
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity.y -= movement_speed
	elif Input.is_action_pressed("ui_down"):
		velocity.y += movement_speed
		
		
	move_and_slide()
	
	var top_limit = black_bar_top 
	var bottom_limit = black_bar_top +black_bar_height - sprite_height()
	position.y = clamp(position.y, top_limit, bottom_limit)
	
	#
	
func sprite_height() -> float:
	var sprite = $Sprite2D
	if sprite and sprite.texture:
		return sprite.texture.get_size().y * sprite.scale.y
	return 0.0
