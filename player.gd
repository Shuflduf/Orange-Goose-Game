extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@onready var sprite: Sprite3D = $Sprite3D

@export var speed = 5.0
@export var jump_height = 8.5
@export var lookahead = 4
@export var total_jumps = 2

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera_x_offset: float
var jumps = total_jumps

func _physics_process(delta: float) -> void:
	camera.position.x = position.x + camera_x_offset

	if is_on_floor():
		jumps = total_jumps
	else:
		velocity.y -= gravity * delta


	if Input.is_action_just_pressed("jump") and jumps > 0:
		velocity.y = jump_height
		jumps -= 1

	var input_dir := Input.get_axis("left", "right")
	var direction := (transform.basis * Vector3(input_dir, 0, 0)).normalized()
	if direction:
		change_dir_left(input_dir < 0)
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func change_dir_left(dir):
	if sprite.flip_h != dir:
		var mult = -1 if dir else 1
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "camera_x_offset", lookahead * mult, 0.5)
	sprite.flip_h = dir
