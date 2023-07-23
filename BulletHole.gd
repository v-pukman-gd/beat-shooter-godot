extends "res://PoolableNode2D.gd"

func _enter_tree():
	for c in $SpriteC.get_children():
		c.hide()
		
	get_node("SpriteC/Var" + str(rand_number())).show()
	$AnimationPlayer.play("fade")

func rand_number():
	randomize()
	return (randi()%3) + 1

func _on_anim_finished(anim):
	$AnimationPlayer.stop()
	get_parent().remove_child(self)
	kill()
