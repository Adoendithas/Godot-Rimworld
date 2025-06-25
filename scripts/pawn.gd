extends CharacterBody2D

@onready var terrain = $"../TileMap/TerrainLayer"
@onready var pathfinding = $"../TileMap/Pathfinding"
@onready var sprite = $sprite


const SPEED = 250
var path = []
var targetHex : Vector2i

#func _input(event):
	#if event.is_action_pressed("moving"):
		#pass
		##var mouse_position_in_viewport: Vector2 = event.position
		##var mouse_position_tilemap_local: Vector2 = get_global_transform_with_canvas().affine_inverse() * mouse_position_in_viewport
		##pathEnd = terrain.local_to_map(mouse_position_tilemap_local)

func _physics_process(delta):
	if Input.is_action_just_pressed("move pawn"):
		path.clear()
		
		# Get the Hex-Coords of Pawn in 2D-Hex-Coords
		var entity_pos = self.position	# pixel-position
		var entity_hex = terrain.cube_to_map(terrain.local_to_cube(entity_pos)) # 2D-Hex(Cube-Hex(pixel-pos))
		print("Pika is in hex: ", entity_hex) # prints correct PikaPos

		#var hex_pos = Vector3i(2, -1, -1)
		#var center = tilemap.cube_to_local(hex_pos)
		#my_entity.position = center  # Places entity at hex c

		# Converting from cube (2, 1, -3) back to tilemap (Vector2i) coordinates
		#var map_pos = tilemap.cube_to_map(Vector3i(2, 1, -3))
		#print(map_pos)  # Output: (2, 1)

		# Get the Targethex under the mouse cursor (in 2D- Coords)
		targetHex = terrain.cube_to_map(terrain.get_closest_cell_from_mouse())
		print("targetHex: ", targetHex)  # Output: Vector2i(2, 1) - coordinates of the hex under mouse

		print("Clicked, Calculation path from ", entity_hex, " to ", targetHex)
		path = pathfinding.request_path(entity_hex, targetHex)
		
	if len(path) > 0:
		var direction = global_position.direction_to(path[0])
		
		var speed_modifier = terrain._pathfinding_get_tile_weight(terrain.cube_to_map(terrain.local_to_cube(self.position)))
		# apply tilespeed: _pathfinding_get_tile_weight(coords: Vector2i) -> float:
		velocity = direction * SPEED * (1 / speed_modifier)
		change_sprite_direction(direction)
		print("direction is ", direction, "; TileDifficulty: ", speed_modifier)
		#print("velocity is ", velocity)
		print("first path element: ", path[0], ", distance from Pika is: ", position.distance_to(path[0]), " Speed * delta: ", SPEED * delta, " Path End: ", targetHex)
		if (position.distance_to(path[0]) < SPEED * delta):
			path.remove_at(0)
			pathfinding.queue_redraw()
			if (len(path) == 0):
				change_sprite_direction(Vector2i(0, 0))
	else:
		#print("Keine Knoten mehr.")
		velocity = Vector2(0, 0)
		
	move_and_slide()
	
func change_sprite_direction(direction):
	if (abs(direction.x) <= 0.06):
		if (direction.y > 0):
			self.sprite.play("walk_down")
		elif (direction.y < 0):
			self.sprite.play("walk_up")
		else:
			var rng = RandomNumberGenerator.new()
			var num = rng.randi_range(0, 10)
			if (num >= 9):
				self.sprite.play("sleep")
			else:
				self.sprite.play("idle")
	elif (direction.x > 0 && direction.y > 0):
		self.sprite.play("walk_right_down")
	elif (direction.x > 0 && direction.y < 0):
		self.sprite.play("walk_right_up")
	elif (direction.x < 0 && direction.y > 0):
		self.sprite.play("walk_left_down")
	elif (direction.x < 0 && direction.y < 0):
		self.sprite.play("walk_left_up")
	else:
		self.sprite.play("idle")
	pass
