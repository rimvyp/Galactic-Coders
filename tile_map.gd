extends TileMap


const CELL_SIZE = 270 
const GRID_SIZE = 4   

func _draw():
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			var rect = Rect2(x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE)
			draw_rect(rect, Color(1, 1, 1), false, 2) 


	
