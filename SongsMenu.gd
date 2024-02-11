extends Control

var song_option_scn = preload("res://SongOption.tscn")

onready var bg_sound_01 = preload("res://audio/bg01.mp3")
onready var bg_sound_02 = preload("res://audio/bg02.mp3")
onready var bg_sound_03 = preload("res://audio/bg03.mp3")
onready var bg_music_player = $BgMusicPlayer

var songs_list = []
var curr_song = null

onready var list_c = $ListC/VBoxC

func _ready():
	VisualServer.set_default_clear_color(Color('#25252a'))
	songs_list = SongsLoader.load_songs(GameSpace.GAME_SONGS_DIR)
	spawn_songs()
	
	yield(get_tree().create_timer(1), "timeout")
	play_bg_music()
	
func _notification(what):
	if what ==  MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		stop_bg_music()
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		play_bg_music()

func play_bg_music():
	randomize()
	var index = randi()%3 + 1
	bg_music_player.stream = self["bg_sound_0" + str(index)]
	bg_music_player.play()
	
func stop_bg_music():
	bg_music_player.stop()

func spawn_songs():
	for song in songs_list:
		var option = song_option_scn.instance()
		option.song = song
		list_c.add_child(option)
		option.connect("song_pressed", self, "_on_song_pressed")

func _on_song_pressed(song):
	if !curr_song:
		curr_song = song
		
		GameSpace.curr_song = song
		bg_music_player.stream_paused = true
		#yield(get_tree().create_timer(0.2), "timeout")
		yield(get_tree().create_timer(0.2), "timeout")
		SceneLoader.goto_scene("res://Game.tscn")

func _on_ConfigBtn_pressed():
	print("config!")
