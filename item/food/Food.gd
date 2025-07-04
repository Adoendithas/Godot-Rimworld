extends Item

class_name Food

enum FoodType {BERRIES = 0, MEAL = 1}
enum FoodQuality {SPOILED = 0, SIMPLE = 1, GOOD = 2, FANCY = 3}

@export var itemName : String
@export var nutrition = 0.5
@export var foodType : FoodType
@export var foodQuality : FoodQuality

func _init():
	super._init();
	add_to_group("Food")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
