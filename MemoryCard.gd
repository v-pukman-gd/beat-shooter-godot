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

func _ready():
	read()

# don't use open_encrypted_with_pass for now
func write():
	var file = File.new()
	#var err = file.open_encrypted_with_pass(path, File.WRITE, str(OS.get_unique_ID())+"bangbang")
	var err = file.open(path, File.WRITE)
	file.store_line(data.to_json())
	file.close()

func read():
	var file = File.new()
	if not file.file_exists(path):
		print("No file saved!")
		return

	#var err = file.open_encrypted_with_pass(path, File.READ, str(OS.get_unique_ID())+"bangbang")
	var err = file.open(path, File.READ)
	data.parse_json(file.get_as_text())
	file.close()

func check_track(track_dir, mode):
	mode = str(mode)
	track_dir = str(track_dir)
	if not data.tracks.has(track_dir):
		data.tracks[track_dir] = {}
	if not data.tracks[track_dir].has(mode):
		data.tracks[track_dir][mode] = {}


func get_track_param(track_dir, mode, param_name):
	check_track(track_dir, mode)
	mode = str(mode)
	track_dir = str(track_dir)
	if data.tracks[track_dir][mode].has(param_name):
		return data.tracks[track_dir][mode][param_name]
	else: return null

func set_track_param(track_dir, mode, param_name, param_value):
	check_track(track_dir, mode)
	mode = str(mode)
	track_dir = str(track_dir)
	data.tracks[track_dir][mode][param_name] = param_value

func save_highscore(total_score):
	var highscore = get_track_param(GameSpace.curr_track_dir, GameSpace.original_mode, "highscore")
	if highscore != null:
		var prev_value = int(highscore)
		if total_score > prev_value:
			set_track_param(GameSpace.curr_track_dir, GameSpace.original_mode, "highscore", total_score)
			write()
			return true
	else:
		set_track_param(GameSpace.curr_track_dir, GameSpace.original_mode, "highscore", total_score)
		write()
		return true
	return false

func get_highscore():
	return get_track_param(GameSpace.curr_track_dir, GameSpace.original_mode, "highscore")

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
	add_recent_track(GameSpace.curr_track.track_dir)
	write()

func get_finished_tracks():
	if data.has("finished_tracks"):
		return data.finished_tracks
	else:
		return []

func is_track_finished(track):
	return get_finished_tracks().has(track.track_dir)

func save_finished_track():
	if not data.has("finished_tracks"):
		data["finished_tracks"] = []

	if not data.finished_tracks.has(GameSpace.curr_track.track_dir):
		data.finished_tracks.append(GameSpace.curr_track.track_dir)
		write()




