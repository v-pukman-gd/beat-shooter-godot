extends "res://BaseNote.gd"

func collect():
	if is_collected: return false
	if sprite_faded_out(): return false
	
	is_collected = true
	
	sprite_c.hide()
	play_instant_sound()
	
func play_instant_sound():
	$AudioStreamPlayer2D.play()
