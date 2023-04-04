extends CharacterBody2D

var score : int = 0

var speed : int = 200
var jumpForce : int = 400
var gravity : int = 800

var vel : Vector2 = Vector2()
var facingRight = true
var canDoubleJump = true
var canWallJump = true
var wallJump = false


@onready var sprite : Sprite2D = get_node("VirtualGuy")
@onready var animationTree = $AnimationTree
@onready var stateMachine = animationTree.get("parameters/playback")

func _ready():
	stateMachine.travel("Idle")

func _physics_process(delta):
#	if vel.y > 400:
#		vel.y = 400
	#var current = stateMachine.get_current_node()

	vel.x = 0

	if is_on_floor():
		canDoubleJump = true
		canWallJump = true
		wallJump = false
#	elif wallJump :
#		if 
	if Input.is_action_pressed("move_left"):
		vel.x -= speed
		facingRight = false
	if Input.is_action_pressed("move_right"):
		vel.x += speed
		facingRight = true
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		vel.y -= jumpForce
		stateMachine.travel("Jump")
	if Input.is_action_just_pressed("move_up") and ! is_on_floor() and ! is_on_wall() and canDoubleJump:
		canDoubleJump = false
		vel.y = 0
		vel.y -= jumpForce
		stateMachine.travel("Double Jump")
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		vel.y -= jumpForce
		stateMachine.travel("Jump")
	if Input.is_action_just_pressed("move_jump") and ! is_on_floor() and ! is_on_wall() and canDoubleJump:
		canDoubleJump = false
		vel.y = 0
		vel.y -= jumpForce
		stateMachine.travel("Double Jump")
	if Input.is_action_pressed("move_down") and  ! is_on_floor():
		vel.y += jumpForce/5
	if Input.is_action_just_pressed("move_jump") and Input.is_action_pressed("move_right") and is_on_wall() and ! is_on_floor() and canWallJump:
#		canWallJump = false
#		vel.y = 0
#		vel.y -= jumpForce
#		vel.x -= 5000
#		stateMachine.travel("Jump")
		wallJump = true
	if Input.is_action_just_pressed("move_up") and Input.is_action_pressed("move_right") and is_on_wall() and ! is_on_floor() and canWallJump:
#		canWallJump = false
#		vel.y = 0
#		vel.y -= jumpForce
#		vel.x -= 1000
#		stateMachine.travel("Jump")
		wallJump = true

	if is_on_wall() and vel.y > 0:
		vel.y = 70
		stateMachine.travel("Wall Jump")
	else:
		vel.y += gravity * delta
		
	if wallJump and  (Input.is_action_pressed("move_up") or Input.is_action_pressed("move_jump")):
		vel.y = 0
		vel.y -= jumpForce
		vel.x -= 10000 * delta
		stateMachine.travel("Jump")
	else:
		wallJump = false

	set_velocity(vel)
	set_up_direction(Vector2.UP)
	move_and_slide()
	vel = velocity

	if facingRight:
		sprite.scale.x = 1
		#sprite.flip_h = false
		if is_on_floor() and vel.x > 0:
			stateMachine.travel("Run")
#			$AnimationPlayer.play("Run")
	else:
		sprite.scale.x = -1
		#sprite.flip_h = true
		if is_on_floor() and vel.x < 0:
			stateMachine.travel("Run")
#			$AnimationPlayer.play("Run")
#	
	if vel.length() == 0:
		stateMachine.travel("Idle")
	if vel.y > 0 and ! is_on_wall():
#		$AnimationPlayer.play("Fall")
		stateMachine.travel("Fall")
		
func die():
	stateMachine.travel("Hit")
	get_tree().reload_current_scene()


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "Hit":
		get_tree().reload_current_scene()
