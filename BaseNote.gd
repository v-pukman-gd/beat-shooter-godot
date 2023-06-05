extends Node2D

var is_colliding = false
var is_collected = false
var entered_bottom = false
export var size = "small"
export var score = 100

export(Color) var particle_color = Color.yellow
export(Color) var score_color = Color.yellow
var particle_scn = preload("res://ShotParticle.tscn")

onready var sprite_c = $SpriteC

var speed = 0 # will be set by bar

func collect():
	if !is_colliding: return false
	if is_collected: return false
	
	sprite_c.hide()
	play_shot_anim()
	is_collected = true
	print("collected!")
		
	return true

func play_shot_anim():
	var p = particle_scn.instance()
	p.one_shot = true
	p.emitting = true 
	p.self_modulate = particle_color
	
	if size == "big":
		p.lifetime = 0.4
		p.process_material.set("scale", 40)
	else:
		p.lifetime = 0.3
		p.process_material.set("scale", 35)
	add_child(p)
	
	
func _process(delta):
	# play fade anim
	if entered_bottom and sprite_c.modulate.a > 0:
		sprite_c.modulate.a = max(0, sprite_c.modulate.a - 4*delta*(speed/733.3))
