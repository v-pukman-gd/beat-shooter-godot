extends Node2D

signal missed
signal hit
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#"res://GunShotSnglFireIn PE1097304.mp3"
#"res://GunShotSnglShotIn PE1097906.mp3"
var reload_sound = preload("res://mixkit-handgun-click-1660.mp3")
var no_bullets_sound = preload("res://no_bullets.mp3")
var big_fire_sound = preload("res://GunShotSnglShotIn PE1097906.mp3")
var small_fire_sound = preload("res://GunShotSnglShotIn PE1097906.mp3") #preload("res://mixkit-game-gun-shot-1662.mp3")
#var reload_sound = preload("res://mixkit-handgun-click-1660.mp3")

var is_fire_on = false
var no_bullets = false
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
	
	if Input.is_action_just_pressed("fire"):
		print("fire:")
		
		if no_bullets:
			play_sound($AudioStreamPlayer2D2, no_bullets_sound)
			return
			
		if global_position.y < 100:
			return
			
		play_sound($AudioStreamPlayer2D, big_fire_sound)
		GameEvent.emit_signal("shoot", global_position)
		
		var collected = 0
		for n in get_tree().get_nodes_in_group("note"):
			if n.is_colliding:
				var note_collected = n.collect()
				if note_collected: 
					collected += 1
					# handle hit signal here as we need target position, not the note's position
					emit_signal("hit", n.score, n.score_color, global_position)
				#break
				
		for crab in get_tree().get_nodes_in_group("crab"):
			if crab.is_colliding:
				collected += 1
				var bonus = crab.hit_with_bonus()
				if bonus > 0:
					emit_signal("hit", bonus, crab.bouns_color, global_position, 0, -1, false)
			
		print("check collected:", collected)	
		if collected <= 0:
			# ignore UI header
			if global_position.y > 70:
				emit_signal("missed", global_position)
				

func _input(event):	
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if Input.mouse_mode != Input.MOUSE_MODE_HIDDEN:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			
func play_sound(channel, sound):
	channel.stream = sound
	channel.play()
	
func _on_area_enter(area):
	print(area.get_parent(), area.get_parent().is_in_group("note"))
	if area and area.get_parent():
		var el = area.get_parent()
		if el.is_in_group("note") or el.is_in_group("crab"):
			el.is_colliding = true
		elif el.is_in_group("instant"):
			el.collect()
			emit_signal("hit", el.score, el.score_color, global_position)
	
func _on_area_exit(area):
	if area and area.get_parent():
		if area.get_parent().is_in_group("note") or area.get_parent().is_in_group("crab"):
			area.get_parent().is_colliding = false

func _on_no_bullets():
	no_bullets = true

func _on_reload_gun(reload_bonus):
	no_bullets = false
	play_sound($AudioStreamPlayer2D2, reload_sound)
	if reload_bonus > 0:
		emit_signal("hit", reload_bonus, Color.white, global_position, 0, -1, false)
	
