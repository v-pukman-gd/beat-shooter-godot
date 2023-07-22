extends Node

const Pool = preload("res://Pool.gd")
var pool = {}

var pool_scn = {
	"big_note": preload("res://Coin.tscn"),
	"middle_note": preload("res://Gem.tscn"),
	"short_note":  preload("res://InstantNote.tscn"),
	"bar_grid": preload("res://BarGrid.tscn"),
	"bullet_hole": preload("res://BulletHole.tscn")
}

var pool_size = {
	"big_note": 30,
	"middle_note": 50,
	"short_note": 50,
	"bar_grid": 6,
	"bullet_hole": 10
}

func setup():
	for type in pool_size.keys():
		pool[type] =  Pool.new(pool_size[type], type+"_n", pool_scn[type])

func get_instance(type):
	print("get_instance: ", type)
	return pool[type].get_first_dead()
