extends Item

class_name Plant

@export var harvestProgress : float = 0
@export var harvestDifficulty : float = 1

@export var harvestItem : String = "Berries"
@export var harvestAmount : Vector2i = Vector2i(5, 15)

@export var chopItems : Array = ["Wood", "Berries"]
@export var chopAmount : Vector2i = Vector2i(20, 50)

@export var itemName : String

func _init():
	super._init();
	add_to_group("Plant")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func try_harvest(amount : float) -> bool:
	harvestProgress += amount * 1/harvestDifficulty
	if harvestProgress >= 1:
		itemManager.remove_item_from_world(self)
		var rng = RandomNumberGenerator.new()
		itemManager.spawn_item_by_name(harvestItem, rng.randi_range(harvestAmount.x, harvestAmount.y), itemManager.local_to_map(position))
		return true
	else:
		return false
	
func on_click():
	taskManager.add_task(Task.TaskType.Harvest, self)
	pass
