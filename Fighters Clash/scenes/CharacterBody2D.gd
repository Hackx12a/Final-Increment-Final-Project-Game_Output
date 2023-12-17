extends CharacterBody2D
signal ehondaplayer2_hit_enemy
signal ryuplayer2_hitenemy
signal blankaplayer2hit_enemy

signal ehondaplayer1_hit_enemy

signal ehondaplayer1_get_killed
signal ehondaplayer2_get_killed
signal ryuplayer2_get_killed
signal blankaplayer2killed

signal to_move_allfighters

signal ProgressBars1

const SPEED = 350.0
const JUMP_VELOCITY = -470
const MAX_HEALTH = 100


@onready var animation = $AnimationPlayer
@onready var sumohealth = $ProgressBar
@onready var anim = $AnimatedSprite2D
var health = MAX_HEALTH
var can_move = true
var can_attack = true
var left = false
var hit = false
var speed = 1000
var dead = false
var y_position = -600
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	call_deferred("_disable")
	connect("blankaplayer2killed", _on_blankaplayer_2_blankaplayer_2_killed)
	connect("blankaplayer2hit_enemy", _on_blankaplayer_2_blankaplayer_2_hit_enemy)
	connect("to_move_allfighters", _on_players_to_move_allfighters)
	connect("ryuplayer2_hitenemy", _on_ryu_ryuplayer_2_hitenemy)
	connect("ehondaplayer2_hit_enemy", _on_ehondaplayer_2_ehondaplayer_2_hit_enemy)
	connect("ehondaplayer2_get_killed",_on_ehondaplayer_2_ehondaplayer_2_get_killed)
	connect("ryuplayer2_get_killed", _on_ryu_ryuplayer_2_get_killed)

#FUNCTION OF JUMPING AND ATTACK
func _physics_process(delta):
	if dead:
		position.y += y_position * delta
		position.x -= speed * delta
	if hit:
		can_move = false
		can_attack = false
		position.x -= speed * delta
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("slashattack") and is_on_floor():
		if can_attack:
			$countdowntoattackagain.start()
			animation.play("slashattack")
			can_attack = false
			velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("jump player1") and is_on_floor():
		if can_move:
			velocity.y = JUMP_VELOCITY
			animation.play("jump")

	if Input.is_action_just_pressed("slashattack") and not is_on_floor():
		if can_attack:
			$countdowntoattackagain.start()
			animation.play("slashattack")
			can_attack = false

	
	var direction = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("left"):
		if can_move:
			left = true
			can_attack = false
			animation.play("shield")
	if Input.is_action_just_released("left"):
		if can_move:
			left = false
			can_attack = true
	if Input.is_action_just_pressed("right"):
		if can_move:
			animation.play("walk")

	if Input.is_action_just_pressed("headbuttplayer1"):
		animation.play("headbutt")
		$countdowntoattackagain.start()
		can_attack = false

	if Input.is_action_just_pressed("crouchplayer1"):
		if can_move:
			animation.play("crouch")
	if Input.is_action_just_released("crouchplayer1"):
		animation.play("walk")

	if Input.is_action_just_pressed("tumblingplayer1"):
		animation.play("tumbling")
		$countdowntoattackagain.start()
		can_attack = false

	if direction:
		if can_move:
			if can_move:velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _health():
	if health == 0:
		dead = true
		$deathscenetimer.start()
		can_move = false
		can_attack = false
		animation.play("death")
		emit_signal("ehondaplayer1_get_killed")
		await get_node("AnimationPlayer").animation_finished
		queue_free()
	else:
		$hurt.play()
		hit = true
		$Timerifhit.start()
		can_move = false
		can_attack = false
		$attack.start()
		animation.play("hurt")
		health -= 10
		emit_signal("ProgressBars1")

		
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hurt" or anim_name == "jump" or anim_name == "slashattack" or anim_name == "shield" or anim_name == "intro" or anim_name == "headbutt" or anim_name == "tumbling":
		animation.play("walk")


#IF ENEMY GET HIT
func _on_punch_body_entered(body):
	if body.is_in_group("player2"):
		$Timerforhiteffects.start()
		$Sprite2D.visible = true
		$punch2.play()
		emit_signal("ehondaplayer1_hit_enemy")
		call_deferred("_disable")

func _disable():
	$punch/punch.disabled = true
	$headbutt_tumbling/headbutt_tumbling.disabled = true

func slow_down_scene():
	Engine.set_time_scale(0.6)

# Function to reset the time scale to normal
func reset_time_scale():
	Engine.set_time_scale(1.0)


func _on_countdowntoattackagain_timeout():
	can_attack = true

func _on_slowthescenetimer_timeout():
	can_move = false
	can_attack = false
	reset_time_scale()
	animation.play("victory")





func _on_countdowntomove_timeout():
	can_move = true
	can_attack = true






func _on_attack_timeout():
	can_move = true
	can_attack = true


func _on_ryu_ryuplayer_2_get_killed():
	$youwin.play()
	can_move = false
	can_attack = false
	$slowthescenetimer.start()
	slow_down_scene()

func _on_ehondaplayer_2_ehondaplayer_2_get_killed():
	$youwin.play()
	can_move = false
	can_attack = false
	$slowthescenetimer.start()
	slow_down_scene()



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


func _on_players_to_move_allfighters():
	animation.play("intro")
	$countdowntomove.start()
	can_move = false
	can_attack = false


func _on_timerifhit_timeout():
	hit = false


func _on_blankaplayer_2_blankaplayer_2_hit_enemy():
	if left == true:
		animation.play("shield")
	else:
		_health()


func _on_blankaplayer_2_blankaplayer_2_killed():
	$youwin.play()
	can_move = false
	can_attack = false
	$slowthescenetimer.start()
	slow_down_scene()


func _on_deathscenetimer_timeout():
	dead = false


func _on_headbutt_tumbling_body_entered(body):
	if body.is_in_group("player2"):
		$Sprite2D2.visible = true
		$Timerforhiteffects.start()
		$kick.play()
		emit_signal("ehondaplayer1_hit_enemy")
		call_deferred("_disable")


func _on_timerforhiteffects_timeout():
	$Sprite2D.visible = false
	$Sprite2D2.visible = false
