extends Node

var click_sound = preload("res://audio/click2.mp3")
onready var audio_player = $AudioStreamPlayer

func _ready():
	audio_player.stream = click_sound

func click():
	audio_player.play()

