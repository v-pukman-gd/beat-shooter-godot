extends Node2D

var index = 0
var RELOAD_COST = 100

func _ready():
	reload_all()
	
func _input(event):
	if GameSpace.is_paused: return
	
	if event.is_action_pressed("fire"):
		shoot()
	elif event.is_action_pressed("reload_gun"):
		if index > 0:
			reload_all()
			GameEvent.emit_signal("reload_gun", RELOAD_COST)


func reload_all():
	index = 0
	for b in get_children():
		b.modulate = Color.white
		b.self_modulate = Color.white

func shoot():
	index += 1
	if index <= get_child_count():
		var b = get_node("Sprite" + str(index))
		b.modulate = Color("3effffff")
		b.self_modulate = Color("000000")
	else:
		print("need to reload!")
		GameEvent.emit_signal("no_bullets")
		
	
