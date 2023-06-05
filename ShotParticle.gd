extends Particles2D

onready var created_at = Time.get_ticks_msec()

func _process(delta):
	if self.visible and Time.get_ticks_msec() - created_at > 10000:
		self.emitting = false
		hide()
