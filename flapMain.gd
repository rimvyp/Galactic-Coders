extends Node2D


@onready var pipe_scene = preload("res://Pipe.tscn")



func _on_pipe_timer_timeout() -> void:
	var pipe = pipe_scene.instantiate()
	pipe.position = Vector2(800, randf_range(200, 400))  
	add_child(pipe)
