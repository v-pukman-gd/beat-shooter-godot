extends "res://PoolableNode2D.gd"

var is_colliding = false
var is_collected = false
var entered_bottom = false
export var size = "small"
export var score = 100
export var damage = 0.1

export(Color) var particle_color = Color.yellow
export(Color) var score_color = Color.yellow

onready var sprite_c = $SpriteC

var speed = 0 # will be set by bar
	
func reset():
	#print("RESET")
	is_colliding = false
	is_collected = false
	entered_bottom = false
	if sprite_c:
		sprite_c.show()
		sprite_c.modulate.a = 1

func collect():
	if is_collected: return false
	if !is_colliding: return false
	if sprite_faded_out(): return false
	
	sprite_c.hide()
	is_collected = true
	print("collected!")
		
	return true
		
func process_fade_anim(delta):
	if entered_bottom and sprite_c.modulate.a > 0:
		sprite_c.modulate.a = max(0, sprite_c.modulate.a - 4*delta*(speed/733.3))
	
func _process(delta):
	process_fade_anim(delta)
	
func sprite_faded_out():
	return sprite_c.modulate.a == 0
