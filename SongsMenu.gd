extends Control

var song_option_scn = preload("res://SongOption.tscn")
var click_sound = preload("res://audio/click.wav")

var songs_list = []
var curr_song = null

onready var list_c = $ListC/VBoxC

func _ready():
	VisualServer.set_default_clear_color(Color('#25252a'))
	songs_list = SongsLoader.load_songs(GameSpace.GAME_SONGS_DIR)
	spawn_songs()
	yield(get_tree().create_timer(0.2), "timeout")
	GameAudio.play_bg_music()

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
		GameAudio.stop_bg_music()
		yield(get_tree().create_timer(0.2), "timeout")
		SceneLoader.goto_scene("res://Game.tscn")

func _on_ConfigBtn_pressed():
	print("config!")
