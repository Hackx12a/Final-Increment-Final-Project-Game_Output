extends Node2D
signal hit_enemy


@onready var label = $"name"
var ehonda = preload("res://selection screen/E Honda - Idle.png")
var ryu = preload("res://selection screen/Idle.png")
var blanka = preload("res://selection screen/38136.png")
func _ready():
	emit_signal("hit_enemy")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): 
	var selection_box_x = $selectionbox4.position.x
	if Input.is_action_just_pressed("right") and selection_box_x != 144:
		$selectionbox4.position.x += 72
		$SelectionCursorPlayer1.offset.x += 32
		print(selection_box_x)
	if Input.is_action_just_pressed("left") and selection_box_x != 0:
		$selectionbox4.position.x -= 72
		$SelectionCursorPlayer1.offset.x -= 32


func _on_selectionbox_4_body_entered(body):
	if body.name == "ehonda":
		label.text = "Ehonda"
		$"hero".texture = ehonda
		emit_signal("hit_enemy")
