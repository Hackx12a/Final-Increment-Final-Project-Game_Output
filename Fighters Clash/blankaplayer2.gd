extends CharacterBody2D
signal blankaplayer2hit_enemy
signal blankaplayer2killed
signal blankap2health




signal to_move_allfighters

signal ehondaplayer1_get_killed
signal ryuplayer1_get_killed
signal blankaplayer1_getkilled

signal ehondaplayer1_hit_enemy
signal ryuplayer1_hitenemy
signal blankaplayer1_hitenemy

var speed = 700
var speed1 = 1000
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var y_position = -600
var can_move = false
var can_attack = false
var left = false
var punch = 1
var rollclick = false
var MAX_HEALTH = 100
var hit = false
var dead = false
var current_health = MAX_HEALTH
@onready var animation = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	call_deferred("_disable")
	connect("ehondaplayer1_get_killed", _on_ken_ehondaplayer_1_get_killed)
	connect("ryuplayer1_get_killed", _on_ryuplayer_1_ryuplayer_1_get_killed)
	connect("blankaplayer1_getkilled", _on_blankaplayer_1_blankaplayer_1_killed)
	connect("ehondaplayer1_hit_enemy", _on_ken_ehondaplayer_1_hit_enemy)
	connect("ryuplayer1_hitenemy", _on_ryuplayer_1_ryuplayer_1_hit_enemy)
	connect("blankaplayer1_hitenemy", _on_blankaplayer_1_blankaplayer_1_hitenemy)

func _physics_process(delta):
	if dead:
		position.y += y_position * delta
		position.x += speed * delta
	if hit:
		position.x += speed * delta

	if rollclick:
		if can_attack:
			position.x -= speed * delta
			animation.play("roll")

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("rollblankaplayer2"):
		rollclick = true

	if Input.is_action_just_pressed("jump player2") and is_on_floor():
		if can_move:
			velocity.y = JUMP_VELOCITY
			animation.play("jump")


	if Input.is_action_just_pressed("punchblankaplayer2"):
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



	if Input.is_action_just_pressed("kickblankaplayer2"):
		if can_attack:
			$Timetoattackagain.start()
			can_attack = false
			animation.play("kick")

	var direction = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("ui_left"):
		if can_move:
			animation.play("walk")
			rollclick = false
	if Input.is_action_just_pressed("ui_right"):
		if can_move:
			left = true
			can_attack = false
			animation.play("shield")
			rollclick = false
	if Input.is_action_just_released("ui_right"):
		if can_move:
			left = false
			can_attack = true

	if Input.is_action_just_pressed("crouchplayer2"):
		if can_move:
			animation.play("crouch")
	if Input.is_action_just_released("crouchplayer2"):
		animation.play("walk")

	if direction:
		if can_move:
			velocity.x = direction * SPEED
	else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func slow_down_scene():
	Engine.set_time_scale(0.4)  # Adjust the time scale as needed for slower motion

# Function to reset the time scale to normal
func reset_time_scale():
	Engine.set_time_scale(1.0)

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
	if body.is_in_group("player1"):
		$kick2.play()
		$Timerforhiteffects.start()
		$Sprite2D.visible = true
		$Timetoattackagain.start()
		can_attack = false
		emit_signal("blankaplayer2hit_enemy")
		call_deferred("_disable")


func _on_punch_body_entered(body):
	if body.is_in_group("player1"):
		$punch2.play()
		$Timerforhiteffects.start()
		$Sprite2D2.visible = true
		$Timetoattackagain.start()
		can_attack = false
		emit_signal("blankaplayer2hit_enemy")
		call_deferred("_disable")


func _on_roll_body_entered(body):
	if body.is_in_group("player1"):
		$Timerforhiteffects.start()
		$Sprite2D3.visible = true
		$kick2.play()
		$Timetoattackagain.start()
		can_attack = false
		emit_signal("blankaplayer2hit_enemy")
		call_deferred("_disable")
		rollclick = false


func _disable():
	$kick/kick.disabled = true
	$punch/punch.disabled = true
	$roll/roll.disabled = true



func _on_ken_ehondaplayer_1_hit_enemy():
	if left == true:
		animation.play("shield")
	else:
		_health()


func _on_ryuplayer_1_ryuplayer_1_hit_enemy():
	if left == true:
		animation.play("shield")
	else:
		_health()


func _on_blankaplayer_1_blankaplayer_1_hitenemy():
	if left == true:
		animation.play("shield")
	else:
		_health()
	
	
func _health():
	if current_health == 0:
		dead = true
		$hurtblanka.play()
		$anotherdeathanimation.start()
		emit_signal("blankaplayer2killed")
		can_move = false
		can_attack = false
		animation.play("death")
		await get_node("AnimationPlayer").animation_finished
		queue_free()
	else:
		hit = true
		$hurtblanka.play()
		emit_signal("blankap2health")
		$Timerifhit.start()
		$Timetoattackagain.start()
		animation.play("hurt")
		can_attack = false
		can_move = false
		current_health -= 10
		current_health = clamp(current_health, 0, MAX_HEALTH) 
		$ProgressBar.value = current_health

#timer what distance if blanka player2 hit by enemy
func _on_timerifhit_timeout():
	hit = false



#if blanka player2 win make an animation of win

func _on_ken_ehondaplayer_1_get_killed():
	can_attack = false
	can_move = false
	slow_down_scene()
	$deathanimationslowmotimer.start()
	$youwin.play()


func _on_ryuplayer_1_ryuplayer_1_get_killed():
	can_attack = false
	can_move = false
	slow_down_scene()
	$deathanimationslowmotimer.start()
	$youwin.play()


func _on_blankaplayer_1_blankaplayer_1_killed():
	can_attack = false
	can_move = false
	slow_down_scene()
	$deathanimationslowmotimer.start()
	$youwin.play()

func _on_deathanimationslowmotimer_timeout():
	animation.play("win")
	reset_time_scale()


func _on_anotherdeathanimation_timeout():
	dead = false


func _on_timerforhiteffects_timeout():
	$Sprite2D3.visible = false
	$Sprite2D.visible = false
	$Sprite2D2.visible = false
