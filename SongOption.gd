extends Button

signal song_pressed

var progress_mark_scn = preload("res://ProgressMark.tscn")

# mock data as an example
var song = {
	"map": {"audio": {"artist": "From The Dust", "title": "Supernova_CC_BY"}},
	"start_index": 0, 
	"end_index": 32,
	"cover": null,
	"song_progress": {"completed": true, "progress_level": 2, "highscore": 1000}
}

onready var panel = $Panel
onready var progress_bar = $HBoxC/Info/HBoxC/ProgressBar
onready var artist_label = $HBoxC/Info/Artist
onready var title_label = $HBoxC/Info/Title
onready var song_icon_sprite = $HBoxC/IconC/SongIcon
onready var last_record_c = $LastRecord

func _ready():
	setup()

func setup():
	artist_label.text = song.map.audio.artist
	title_label.text = song.map.audio.title

	if song.cover:
		song_icon_sprite.icon = song.cover
	
	# progress bar
	for i in range(0, GameSpace.MAX_PROGRESS_LEVEL):
		var p = progress_mark_scn.instance()
		p.rect_position.x = 10+i*40
		p.get_node("Sprite").modulate = Color("3effffff")
		p.get_node("Sprite").self_modulate = Color("000000")
		progress_bar.add_child(p)


		if song.song_progress.completed and i < song.song_progress.progress_level:
			p.get_node("Sprite").modulate = Color.white
			p.get_node("Sprite").self_modulate = Color.white

	if song.song_progress.completed  and song.song_progress.highscore != null:
		last_record_c.get_node("Score").show()
		last_record_c.get_node("Score").text = "$" + str(song.song_progress.highscore)
	else:
		last_record_c.get_node("Score").hide()

func _on_SongOption_pressed():
	emit_signal("song_pressed", song)

func _on_SongOption_mouse_entered():
	panel.modulate.a = 0.6

func _on_SongOption_mouse_exited():
	panel.modulate.a = 1

func _on_SongOption_button_down():
	self.rect_scale = Vector2(0.99, 0.99)

func _on_SongOption_button_up():
	self.rect_scale = Vector2(1, 1)
