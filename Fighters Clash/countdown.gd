extends Node2D

var countdown_label: Label

func _ready():
	countdown_label = $Label
	start_countdown()

func start_countdown():
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
			$Label/Timer.stop()
			$StaticBody2D/CollisionShape2D.disabled = true
			$Pngwing_com.visible = true

