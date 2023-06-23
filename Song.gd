extends Object

var song_id
var map_path
var audio_path
var cover_path
var sections = []
var song_progress = {"completed": false, "progress_level": 0, "highscore": null}

var map = {}
var audio
var cover
var sections_progress = {} # loaded from memory card
var is_user_content = false
var full_song_dir

var title
var artist

func setup(catalog_dir, song_dir):
	is_user_content = catalog_dir == GameSpace.USER_SONGS_DIR
	full_song_dir = catalog_dir + "/" + song_dir
	
	var config_file = full_song_dir + "/" + "song.json"
	var config = GameSpace.read_json_file(config_file)
	if config.empty():
		return false
	
	
	song_id = config.song_id
	map_path = full_song_dir + "/" + config.map
	audio_path = full_song_dir + "/" + config.audio
	cover_path = full_song_dir + "/" + config.cover
	sections = config.sections
	
	map = GameSpace.read_json_file(map_path)
	set_title()
	
	if config.cover:
		cover = load(cover_path)
		
	# load progress
	MemoryCard.set_track(self, sections[0])
	if MemoryCard.is_track_finished():
		song_progress.completed = true
	if MemoryCard.get_highscore() != null:
		song_progress.highscore = MemoryCard.get_highscore()
	if MemoryCard.get_param("progress_level") != null:
		song_progress.progress_level = MemoryCard.get_param("progress_level")
	
	return true

func set_title():
	title = str(map.audio.title)
	artist = str(map.audio.artist)
	
func get_full_title():
	if artist != "":
		return str(artist) + " - " + str(title)
	else:
		return str(title)
