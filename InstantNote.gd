extends "res://BaseNote.gd"

func collect():
	if is_collected: return
	is_collected = true
	
	sprite_c.hide()
	play_shot_anim()
	play_instant_sound()
	
func play_instant_sound():
	$AudioStreamPlayer2D.play()
