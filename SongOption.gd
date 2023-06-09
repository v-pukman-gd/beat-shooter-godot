extends Button

signal song_pressed
signal section_pressed

var progress_mark_scn = preload("res://ProgressMark.tscn")
var song_section_option_scn = preload("res://SongSectionOption.tscn")

var params = {
	"id": "01",
	"audio_path": "res://songs/01/From The Dust - Supernova_CC_BY.mp3",
	"map_path": "res://songs/01/From The Dust - Supernova_CC_BY.map",
	"artist": "From The Dust",
	"title": "Supernova_CC_BY",
	"sections_config": {
		"1": {"start_index": 0, "end_index": 32},
		"2": {"start_index": 32, "end_index": 64},
	},
	"sections_progress": {
		"1": {"completed": true, "score": 0, "quality": 2},
		"2": {"completed": false, "score": 0, "quality": 0},
	}
}

var show_sections = false

func _ready():
	setup()

func setup():
	$HBoxC/Info/Artist.text = params.artist
	$HBoxC/Info/Title.text = params.title
	
	var progress_bar = $HBoxC/Info/ProgressBar
	
	for i in params.sections_config.size():
		# progress bar
		var p = progress_mark_scn.instance()
		p.get_node("Sprite").modulate = Color("ffffff")
		p.rect_position.x = 10+i*30
		progress_bar.add_child(p)
			
		# sections list
		var section_id = str(i+1)
		var section_progress = params.sections_progress[section_id]
		var section_config = params.sections_config[section_id]
		if section_progress:
			if section_progress.completed:
				p.get_node("Sprite").modulate = Color("f9fb07")
			
			# spawn option
			var section_node = song_section_option_scn.instance()
			
			section_node.section_id = section_id
			section_node.quality = section_progress.quality
			section_node.section_name = "Part " + section_id
			section_node.start_index = section_config.start_index
			section_node.end_index = section_config.end_index
			section_node.connect("section_pressed", self, "_on_section_pressed")
			$SectionsC.add_child(section_node) 
			
	if show_sections:
		$SectionsC.show()
	else:
		$SectionsC.hide()
		


func _on_SongOption_pressed():
	emit_signal("song_pressed", params)

func _on_section_pressed(section_id):
	emit_signal("section_pressed", params, section_id)
