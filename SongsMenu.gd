extends Control

var song_option_scn = preload("res://SongOption.tscn")

var songs_list = []
var curr_song = null

onready var list_c = $ListC/VBoxC

func _ready():
	songs_list = SongsLoader.load_songs(GameSpace.GAME_SONGS_DIR)
	#TODO: add memory card class and load progress
	spawn_songs()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func spawn_songs():
	for song in songs_list:
		var option = song_option_scn.instance()
		option.song = song
		list_c.add_child(option)
		option.connect("song_pressed", self, "_on_song_pressed")
		# Skip sections logic for now
		# always pick the fist section
		#option.connect("section_pressed", self, "_on_section_pressed")
		
func _on_song_pressed(song):
	if !curr_song:
		curr_song = song
		_on_section_pressed(curr_song, curr_song.sections[0].section_id)
		
#		for option in list_c.get_children():
#			if option.song.song_id == curr_song.song_id:
#				option.toggle_sections(true)
#			else:
#				option.hide()
		
func _on_section_pressed(song, section_id):	
	GameSpace.curr_song = song
	var section = null
	for s in song.sections:
		if s.section_id == section_id:
			section = s
			break
	GameSpace.curr_section = section
	if song and section:
		get_tree().change_scene("res://Game.tscn")
	
func _on_BackBtn_pressed():
	if curr_song:
		for option in list_c.get_children():
			option.show()
			option.toggle_sections(false)
		
		curr_song = null
