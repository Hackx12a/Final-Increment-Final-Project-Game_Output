extends CharacterBody2D
signal to_move_allfighters

signal blankap1health

signal blankaplayer1killed
signal ehondaplayer2_get_killed
signal ryuplayer2_get_killed
signal blankaplayer2killed

signal blankaplayer1_hitenemy

signal ehondaplayer2_hit_enemy
signal ryuplayer2_hitenemy
signal blankaplayer2hit_enemy

var speed = 700
var speed1 = 1000
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var can_move = false
var can_attack = false
var left = false
var punch = 1
var rollclick = false
var MAX_HEALTH = 100
var hit = false
var y_position = -600
var dead = false
var current_health = MAX_HEALTH
@onready var animation = $AnimationPlayer
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	call_deferred("_disable")
	connect("blankaplayer2killed", _on_blankaplayer_2_blankaplayer_2_killed)
	connect("blankaplayer2hit_enemy", _on_blankaplayer_2_blankaplayer_2_hit_enemy)
	connect("ryuplayer2_get_killed", _on_ryu_ryuplayer_2_get_killed)
	connect("ehondaplayer2_get_killed", _on_ehondaplayer_2_ehondaplayer_2_get_killed)
	connect("ehondaplayer2_hit_enemy", _on_ehondaplayer_2_ehondaplayer_2_hit_enemy)
	connect("ryuplayer2_hitenemy", _on_ryu_ryuplayer_2_hitenemy)
	connect("to_move_allfighters", _on_players_to_move_allfighters)

func _process(delta):
	if dead:
		position.y += y_position * delta
		position.x -= speed * delta
	if hit:
		position.x -= speed1 * delta

	if rollclick:
		if can_attack:
			position.x += speed * delta
			animation.play("roll")

	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("rollblanka"):
		rollclick = true





	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if can_move:
			velocity.y = JUMP_VELOCITY
			animation.play("jump")
	
	if Input.is_action_just_pressed("punchplayer1"):
		if punch == 1:
			if can_attack:
				$Timetoattackagain.start()
				can_attack = false
				animation.play("punch1")
				punch += 1

		elif punch == 2:
			if can_attack:
				$Timetoattackagain.start()
				can_attack = false
				animation.play("punch")
				punch = 1
				

	if Input.is_action_just_pressed("kickplayer1"):
		if can_attack:
			$Timetoattackagain.start()
			can_attack = false
			animation.play("kick")


	if Input.is_action_just_pressed("crouchplayer1"):
		if can_move:
			animation.play("crouch")
	if Input.is_action_just_released("crouchplayer1"):
		animation.play("walk")
	
	var direction = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("right"):
		if can_move:
			animation.play("walk")
			rollclick = false
	if Input.is_action_just_pressed("left"):
		if can_move:
			left = true
			can_attack = false
			animation.play("shield")
			rollclick = false
	if Input.is_action_just_released("left"):
		if can_move:
			left = false
			can_attack = true


	if direction:
		if can_move:
			velocity.x = direction * SPEED
	else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "win" or anim_name == "jump" or anim_name == "intro" or anim_name == "punch" or anim_name == "punch1" or anim_name == "kick" or anim_name == "punch" or anim_name == "punch1" or anim_name == "roll" or anim_name == "hurt":
		animation.play("walk")
	elif anim_name == "shield":
		animation.play("walkbackward")


func _on_players_to_move_allfighters():
	$Timertostart.start()
	can_attack = false
	can_move = false
	animation.play("win")


func _on_timertostart_timeout():
	can_attack = true
	can_move = true


func _on_timetoattackagain_timeout():
	can_attack = true
	can_move = true


func _on_kick_body_entered(body):
	if body.is_in_group("player2"):
		$Timerforhiteffects.start()
		$roll2.visible = true
		$kick2.play()
		$Timetoattackagain.start()
		can_attack = false
		emit_signal("blankaplayer1_hitenemy")
		call_deferred("_disable")


func _on_punch_body_entered(body):
	if body.is_in_group("player2"):
		$punch3.visible = true
		$Timerforhiteffects.start()
		$punch2.play()
		$Timetoattackagain.start()
		can_attack = false
		emit_signal("blankaplayer1_hitenemy")
		call_deferred("_disable")

func _disable():
	$kick/kick.disabled = true
	$punch/punch.disabled = true
	$roll/roll.disabled = true

func _on_roll_body_entered(body):
	if body.is_in_group("player2"):
		$roll2.visible = true
		$kick2.play()
		$Timerforhiteffects.start()
		$Timetoattackagain.start()
		can_attack = false
		emit_signal("blankaplayer1_hitenemy")
		call_deferred("_disable")
		rollclick = false


func _on_ehondaplayer_2_ehondaplayer_2_hit_enemy():
	if left == true:
		animation.play("shield")
	else:
		_health()

func _on_ryu_ryuplayer_2_hitenemy():
	if left == true:
		animation.play("shield")
	else:
		_health()
	
	
func _health():
	if current_health == 0:
		$hurtblanka.play()
		dead = true
		$Timeranimationifblankaplayer1dead.start()
		emit_signal("blankaplayer1killed")
		can_move = false
		can_attack = false
		animation.play("death")
		await get_node("AnimationPlayer").animation_finished
		queue_free()
	else:
		$hurtblanka.play()
		hit = true
		emit_signal("blankap1health")
		$Timerifhit.start()
		$Timetoattackagain.start()
		animation.play("hurt")
		can_attack = false
		can_move = false
		current_health -= 10
		current_health = clamp(current_health, 0, MAX_HEALTH) 
		$ProgressBars.value = current_health


func _on_timerifhit_timeout():
	hit = false


func _on_ehondaplayer_2_ehondaplayer_2_get_killed():
	$youwin.play()
	can_attack = false
	can_move = false
	$Timerforslowmoanimation.start()
	slow_down_scene()


func _on_ryu_ryuplayer_2_get_killed():
	$youwin.play()
	can_attack = false
	can_move = false
	$Timerforslowmoanimation.start()
	slow_down_scene()


func _on_blankaplayer_2_blankaplayer_2_hit_enemy():
	if left == true:
		animation.play("shield")
	else:
		_health()


func _on_blankaplayer_2_blankaplayer_2_killed():
	$youwin.play()
	can_attack = false
	can_move = false
	$Timerforslowmoanimation.start()
	slow_down_scene()

func slow_down_scene():
	Engine.set_time_scale(0.4)  # Adjust the time scale as needed for slower motion

# Function to reset the time scale to normal
func reset_time_scale():
	Engine.set_time_scale(1.0)

func _on_timeranimationifblankaplayer_1_dead_timeout():
	dead = false


func _on_timerforslowmoanimation_timeout():
	reset_time_scale()
	animation.play("win")


func _on_timerforhiteffects_timeout():
	$punch3.visible = false
	$punch4.visible = false
	$roll2.visible = false
