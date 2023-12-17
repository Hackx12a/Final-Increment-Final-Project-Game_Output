extends Node2D
var current_health = MAX_HEALTH
const MAX_HEALTH = 100
signal ProgressBarsofehondaplayer2

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("ProgressBarsofehondaplayer2", _on_ehondaplayer_2_progress_barsofehondaplayer_2)




func _on_ehondaplayer_2_progress_barsofehondaplayer_2():
	current_health -= 10
	current_health = clamp(current_health, 0, MAX_HEALTH) 
	$ProgressBar.value = current_health
