extends Node2D

var index = 0

func _ready():
	add_all()

func add_all():
	index = 0
	for b in get_children():
		b.modulate = Color.white
		b.self_modulate = Color.white
		
func add_one():
	if (index - 1) >= 0:
		var b = get_node("Sprite" + str(index))
		b.modulate = Color.white
		b.self_modulate = Color.white
		index -= 1

func lost_life():
	if (index + 1) <= get_child_count():
		index += 1
		var b = get_node("Sprite" + str(index))
		b.modulate = Color("3effffff")
		b.self_modulate = Color("000000")		
		
		if index >= get_child_count():
			print("no_lifes!")
			GameEvent.emit_signal("no_lifes")

# use for debug		
#func _input(event):	
#	if event.is_action_pressed("fire"):
#		lost_life()
#	elif event.is_action_pressed("reload_gun"):
#		add_one()
#
#	print("index:", index)
