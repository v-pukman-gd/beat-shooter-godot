extends Node2D

var song_id = "song_01"
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
var is_finished = false

var total_score = 0
const SHOOT_LINE_Y = 645

var missed_notes_temp = 0
var heart_duration = GameSpace.heart_duration

onready var popup_screen = $PopupScreen
onready var header = $Header

var mc = MemoryCard

func _init():
	GamePool.setup()

func _ready():
	GameSpace.paused = false
	GameSpace.failed = false
	$Pointer.hide()

	# curr_song is empty in debug mode
	var curr_song = GameSpace.curr_song
	if curr_song:
		audio_path = curr_song.audio_path
		map_path = curr_song.map_path
		curr_bar_index =  curr_song.start_index
		last_bar_index = curr_song.end_index
		song_id = curr_song.song_id
		map = curr_song.map
	
	audio = load(audio_path)
	if !map: map = GameSpace.read_json_file(map_path)
	setup()
	$Target.connect("missed", self, "_on_missed_shot")
	$Target.connect("hit", self, "_on_hit")

	$BottomC/Area2D.connect("area_entered", self, "_on_bottom_area_enter")
	$BottomC/Area2D.connect("area_exited", self, "_on_bottom_area_exited")

	GameEvent.connect("no_lifes", self, "_on_no_lifes")

	popup_screen.connect("menu_btn_press", self, "_on_menu_btn_press")
	popup_screen.connect("replay_btn_press", self, "_on_replay_btn_press")
	popup_screen.connect("play_btn_press", self, "_on_play_btn_press")

	header.connect("pause_btn_press", self, "_on_pause_btn_press")
	
	# memory card
	mc.setup(song_id)

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
	flow.speed = Vector2(0, speed)
	flow.start_y = SHOOT_LINE_Y - start_pos_in_px
	flow.set_bars_data(bars) # set bars data and make calculations
	flow.connect("finished", self, "_on_flow_finished")
	$BottomC.position.y = SHOOT_LINE_Y
	$FlowC.add_child(flow)

	header.setup_title(map.audio.artist, map.audio.title)
	header.update_total_score(total_score)
	header.hide_total_score()
	header.setup_progress(music.get_length())

	is_ready = true

func _process(delta):
	if not is_ready or is_finished:
		return

	if GameSpace.paused:
		return

	flow.process_with_time(music.time, delta)

	header.update_progress(music.get_playback_position())

func _on_missed_shot(pos):
	print("missed at:", pos)
	var h = GamePool.get_instance("bullet_hole")
	h.position = pos
	$BulletHoleC.add_child(h)

func _on_hit(score, particle_color, pos, progress_val=1, dir=1, check_precision=true):
	if check_precision:
		if abs(pos.y - SHOOT_LINE_Y) >= 120:
			score = 0
		elif abs(pos.y - SHOOT_LINE_Y) >= 60:
			score = int(score/2.0)

	var shot_score = GamePool.get_instance("shot_score")
	shot_score.score = score
	shot_score.position = pos
	shot_score.modulate = particle_color
	shot_score.dir = dir
	$ShotScoreC.add_child(shot_score)

	if score != 0:
		total_score += score
		if total_score < 0: total_score = 0
		header.update_total_score(total_score)
		header.show_total_score()

func _on_bottom_area_enter(area):
	var n = area.get_parent()
	if n.is_in_group("note") or n.is_in_group("instant"):
		n.entered_bottom = true

func _on_bottom_area_exited(area):
	var n = area.get_parent()
	if n.is_in_group("note"): #or n.is_in_group("instant"):
		if !n.is_collected:
			if n.size == 'big':
				# ignore note damage and use GameSpace params
				missed_notes_temp += GameSpace.big_miss_damage
			else:
				missed_notes_temp += GameSpace.short_miss_damage

			if missed_notes_temp >= heart_duration:
				$LifesSet.lost_life()
				missed_notes_temp = 0

				$HurtScreen/AnimationPlayer.stop()
				$HurtScreen/AnimationPlayer.play("hurt")

func _on_no_lifes():
	return
	GameSpace.paused = true
	GameSpace.failed = true
	music.pause()
	popup_screen.show_fail()
	$Target.hide()
	$Pointer.show()

func _on_menu_btn_press():
	yield(get_tree().create_timer(0.2), "timeout")
	SceneLoader.goto_scene("res://SongsMenu.tscn")

func _on_replay_btn_press():
	# reload song to get config and map changes in dev mode
	if OS.is_debug_build() and GameSpace.curr_song: 
		GameSpace.curr_song.reload_song()

	yield(get_tree().create_timer(0.2), "timeout")
	SceneLoader.goto_scene("res://Game.tscn")

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

func _on_flow_finished():
	is_finished = true
	GameSpace.paused = true
	music.pause()
	$Target.hide()
	$Pointer.show()

	var progress_level = calc_progress_level()
	print(total_score, "/", flow.max_score, " : ", progress_level)
	popup_screen.show_success(total_score, progress_level)

	mc.save_finished_track()
	if mc.get_highscore() == null or (mc.get_highscore() != null and mc.get_highscore() < total_score):
		mc.save_highscore(total_score)
		mc.set_param("progress_level", progress_level)
		mc.write()
		#print(mc.data)

func calc_progress_level():
	if total_score > flow.max_score+200:
		return 3
	elif total_score > flow.max_score*0.75:
		return 2
	elif total_score > 0:
		return 1
	else:
		return 0
