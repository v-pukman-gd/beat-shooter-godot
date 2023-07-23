extends Node2D

signal killed(target)
var dead = true

func kill():
	dead = true
	emit_signal("killed", self)

func reset():
	pass

func _init():
	#print("INIT")
	pass

# called EACH TIME when get_instance is called
func _enter_tree():
	#print("ENTER_TREE")
	reset()

# called ONLY ONCE when get_instance is called (at first time)
func _ready():
	#print("READY")
	#reset() # no need to reset when it's called at _enter_tree
	pass
