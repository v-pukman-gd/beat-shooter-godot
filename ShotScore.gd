extends Node2D

export (int)var score = 100
export (int)var dir = 1

func _ready():
	var prefix = ""
	if score < 0: prefix = "- "	
	$LabelC/Label.text = prefix + "$" + str(abs(score))
	$LabelC/Label2.text = prefix + "$" + str(abs(score))
	$LabelC/Label3.text = prefix + "$" + str(abs(score))
	if dir == 1:
		$AnimationPlayer.play("fade_down")
	else:
		$AnimationPlayer.play("fade_up")
		
	$AnimationPlayer.connect("animation_finished", self, "_on_anim_finished")
	
func _on_anim_finished(anim):
	queue_free()
