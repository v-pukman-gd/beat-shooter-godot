extends Control

var song_option_scn = preload("res://SongOption.tscn")

var songs = [
	{
		"id": "01",
		"audio_path": "res://songs/01/From The Dust - Supernova_CC_BY.mp3",
		"map_path": "res://songs/01/From The Dust - Supernova_CC_BY.map",
		"artist": "From The Dust",
		"title": "Supernova_CC_BY",
		"sections_config": {
			"1": {"start_index": 0, "end_index": 32},
			"2": {"start_index": 32, "end_index": 64},
		},
		"sections_progress": {
			"1": {"completed": true, "score": 0, "quality": 0},
			"2": {"completed": false, "score": 0, "quality": 0},
		}
	},
	{
		"id": "02",
		"audio_path": "res://songs/01/From The Dust - Supernova_CC_BY.mp3",
		"map_path": "res://songs/01/From The Dust - Supernova_CC_BY.map",
		"artist": "From The Dust",
		"title": "Supernova_CC_BY",
		"sections_config": {
			"1": {"start_index": 0, "end_index": 32},
			"2": {"start_index": 32, "end_index": 64},
		},
		"sections_progress": {
			"1": {"completed": true, "score": 0, "quality": 0},
			"2": {"completed": false, "score": 0, "quality": 0},
		}
	},
]

var selected_song_params = null

func _ready():
	for params in songs:
		#load_song_map_data(song)
		
		var option = song_option_scn.instance()
		option.params = params
		$ListC/VBoxC.add_child(option)
		option.connect("song_pressed", self, "_on_option_pressed")
		
func _on_option_pressed(params):
	if selected_song_params: return
	selected_song_params = params
	
	var option = song_option_scn.instance()
	option.params = params
	option.show_sections = true
	option.connect("song_pressed", self, "_on_option_close")
	option.connect("section_pressed", self, "_on_section_pressed")
	
	$DetailsC/VBoxC.add_child(option)
	
	$ListC.hide()
	$DetailsC.show()
	
func _on_option_close(params):
	close_song()

func _on_BackBtn_pressed():
	if selected_song_params:
		close_song()
	else:
		print("back to main menu")
		
func close_song():
	selected_song_params = null
		
	$DetailsC.hide()
	for c in $DetailsC/VBoxC.get_children():
		c.queue_free()
	
	$ListC.show()
		
func _on_section_pressed(params, section_id):
	#if !selected_song_params: return
	
	print("play:", params.id, section_id)
	
