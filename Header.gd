extends Control

signal pause_btn_press

var total_score = 0
var changed = false

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
	
func setup_title(artist, title):
	$TitleC/Artist.text = artist
	$TitleC/Title.text = title

func setup_progress(max_val):
	$TitleC/ProgressBar.max_value = max_val
	$TitleC/ProgressBar.value = 0
	
func update_progress(val):
	$TitleC/ProgressBar.value = val

func _on_PauseBtn_pressed():
	emit_signal("pause_btn_press")
	
func _input(event):
	# pause for debug/screenshot purposes 
	if event.is_action_pressed("pause"):
		if !get_tree().paused:
			get_tree().paused = true
			print("PAUSE!")
		else:
			get_tree().paused = false
			print("PAUSE OFF")
