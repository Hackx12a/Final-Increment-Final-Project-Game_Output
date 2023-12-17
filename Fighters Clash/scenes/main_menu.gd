extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()


func _on_button_2_pressed():
	$click.play()
	$Label.visible = true


func _on_button_pressed():
	$click.play()
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_button_3_pressed():
	$click.play()
	get_tree().quit()
