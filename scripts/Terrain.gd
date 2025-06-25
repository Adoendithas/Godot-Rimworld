@tool
extends HexagonTileMapLayer

@export var generateTerrain : bool
@export var clearTerrain : bool
@export var terrainSeed : int
@export var mapWidth: int
@export var mapHeight: int
# @export var mapMaxRadius: int <- Maybe for Hex MapShape
@export var elevationoffset: float

@export var darkWaterThreshold: float
@export var waterThreshold: float
@export var sandThreshold: float
@export var grassThreshold: float
@export var forestThreshold: float
@export var rockyThreshold: float
@export var peakThreshold: float
@export var snowThreshold: float
@export var lavaThreshold: float

const SourceTerrainTiles: int = 2

#pathfinding:
# var from = pathfinding_get_point_id(Vector2i.ZERO)
# var to = pathfinding_get_point_id(Vector2i(6, -4))

# Called when the node enters the scene tree for the first time.

func _ready():
	super._ready()
	
	# Experimentation with the library:
	#var astar: AStar2D = AStar2D.new()
	#print(astar)
	#var from = pathfinding_get_point_id(Vector2i(0, 0))
	#var to = pathfinding_get_point_id(Vector2i(6, 3))
	#var path = astar.get_id_path(from, to)
	
	# Enable pathfinding
	pathfinding_enabled = true

	## Customize pathfinding weights (optional)
	#func _pathfinding_get_tile_weight(coords: Vector2i) -> float:
		## Return custom weight value (default is 1.0)
		#return 1.0

	## Customize pathfinding connections (optional)
	#func _pathfinding_does_tile_connect(tile: Vector2i, neighbor: Vector2i) -> bool:
		## Return whether tiles should be connected (default is true)
		#return true

	# Enable debug visualization (optional)
	# debug_mode = DebugModeFlags.TILES_COORDS | DebugModeFlags.CONNECTIONS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if generateTerrain:
		generateTerrain = false
		generate_terrain()
		
	if clearTerrain:
		clearTerrain = false
		clear()
		
	pass

func generate_terrain():
	var noise = FastNoiseLite.new()
	var rng = RandomNumberGenerator.new()
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	
	if terrainSeed == 0:
		noise.seed = rng.randi()
	else:
		noise.seed = terrainSeed
	
	print("Seed set: ", noise.seed)
	
	for x in range(mapWidth):
		for y in range (mapHeight):
			var altitude = noise.get_noise_2d(x, y) + elevationoffset
			print("Set Cell", Vector2i(x, y), " with Altitude ", altitude)
			if altitude < darkWaterThreshold:
				set_cell(Vector2i(x, y), SourceTerrainTiles, Vector2i(0, 4))
				print("Water @: ", Vector2i(x, y))
			elif altitude < waterThreshold:
				set_cell(Vector2i(x, y), SourceTerrainTiles, Vector2i(2, 3))
			elif altitude < sandThreshold:
				set_cell(Vector2i(x, y), SourceTerrainTiles, Vector2i(0, 0))
			elif altitude < grassThreshold:
				set_cell(Vector2i(x, y), SourceTerrainTiles, Vector2i(0, 1))
			elif altitude < forestThreshold:
				set_cell(Vector2i(x, y), SourceTerrainTiles, Vector2i(2, 2))
			elif altitude < rockyThreshold:
				set_cell(Vector2i(x, y), SourceTerrainTiles, Vector2i(0, 3))
			elif altitude < peakThreshold:
				set_cell(Vector2i(x, y), SourceTerrainTiles, Vector2i(0, 2))
			elif altitude < snowThreshold:
				set_cell(Vector2i(x, y), SourceTerrainTiles, Vector2i(1, 4))
			elif altitude < lavaThreshold:
				set_cell(Vector2i(x, y), SourceTerrainTiles, Vector2i(1, 3))
				
func _input(event):
	if event.is_action_pressed("select_tile"):
		assert(event is InputEventMouseButton)
		# Lifesaver: https://www.reddit.com/r/godot/comments/1cm6zrk/comment/l2yjwqw/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1
		var mouse_position_in_viewport: Vector2 = event.position
		var mouse_position_tilemap_local: Vector2 = get_global_transform_with_canvas().affine_inverse() * mouse_position_in_viewport
		var coordinates = local_to_map(mouse_position_tilemap_local)
		var cellData: TileData = get_cell_tile_data(coordinates)
		if cellData != null:
			var difficulty: float = cellData.get_custom_data("difficulty")
			print(coordinates, "Movement Difficulty: ", difficulty)			
		pass
		
	elif event.is_action_pressed("paint_tile"):
		var mouse_position_in_viewport: Vector2 = event.position
		var mouse_position_tilemap_local: Vector2 = get_global_transform_with_canvas().affine_inverse() * mouse_position_in_viewport
		var coordinates = local_to_map(mouse_position_tilemap_local)
		set_cell(coordinates, 2, Vector2i(1, 3))
		print ("Klicked Tile", coordinates, "")
		pass
		
func _pathfinding_get_tile_weight(coords: Vector2i) -> float:
	# Get the TileData for the specified coordinates
	var cellData: TileData = get_cell_tile_data(coords)
	if cellData:
		#print("Weight for this tile is ", cellData.get_custom_data("difficulty"))
		return cellData.get_custom_data("difficulty")
	else:
		#print("No Weight found, returning 1")
		return -1.0  # Default weight if no tile data is found
		
# Customize pathfinding connections (optional)
func _pathfinding_does_tile_connect(tile: Vector2i, neighbor: Vector2i) -> bool:
	var cellData: TileData = get_cell_tile_data(tile)
	if cellData:
		if (cellData.get_custom_data("difficulty") != -1):
			# Return whether tiles should be connected (default is true)
			return true
	
	return false
		
			# Different Tut Examples:
			# var local_mouse_position = to_local(event.position)
			#var tileSnap = local_to_map(event.position)
			#var tile_coords = map_to_local(tileSnap)
			#var mouse_position: Vector2 = event.position
			#var tile_coords: Vector2i = self.local_to_map(mouse_position)
			# var tile_id = get_cell_item(tile_coords)
			# var tile_name = tile_set.get_tile_data(tile_id).custom_data["tileName"]
			
			# From nice tut: https://www.youtube.com/watch?v=qXngcKtoKNE
			# Problems with Zoom and other stuff.
			# var mouse_position : Vector2 = event.global_position
			# var local_coords: Vector2i = local_to_map(to_local(mouse_position))
