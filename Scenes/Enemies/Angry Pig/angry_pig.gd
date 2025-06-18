extends CharacterBody2D

const WALK_SPEED = 50
const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_moving_left = true
var movement_direction = -1
var movement_speed = 0

@onready var anim = $AnimatedSprite2D

func _ready():
	movement_speed = WALK_SPEED
	anim.play("walk")


func _physics_process(delta):
	
	move_pig(movement_speed, movement_direction)
	detect_turn_around()
	
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
	

func move_pig(speed, direction):
	velocity.x = speed * direction


func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		movement_direction *= -1
		scale.x = -scale.x


func _on_player_detector_body_entered(body):
	anim.play("run")
	movement_speed = SPEED


func _on_player_detector_body_exited(body):
#	while global_position.x != body.global_position.x:
#		move_pig(movement_speed, movement_direction)
	movement_speed = 0
	for x in range(5):
		anim.play("default")
		await(anim.animation_finished)
	anim.play("walk")
	movement_speed = WALK_SPEED


func _on_attack_body_entered(body):
	body.die()
	print("die")


func _on_stomp_detector_body_entered(body):
	anim.play("hit1")
	await(anim.animation_finished)
	queue_free()
