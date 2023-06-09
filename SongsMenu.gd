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

func _ready():
	for params in songs:
		#load_song_map_data(song)
		
		var option = song_option_scn.instance()
		option.params = params
		$ListC/VBoxC.add_child(option)
		
#func load_song_map_data(song):
#	song.map_data = Global.load_json(song.map_path) 
