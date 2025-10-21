extends Node2D
var angle = 0  
var radius = 100  
var speed = 2  

func _process(delta):
	angle += speed * delta
	var x = cos(angle) * radius
	var y = sin(angle) * radius
	$spaceship.position = Vector2(x, y) 
