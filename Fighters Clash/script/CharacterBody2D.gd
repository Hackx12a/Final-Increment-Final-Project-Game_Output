extends CharacterBody2D

signal character_hit
signal player1
signal kill
signal kill1
signal ProgressBars1

var SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_HEALTH = 100

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_health = MAX_HEALTH
var keys_enabled = true
@onready var anims = $AnimationPlayer
@onready var punchhit = $punchhit
@onready var kick = $kick
@onready var punchhits = $punchhit/CollisionShape2D
@onready var kicks = $kick/kick
var punches = 0
var can_collide = true
var left = false
@onready var myCollisionNode = $"body collision2"


func _ready():
	connect("kill", _on_ryu_kill)
	connect("character_hit", _on_ryu_character_hit)
	anims.play("idle")
	await get_node("AnimationPlayer").animation_finished
	anims.play("walk")

func _physics_process(delta):
	if not is_on_floor():
		if keys_enabled:
			velocity.y += gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if keys_enabled:
			velocity.y = JUMP_VELOCITY
			anims.play("jump")
	if Input.is_action_just_pressed("kick player 1"):
		if keys_enabled:
			anims.play("kick")
	if Input.is_action_just_pressed("punch player 1"):
		if (punches == 0):
			if keys_enabled:
				anims.play("punch1")
				punches += 1
		elif (punches == 1):
			if keys_enabled:
				anims.play("punch2")
				punches += 1
		elif (punches == 2):
			if keys_enabled:
				anims.play("punch3")
				punches = 0


	var direction = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("right"):
		if keys_enabled:
			anims.play("walk")
	if Input.is_action_just_pressed("left"):
		if keys_enabled:
			anims.play("shield")
			left = true
			keys_enabled = false
	if Input.is_action_just_released("left"):
		keys_enabled = true
		left = false



	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	


func _on_ryu_character_hit():
	if left == true:
		anims.play("shield")
	else:
		emit_signal("ProgressBars1")
		anims.play("fall")
		myCollisionNode.scale = Vector2(0, 0)
		await get_node("AnimationPlayer").animation_finished
		myCollisionNode.scale = Vector2(1, 1)
		anims.play("walk")
		current_health -= 3
		current_health = clamp(current_health, 0, MAX_HEALTH)
		$ProgressBar2.value = current_health
		_health()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "punch2" or anim_name == "jump" or anim_name == "punch1" or anim_name == "punch3" or anim_name == "kick"or anim_name == "shield":
		anims.play("walk")

func _on_kicks_body_entered(body):
	if body.name == "ryu":
		emit_signal("player1")
		call_deferred("toggle_collision")

func _on_punchhits_body_entered(body):
	if body.name == "ryu":
		emit_signal("player1")
		call_deferred("toggle_collision")

func toggle_collision():
	can_collide = !can_collide
	punchhits.disabled = !can_collide
	kicks.disabled = !can_collide
	anims.play("walk")

func _health():
	if current_health <= 0:
		myCollisionNode.scale = Vector2(0, 0)
		anims.play("death")
		emit_signal("kill1")
		await get_node("AnimationPlayer").animation_finished
		keys_enabled = false
		queue_free()

func _on_ryu_kill():
	anims.play("idle")
	keys_enabled = false


