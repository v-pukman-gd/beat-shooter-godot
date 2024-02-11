extends Node2D

signal missed
signal hit
signal bonus_hit

var reload_sound = preload("res://audio/mixkit-handgun-click-1660.mp3")
var no_bullets_sound = preload("res://audio/no_bullets.mp3")
var big_fire_sound = preload("res://audio/GunShotSnglShotIn PE1097906.mp3")
var small_fire_sound = preload("res://audio/GunShotSnglShotIn PE1097906.mp3") #preload("res://audio/mixkit-game-gun-shot-1662.mp3")
#var reload_sound = preload("res://audio/mixkit-handgun-click-1660.mp3")

var no_bullets = false

var check_hits_frames = -1
const POS_OFFSET = 35

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Area2D.connect("area_entered", self, "_on_area_enter")
	$Area2D.connect("area_exited", self, "_on_area_exit")

	play_sound($AudioStreamPlayer2D2, reload_sound)

	GameEvent.connect("no_bullets", self, "_on_no_bullets")
	GameEvent.connect("reload_gun", self, "_on_reload_gun")

func _process(delta):
	if GameSpace.paused: return

	self.position = get_global_mouse_position()
	var screen = get_viewport_rect().size
	
	if self.position.x < POS_OFFSET:
		self.position.x = POS_OFFSET
	elif self.position.x > screen.x - POS_OFFSET:
		self.position.x = screen.x - POS_OFFSET
		
	if self.position.y < POS_OFFSET:
		self.position.y = POS_OFFSET
	elif self.position.y > screen.y - POS_OFFSET:
		self.position.y = screen.y - POS_OFFSET
	
	
func _physics_process(delta):
	# Check hits after areas collisions are updated
	if check_hits_frames >= 1:
		check_hits_frames -= 1
	elif check_hits_frames == 0:
		check_hits()
		check_hits_frames = -1
		
func _on_fire_press():
	if no_bullets:
		play_sound($AudioStreamPlayer2D2, no_bullets_sound)
		return

	if global_position.y < 100:
		return
	
	self.position = get_global_mouse_position()	
	play_sound($AudioStreamPlayer2D, big_fire_sound)
	GameEvent.emit_signal("shoot", global_position)
	check_hits_frames = 1

func check_hits():
	var collected = 0
	for n in get_tree().get_nodes_in_group("note"):
		if n.is_colliding:
			var note_collected = n.collect()
			if note_collected:
				collected += 1
				# handle hit signal here as we need target position, not the note's position
				emit_signal("hit", n.score, n.score_color, n.particle_color, n.size, global_position)

	for crab in get_tree().get_nodes_in_group("crab"):
		if crab.is_colliding:
			collected += 1
			var bonus = crab.hit_with_bonus()
			if bonus > 0:
				emit_signal("bonus_hit", bonus, crab.bouns_color, global_position, -1)

	print("check collected:", collected)
	if collected <= 0:
		# ignore UI header
		if global_position.y > 70:
			emit_signal("missed", global_position)

func _input(event):
	if GameSpace.paused: return
	
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event.is_action_pressed("fire") or (event is InputEventScreenTouch and event.is_pressed()):
		_on_fire_press()
		if Input.mouse_mode != Input.MOUSE_MODE_HIDDEN:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func play_sound(channel, sound):
	channel.stream = sound
	channel.play()

func _on_area_enter(area):
	var node = area.get_parent()
	if node.is_in_group("note") or node.is_in_group("crab"):
		node.is_colliding = true
	elif node.is_in_group("instant"):
		node.collect()
		emit_signal("hit", node.score, node.score_color, node.particle_color, node.size, global_position)

func _on_area_exit(area):	
	var node = area.get_parent()
	if node.is_in_group("note") or node.is_in_group("crab"):
		node.is_colliding = false

func _on_no_bullets():
	no_bullets = true

func _on_reload_gun(reload_bonus):
	no_bullets = false
	play_sound($AudioStreamPlayer2D2, reload_sound)
	if reload_bonus > 0:
		emit_signal("bonus_hit", reload_bonus, Color.white, global_position, -1)

