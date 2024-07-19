extends CharacterBody3D

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
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * gravity_mult

	var move_dir = Vector3.ZERO
	if target != null:
		move_dir = global_position.direction_to(target.global_position)
		move_dir *= Vector3.RIGHT
		move_dir = move_dir.normalized()
	velocity.x = move_dir.x * speed
	
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()






