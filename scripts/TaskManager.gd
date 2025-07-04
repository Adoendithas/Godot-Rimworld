extends Node

class_name TaskManager

func request_task(foodNeed, stamina):
	var task = Task.new()
	if (foodNeed < stamina) and (stamina > 0.2):
		task.init_find_and_eat_food_task()
	else:
		task.sleep()
	return task
