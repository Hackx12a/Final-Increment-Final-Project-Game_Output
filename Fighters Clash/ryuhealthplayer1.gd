extends Node2D
var current_health = MAX_HEALTH
const MAX_HEALTH = 100
signal ryup1health

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("ryup1health", _on_ryuplayer_1_ryup_1_health)



func _on_ryuplayer_1_ryup_1_health():
	current_health -= 10
	current_health = clamp(current_health, 0, MAX_HEALTH) 
	$ProgressBars.value = current_health
