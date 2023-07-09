extends  "res://PoolableNode2D.gd"

var is_colliding = false
var is_collected = false
var entered_bottom = false
export var size = "small"
export var score = 100
export var damage = 0.1

export(Color) var particle_color = Color.yellow
export(Color) var score_color = Color.yellow

onready var sprite_c = $SpriteC
onready var shot_particle = $ShotParticle

var speed = 0 # will be set by bar
	
func reset():
	print("RESET")
	is_colliding = false
	is_collected = false
	entered_bottom = false
	if sprite_c:
		sprite_c.show()
		sprite_c.modulate.a = 1
	if shot_particle:
		shot_particle.emitting = false
		shot_particle.set_process(false)

func collect():
	if !is_colliding: return false
	if is_collected: return false
	
	sprite_c.hide()
	play_shot_anim()
	is_collected = true
	print("collected!")
		
	return true

func play_shot_anim():
	shot_particle.set_process(true)
	shot_particle.one_shot = true
	shot_particle.emitting = true 
	shot_particle.self_modulate = particle_color
	
	if size == "big":
		shot_particle.lifetime = 0.4
		shot_particle.process_material.set("scale", 40)
	else:
		shot_particle.lifetime = 0.3
		shot_particle.process_material.set("scale", 35)
	
func process_fade_anim(delta):
	if entered_bottom and sprite_c.modulate.a > 0:
		sprite_c.modulate.a = max(0, sprite_c.modulate.a - 4*delta*(speed/733.3))
	
func _process(delta):
	process_fade_anim(delta)
