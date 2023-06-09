extends Control

var section_id = "1"
var section_name = "Part XXX"
var quality = 1
var start_index = 0
var end_index = 0

func _ready():
	$HBoxC/Label.text = section_name
	
	for child in $QualityC.get_children():
		child.self_modulate = Color("82000000") # fade out
	
	for i in quality:
		var node = get_node("QualityC/Quality"+str(i+1))
		if node:
			node.self_modulate = Color("ffffff") # fade in

