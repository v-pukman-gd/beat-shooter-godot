extends Button

signal song_pressed
signal section_pressed

var progress_mark_scn = preload("res://ProgressMark.tscn")
var song_section_option_scn = preload("res://SongSectionOption.tscn")

# mock data as an example
var song = {
	"map": {"audio": {"artist": "From The Dust", "title": "Supernova_CC_BY"}},
	"sections": [
		{"section_id": "01", "section_name": "", "start_index": 0, "end_index": 32},
		{"section_id": "02", "section_name": "Final","start_index": 32, "end_index": 64}
	],
	"sections_progress": {"01": {"completed": true, "progress_level": 2} },
}

onready var panel = $Panel

func _ready():
	setup()

func setup():
	$HBoxC/Info/Artist.text = song.map.audio.artist
	$HBoxC/Info/Title.text = song.map.audio.title
	
	toggle_sections(false)
	var progress_bar = $HBoxC/Info/ProgressBar	
	var i = 0
	for section in song.sections:
		# progress bar
		var p = progress_mark_scn.instance()
		p.get_node("Sprite").modulate = Color("ffffff")
		p.rect_position.x = 10+i*30
		progress_bar.add_child(p)
			
		var section_id = section.section_id
		var section_progress = null 
		if song.sections_progress.has(section_id): section_progress = song.sections_progress[section_id]
		if section_progress:
			if section_progress.completed:
				p.get_node("Sprite").modulate = Color("f9fb07")
		
		# section bar
		var section_node = song_section_option_scn.instance()
		section_node.section_id = section_id
		section_node.section_name = section.section_name
		section_node.start_index = section.start_index
		section_node.end_index = section.end_index
		if section_progress:
			section_node.completed = section_progress.completed
			section_node.progress_level = section_progress.progress_level		
		section_node.connect("section_pressed", self, "_on_section_pressed")
		$SectionsC.add_child(section_node) 
			
		i += 1
			
		
func toggle_sections(val):
	if val:
		$SectionsC.show()
	else:
		$SectionsC.hide()

func _on_SongOption_pressed():
	GameFX.click()
	emit_signal("song_pressed", song)

func _on_section_pressed(section_id):
	emit_signal("section_pressed", song, section_id)

func _on_SongOption_mouse_entered():
	panel.modulate.a = 0.6
	
func _on_SongOption_mouse_exited():
	panel.modulate.a = 1

func _on_SongOption_button_down():
	self.rect_scale = Vector2(0.99, 0.99)

func _on_SongOption_button_up():
	self.rect_scale = Vector2(1, 1)
