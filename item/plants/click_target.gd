extends Area2D

func _input_event(viewport, event, shape_idx) -> void:
	# Change select_tile to "click" !
	if event.is_action_pressed("select_tile"):
		get_parent().on_click()
	pass
