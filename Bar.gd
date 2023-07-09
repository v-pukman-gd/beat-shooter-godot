extends Node2D

var notes_data = [
	{
		"pos": 0,
		"length": 100,
		"full_length": 100,
	
		"note_scn": "normal_note_scn",
		"size": "big",
		"score": 100,
		"damage": 1
	},
	{
		"pos": 100,
		"length": 100,
		"full_length": 100,
		
		"note_scn": "normal_note_scn",
		"size": "big",
		"score": 100,
		"damage": 1
	},
	{
		"pos": 200,
		"length": 100,
		"full_length": 100,
		
		"note_scn": "middle_note_scn",
		"size": "middle",
		"score": 200,
		"damage": 0.1
	},
	{
		"pos": 500,
		"length": 100,
		"full_length": 100,
		
		"note_scn": "short_note_scn",
		"size": "short",
		"score": 50,
		"damage": 0.1
	},
]

var note_scale = 0.5
var length = 1600 
var notes = []
var is_ready = false
var speed = 0

onready var notes_c = $NotesC

func _ready():
	#debug:
	#add_notes(4)
	#self.position.y = 400
	if !is_ready:
		for n in notes:
			notes_c.add_child(n)
			
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
	
		if note_data.full_length < 400:
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
	
#	$Grid/Line3.scale.x = note_scale
#	$Grid/Line4.scale.x = note_scale
#	$Grid/Line5.scale.x = note_scale
#	$Grid/Line6.scale.x = note_scale
#
#	$Grid/Line3.position.y = length*note_scale*0.5
#	$Grid/Line4.position.y = length*note_scale*0.5
#	$Grid/Line5.position.y = length*note_scale*0.5
#	$Grid/Line6.position.y = length*note_scale*0.5
	#$Line4.position.y = length*note_scale*0.5
	#$Line5.position.y = length*note_scale*0.5
	
	return curr_line
		
func add_note(curr_line, note_data, next_note_data):
		
		
	var note = NotePool.get_instance(note_data.size)
	note.size = note_data.size
	note.score = note_data.score
	note.damage =  note_data.damage
	note.position = Vector2(125*curr_line-25, -float(note_data.pos)*note_scale)
	note.speed = speed
	
	notes.append(note)
	
func rand_line(max_val=4):
	randomize()
	return (randi()%max_val) + 1 # 1 2 3 4
	
func rand_binary():
	randomize()
	return (randi()%2) # 0 1

func remove_notes():
	for n in notes:
		notes_c.remove_child(n)
		n.kill()
	notes = []
