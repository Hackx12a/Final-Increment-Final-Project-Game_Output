extends Node2D
signal p1ready
signal p2ready
var p1 = false
var p2 = false

signal start_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("p2ready", _on_player_2_p_2_ready)
	connect("p1ready", _on_player_1_p_1_ready)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("start the battle"):
		if p1 and p2:
			$"..".queue_free()
			emit_signal("start_timer")
		else:
			$"../Label".visible = true


func _on_player_1_p_1_ready():
	p1 = true


func _on_player_2_p_2_ready():
	p2 = true

