class_name Zombie
extends CharacterBody3D

@onready var animation := $AnimationPlayer
@onready var sprites := $Sprites
@onready var attack_cooldown := $AttackCooldown
@onready var hitbox := $Sprites/HitBox
@onready var collision := $CollisionShape3D
@onready var particles := $GPUParticles3D
@onready var sound: PlayerSound = $Sound

@export var speed := 5.0

var target: Player

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_mult := 1.5

var attacking := false

func _on_player_detect_body_entered(body: Node3D) -> void:
	if body is Player:
		target = body
		
		
func _on_player_detect_body_exited(body: Node3D) -> void:
	if body is Player:
		target = null
		animation.play("idle")
	
	
func _physics_process(delta: float) -> void:
	position.z = 0
	if not is_on_floor():
		velocity.y -= gravity * delta * gravity_mult
	
	velocity.x = 0
	
	if attacking:
		return
	
	if target != null and !target.dead:
		var move_dir := global_position.direction_to(target.global_position)
		move_dir *= Vector3.RIGHT
		var d: float = abs(global_position.x - target.global_position.x)
		if d > 1.0:
			move_dir = move_dir.normalized()
			sprites.scale.x = -8 * move_dir.x
		else:
			move_dir = Vector3.ZERO
			animation.play("idle")
		
		 
		if global_position.distance_to(target.global_position) < 3:
			attacking = true
			attack_cooldown.start()
			animation.play("LONG_RESET", 0)
			await animation.animation_finished
			animation.play("attack", 0)
			
			
			await animation.animation_finished 
			for i: PhysicsBody3D in hitbox.get_overlapping_bodies():
				if i is Player:
					i.take_damage(1)
					#if i.health <= 0:
						#target = null
			animation.play("idle")
			
			return
			
		
		velocity.x = move_dir.x * speed
		animation.play("walk")
	
	move_and_slide()


func die() -> void:
	sprites.visible = false
	for child in get_children(true):
		if child is CollisionShape3D or child is Area3D:
			child.queue_free()
		else:
			continue
	particles.restart()
	await particles.finished
	queue_free()


func _on_attack_cooldown_timeout() -> void:
	attacking = false
	#animation.pla


func get_block_below() -> void:
	var gridmap: GridMap = get_tree().root.find_child("GridMap", true, false)
	var p := global_position + Vector3(0, -2.5, 0)
	var grid_coords := gridmap.local_to_map(Vector3i(p - gridmap.global_position))
	var under := gridmap.get_cell_item(grid_coords)
	if under != -1:
		var block_name: String = gridmap.mesh_library.get_item_name(under)
		sound.match_block_name(block_name)
	sound.step()
