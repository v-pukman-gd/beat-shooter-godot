extends Node

const GAME_SONGS_DIR = "res://songs"
const USER_SONGS_DIR = "user://songs"

var curr_song
var curr_section
var is_paused = false

func load_json(path):
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	return JSON.parse(content).get_result()

func read_json_file(path):
	var data = {}
	var file = File.new()
	if not file.file_exists(path):
		print(str(path) + " file not found")
		return data
	if file.open(path, File.READ) != 0:
		print(str(path) + " file openning failed")
		return data
	var content = file.get_as_text()
	if content.find("{") == -1:
		print(str(path) + " is not json")
		return data
		
	data = JSON.parse(content).get_result()
	file.close()
	return data
