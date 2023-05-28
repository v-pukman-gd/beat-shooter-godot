extends Node2D

signal missed
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#"res://GunShotSnglFireIn PE1097304.mp3"
#"res://GunShotSnglShotIn PE1097906.mp3"
var reload_sound = preload("res://mixkit-handgun-click-1660.mp3")
var big_fire_sound = preload("res://GunShotSnglShotIn PE1097906.mp3")
var small_fire_sound = preload("res://GunShotSnglShotIn PE1097906.mp3") #preload("res://mixkit-game-gun-shot-1662.mp3")
#var reload_sound = preload("res://mixkit-handgun-click-1660.mp3")

var is_fire_on = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Area2D.connect("area_entered", self, "_on_area_enter")
	$Area2D.connect("area_exited", self, "_on_area_exit")
	
	$AudioStreamPlayer2D.stream = reload_sound
	$AudioStreamPlayer2D.play()


func _process(delta):
	self.position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("fire"):
		print("fire:")
		
		$AudioStreamPlayer2D.stream = big_fire_sound
		$AudioStreamPlayer2D.play()
		
		var collected = 0
		for n in get_tree().get_nodes_in_group("note"):
			if n.is_colliding:
				var res = n.collect()
				if res: collected += 1
				#break
			
		print("check collected:", collected)	
		if collected <= 0:
			emit_signal("missed", global_position)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if Input.mouse_mode != Input.MOUSE_MODE_HIDDEN:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			
	
func _on_area_enter(b):
	print(b.get_parent(), b.get_parent().is_in_group("note"))
	if b and b.get_parent():
		var node = b.get_parent()
		if node.is_in_group("note"):
			node.is_colliding = true
		elif node.is_in_group("instant"):
			node.collect()
	
func _on_area_exit(b):
	if b and b.get_parent() and b.get_parent().is_in_group("note"):
		b.get_parent().is_colliding = false
