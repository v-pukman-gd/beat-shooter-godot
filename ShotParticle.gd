extends "res://PoolableNode2D.gd"

var created_at = -1
var particle_color = Color("ffffff")
var note_size = NoteSize.BIG

func reset():
	created_at = Time.get_ticks_msec()
	
	$Particles2D.one_shot = true
	$Particles2D.emitting = true 
	$Particles2D.self_modulate = particle_color
	
	if note_size == NoteSize.SHORT:
		$Particles2D.lifetime = 0.3
		$Particles2D.process_material.set("scale", 35)
	elif note_size == NoteSize.MIDDLE:
		$Particles2D.lifetime = 0.38
		$Particles2D.process_material.set("scale", 35)
	else:
		$Particles2D.lifetime = 0.4
		$Particles2D.process_material.set("scale", 40)		
		
func _process(delta):
	if created_at > 0 and Time.get_ticks_msec() - created_at > 2000:
		created_at = -1
		get_parent().remove_child(self)
		kill()
