extends Node2D
signal w

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("w")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
