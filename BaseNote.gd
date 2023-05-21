extends Node2D

var is_colliding = false
export var size = "small"

func collect():
	if !is_colliding: return
	
	print("collected!")
	hide()
