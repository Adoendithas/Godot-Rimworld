extends TileMapLayer

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			# Berechne die lokale Mausposition
			var local_mouse_position = to_local(event.position)
			# Berechne die Kachelkoordinaten basierend auf der lokalen Mausposition
			var tile_coords = local_to_map(local_mouse_position)
			# var tile_id = get_cell_item(tile_coords)
			# var tile_name = tile_set.get_tile_data(tile_id).custom_data["tileName"]
			print(tile_coords)			
			pass
