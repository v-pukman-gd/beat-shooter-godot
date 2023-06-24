extends Node

var click_sound = preload("res://audio/click2.mp3")
onready var audio_player = $AudioStreamPlayer

func click():
	audio_player.stream = click_sound
	audio_player.play()

