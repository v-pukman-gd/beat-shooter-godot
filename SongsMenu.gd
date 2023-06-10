extends Control

var song_option_scn = preload("res://SongOption.tscn")

var songs_list = []
var curr_song = null

func _ready():
	songs_list = SongsLoader.load_songs(GameSpace.GAME_SONGS_DIR)
	#TODO: add memory card class and load progress
	spawn_songs()
	
func spawn_songs():
	for song in songs_list:
		var option = song_option_scn.instance()
		option.song = song
		$ListC/VBoxC.add_child(option)
		option.connect("song_pressed", self, "_on_song_pressed")
		option.connect("section_pressed", self, "_on_section_pressed")
		
func _on_song_pressed(song):
	if curr_song:
		for option in $ListC/VBoxC.get_children():
			option.show()
			option.toggle_sections(false)
		
		curr_song = null
	else:
		curr_song = song
		for option in $ListC/VBoxC.get_children():
			if option.song.song_id == curr_song.song_id:
				option.toggle_sections(true)
			else:
				option.hide()
		
func _on_section_pressed(song, section_id):	
	GameSpace.curr_song = song
	GameSpace.curr_section_id = section_id
	print("play:", GameSpace.curr_song.song_id, " ", GameSpace.curr_section_id)
	
func _on_BackBtn_pressed():
	pass
