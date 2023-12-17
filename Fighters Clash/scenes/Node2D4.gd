extends Node2D
var current_health = MAX_HEALTH
const MAX_HEALTH = 100
signal ProgressBars1

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("ProgressBars1",  _on_ken_progress_bars_1)


func _on_ken_progress_bars_1():
	current_health -= 10
	current_health = clamp(current_health, 0, MAX_HEALTH) 
	$ProgressBars1.value = current_health
