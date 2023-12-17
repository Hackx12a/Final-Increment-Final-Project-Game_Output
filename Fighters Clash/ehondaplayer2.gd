extends CharacterBody2D
signal ehondaplayer2_hit_enemy

signal ehondaplayer1_get_killed
signal ehondaplayer2_get_killed
signal ryuplayer1_get_killed
signal blankaplyer1killed

signal to_move_allfighters

signal blankaplayer1_hitenemy
signal ryuplayer1_hit_enemy
signal ehondaplayer1_hit_enemy
signal ProgressBarsofehondaplayer2

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
var y_position = -600
var dead = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	call_deferred("_disable")
	connect("blankaplyer1killed", _on_blankaplayer_1_blankaplayer_1_killed)
	connect("blankaplayer1_hitenemy", _on_blankaplayer_1_blankaplayer_1_hitenemy)
	connect("ryuplayer1_get_killed",  _on_ryuplayer_1_ryuplayer_1_get_killed)
	connect("to_move_allfighters", _on_players_to_move_allfighters)
	connect("ehondaplayer1_get_killed", _on_ken_ehondaplayer_1_get_killed)
	connect("ehondaplayer1_hit_enemy", _on_ken_ehondaplayer_1_hit_enemy)
	connect("ryuplayer1_hit_enemy", _on_ryuplayer_1_ryuplayer_1_hit_enemy)

#FUNCTION OF JUMPING AND ATTACK
func _physics_process(delta):
	if dead:
		position.y += y_position * delta
		position.x += speed * delta
	if hit:
		can_move = false
		can_attack = false
		position.x += speed * delta
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("player1 slash attack") and is_on_floor():
		if can_attack:
			$countdowntoattackagain.start()
			animation.play("slashattack")
			can_attack = false
			velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("jump player2") and is_on_floor():
		if can_move:
			velocity.y = JUMP_VELOCITY
			animation.play("jump")

	if Input.is_action_just_pressed("headbuttplayer2"):
		animation.play("headbutt")
		$countdowntoattackagain.start()
		can_attack = false

	if Input.is_action_just_pressed("tumblingplayer2"):
		animation.play("tumbling")
		$countdowntoattackagain.start()
		can_attack = false

	if Input.is_action_just_pressed("crouchplayer2"):
		if can_move:
			animation.play("crouch")
	if Input.is_action_just_released("crouchplayer2"):
		animation.play("walk")

	if Input.is_action_just_pressed("player1 slash attack") and not is_on_floor():
		if can_attack:
			$countdowntoattackagain.start()
			animation.play("slashattack")
			can_attack = false

	
	var direction = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("ui_right"):
		if can_move:
			left = true
			can_attack = false
			animation.play("shield")
	if Input.is_action_just_released("ui_right"):
		if can_move:
			left = false
			can_attack = true
	if Input.is_action_just_pressed("ui_left"):
		if can_move:
			animation.play("walk")

	
	if direction:
		if can_move:
			if can_move:velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()



func _health():
	if health == 0:
		dead = true
		$anotherslowthescene.start()
		can_move = false
		can_attack = false
		animation.play("death")
		emit_signal("ehondaplayer2_get_killed")
		await get_node("AnimationPlayer").animation_finished
		queue_free()
	else:
		$hurt.play()
		hit = true
		$Timerifhit.start()
		$attack.start()
		can_move = false
		can_attack = false
		animation.play("hurt")
		health -= 10
		emit_signal("ProgressBarsofehondaplayer2")
		
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hurt" or anim_name == "jump" or anim_name == "slashattack" or anim_name == "shield" or anim_name == "intro" or anim_name == "headbutt" or anim_name == "tumbling":
		animation.play("walk")


#IF ENEMY GET HIT
func _on_punch_body_entered(body):
	if body.is_in_group("player1"):
		$punch2.play()
		$Timerforpuncheffects.start()
		$Sprite2D.visible = true
		emit_signal("ehondaplayer2_hit_enemy")
		call_deferred("_disable")

func _disable():
	$punch/punch.disabled = true
	$headbutt_tumbling/headbutt_tumbling.disabled = true
func slow_down_scene():
	Engine.set_time_scale(0.4)

# Function to reset the time scale to normal
func reset_time_scale():
	Engine.set_time_scale(1.0)


func _on_countdowntoattackagain_timeout():
	can_attack = true

func _on_slowthescenetimer_timeout():
	reset_time_scale()
	animation.play("victory")





func _on_countdowntomove_timeout():
	can_move = true
	can_attack = true





func _on_attack_timeout():
	can_move = true
	can_attack = true


func _on_ryuplayer_1_ryuplayer_1_hit_enemy():
	if left == true:
		animation.play("shield")
	else:
		_health()



func _on_ken_ehondaplayer_1_hit_enemy():
	if left == true:
		animation.play("shield")
	else:
		_health()


func _on_ken_ehondaplayer_1_get_killed():
	$youwin.play()
	can_move = false
	can_attack = false
	$slowthescenetimer.start()
	slow_down_scene()


func _on_players_to_move_allfighters():
	animation.play("intro")
	$countdowntomove.start()
	can_move = false
	can_attack = false


func _on_ryuplayer_1_ryuplayer_1_get_killed():
	$youwin.play()
	can_move = false
	can_attack = false
	$slowthescenetimer.start()
	slow_down_scene()


func _on_blankaplayer_1_blankaplayer_1_hitenemy():
	if left == true:
		animation.play("shield")
	else:
		_health()


func _on_timerifhit_timeout():
	hit = false


func _on_blankaplayer_1_blankaplayer_1_killed():
	$youwin.play()
	can_move = false
	can_attack = false
	$slowthescenetimer.start()
	slow_down_scene()


func _on_anotherslowthescene_timeout():
	dead = false


func _on_headbutt_tumbling_body_entered(body):
	if body.is_in_group("player1"):
		$kick.play()
		$Sprite2D2.visible = true
		$Timerforpuncheffects.start()
		emit_signal("ehondaplayer2_hit_enemy")
		call_deferred("_disable")


func _on_timerforpuncheffects_timeout():
	$Sprite2D.visible = false
	$Sprite2D2.visible = false
