extends Node

enum RessourceType {
	WOOD, # 0
	STONE, # 1
	IRON, # 2
	GOLD # 3
}

var resources = {
	"wood": {
		"value": 4,
		"cooldown": 3.0,
	},
	"stone": {
		"value": 6,
		"cooldown": 3.0
	},
	"iron": {
		"value": 0,
		"cooldown": 5.0
	},
	"gold": {
		"value": 0,
		"cooldown": 10.0
	},
}

var default_value = {}

func _ready() -> void:
	default_value = resources.duplicate(true)

func get_ressource_by_id(id: int):
	match id:
		0: 
			return resources["wood"]
		1: 
			return resources["stone"]
		2: 
			return resources["iron"]
		3: 
			return resources["gold"]
		_:
			return null

func ressource_gathered(type: String) -> void:
	var value = 5
	
	resources[type].value = resources[type].value + value

func reset():
	resources = default_value.duplicate(true)
