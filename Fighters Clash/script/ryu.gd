extends CharacterBody2D
signal ehondaplayer1_get_killed

signal ryup2health #healthbars

signal blankaplayer1_hitenemy
signal ryuplayer2_hitenemy
signal ryuplayer1_hit_enemy
signal ehondaplayer1_hit_enemy

signal ryuplayer2_get_killed
signal ryuplayer1_get_killed
signal blankaplayer1killed

signal to_move_allfighters
var speed = 400
var hit = false
var speed1 = 1000

const SPEED = 350.0
const JUMP_VELOCITY = -480.0
const MAX_HEALTH = 100
const haduken_scene = preload("res://haduken.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_health = MAX_HEALTH
@onready var player = $character1
@onready var anim = $AnimationPlayer1
@onready var punchhits = $punchhit/punch
@onready var kicks = $kick/kick
@onready var myCollisionNode = $"bodycollision"
var keys_enabled = true
var punches = 0
var left = false
var canmove = true
var leftclick = false
var toggle_collision = true
var y_position = -600
var dead = false

func _ready():
	call_deferred("_disable")
	connect("blankaplayer1killed", _on_blankaplayer_1_blankaplayer_1_killed)
	connect("blankaplayer1_hitenemy", _on_blankaplayer_1_blankaplayer_1_hitenemy)
	connect("ryuplayer1_get_killed",  _on_ryuplayer_1_ryuplayer_1_get_killed)
	connect("to_move_allfighters", _on_players_to_move_allfighters)
	connect("ehondaplayer1_get_killed", _on_ken_ehondaplayer_1_get_killed)
	connect("ryuplayer1_hit_enemy", _on_ryuplayer_1_ryuplayer_1_hit_enemy)
	connect("ehondaplayer1_hit_enemy", _on_ken_ehondaplayer_1_hit_enemy)
	

func _physics_process(delta): 
	if dead:
		position.y += y_position * delta
		position.x += speed * delta
	if hit:
		position.x += speed1 * delta
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("haduken1"):
		if keys_enabled:
			$haduken.play()
			spawnhaduken()
			anim.play("haduken")
			keys_enabled = false
			await get_node("AnimationPlayer1").animation_finished
			$Timer2.start()
	if Input.is_action_just_pressed("kick"):
		if keys_enabled:
			keys_enabled = false
			$Timer2.start()
			anim.play("kick")
	if Input.is_action_just_pressed("punch"):
		if (punches == 0):
			if keys_enabled:
				keys_enabled = false
				$Timer2.start()
				anim.play("punch1")
				punches += 1
		elif (punches == 1):
			if keys_enabled:
				keys_enabled = false
				$Timer2.start()
				anim.play("punch2")
				punches += 1
		elif (punches == 2):
			if keys_enabled:
				keys_enabled = false
				$Timer2.start()
				anim.play("punch3")
				punches = 0


		
	if Input.is_action_just_pressed("jump player2") and is_on_floor():
		if canmove:
			velocity.y = JUMP_VELOCITY
			anim.play("jump")

	if Input.is_action_just_pressed("crouchplayer2"):
		if canmove:
			anim.play("crouch")
	if Input.is_action_just_released("crouchplayer2"):
		anim.play("walk")

	var direction = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("ui_left"):
		if canmove:
			anim.play("walk")
	if Input.is_action_just_pressed("ui_right"):
		if canmove:
			left = true
			keys_enabled = false
			anim.play("shield")
	if Input.is_action_just_released("ui_right"):
		if canmove:
			left = false
			keys_enabled = true



	if direction:
		if canmove:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide() 


func spawnhaduken():
	var new_haduken = haduken_scene.instantiate()
	get_parent().add_child(new_haduken)
	new_haduken.global_position = global_position
	new_haduken.speed = speed
	new_haduken.connect("haduken", _on_haduken_hit_enemy)
	new_haduken.visible = true

func _on_haduken_hit_enemy():
	$Timer2.start()
	emit_signal("ryuplayer2_hitenemy")


func _on_kick_body_entered(body):
	if body.is_in_group("player1"):
		$Timerforhiteffects.start()
		$kick3.visible = true
		$kick2.play()
		emit_signal("ryuplayer2_hitenemy")
		call_deferred("_disable")

func _disable():
	$punchhit/punch.disabled = true
	$kick/kick.disabled = true


func _on_punchhit_body_entered(body):
	if body.is_in_group("player1"):
		$Timerforhiteffects.start()
		$punch2.play()
		$punch3.visible = true
		emit_signal("ryuplayer2_hitenemy")
		call_deferred("_disable")

func _health():
	if current_health == 0:
		$ryuhurt.play()
		dead = true
		$Timerfordeathanimation.start()
		canmove = false
		keys_enabled = false
		anim.play("death")
		emit_signal("ryuplayer2_get_killed")
		await get_node("AnimationPlayer1").animation_finished
		queue_free()
	else:
		$ryuhurt.play()
		hit = true
		emit_signal("ryup2health")
		anim.play("fall")
		$Timer32.start()
		$Timeifhit.start()
		keys_enabled = false
		canmove = false
		current_health -= 10
		current_health = clamp(current_health, 0, MAX_HEALTH) 
		$ProgressBar.value = current_health

func slow_down_scene():
	Engine.set_time_scale(0.6)  # Adjust the time scale as needed for slower motion

# Function to reset the time scale to normal
func reset_time_scale():
	Engine.set_time_scale(1.0)


func _on_timer_32_timeout():
	canmove = true
	keys_enabled = true



func _on_timer_2_timeout():
	keys_enabled = true





func _on_timertostart_timeout():
	canmove = true
	keys_enabled = true




func _on_ryuplayer_1_ryuplayer_1_hit_enemy():
	if left == true:
		anim.play("shield")
	else:
		_health()



func _on_ken_ehondaplayer_1_hit_enemy():
	if left == true:
		anim.play("shield")
	else:
		_health()


func _on_ken_ehondaplayer_1_get_killed():
	$youwin.play()
	canmove = false
	keys_enabled = false
	$Timerforslowmo.start()
	slow_down_scene()


func _on_players_to_move_allfighters():
	anim.play("idle")
	$Timertostart.start() 
	keys_enabled = false
	canmove = false


func _on_ryuplayer_1_ryuplayer_1_get_killed():
	$youwin.play()
	canmove = false
	keys_enabled = false
	$Timerforslowmo.start()
	slow_down_scene()



func _on_animation_player_1_animation_finished(anim_name):
	if anim_name == "punch2" or anim_name == "jump" or anim_name == "punch1" or anim_name == "punch3"or anim_name == "kick" or anim_name == "haduken" or anim_name == "fall" or anim_name == "idle":
		anim.play("walk")
	elif anim_name == "shield":
		anim.play("walkleft")


func _on_blankaplayer_1_blankaplayer_1_hitenemy():
	if left == true:
		anim.play("shield")
	else:
		_health()


func _on_timeifhit_timeout():
	hit = false


func _on_blankaplayer_1_blankaplayer_1_killed():
	$youwin.play()
	canmove = false
	keys_enabled = false
	$Timerforslowmo.start()
	slow_down_scene()


func _on_timerforslowmo_timeout():
	reset_time_scale()
	anim.play("idle")


func _on_timerfordeathanimation_timeout():
	dead = false


func _on_timerforhiteffects_timeout():
	$kick3.visible = false
	$punch3.visible = false
