extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@onready var sprite: Sprite3D = $Sprite3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 8.5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	camera.position.x = position.x

	if not is_on_floor():
		velocity.y -= gravity * delta


	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_axis("left", "right")
	var direction := (transform.basis * Vector3(input_dir, 0, 0)).normalized()
	if direction:
		sprite.flip_h = true if input_dir < 0 else false
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
