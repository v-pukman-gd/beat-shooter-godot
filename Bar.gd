extends Node2D

var notes_data = [
	{
		"pos": 0,
		"length": 100,
		"full_length": 100,
	
		#"note_scn": "normal_note_scn",
		"size": "big",
		"score": 100,
		"damage": 1
	},
	{
		"pos": 400,
		"length": 100,
		"full_length": 100,
		
		#"note_scn": "normal_note_scn",
		"size": "big",
		"score": 100,
		"damage": 1
	},
	{
		"pos": 800,
		"length": 100,
		"full_length": 100,
		
		#"note_scn": "middle_note_scn",
		"size": "middle",
		"score": 200,
		"damage": 0.1
	},
	{
		"pos": 1200,
		"length": 100,
		"full_length": 100,
		
		#"note_scn": "short_note_scn",
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
var grid

func _ready():
	#debug:
	#GamePool.setup()
	#build_notes(4)
	#self.position.y = length*note_scale

	if !is_ready:
		add_grid()
		add_notes()		
		is_ready = true
		
func add_notes():
	for n in notes:
		notes_c.add_child(n)
		
func add_grid():
	if grid: return
	grid = GamePool.get_instance("bar_grid")
	grid.length = length
	grid.note_scale = note_scale
	add_child(grid)
	
func build_notes(curr_line):
	var index = 0
	for note_data in notes_data:
		if curr_line < 0: curr_line = rand_line()
		
		var next_note_data = null
		if notes_data.size() > index + 1:
			next_note_data = notes_data[index+1]
		
		build_note(curr_line, note_data, next_note_data)
		
		var next_line
	
		if note_data.full_length < 400:
			next_line = curr_line
			while abs(next_line-curr_line) != 1:
				next_line = rand_line()
		else:
			next_line = rand_line()
			
		
		curr_line = next_line
		index += 1
	
	return curr_line
		
func build_note(curr_line, note_data, next_note_data):
	var note = GamePool.get_instance(str(note_data.size) + "_note")
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

func remove_grid():
	remove_child(grid)
	grid.kill()
