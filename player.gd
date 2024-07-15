class_name Player
extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@onready var sprites: Node3D = $Sprites
@onready var animation: AnimationPlayer = $AnimationPlayer

@export var speed = 5.0
@export var running_speed = 8.0
@export var jump_height = 11.0
@export var total_jumps = 2

@export_category("Camera Offsets")
@export var default_water_offset = Vector2(0, 10)
@export var default_ahead_offset = 4

var ahead_offset: float
var water_offset: Vector2 # Y and Z

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_mult = 1.5
var jumps = total_jumps
var weight_mult = 1
var in_water = false
var following_player_y = false
var default_cam_pos: Vector3

var running = false

func _ready() -> void:
	default_cam_pos = camera.position


func _physics_process(delta: float) -> void:
	camera.position.x = default_cam_pos.x + position.x + ahead_offset
	camera.position.z = default_cam_pos.z + water_offset.y
	camera.position.y = default_cam_pos.y + water_offset.x
	
	if is_on_floor() and !in_water:
		jumps = total_jumps
	else:
		velocity.y -= gravity * delta * weight_mult * gravity_mult
	
	if Input.is_action_just_pressed("run"):
		running = true
	elif Input.is_action_just_released("run"):
		running = false
	
	if Input.is_action_pressed("down"):
		weight_mult = -2 if in_water else 3
	else:
		weight_mult = 1

	

	var input_dir := Input.get_axis("left", "right")
	var direction := (transform.basis * Vector3(input_dir, 0, 0)).normalized()
	if direction:
		if is_on_floor():
			if running:
				animation.play("run")
			else:
				animation.play("walk")
		change_dir_left(input_dir < 0)
		velocity.x = direction.x * (speed if !running else running_speed)
	else:
		if is_on_floor():
			animation.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if Input.is_action_just_pressed("jump") and jumps > 0 and !in_water:
			velocity.y = jump_height
			jumps -= 1
			animation.play("jump", 0.1)
			animation.queue("jump_up")
			
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


#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "jump":
		#animation.play("jump_up")
