extends CharacterBody2D
signal ehondaplayer2_hit_enemy
signal ryuplayer2_hitenemy
signal blankaplayer2hit_enemy

signal to_move_allfighters

signal ryup1health
signal ryuplayer1_hit_enemy

signal ehondaplayer2_get_killed
signal ryuplayer2_get_killed
signal ryuplayer1_get_killed
signal blankaplayer2killed

var speed = 400
var speed1 = 1000
var y_position = -600
var dead = false

const SPEED = 350.0
const JUMP_VELOCITY = -480.0
const MAX_HEALTH = 100
const haduken_scene = preload("res://hadukenplayer_1.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_health = MAX_HEALTH
@onready var player = $character1
@onready var anim = $AnimationPlayer
@onready var punchhits = $punchhit/punch
@onready var kicks = $kick/kick
var keys_enabled = true
var punches = 0
var left = false
var canmove = true
var leftclick = false
var toggle_collision = true
var hit = false

func _ready():
	call_deferred("_disable")
	connect("blankaplayer2killed", _on_blankaplayer_2_blankaplayer_2_killed)
	connect("blankaplayer2hit_enemy", _on_blankaplayer_2_blankaplayer_2_hit_enemy)
	connect("to_move_allfighters", _on_players_to_move_allfighters)
	connect("ryuplayer2_hitenemy", _on_ryu_ryuplayer_2_hitenemy)
	connect("ehondaplayer2_hit_enemy", _on_ehondaplayer_2_ehondaplayer_2_hit_enemy)
	connect("ehondaplayer2_get_killed", _on_ehondaplayer_2_ehondaplayer_2_get_killed)
	connect("ryuplayer2_get_killed", _on_ryu_ryuplayer_2_get_killed)
	

func _physics_process(delta): 
	if dead:
		position.y += y_position * delta
		position.x -= speed * delta
	
	if hit:
		position.x -= speed1 * delta
	
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("haduken"):
		if keys_enabled:
			$haduken.play()
			spawnhaduken()
			anim.play("haduken")
			keys_enabled = false
			await get_node("AnimationPlayer").animation_finished
			$Timer2.start()
	if Input.is_action_just_pressed("kickplayer1"):
		if keys_enabled:
			keys_enabled = false
			$Timer2.start()
			anim.play("kick")
	if Input.is_action_just_pressed("punchplayer1"):
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


		
	if Input.is_action_just_pressed("jump player1") and is_on_floor():
		if canmove:
			velocity.y = JUMP_VELOCITY
			anim.play("jump")


	if Input.is_action_just_pressed("crouchplayer1"):
		if canmove:
			anim.play("crouch")
	if Input.is_action_just_released("crouchplayer1"):
		anim.play("walk")

	var direction = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("right"):
		if canmove:
			anim.play("walk")
	if Input.is_action_just_pressed("left"):
		if canmove:
			left = true
			keys_enabled = false
			anim.play("shield")
	if Input.is_action_just_released("left"):
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
	new_haduken.position.y = -150
	new_haduken.speed = speed
	new_haduken.connect("haduken1", _on_haduken_hit_enemy)
	new_haduken.visible = true
	
func _on_haduken_hit_enemy():
	emit_signal("ryuplayer1_hit_enemy")
	$Timer2.start()
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "punch2" or anim_name == "jump" or anim_name == "punch1" or anim_name == "punch3" or anim_name == "kick" or anim_name == "haduken" or anim_name == "fall" or anim_name == "idle":
		anim.play("walk")
	elif  anim_name == "shield":
		anim.play("walkleft")

func _on_kick_body_entered(body):
	if body.is_in_group("player2"):
		$kick3.visible = true
		$Timerforhiteffects.start()
		$kick2.play()
		emit_signal("ryuplayer1_hit_enemy")
		call_deferred("_disable")

func _disable():
	$punchhit/punch.disabled = true
	$kick/kick.disabled = true


func _on_punchhit_body_entered(body):
	if body.is_in_group("player2"):
		$punch3.visible = true
		$punch2.play()
		$Timerforhiteffects.start()
		emit_signal("ryuplayer1_hit_enemy")
		call_deferred("_disable")

func _health():
	if current_health == 0:
		$ryuhurt.play()
		dead = true
		$Timerfordeathanimation.start()
		canmove = false
		keys_enabled = false
		anim.play("death")
		emit_signal("ryuplayer1_get_killed")
		await get_node("AnimationPlayer").animation_finished
		queue_free()
	else:
		$ryuhurt.play()
		hit = true
		$Timerifhit.start()
		emit_signal("ryup1health")
		anim.play("fall")
		$Timer32.start()
		keys_enabled = false
		canmove = false
		current_health -= 10
		current_health = clamp(current_health, 0, MAX_HEALTH) 
		$ProgressBar.value = current_health

func slow_down_scene():
	Engine.set_time_scale(0.4)  # Adjust the time scale as needed for slower motion

# Function to reset the time scale to normal
func reset_time_scale():
	Engine.set_time_scale(1.0)


func _on_timer_32_timeout():
	canmove = true
	keys_enabled = true

func _on_timer_22_timeout():
	reset_time_scale()
	anim.play("idle")



func _on_timer_2_timeout():
	keys_enabled = true






func _on_timertostart_timeout():
	canmove = true
	keys_enabled = true




func _on_ehondaplayer_2_ehondaplayer_2_get_killed():
	$youwin.play()
	keys_enabled = false
	canmove = false
	slow_down_scene()
	$Timer22.start()


func _on_ryu_ryuplayer_2_get_killed():
	$youwin.play()
	keys_enabled = false
	canmove = false
	slow_down_scene()
	$Timer22.start()


func _on_ehondaplayer_2_ehondaplayer_2_hit_enemy():
	if left == true:
		anim.play("shield")
	else:
		_health()


func _on_ryu_ryuplayer_2_hitenemy():
	if left == true:
		anim.play("shield")
	else:
		_health()



func _on_players_to_move_allfighters():
	anim.play("idle")
	$Timertostart.start()
	keys_enabled = false
	canmove = false


func _on_timerifhit_timeout():
	hit = false


func _on_blankaplayer_2_blankaplayer_2_hit_enemy():
	if left == true:
		anim.play("shield")
	else:
		_health()


func _on_blankaplayer_2_blankaplayer_2_killed():
	$youwin.play()
	keys_enabled = false
	canmove = false
	slow_down_scene()
	$Timer22.start()

func _on_timerfordeathanimation_timeout():
	dead = false


func _on_timerforhiteffects_timeout():
	$punch3.visible = false
	$kick3.visible = false
