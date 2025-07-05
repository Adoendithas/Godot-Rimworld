extends Node

class_name TaskManager

var taskQueue = []

func request_task():
	if len(taskQueue) > 0:
		var task = taskQueue[0]
		taskQueue.erase(task)
		return task 
	else:
		return null

func request_sleep():
	var task = Task.new()
	task.sleep()
	return task

func request_find_and_eat():
	var task = Task.new()
	task.init_find_and_eat_food_task()
	return task

func add_task(taskType, targetItem):
	var newTask = Task.new()
	if taskType == Task.TaskType.Harvest:
		newTask.init_harvest_plant_task(targetItem)
		taskQueue.append(newTask)
