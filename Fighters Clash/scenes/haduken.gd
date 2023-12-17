extends Area2D

var velocity = Vector2(300, 0)  # Adjust the velocity as needed

func _process(delta):
	var collision = move_and_collide(velocity * delta)

	if collision:
		# Handle collision logic if needed, e.g., queue_free() to remove the projectile
		queue_free()

# Additional logic for firing the projectile goes here
