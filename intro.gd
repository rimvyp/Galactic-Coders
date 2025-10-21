extends Node2D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("fade_in")
	await get_tree().create_timer(6.0).timeout
	animation_player.play("fade_out")
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://welcome_screen.tscn")
