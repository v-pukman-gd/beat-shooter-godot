extends Control

signal pause_btn_press

var total_score = 0
var changed = false

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
		
func hide_total_score():
	$TotalScoreC.hide()
	
func show_total_score():
	if !$TotalScoreC.visible:
		$TotalScoreC.show()

func setup_progress(val_max):
	progress_max = val_max
	progress_curr = 0
	
	$TitleC/ProgressBar.max_value = progress_max
	$TitleC/ProgressBar.value = progress_curr
	
func setup_title(artist, title):
	$TitleC/Artist.text = artist
	$TitleC/Title.text = title
	
func update_progress(val):
	progress_curr += val
	$TitleC/ProgressBar.value = progress_curr


func _on_PauseBtn_pressed():
	emit_signal("pause_btn_press")
