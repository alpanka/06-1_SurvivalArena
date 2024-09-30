class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum: int = 0

## Add an upgrade item
## Add its weight value
func add_item(item, weight: int) -> void:
	items.append({"item": item, "weight": weight})
	weight_sum += weight
	print(items)


## Return an item that its weight larger then
## Randi of 1 to total weight of whole array
func pick_item(exclude: Array = []):
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum
	# Check if there is exclusion
	if exclude.size() > 0:
		# Empty items list and weight value
		adjusted_items = []
		adjusted_weight_sum = 0
		# Re-create items list with exlusion
		for item in items:
			if item["item"] in exclude:
				continue # Skip to next iteration
			adjusted_items.append(item)
			adjusted_weight_sum += item["weight"]
	
	
	var chosen_weight: int = randi_range(1, adjusted_weight_sum)
	var iteration_sum: int = 0
	
	for _item in adjusted_items:
		iteration_sum += _item["weight"]
		if chosen_weight <= iteration_sum:
			return _item["item"]


func remove_item(item_to_remove) -> void:
	items = items.filter(func (_item): return _item["item"] != item_to_remove)
	
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]
