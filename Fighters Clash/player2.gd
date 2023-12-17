extends Node2D
signal p2pickehonda
signal p2pickblanka
signal p2pickryu

signal p2ready

signal ehonda2
signal blanka2
signal ryu2

var heropick = "blank"
var alreadychoose = false
var disable_space = false

@onready var label = $"name"
var ehonda = preload("res://selection screen/E Honda - Idle.png")
var ryu = preload("res://selection screen/Idle.png")
var blanka = preload("res://selection screen/38136.png")

func _ready():
	pass



func _process(_delta):
	if Input.is_action_just_pressed("jump player2") and disable_space == false:
		if heropick == "ehonda":
			$AudioStreamPlayer2D3.play()
			disable_space = true
			$ready.visible=true
			emit_signal("p2pickehonda")
			emit_signal("p2ready")
			alreadychoose = true
			$ehonda2.play ("victory")
			$ehonda2.visible = true
			$"hero".texture = $ehonda2
		if heropick == "blanka":
			$AudioStreamPlayer2D3.play()
			disable_space = true
			$ready.visible=true
			emit_signal("p2pickblanka")
			alreadychoose = true
			emit_signal("p2ready")
			$blanka2.visible = true
			$"hero".texture = $blanka2
			$blanka2.play("idle")
		if heropick == "ryu":
			$AudioStreamPlayer2D3.play()
			disable_space = true
			$ready.visible=true
			emit_signal("p2pickryu")
			alreadychoose = true
			emit_signal("p2ready")
			$ryu2.play ("idle")
			$ryu2.visible = true
			$"hero".texture = $ryu2
	var selection_box_x = $"selectionbox2".position.x
	if Input.is_action_just_pressed("ui_right") and selection_box_x != 435 and alreadychoose == false:
		$"selectionbox2".position.x += 75
		$"SelectionCursorPlayer2".offset.x += 32
	if Input.is_action_just_pressed("ui_left") and selection_box_x != 285 and alreadychoose == false:
		$"selectionbox2".position.x -= 75
		$"SelectionCursorPlayer2".offset.x -= 32



func _on_selectionbox_2_body_entered(body):
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
