extends Node2D
var current_health = MAX_HEALTH
const MAX_HEALTH = 100
signal blankap2health

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("blankap2health", _on_blankaplayer_2_blankap_2_health)




func _on_blankaplayer_2_blankap_2_health():
	current_health -= 10
	current_health = clamp(current_health, 0, MAX_HEALTH) 
	$ProgressBars.value = current_health
