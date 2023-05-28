extends Node2D

func _ready():
	get_node("SpriteC/Var" + str(rand_number())).show()
	
	$AnimationPlayer.play("fade")
	$AnimationPlayer.connect("animation_finished", self, "_on_anim_finished")

func rand_number():
	randomize()
	return (randi()%3) + 1

func _on_anim_finished(anim):
	queue_free()
