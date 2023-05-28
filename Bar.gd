extends Node2D

var short_note_scn = preload("res://InstantNote.tscn")
var middle_note_scn = preload("res://Gem.tscn")
var normal_note_scn = preload("res://Coin.tscn")

var notes_data = [
	{
		"pos": 0,
		"len": 100,
		"full_len": 100,
		"markers": ["d"]
	},
	{
		"pos": 100,
		"len": 100,
		"full_len": 100,
		"markers": ["d"]
	},
	{
		"pos": 200,
		"len": 100,
		"full_len": 100,
		"markers": ["d"]
	},
	{
		"pos": 300,
		"len": 100,
		"full_len": 100,
		"markers": ["d"]
	},
#	{
#		"pos": 0,
#		"len": 100,
#		"full_len": 400,
#		"markers": ["DD"]
#	},
	{
		"pos": 400,
		"len": 100,
		"full_len": 400,
		"markers": ["DD"]
	},
	{
		"pos": 800,
		"len": 100,
		"full_len": 400,
		"markers": []
	},
	{
		"pos": 1200,
		"len": 100,
		"full_len": 400,
		"markers": ["KK"]
	}
]

var note_scale = 0.5
var length = 1600 
var notes = []
var is_ready = false

func _ready():
	#add_notes(4)
	if !is_ready:
		for n in notes:
			$NotesC.add_child(n)
			
		is_ready = true

func add_notes(curr_line):
	var index = 0
	for note_data in notes_data:
		if curr_line < 0: curr_line = rand_line()
		
		var next_note_data = null
		if notes_data.size() > index + 1:
			next_note_data = notes_data[index+1]
		
		add_note(curr_line, note_data, next_note_data)
		
		var next_line
	
		if note_data.full_len < 400:
			next_line = curr_line
			while abs(next_line-curr_line) != 1:
				next_line = rand_line()
		else:
			next_line = rand_line()
			
		
		curr_line = next_line
		index += 1
		
#	var y = length*note_scale
#	self.position.y = y # Y has positive values from top to bottom
#	$Line.position.y = 0
#	$Line2.position.y = -y*0.5

	$Grid/Line.position.y = 0
	$Grid/Line_h2.position.y = length*note_scale*0.5
	$Grid/Line_h3.position.y = length*note_scale*0.25
	$Grid/Line_h4.position.y = length*note_scale*0.75
	
	$Grid/Line3.scale.x = note_scale
	$Grid/Line4.scale.x = note_scale
	$Grid/Line5.scale.x = note_scale
	$Grid/Line6.scale.x = note_scale
	
	$Grid/Line3.position.y = length*note_scale*0.5
	$Grid/Line4.position.y = length*note_scale*0.5
	$Grid/Line5.position.y = length*note_scale*0.5
	$Grid/Line6.position.y = length*note_scale*0.5
	#$Line4.position.y = length*note_scale*0.5
	#$Line5.position.y = length*note_scale*0.5
	
	return curr_line
		
func add_note(curr_line, note_data, next_note_data):
	var note_scn = normal_note_scn
		
	if note_data.markers.has("big"):
		note_scn = normal_note_scn
	elif note_data.markers.has("middle"):
		note_scn = middle_note_scn
	elif note_data.full_len <= 100 or note_data.markers.has("short"):
		note_scn = short_note_scn
	elif note_data.full_len < 400:
		note_scn = middle_note_scn
		
	var note = note_scn.instance()
	note.position = Vector2(125*curr_line-25, -float(note_data.pos)*note_scale)
	
	notes.append(note)
	
func rand_line(max_val=4):
	randomize()
	return (randi()%max_val) + 1 # 1 2 3 4
	
func rand_binary():
	randomize()
	return (randi()%2) # 0 1
