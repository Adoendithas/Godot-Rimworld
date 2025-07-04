extends Node

class_name ItemManager

enum ItemCategory {ITEM = 0, FOOD = 1, RESSOURCE = 2}
var itemCategories = ["Item", "Food", "Ressource"]

#All the FoodPrototypes that exist
var foodPrototypes = []
#All Items actually on the map
var itemsInWorld = []
var foodPath = "res://item/food"
@onready var hexTerrain = $"../TileMap/TerrainLayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_food(foodPath)
	
	var rng = RandomNumberGenerator.new()
	var i = 0
	while i < 3:
		var posX = rng.randi_range(1, hexTerrain.mapWidth - 1)
		var posY = rng.randi_range(1, hexTerrain.mapHeight -1)
		var type = rng.randi_range(0, 1)
		spawn_item(foodPrototypes[type], map_to_world_position(posX, posY))
		i += 1
	#print(itemsInWorld)
	#print(is_item_in_category(itemsInWorld[0], ItemCategory.FOOD))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_item(item, mapPos):
	var newItem = item.instantiate()
	add_child(newItem)
	itemsInWorld.append(newItem)
	newItem.position = mapPos
	pass
	
func remove_item_from_world(item):
	remove_child(item)
	itemsInWorld.erase(item)
	
func find_nearest_item_by_category(itemCategory : ItemCategory, worldPosition : Vector2):
	if len(itemsInWorld) == 0:
		return null
	var nearestItem = null
	var nearestDistance = 9999
	
	for item in itemsInWorld:
		if is_item_in_category(item, itemCategory):
			var distance = worldPosition.distance_to(item.position)
			if nearestItem == null:
				nearestItem = item
				nearestDistance = distance
				continue
			if distance < nearestDistance:
				nearestItem = item
				nearestDistance = distance
	return nearestItem

func is_item_in_category(item, itemCategory) -> bool:
	return item.is_in_group(itemCategories[itemCategory])

func load_food(path):
	var dir = DirAccess.open(path)
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var fileName = dir.get_next()
		if fileName == "":
			break
		elif fileName.ends_with(".tscn"):
			foodPrototypes.append(load(path + "/" + fileName))
			print(fileName)
	dir.list_dir_end()

func map_to_world_position(mapPosX, mapPosY) -> Vector2:
	return hexTerrain.cube_to_local(hexTerrain.map_to_cube(Vector2(mapPosX, mapPosY)))

# WorldPosition -> Map Coordinates
func local_to_map(cords : Vector2):
	return hexTerrain.cube_to_map(hexTerrain.local_to_cube(cords))
