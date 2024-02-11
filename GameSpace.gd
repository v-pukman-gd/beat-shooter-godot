extends Node

const GAME_SONGS_DIR = "res://songs"
const USER_SONGS_DIR = "user://songs"

const MAX_PROGRESS_LEVEL= 3

var curr_song = null
var paused = false
var failed = false

# difficulty level
var auto_reload_gun = true
var short_miss_damage = 0.1
var big_miss_damage = 0.1
var heart_duration = 1

var start_pressed = false

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

