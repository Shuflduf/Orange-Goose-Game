class_name Player
extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@onready var sprites: Node3D = $Sprites
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var health_ui: Panel = $HealthUI
@onready var heal_timer: Timer = $HealTimer
@onready var particles: GPUParticles3D = $GPUParticles3D

@export var speed = 5.0
@export var running_speed = 8.0
@export var jump_height = 11.0
@export var total_jumps = 2
@export var max_health = 3

@export_category("Camera Offsets")
@export var default_water_offset = Vector2(0, 10)
@export var default_ahead_offset = 4
@export var death_offset = Vector3(0, 0, 4)

var ahead_offset: float
var water_offset: Vector2 # Y and Z
var world_offset = 0.0
var death_offset_lerp = 0.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_mult = 1.5
var jumps = total_jumps
var weight_mult = 1
var in_water = false
var health = 0
var following_player_y = false
var default_cam_pos: Vector3
var respawn_point: Vector3

var running = false
var dead = false

func _ready() -> void:
	default_cam_pos = camera.position - position
	respawn_point = global_position
	health = max_health


func _physics_process(delta: float) -> void:
	
	if position.y < -30:
		respawn()
		return
	
	camera.position = lerp(camera.position, death_offset + position, death_offset_lerp)
	
	if dead:
		return
	
	camera.position.x = default_cam_pos.x + position.x + ahead_offset
	camera.position.z = default_cam_pos.z + water_offset.y
	camera.position.y = default_cam_pos.y + water_offset.x + world_offset
	
	
	
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
	elif Input.is_action_pressed("up") and in_water:
		weight_mult = 2
	else:
		weight_mult = 1
		
	

	var input_dir := Input.get_axis("left", "right")
	var direction := (transform.basis * Vector3(input_dir, 0, 0)).normalized()
	
	if direction:
		if is_on_floor() and !in_water:
			if running:
				animation.play("run")
			else:
				animation.play("walk")
		change_dir_left(input_dir < 0)
		velocity.x = direction.x * (speed if !running else running_speed)
	else:
		if is_on_floor() and !in_water:
			animation.play("idle", 0.5)
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if Input.is_action_just_pressed("jump") and jumps > 0 and !in_water:
			velocity.y = jump_height
			jumps -= 1
			animation.play("jump", 0.1)
			animation.queue("jump_up")
	
	if !is_on_floor() and velocity.y < 0 and !in_water:
		animation.play("falling")
	
	move_and_slide()
	
	if in_water:
		look_in_dir(velocity.y)
	

func change_dir_left(dir: bool):
	if sprites.scale.x < 0 == dir:
		flip_sprites(dir)
		var mult = -1 if dir else 1
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "ahead_offset", default_ahead_offset * mult, 0.5)


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is Water:
		in_water = true
		animation.play("RESET")
		animation.queue("swimming")
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "water_offset", default_water_offset, 0.5)
		gravity = -ProjectSettings.get_setting("physics/3d/default_gravity") * area.gravity_mult
	
	if area is CameraUpdater:
		tween_world_offset(area.new_camera_offset)


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area is Water:
		sprites.rotation.z = 0
		jumps = total_jumps
		in_water = false
		animation.play("RESET", 0)
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "water_offset", Vector2.ZERO, 0.5)
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		
		animation.queue("jump_up" if velocity.y > 0 else "falling")


func look_in_dir(vel):
	print(vel)
	var dir = 1 if sprites.scale.x < 0 else -1
	sprites.rotation_degrees.z = clamp(vel * dir * 4, -70, 70)


func flip_sprites(dir: bool):
	var offset = 1 if dir else -1
	sprites.scale.x = 8 * offset


func tween_world_offset(final: float):
	var tween = get_tree().create_tween()\
			.set_ease(Tween.EASE_IN_OUT)\
			.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "world_offset", final, 0.5)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Zombie:
		if velocity.y < -1:
			
			body.die()
			velocity.y = jump_height / 2


func take_damage(damage):
	health -= damage
	update_health_ui()
	
	if health <= 0:
		die()
		return
	
	heal_timer.start()
func update_health_ui():
	var health_percent: float = 1 - (float(health) / float(max_health))
	var tween = get_tree().create_tween()\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_SINE)
	tween.tween_property(health_ui, "modulate:a", health_percent, 0.3)
	#health_ui.modulate.a = health_percent
func _on_heal_timer_timeout() -> void:
	if dead:
		return
	var tween = get_tree().create_tween()
	health = max_health
	tween.tween_property(self, "health_ui:modulate:a", 0.0, 1)


func die():
	dead = true
	var tween = get_tree().create_tween()\
			.set_ease(Tween.EASE_IN_OUT)\
			.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "death_offset_lerp", 1, 1.4)
	await tween.finished
	
	await get_tree().create_timer(0.5).timeout
	
	sprites.visible = false
	#for child in get_children(true):
		#if child is CollisionShape3D or child is Area3D:
			#child.queue_free()
		#else:
			#continue
	particles.restart()
	await particles.finished
	await get_tree().create_timer(0.5).timeout
	respawn()

func respawn():
	global_position = respawn_point
	sprites.visible = true
	death_offset_lerp = 0
	health_ui.modulate.a = 0
	health = max_health
	dead = false
