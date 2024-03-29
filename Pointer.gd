extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	update_position()

func _process(delta):
	update_position()
	
func update_position():
	self.position = get_global_mouse_position()
	var screen = get_viewport_rect().size
	
	if self.position.x < 15:
		self.position.x = 15
	elif self.position.x > screen.x - 20:
		self.position.x = screen.x - 20
		
	if self.position.y < 10:
		self.position.y = 10
	elif self.position.y > screen.y - 28:
		self.position.y = screen.y - 28

func _input(event):	
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if Input.mouse_mode != Input.MOUSE_MODE_HIDDEN:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	#if self.visible and event is InputEventMouseButton and event.is_pressed():
	#	$AudioStreamPlayer.play()
