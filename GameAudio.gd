extends Node

var click_sound = preload("res://audio/click2.mp3")
onready var audio_player = $AudioStreamPlayer

onready var bg_sound_01 = preload("res://audio/bg01.mp3")
onready var bg_sound_02 = preload("res://audio/bg02.mp3")
onready var bg_sound_03 = preload("res://audio/bg03.mp3")
onready var audio_bg_player = $BgMusicPlayer

func click():
	audio_player.stream = click_sound
	audio_player.play()

func play_bg_music():
	randomize()
	var index = randi()%3 + 1
	audio_bg_player.stream = self["bg_sound_0" + str(index)]
	audio_bg_player.play()
	
func stop_bg_music():
	audio_bg_player.stop()

