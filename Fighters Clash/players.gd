extends Node2D
const pickingfighters = preload("res://pick_player.tscn")
@onready var ryu = $ryuplayer1
@onready var ehonda = $ehondaplayer1
var countdown_label = Label

signal to_move_allfighters

var speed = 400

func _ready():
	$AudioStreamPlayer2D.play()
	call_deferred("_atay")
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("back to pick hero"):
		get_tree().change_scene_to_file("res://scenes/world.tscn")

func _atay():
	var new_pickingfighters = pickingfighters.instantiate()
	get_parent().add_child(new_pickingfighters)
	new_pickingfighters.connect("ehonda1", _on_pick_player_ehonda)
	new_pickingfighters.connect("blanka1" ,_on_pick_player_blanka)
	new_pickingfighters.connect("ryu1", _on_pick_player_ryu)
	
	new_pickingfighters.connect("ryu2", _on_pick_player_ryu1)
	new_pickingfighters.connect("blanka2", _on_pick_player_blanka1)
	new_pickingfighters.connect("ehonda2", _on_pick_player_ehonda1)
	
	new_pickingfighters.connect("finalstarttimer", on_start_countdown)

func _on_pick_player_ehonda():
	$player1.text = "Ehonda"
	$ryuplayer1.queue_free()
	$blankaplayer1.queue_free()
	$blankahealthplayer1.queue_free()
	$ryuhealthplayer1.queue_free()
func _on_pick_player_blanka():
	$player1.text = "Blanka"
	$ryuplayer1.queue_free()
	$ehondaplayer1.queue_free()
	$ehondahealthplayer1.queue_free()
	$ryuhealthplayer1.queue_free()
func _on_pick_player_ryu():
	$player1.text = "Ryu"
	$ehondaplayer1.queue_free()
	$blankaplayer1.queue_free()
	$blankahealthplayer1.queue_free()
	$ehondahealthplayer1.queue_free()

func _on_pick_player_ryu1():
	$player2.text = "Ryu"
	$ehondaplayer2.queue_free()
	$blankaplayer2.queue_free()
	$blankahealthplayer2.queue_free()
	$ehondahealthplayer2.queue_free()
func _on_pick_player_blanka1():
	$player2.text = "Blanka"
	$ehondaplayer2.queue_free()
	$ryuplayer2.queue_free()
	$ehondahealthplayer2.queue_free()
	$ryuhealthplayer2.queue_free()
func _on_pick_player_ehonda1():
	$player2.text = "Ehonda"
	$ryuplayer2.queue_free()
	$blankaplayer2.queue_free()
	$ryuhealthplayer2.queue_free()
	$blankahealthplayer2.queue_free()

func on_start_countdown():
	countdown_label = $Label
	emit_signal("to_move_allfighters")
	_start_countdown()

func _start_countdown():
	countdown_label.text = "3"
	countdown_label.visible = true
	$Label/Timer.start()

func _on_timer_timeout():
	match countdown_label.text:
		"3":
			countdown_label.text = "2"
		"2":
			countdown_label.text = "1"
		"1":
			countdown_label.visible = false
			$AudioStreamPlayer2D2.play()
			$Label/Timer.stop()
			$Sprite2D.visible = true
			$Label/Timer2.start()


func _on_timer_2_timeout():
	$Sprite2D.visible = false
