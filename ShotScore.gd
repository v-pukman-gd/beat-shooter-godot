extends "res://PoolableNode2D.gd"

export (int)var score = 100
export (int)var dir = 1

func reset():	
	var prefix = ""
	if score < 0: prefix = "- "	
	$LabelC/Label.text = prefix + "$" + str(abs(score))
	if dir == 1:
		$AnimationPlayer.play("fade_down")
	else:
		$AnimationPlayer.play("fade_up")

func _on_anim_finished(anim):
	get_parent().remove_child(self)
	kill()
