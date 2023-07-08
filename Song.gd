extends Object

var catalog_dir
var song_dir

var song_id
var start_index = 0
var end_index = null # null means all bars
var map_path
var audio_path
var cover_path
var song_progress = {"completed": false, "progress_level": 0, "highscore": null}

var map = {}
var audio
var cover
var is_user_content = false
var full_song_dir

var title
var artist

func setup(catalog_dir, song_dir):
	self.catalog_dir = catalog_dir
	self.song_dir = song_dir
	
	is_user_content = catalog_dir == GameSpace.USER_SONGS_DIR
	full_song_dir = catalog_dir + "/" + song_dir

	var config_file = full_song_dir + "/" + "song.json"
	var config = GameSpace.read_json_file(config_file)
	if config.empty():
		return false

	song_id = config.song_id
	if config.has('start_index'): start_index = config.start_index
	if config.has('end_index'): end_index = config.end_index
	map_path = full_song_dir + "/" + config.map
	audio_path = full_song_dir + "/" + config.audio
	cover_path = full_song_dir + "/" + config.cover

	map = GameSpace.read_json_file(map_path)
	set_title()

	if config.cover:
		cover = load(cover_path)

	# load progress
	MemoryCard.setup(song_id)
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
		
func reload_song():
	print("reload song: ", self.song_id)
	setup(self.catalog_dir, self.song_dir)
