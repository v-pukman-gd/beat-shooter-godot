tool
extends Node2D


export(String, "Skull", "Dollar") var type = "Skull"


# Called when the node enters the scene tree for the first time.
func _ready():
	if type == "Skull":
		$Skull2.show()
		$Skull2.scale = Vector2(0.12, 0.12)
	else:
		$Skull4.show()
		$Skull4.scale = Vector2(0.12, 0.12)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
