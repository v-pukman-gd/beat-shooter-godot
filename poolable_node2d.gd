extends Node2D

signal killed(target)
var dead = true

func kill():
	dead = true
	emit_signal("killed", self)
