extends Control

signal section_pressed

var section_id = "1"
var start_index = 0
var end_index = 0

var progress_level = 0
var completed = false

func _ready():
	$HBoxC/Label.text = "Part " + str(section_id)
	var progress_c = $ProgressLevelC
	
	for child in progress_c.get_children():
		child.self_modulate = Color("82000000") # fade out
	
	for i in progress_level:
		var node = progress_c.get_node("Level"+str(i+1))
		if node:
			node.self_modulate = Color("ffffff") # fade in


func _on_SongSectionOption_pressed():
	emit_signal("section_pressed", section_id)
