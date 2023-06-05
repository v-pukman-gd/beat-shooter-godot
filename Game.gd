extends Node2D

var audio
var map
var audio_path = "res://songs/01/From The Dust - Supernova_CC_BY.mp3" 
var map_path = "res://songs/01/From The Dust - Supernova_CC_BY.mboy" 

var curr_bar_index = 8
var tempo
var bar_length_in_m
var quarter_time_in_sec
var speed
var note_scale
var start_pos_in_sec
var start_pos_in_px

var music_scn = preload("res://Music.tscn")
var music

var flow_scn = preload("res://Flow.tscn")
var flow

var is_ready = false

var bullet_hole_scn = preload("res://BulletHole.tscn")
var shot_score_scn = preload("res://ShotScore.tscn")

var total_score = 0
const SHOOT_LINE_Y = 645

func _ready():
	audio = load(audio_path)
	map = load_map()
	setup()
	$Target.connect("missed", self, "_on_missed_shot")
	$Target.connect("hit", self, "_on_hit")
	
	$BottomC/Area2D.connect("area_entered", self, "_on_bottom_area_enter")
	
func load_map():
	var file = File.new()
	file.open(map_path, File.READ)
	var content = file.get_as_text()
	file.close()
	return JSON.parse(content).get_result()

func setup():
	print("start at:", curr_bar_index)
	tempo = int(map.tempo)
	bar_length_in_m = 1600 # Godot meters
	quarter_time_in_sec = 60/float(tempo) # 60/60 = 1, 60/85 = 0.71
	speed = bar_length_in_m/float(4*quarter_time_in_sec) # each bar has 4 quarters # 
	note_scale = bar_length_in_m/float(4*400) # 400 is the length of 1 quarter in MBOY Editor
	start_pos_in_sec = (float(map.start_pos)/400.0) * quarter_time_in_sec
	start_pos_in_px = start_pos_in_sec * speed
	
	music = music_scn.instance()
	music.audio = audio
	music.speed = speed
	music.tempo = tempo 
	# should include start_pos_in_px (related to start_pos_in_sec)
	music.pre_start_length = bar_length_in_m + start_pos_in_px 
	# include start_pos_in_sec here
	music.start_pos_in_sec = start_pos_in_sec + curr_bar_index*4*quarter_time_in_sec # we confirm that all bars have fixed length - 4 quarters
	add_child(music)
	
	var bars = map.tracks[0].bars
	bars = bars.slice(curr_bar_index, bars.size()-1)
	bars.push_front({"index": -1, "quarters_count": 4, "notes": []})
	
	flow = flow_scn.instance()	
	flow.note_scale = note_scale
	flow.bar_length_in_m = bar_length_in_m
	flow.original_bars_data = bars
	flow.speed = Vector2(0, speed)
	flow.start_y = SHOOT_LINE_Y
	$BottomC.position.y = SHOOT_LINE_Y	 
	$FlowC.add_child(flow)
	
	$UI.update_total_score(total_score)
	$UI.setup_progress(flow.notes_count)

	is_ready = true

func _process(delta):
	if not is_ready:
		return
		
	flow.process_with_time(music.time, delta)
	

func _on_missed_shot(pos):
	print("missed at:", pos)
	var h = bullet_hole_scn.instance()
	h.position = pos
	$BulletHoleC.add_child(h)

func _on_hit(score, particle_color, pos, progress_val=1, dir=1, check_precision=true):
	if check_precision:
		if abs(pos.y - SHOOT_LINE_Y) >= 240:
			score = 0
		elif abs(pos.y - SHOOT_LINE_Y) >= 120:
			score = int(score/2.0)
		
	var shot_score = shot_score_scn.instance()
	shot_score.score = score
	shot_score.position = pos 
	shot_score.modulate = particle_color
	shot_score.dir = dir
	$ShotScoreC.add_child(shot_score)
	
	
	if score != 0:
		total_score += score
		$UI.update_total_score(total_score)
	
	$UI.update_progress(progress_val)
	
	
func _on_bottom_area_enter(area):
	if area.get_parent().is_in_group("note"):
		area.get_parent().entered_bottom = true
