extends Node2D

var audio
var map
var audio_path = "res://songs/01/From The Dust - Supernova_CC_BY.mp3" 
var map_path = "res://songs/01/From The Dust - Supernova_CC_BY.mboy" 

var curr_bar_index = 0
var last_bar_index = null
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

var missed_notes_temp = 0
var heart_duration = GameSpace.heart_duration

onready var popup_screen = $PopupScreen

func _ready():
	GameSpace.paused = false
	GameSpace.failed = false
	$Pointer.hide()
	
	if GameSpace.curr_song:
		audio_path = GameSpace.curr_song.audio_path
		map_path = GameSpace.curr_song.map_path
		curr_bar_index =  GameSpace.curr_section.start_index
		last_bar_index = GameSpace.curr_section.end_index
		
	audio = load(audio_path)
	map = GameSpace.read_json_file(map_path)
	setup()
	$Target.connect("missed", self, "_on_missed_shot")
	$Target.connect("hit", self, "_on_hit")
	
	$BottomC/Area2D.connect("area_entered", self, "_on_bottom_area_enter")
	$BottomC/Area2D.connect("area_exited", self, "_on_bottom_area_exited")
	
	GameEvent.connect("no_lifes", self, "_on_no_lifes")
	
	popup_screen.connect("menu_btn_press", self, "_on_menu_btn_press")
	popup_screen.connect("replay_btn_press", self, "_on_replay_btn_press")
	popup_screen.connect("play_btn_press", self, "_on_play_btn_press")
	
	$UI.connect("pause_btn_press", self, "_on_pause_btn_press")
	
	# TODO: cleanup after the development
	$FlowDev.queue_free()

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
	if last_bar_index == null || last_bar_index > bars.size()-1: last_bar_index = bars.size()-1
	bars = bars.slice(curr_bar_index, last_bar_index)
	bars.push_front({"index": -1, "quarters_count": 4, "notes": []})
	
	flow = flow_scn.instance()	
	flow.note_scale = note_scale
	flow.bar_length_in_m = bar_length_in_m
	flow.original_bars_data = bars
	flow.speed = Vector2(0, speed)
	flow.start_y = SHOOT_LINE_Y - start_pos_in_px
	$BottomC.position.y = SHOOT_LINE_Y	 
	$FlowC.add_child(flow)
	
	$UI.setup_title(map.audio.artist, map.audio.title)
	$UI.update_total_score(total_score)
	$UI.hide_total_score()
	$UI.setup_progress(flow.notes_count)

	is_ready = true

func _process(delta):
	if not is_ready:
		return
		
	if GameSpace.paused:
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
		if total_score < 0: total_score = 0
		$UI.update_total_score(total_score)
		$UI.show_total_score()
	
	$UI.update_progress(progress_val)
	
func _on_bottom_area_enter(area):
	var n = area.get_parent()
	if n.is_in_group("note") or n.is_in_group("instant"):
		n.entered_bottom = true
		
func _on_bottom_area_exited(area):
	var n = area.get_parent()
	if n.is_in_group("note") or n.is_in_group("instant"):
		if !n.is_collected and n.entered_bottom:
			if n.size == 'big':
				missed_notes_temp += GameSpace.big_miss_damage
			else:
				missed_notes_temp += GameSpace.small_miss_damage
			
			if missed_notes_temp >= heart_duration:
				$LifesSet.lost_life()
				missed_notes_temp = 0
				
				$HurtScreen/AnimationPlayer.stop()
				$HurtScreen/AnimationPlayer.play("hurt")

func _on_no_lifes():
	GameSpace.paused = true
	GameSpace.failed = true
	music.pause()	
	popup_screen.show_fail()
	$Target.hide()
	$Pointer.show()
	
func _on_menu_btn_press():
	get_tree().change_scene("res://SongsMenu.tscn")
	
func _on_replay_btn_press():
	get_tree().change_scene("res://Game.tscn")

func _on_pause_btn_press():
	GameSpace.paused = true
	music.pause()	
	popup_screen.show_pause()
	$Target.hide()
	$Pointer.show()
	
func _on_play_btn_press():
	GameSpace.paused = false
	music.resume()	
	popup_screen.hide_all()
	$Target.show()
	$Pointer.hide()
