extends Node2D

var is_colliding = false

onready var particles_started_at = 0

const BONUS_SCORE = 25
const bouns_color = Color("fc8464") 

func _ready():
	$Particles1.emitting = false 

func hit():	
	$Particles1.emitting = true
	particles_started_at = Time.get_ticks_msec()
	
func hit_with_bonus():
	hit()
	randomize()
	var val = randi()%10
	if val == 0 or val == 5:
		$AudioStreamPlayer2D.play()
		return BONUS_SCORE
	else:
		return 0
	
func _process(delta):
	if $Particles1.emitting and particles_started_at > 0:
		if Time.get_ticks_msec() - particles_started_at > 1000:
			$Particles1.emitting = false
	
