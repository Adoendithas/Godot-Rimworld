extends Node

class_name Task

enum TaskType {BaseTask, FindItem, WalkTo, Pickup, Eat, Manipulate, Harvest, Sleep}

var taskName : String
var taskType : TaskType = TaskType.BaseTask

var subTasks = []
var currentSubTask : int = 0

var targetItem
var targetItemType

func is_finished() -> bool:
	return currentSubTask == len(subTasks)
	
func finish():
	currentSubTask = len(subTasks)
	
func get_current_sub_task():
	print("get_current_sub_task() return ", subTasks[currentSubTask])
	return subTasks[currentSubTask]
	
func on_finish_sub_task():
	currentSubTask += 1
	
func on_found_item(item):
	on_finish_sub_task()
	get_current_sub_task().targetItem = item
	
func on_reached_destination():
	on_finish_sub_task()
	get_current_sub_task().targetItem = subTasks[currentSubTask - 1].targetItem
	
func sleep():
	taskName = "Sleep and restore stamina"
	var subTask = Task.new()
	subTask.taskType = TaskType.Sleep
	subTasks.append(subTask)
	
func init_find_and_eat_food_task():
	taskName = "Find and eat some food"
	var subTask = Task.new()
	
	subTask.taskType = TaskType.FindItem
	subTask.targetItemType = ItemManager.ItemCategory.FOOD
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.WalkTo
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.Pickup
	subTasks.append(subTask)
	
	subTask = Task.new()
	subTask.taskType = TaskType.Eat
	subTasks.append(subTask)
