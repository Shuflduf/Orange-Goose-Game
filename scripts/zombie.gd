extends CharacterBody3D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprites: Node3D = $Sprites

@export var speed = 5.0

var target: Player

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_mult = 1.5

func _on_player_detect_body_entered(body: Node3D) -> void:
	if body is Player:
		target = body
		print("found")
		
		
func _on_player_detect_body_exited(body: Node3D) -> void:
	if body is Player:
		target = null
		print("lost")
		animation.play("idle")
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * gravity_mult
	
	velocity = Vector3.ZERO
	var move_dir = Vector3.ZERO
	if target != null:
		move_dir = global_position.direction_to(target.global_position)
		move_dir *= Vector3.RIGHT
		move_dir = move_dir.normalized()
		velocity.x = move_dir.x * speed
		var dir = 1 if move_dir.x < 0 else -1
		sprites.scale.x = 8 * dir
		
	
	
	
	move_and_slide()






