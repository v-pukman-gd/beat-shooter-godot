extends Node


func load_json(path):
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	return JSON.parse(content).get_result()
