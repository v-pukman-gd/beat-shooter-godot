extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	self.position = get_global_mouse_position()

func _input(event):	
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if Input.mouse_mode != Input.MOUSE_MODE_HIDDEN:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	#if self.visible and event is InputEventMouseButton and event.is_pressed():
	#	$AudioStreamPlayer.play()
