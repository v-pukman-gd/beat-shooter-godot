extends Particles2D

onready var created_at = Time.get_ticks_msec()

func _process(delta):
	if Time.get_ticks_msec() - created_at > 10000:
		queue_free()
