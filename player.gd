class_name Player
extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@onready var sprite: Sprite3D = $Sprite3D
#@onready var area: Area3D = $Area3D

@export var speed = 5.0
@export var jump_height = 8.5
@export var lookahead = 4
@export var total_jumps = 2
@export var in_water_offset = Vector3(0, 0, 10)

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera_x_offset: float
var camera_water_offset
var jumps = total_jumps
var weight_mult = 1
var in_water = false
var default_cam_pos

func _ready() -> void:
	default_cam_pos = camera.position


func _physics_process(delta: float) -> void:
	camera.position.x = position.x + camera_x_offset
	#camera.position 
	
	if is_on_floor():
		jumps = total_jumps
	else:
		velocity.y -= gravity * delta * weight_mult
	
	if Input.is_action_pressed("down"):
		weight_mult = 3
	else:
		weight_mult = 1

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



func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is Water:
		in_water = true
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(camera, "position", \
		position + in_water_offset + default_cam_pos + Vector3(camera_x_offset, 0, 0), 0.5)
		gravity = -ProjectSettings.get_setting("physics/3d/default_gravity") * area.gravity_mult


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area is Water:
		in_water = false
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(camera, "position", \
		position + default_cam_pos + Vector3(camera_x_offset, 0, 0), 0.5)
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 
