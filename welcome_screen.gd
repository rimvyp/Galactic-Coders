
extends Control

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer  
@onready var timer2 = $Timer2
@onready var spriteWalk = $Sprite2D/SpriteFrames/spriteScreenWalk
@onready var spriteAnim = $Sprite2D/SpriteFrames
func _on_start_button_pressed() -> void:
	animation_player.play("button_fly_away")
	timer.start(2)
	
	spriteWalk.play("walk_across")
	spriteAnim.play("default")

func _on_timer_timeout() -> void:
	animation_player.play("lesson_fly_in")
	timer2.start(1)
	
func _on_timer_2_timeout() -> void:
	animation_player.play("continue_adventure_fly_in")
	
	timer2.stop()
	
	
	
	
	
	


func _on_lessons_button_pressed() -> void:
	pass # Replace with function body.
