extends Node

#/Users/boom/.godot/app_userdata/

const LAST_PLAYED_LIST_SIZE = 3

var path = "user://memory_card"
var data = {
"tracks":
	{"examle_123": { "mode_1": {} }},
	"recent_tracks": []
}

#data:
	#last_track #string
	#highscore
	# track
	# value
	
var curr_song_id = ""
var curr_section_id = ""

func _ready():
	read()
	
func set_track(curr_song, curr_section):
	curr_song_id = str(curr_song.song_id)
	curr_section_id = "section_" + str(curr_section.section_id)

# don't use open_encrypted_with_pass for now
func write():
	var file = File.new()
	#var err = file.open_encrypted_with_pass(path, File.WRITE, str(OS.get_unique_ID())+"bangbang")
	var err = file.open(path, File.WRITE)
	file.store_line(JSON.print(data))
	file.close()

func read():
	var file = File.new()
	if not file.file_exists(path):
		print("No file saved!")
		return

	#var err = file.open_encrypted_with_pass(path, File.READ, str(OS.get_unique_ID())+"bangbang")
	var err = file.open(path, File.READ)
	var json = JSON.parse(file.get_as_text())
	if json.error != OK:
		print("File JSON parse error!", path)
		file.close()
		return

	data = json.result
	file.close()

func check_track(track_dir, mode):
	mode = str(mode)
	track_dir = str(track_dir)
	if not data.tracks.has(track_dir):
		data.tracks[track_dir] = {}
	if not data.tracks[track_dir].has(mode):
		data.tracks[track_dir][mode] = {}


func get_param(param_name):
	print("get param:", param_name)
	check_track(curr_song_id, curr_section_id)
	if data.tracks[curr_song_id][curr_section_id].has(param_name):
		return data.tracks[curr_song_id][curr_section_id][param_name]
	else: return null

func save_param(param_name, param_value):
	print("save_param: ", param_name, param_value)
	check_track(curr_song_id, curr_section_id)
	data.tracks[curr_song_id][curr_section_id][param_name] = param_value

func save_highscore(total_score):
	var highscore = get_param("highscore")
	if highscore != null:
		var prev_value = int(highscore)
		if total_score > prev_value:
			save_param("highscore", total_score)
			write()
			return true
	else:
		save_param("highscore", total_score)
		write()
		return true
	return false

func get_highscore():
	return get_param("highscore")

func add_recent_track(track_dir):
	var played_size = data.recent_tracks.size()

	if played_size == 0:
		data.recent_tracks.append(track_dir)
	elif not data.recent_tracks.has(track_dir):
		data.recent_tracks.append(track_dir)
		if data.recent_tracks.size() > LAST_PLAYED_LIST_SIZE:
			data.recent_tracks.pop_front()

func get_recent_tracks():
	return data.recent_tracks

func save_recent_track():
	add_recent_track(curr_song_id)
	write()

func get_finished_tracks():
	if data.has("finished_tracks"):
		return data.finished_tracks
	else:
		return []

func is_track_finished():
	return get_finished_tracks().has(curr_song_id)

func save_finished_track():
	if not data.has("finished_tracks"):
		data["finished_tracks"] = []

	if not data.finished_tracks.has(curr_song_id):
		data.finished_tracks.append(curr_song_id)
		write()




