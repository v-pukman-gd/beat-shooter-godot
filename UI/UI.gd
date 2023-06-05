extends Control

var total_score = 0

var progress_max = 0
var progress_curr = 0

func update_total_score(val):
	total_score = val
	if total_score == 0:
		$TotalScoreC/Label.text = ""
	else:
		$TotalScoreC/Label.text = "$"+str(total_score)
		$AnimationPlayer.stop()
		$AnimationPlayer.play("score_jump")

func setup_progress(val_max):
	progress_max = val_max
	progress_curr = 0
	
	$TitleC/ProgressBar.max_value = progress_max
	$TitleC/ProgressBar.value = progress_curr
	
func update_progress(val):
	progress_curr += val
	$TitleC/ProgressBar.value = progress_curr
