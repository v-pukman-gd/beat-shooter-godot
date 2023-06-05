extends Node2D

var bar_scn = preload("res://Bar.tscn")

var original_bars_data = [
		{
			"index": 0,
			"quarters_count": 4,
			"notes": []
		}, 
		{
			"index": 1,
			"quarters_count": 4,
			"notes": []
		}, 
		{
			"index": 2,
			"quarters_count": 4,
			"notes": [{
				"pos": 400,
				"len": 100,
				"markers": ["d"]
			}]
		}, 
		{
			"index": 3,
			"quarters_count": 4,
			"notes": [{
				"pos": 800,
				"len": 100,
				"markers": []
			}]
		}, 
		{
			"index": 4,
			"quarters_count": 4,
			"notes": [{
				"pos": 0,
				"len": 100,
				"markers": ["d"]
			}, {
				"pos": 300,
				"len": 100,
				"markers": ["DD"]
			}]
		}, 
		{
			"index": 5,
			"quarters_count": 4,
			"notes": [{
				"pos": 0,
				"len": 100,
				"markers": ["d"]
			}, {
				"pos": 300,
				"len": 100,
				"markers": ["KK"]
			}, {
				"pos": 1000,
				"len": 100,
				"markers": []
			}]
		}
	]

var notes_count = 0
var note_scale = 0.5
var bar_length_in_m = 1600 # default value
var bars_data = null 
var curr_bar_index = 0 # it's local, always starts from 0
var start_y = 645
var curr_location = Vector2()
var speed = Vector2(0, 10)
var curr_line = -1 # local

var bars = []
onready var bars_node = $BarsC

func _ready():	
	calc_notes_count()
	prepare_bars_data()
	
	bars_node.position.y = start_y
	
	for i in range(4):
		add_bar()
		
func add_bar():
	if  curr_bar_index >= original_bars_data.size(): return
	if !bars_data: return

	var bar = bar_scn.instance()
	bar.note_scale = note_scale
	bar.length = bar_length_in_m
	bar.notes_data = bars_data[curr_bar_index].notes
	bar.position = Vector2(curr_location.x, curr_location.y)
	bar.speed = speed.y
	curr_line = bar.add_notes(curr_line)
	
	bars.append(bar)
	bars_node.add_child(bar)
	
	curr_location -= Vector2(0,bar_length_in_m)
	curr_bar_index += 1
	
func remove_bar(bar):
	bar.queue_free()
	bars.erase(bar)
	
#func _process(delta):
#	return
#	bars_node.translate(speed)
#
#	for bar in bars:		
#		if bar.global_position.y - bar_length_in_m > OS.window_size.y:
#			print("delete at", bar.global_position.y - bar_length_in_m)
#			remove_bar(bar)
#			add_bar()
			
func process_with_time(time, delta):
	bars_node.position.y += speed.y*delta
	
	var position_y = time * speed.y + start_y
	
	#print("x: ", position_x)
	#print("curr x:", bars_node.position.x)
		
	if position_y - bars_node.position.y > speed.y*delta:
		print("FIX delay! ", bars_node.position.y - position_y)
		bars_node.position.y = position_y	
		
	for bar in bars:		
		if bar.global_position.y - bar_length_in_m > OS.window_size.y:
			print("delete at", bar.global_position.y - bar_length_in_m)
			remove_bar(bar)
			add_bar()
	
func prepare_bars_data():
	var plain_notes = []
	var bar_index = 0
	for bar in original_bars_data:
		for note in bar.notes:
			note.bar_index = bar_index
			note.global_pos = bar_index*bar_length_in_m + int(note.pos)
			plain_notes.append(note)
		
		if not bars_data: bars_data = []
		bars_data.append({"index": bar_index, "notes": []})
		bar_index += 1
	

	var note_index = 0
	var extended_notes = []
	for note in plain_notes:
		var extended = note.markers.has("extended")
		if extended:
			extended_notes.append(note)
			note_index += 1
			continue
		else:
			if note_index+1 < plain_notes.size():
				var next = plain_notes[note_index+1]
				note.full_len = next.global_pos - note.global_pos
			else:
				note.full_len = max(400, int(note.len))
				
			if extended_notes.size() > 0:
				var extended_note = extended_notes[0]
				extended_note.full_len = note.global_pos - extended_note.global_pos + note.full_len
				note = extended_note
				extended_notes = []
		
		bars_data[note.bar_index].notes.append(note)
		note_index += 1
	
func calc_notes_count():
	var extended = false
	for bar in original_bars_data:
		for note in bar.notes:
			if extended:
				extended = false
				continue
				
			if note.markers.has("extended"):
				extended = true
			
			notes_count += 1

	
