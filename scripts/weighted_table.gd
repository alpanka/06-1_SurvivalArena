class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum: int = 0


func add_item(item, weight: int) -> void:
	items.append({"item": item, "weight": weight})
	weight_sum += weight


## Return an item that its weight larger then
## Randi of 1 to total weight of whole array
func pick_item():
	var chosen_weight: int = randi_range(1, weight_sum)
	var iteration_sum: int = 0
	
	for _item in items:
		iteration_sum += _item["weight"]
		if chosen_weight <= iteration_sum:
			return _item["item"]
