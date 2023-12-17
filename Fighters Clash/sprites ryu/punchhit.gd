extends Area2D

@onready var anim = $AnimationPlayer
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func attack():
	anim.play("punch")
func kick():
	anim.play("kick")
