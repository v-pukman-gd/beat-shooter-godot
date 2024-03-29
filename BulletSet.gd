extends Node2D

var index = 0
var RELOAD_BONUS = 25

onready var bullets = $Sprites

func _ready():
	GameEvent.connect("shoot", self, "_on_shoot")
	reload_all()
	
func _input(event):
	if GameSpace.paused: return

	if event.is_action_pressed("reload_gun"):
		_on_reload_gun()


func reload_all():
	index = 0
	for b in bullets.get_children():
		b.modulate = Color.white
		b.self_modulate = Color.white
		
func _on_reload_gun():
	if index > 0:
		var bonus = 0
		if index > bullets.get_child_count()*0.5: bonus = RELOAD_BONUS
		reload_all()
		GameEvent.emit_signal("reload_gun", bonus)

func _on_shoot(pos):
	index += 1
	if index <= bullets.get_child_count():
		var b = get_node("Sprites/Sprite" + str(index))
		b.modulate = Color("3effffff")
		b.self_modulate = Color("000000")
		
		if GameSpace.auto_reload_gun and index == bullets.get_child_count():
			reload_all()
			GameEvent.emit_signal("reload_gun", 0)
	else:
		print("need to reload!")
		GameEvent.emit_signal("no_bullets")
