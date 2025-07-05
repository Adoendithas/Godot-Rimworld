extends Node

@onready var taskManager = $"../../TaskManager"
@onready var itemManager = $"../../ItemManager"
@onready var charController = $".."	# "Pawn"

@onready var hungerBar = $"../HungerBar"
@onready var staminaBar = $"../StaminaBar"

enum PawnAction {Idle, DoingSubTask}

var currentAction : PawnAction = PawnAction.Idle

var currentTask : Task = null

var inHand


func _process(delta: float) -> void:
	# Make me hungry
	charController.foodNeed -= charController.foodNeedDepleteSpeed * delta
	hungerBar.value = charController.foodNeed * 100
	#make me sleepy
	charController.stamina -= charController.exhaustionSpeed * delta
	staminaBar.value = charController.stamina * 100
	
	if currentTask != null:
		do_current_task(delta)
	else:
		# Only for now, relevant only for food tasks!
		if charController.stamina < 0.2:
			currentTask = taskManager.request_sleep()
		elif charController.foodNeed < 0.5:
			currentTask = taskManager.request_find_and_eat()
		else:
			currentTask = taskManager.request_task()
		
func on_pickup_item(item):
	inHand = item
	itemManager.remove_item_from_world(item)
	
func on_finished_sub_task():
	currentAction = PawnAction.Idle
	if currentTask.is_finished():
		currentTask = null
		
func do_current_task(delta):
	var subTask = currentTask.get_current_sub_task()
	if currentAction == PawnAction.Idle:
		start_current_subtask(subTask)
	else:
		match subTask.taskType:
			Task.TaskType.WalkTo:
				if charController.has_reached_destination():
					currentTask.on_reached_destination()
					on_finished_sub_task();
			Task.TaskType.Eat:
				if inHand.nutrition > 0 and charController.foodNeed < 1:
					inHand.nutrition -= charController.eatSpeed * delta
					charController.foodNeed += charController.eatSpeed * delta
					charController.sprite.play("eat")
				else:
					charController.sprite.play("idle")
					print ("finished eating food")
					inHand = null
					currentTask.on_finish_sub_task()
					on_finished_sub_task()
			Task.TaskType.Sleep:
				if charController.stamina <= 0.9:
					charController.stamina += 0.2 * delta
					charController.sprite.play("sleep")
				else:
					charController.sprite.play("idle")
					print ("finished sleeping")
					currentTask.on_finish_sub_task()
					on_finished_sub_task()
			Task.TaskType.Harvest:
				var targetItem = currentTask.get_current_sub_task().targetItem
				if targetItem.try_harvest(charController.harvestSkill * delta):
					currentTask.on_finish_sub_task()
					on_finished_sub_task()
				else:
					print(targetItem.harvestProgress)
											
	
func start_current_subtask(subTask):
	print("Starting SubTask: " + Task.TaskType.keys()[subTask.taskType])
	match subTask.taskType:
		Task.TaskType.FindItem:
			var targetItem = itemManager.find_nearest_item_by_category(subTask.targetItemType, get_parent().position)
			if targetItem == null:
				print("no item, force finish")
				currentTask.finish()
			else:
				print("New Task (finding item): ", subTask.targetItemType, "from position: ", get_parent().position)
				print("item is:", itemManager.find_nearest_item_by_category(subTask.targetItemType, get_parent().position))
				currentTask.on_found_item(targetItem)
			on_finished_sub_task()
		
		Task.TaskType.WalkTo:
			charController.set_move_target(subTask.targetItem.position)
			currentAction = PawnAction.DoingSubTask

		Task.TaskType.Pickup:
			on_pickup_item(subTask.targetItem)
			currentTask.on_finish_sub_task()
			on_finished_sub_task()

		Task.TaskType.Eat:
			print(inHand)
			currentAction = PawnAction.DoingSubTask

		Task.TaskType.Sleep:
			print("sleeping")
			currentAction = PawnAction.DoingSubTask

		Task.TaskType.Harvest:
			print("harvesting")
			currentAction = PawnAction.DoingSubTask
