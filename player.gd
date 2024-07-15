class_name Player
extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@onready var sprites: Node3D = $Sprites

@export var speed = 5.0
@export var jump_height = 8.5
@export var total_jumps = 2

@export_category("Camera Offsets")
@export var default_water_offset = Vector2(0, 10)
@export var default_ahead_offset = 4

var ahead_offset: float
var water_offset: Vector2 # Y and Z

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumps = total_jumps
var weight_mult = 1
var in_water = false:
	set(value):
		in_water = value
		print(value)
var following_player_y = false
var default_cam_pos: Vector3

func _ready() -> void:
	default_cam_pos = camera.position


func _physics_process(delta: float) -> void:
	camera.position.x = default_cam_pos.x + position.x + ahead_offset
	camera.position.z = default_cam_pos.z + water_offset.y
	camera.position.y = default_cam_pos.y + water_offset.x
	
	if is_on_floor() and !in_water:
		jumps = total_jumps
	else:
		velocity.y -= gravity * delta * weight_mult
	
	if Input.is_action_pressed("down"):
		weight_mult = -2 if in_water else 3
	else:
		weight_mult = 1

	if Input.is_action_just_pressed("jump") and jumps > 0 and !in_water:
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

func change_dir_left(dir: bool):
	if sprites.scale.x < 0 == dir:
		flip_sprites(dir)
		var mult = -1 if dir else 1
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "ahead_offset", default_ahead_offset * mult, 0.5)


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is Water:
		in_water = true
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "water_offset", default_water_offset, 0.5)
		gravity = -ProjectSettings.get_setting("physics/3d/default_gravity") * area.gravity_mult


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area is Water:
		in_water = false
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "water_offset", Vector2.ZERO, 0.5)
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 

func flip_sprites(dir: bool):
	var offset = 1 if dir else -1
	sprites.scale.x = 8 * offset

