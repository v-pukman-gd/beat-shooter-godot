extends Node

const Pool = preload("res://pool.gd")
var pool = {}

var NOTE_SCN = {
	"big": preload("res://Coin.tscn"),
	"middle": preload("res://Gem.tscn"),
	"short":  preload("res://InstantNote.tscn"),
}

var pool_size = {
	"big": 100,
	"middle": 100,
	"short": 50
}

func setup():
	for type in pool_size.keys():
		pool[type] =  Pool.new(pool_size[type], type+"_n", NOTE_SCN[type])

	pool["big"] = pool["big"]
	pool["middle"] = pool["middle"]
	pool["short"] = pool["short"]

func get_instance(type):
	print("get instance: ", type)
	return pool[type].get_first_dead()
