extends Node2D
signal p2pickehonda
signal p2pickblanka
signal p2pickryu

signal start_timer
signal finalstarttimer

signal ehonda2
signal blanka2
signal ryu2

signal ehonda1
signal blanka1
signal ryu1

signal p1ready
var disable_spacebar = false


@onready var label = $"name"
var ehonda = preload("res://selection screen/E Honda - Idle.png")
var ryu = preload("res://selection screen/Idle.png")
var blanka = preload("res://selection screen/38136.png")
@onready var player1 = $"."
var alreadychoose = false
var heropick = "blank"
func _ready():
	connect("start_timer", _on_checkerifbothplayerareready_start_timer)
	connect("p2pickehonda", _on_player_2_p_2_pickehonda)
	connect("p2pickblanka", _on_player_2_p_2_pickblanka)
	connect("p2pickryu", _on_player_2_p_2_pickryu)
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D2.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): 
	if Input.is_action_just_pressed("jump player1") and disable_spacebar == false:
		if heropick == "ehonda":
			$AudioStreamPlayer2D3.play()
			disable_spacebar = true
			$ready.visible=true
			emit_signal("ehonda1")
			emit_signal("p1ready")
			alreadychoose = true
			$ehonda2.play ("victory")
			$ehonda2.visible = true
			$"hero".texture = $ehonda2
		if heropick == "blanka":
			$AudioStreamPlayer2D3.play()
			$ready.visible=true
			disable_spacebar = true
			emit_signal("blanka1")
			alreadychoose = true
			$blanka2.visible = true
			$"hero".texture = $blanka2
			$blanka2.play("idle")
			emit_signal("p1ready")
		if heropick == "ryu":
			$AudioStreamPlayer2D3.play()
			$ready.visible=true
			disable_spacebar = true
			emit_signal("ryu1")
			alreadychoose = true
			emit_signal("p1ready")
			$ryu2.play ("idle")
			$ryu2.visible = true
			$"hero".texture = $ryu2
	var selection_box_x = $"selectionbox4".position.x
	if Input.is_action_just_pressed("right") and selection_box_x != 144 and alreadychoose == false:
		$"selectionbox4".position.x += 72
		$"SelectionCursorPlayer1".offset.x += 32
	if Input.is_action_just_pressed("left") and selection_box_x != 0 and alreadychoose == false:
		$"selectionbox4".position.x -= 72
		$"SelectionCursorPlayer1".offset.x -= 32


func _on_selectionbox_4_body_entered(body):
	if body.name == "ehonda":
			label.text = "Ehonda"
			$"hero".texture = ehonda
			heropick = "ehonda"
	if body.name == "blanka":
			label.text = "Blanka"
			$"hero".texture = blanka
			heropick = "blanka"
	if body.name == "ryu":
			label.text = "Ryu"
			$"hero".texture = ryu
			heropick = "ryu"



func _on_player_2_p_2_pickblanka():
	emit_signal("blanka2")


func _on_player_2_p_2_pickehonda():
	emit_signal("ehonda2")


func _on_player_2_p_2_pickryu():
	emit_signal("ryu2")


func _on_checkerifbothplayerareready_start_timer():
	emit_signal("finalstarttimer")
