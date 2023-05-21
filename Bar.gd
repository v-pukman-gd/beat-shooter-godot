extends Node2D

var short_note_scn = preload("res://Gem.tscn")
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
	for note_data in notes_data:
		if curr_line < 0: curr_line = rand_line()
		
		add_note(curr_line, note_data)
		
		var next_line
	
		if note_data.full_len < 400:
			next_line = curr_line
			while abs(next_line-curr_line) != 1:
				next_line = rand_line()
		else:
			next_line = rand_line()
			
		
		curr_line = next_line
		
#	var y = length*note_scale
#	self.position.y = y # Y has positive values from top to bottom
#	$Line.position.y = 0
#	$Line2.position.y = -y*0.5
	
	return curr_line
		
func add_note(curr_line, note_data):
	var note_scn = normal_note_scn
	
	if note_data.full_len < 400:
		note_scn = short_note_scn
		
	var note = note_scn.instance()
	note.position = Vector2(125*curr_line-25, -float(note_data.pos)*note_scale)
	
	notes.append(note)
	
func rand_line(max_val=4):
	randomize()
	return (randi()%max_val) + 1 # 1 2 3 4
	
func rand_binary():
	randomize()
	return (randi()%2) # 0 1
