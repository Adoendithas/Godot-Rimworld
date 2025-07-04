#extends Node2D
#
#var pawns : Array[Array]
#var points: Array[Vector2] = []
#var color : Color
#
#func _draw():
	#for pints in pawns:
		#if len(points) > 0:
			#for i in range(len(points) - 1):
				#draw_line(points[i]-position, points[i+1]-position, color)
				#print("draw in PathDrawer: ", points[i], points[i+1])
#
#func _ready():
	#position = Vector2.ZERO
#
#func set_color(pawn: Object, col : Color):
	#pawns[pawn].color = col
