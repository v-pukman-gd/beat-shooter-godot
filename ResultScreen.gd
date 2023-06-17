extends Node2D

signal menu_btn_press
signal replay_btn_press

var fail_sound = preload("res://fail2.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_all()
	
func hide_all():
	$Popup/Success.hide()
	$Popup/Fail.hide()
	hide()

func show_success(score, progress_level):
	hide_all()
	show()
	$Popup/Success.show()
	
	# show score
	$Control/Popup/ScoreLabel.text = "$" + str(score)
	
	# show progress level
	progress_level = max(progress_level, 3)
	var progress_c = $Control/Popup/ProgressLevelC
	
	for child in progress_c.get_children():
		child.self_modulate = Color("82000000") # fade out
	
	for i in progress_level:
		var node = progress_c.get_node("Level"+str(i+1))
		if node:
			node.self_modulate = Color("ffffff") # fade in

func show_fail():
	hide_all()
	show()
	$Popup/Fail.show()
	$AudioStreamPlayer.stream = fail_sound
	$AudioStreamPlayer.play()
	
func _on_MenuBtn_pressed():
	emit_signal("menu_btn_press")

func _on_ReplayBtn_pressed():
	emit_signal("replay_btn_press")
