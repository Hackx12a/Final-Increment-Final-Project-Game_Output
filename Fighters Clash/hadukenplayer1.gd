extends Area2D
var speed = 320 # Adjust the speed as needed
signal haduken1

func _process(delta):
	position.x += speed * delta
	if position.x > get_viewport_rect().size.x:
		queue_free()  


func _on_body_entered(body):
	if body.is_in_group("player2"):
		$kick2.play()
		emit_signal("haduken1")
		$haduken2.visible = true
		$Timer.start()
		$CollisionShape2D.queue_free()
		$Sprite2D.queue_free()



func _on_timer_timeout():
	$haduken2.visible = false
