extends  "res://PoolableNode2D.gd"

var note_scale = 0.5
var length = 1600 

func _ready():
	reset()

func reset():
	$Line.position.y = 0
	$Line_h2.position.y = -length*note_scale*0.5
	$Line_h3.position.y = -length*note_scale*0.25
	$Line_h4.position.y = -length*note_scale*0.75
