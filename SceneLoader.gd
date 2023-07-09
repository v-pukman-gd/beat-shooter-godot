extends Control

var current_scene
var loader
var wait_frames = 1
var time_max = 100 #msec

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count()-1)
	hide()

func goto_scene(path, show_progress=false):
	loader = ResourceLoader.load_interactive(path)
	if loader == null:
		show_error()
		return

	current_scene.queue_free()

	if show_progress:
		show()
		get_node("ProgressBar").set_value(0)

	wait_frames = 5
	set_process(true)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	set_size(get_viewport_rect().size)

	if loader == null:
		set_process(false)
		return

	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else:
			show_error()
			loader = null
			break

func show_error():
	print("loading error")

func update_progress():
	var p = float( loader.get_stage() ) / loader.get_stage_count()
	#get_node("ProgressB").set_progress(p)
	#print("load ...", p)
	get_node("ProgressBar").set_value(int(p*100))


func set_new_scene(scene_resource):
	hide()
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
