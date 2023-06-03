extends Node2D

export (int)var score = 100

func _ready():	
	$LabelC/Label.text = "$%s" % score
	$LabelC/Label2.text = "$%s" % score
	$LabelC/Label3.text = "$%s" % score
	$AnimationPlayer.play("fade2")
	$AnimationPlayer.connect("animation_finished", self, "_on_anim_finished")
	
func _on_anim_finished(anim):
	queue_free()
