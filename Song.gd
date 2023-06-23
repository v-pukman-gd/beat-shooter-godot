extends Object

var song_id
var map_path
var audio_path
var cover_path
var sections = []
var song_progress = {"completed": false, "progress_level": 0}

var map = {}
var audio
var cover
var sections_progress = {} # loaded from memory card
var is_user_content = false

var title
var artist

func setup(catalog_dir, song_dir):
	var config_file = song_dir + "/" + "song.json"
	var config = GameSpace.read_json_file(config_file)
	if config.empty():
		return false
	
	is_user_content = catalog_dir == GameSpace.USER_SONGS_DIR

	song_id = config.song_id
	map_path = song_dir + "/" + config.map
	audio_path = song_dir + "/" + config.audio
	cover_path = song_dir + "/" + config.cover
	sections = config.sections
	
	map = GameSpace.read_json_file(map_path)
	set_title()
	
	if config.cover:
		cover = load(cover_path)
	
	return true

func set_title():
	title = str(map.audio.title)
	artist = str(map.audio.artist)
	
func get_full_title():
	if artist != "":
		return str(artist) + " - " + str(title)
	else:
		return str(title)
