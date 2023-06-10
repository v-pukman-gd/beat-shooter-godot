extends Node

const Song = preload("res://Song.gd")

func load_songs(catalog_dir):
	var dir = Directory.new()
	var songs_list = []
	if dir.open(catalog_dir) == OK:
		dir.list_dir_begin()
		var curr_dir = dir.get_next()
		while(curr_dir != ""):
			if not (curr_dir == "." or curr_dir == ".."):
				if dir.current_is_dir():
					var song_dir = catalog_dir + "/" + curr_dir
					
					var song = Song.new()
					var result = song.setup(catalog_dir, song_dir)
					if result:
						songs_list.append(song)
							
					
			curr_dir = dir.get_next()
	else:
		print("cant open songs folder")

	songs_list.invert()
	return songs_list
