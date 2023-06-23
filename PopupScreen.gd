extends Node2D

signal menu_btn_press
signal replay_btn_press
signal play_btn_press

var fail_sound = preload("res://fail2.mp3")

onready var pause_buttons_c = $Popup/PauseButtonsC
onready var replay_buttons_c = $Popup/ReplayButtonsC

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_all()
	#debug:
	#show_success(1000, 3)
	pass
	
func hide_all():
	$Popup/Success.hide()
	$Popup/Fail.hide()
	$Popup/Pause.hide()
	pause_buttons_c.hide()
	replay_buttons_c.hide()
	hide()

func show_success(score, progress_level):
	hide_all()
	show()
	$Popup/Success.show()
	replay_buttons_c.show()
	
	# show score
	$Popup/Success/ScoreLabel.text = "$" + str(score)
	
	# show progress level
	var progress_c = $Popup/Success/ProgressLevelC
	
	for child in progress_c.get_children():
		child.self_modulate = Color("82000000") # fade out
	
	for i in progress_level:
		var node = progress_c.get_node("Sprite"+str(i+1))
		if node:
			node.self_modulate = Color("ffffff") # fade in

func show_fail():
	hide_all()
	show()
	$Popup/Fail.show()
	replay_buttons_c.show()
	$AudioStreamPlayer.stream = fail_sound
	$AudioStreamPlayer.play()
	
func show_pause():
	hide_all()
	show()
	$Popup/Pause.show()
	pause_buttons_c.show()
	
func _on_MenuBtn_pressed():
	emit_signal("menu_btn_press")
	
func _on_ReplayBtn_pressed():
	emit_signal("replay_btn_press")

func _on_PlayBtn_pressed():
	emit_signal("play_btn_press")
	
