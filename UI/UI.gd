extends Control

var total_score = 0

func update_total_score(val):
	total_score = val
	if total_score == 0:
		$TotalScoreC/Label.text = ""
	else:
		$TotalScoreC/Label.text = "$"+str(total_score)
		$AnimationPlayer.stop()
		$AnimationPlayer.play("score_jump")
