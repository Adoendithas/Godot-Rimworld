@tool
extends Node2D

@export var start : Vector2i
@export var end : Vector2i
@export var calculate : bool

@onready var terrain = $"../TerrainLayer"

var path = []
var points: Array[Vector2] = []

func _ready():
	# Ensure connections
	#if !start:
		#start = Vector2i(0, 0)
	#if !end:
		#end = Vector2i(16, 6)
	#
	#request_path(start, end)
	pass
	
func _process(delta):
	if calculate:
		calculate = false
		request_path(start, end)
	
func _draw():
	print(points)
	if len(points) > 0:
		for i in range(len(points) - 1):
			draw_line(points[i], points[i+1], Color.PURPLE)



func request_path(start: Vector2i, end: Vector2i):	
	terrain.pathfinding_generate_points()
	var from = terrain.pathfinding_get_point_id(start)
	var to = terrain.pathfinding_get_point_id(end)
	#print("Terrain Node Path: ", terrain.get_path())
	#print("Terrain Reference: ", terrain)  # Should not be null
	#print("AStar Reference: ", terrain.astar)  # Should not be null
	print("Start Tile id: ", from)
	print("End Tile id: ", to)
	path = terrain.astar.get_id_path(from, to)
	print("Path (terrain.astar.get_id_path):", path)
	
	for point_id in path:
		var point_pos = terrain.astar.get_point_position(point_id)
		#print("appending point with pos: ", point_pos, " (uncubed)")
		points.append(point_pos)
	print(points.size()) # 0
	print("Requested path: ", points)
	queue_redraw()
	return points
