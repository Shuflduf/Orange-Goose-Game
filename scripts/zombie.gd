class_name Zombie
extends CharacterBody3D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprites: Node3D = $Sprites
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var hitbox: Area3D = $Sprites/HitBox
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var particles: GPUParticles3D = $GPUParticles3D

@export var speed = 5.0

var target: Player

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_mult = 1.5

var attacking = false

func _on_player_detect_body_entered(body: Node3D) -> void:
	if body is Player:
		target = body
		
		
func _on_player_detect_body_exited(body: Node3D) -> void:
	if body is Player:
		target = null
		animation.play("idle")
	
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta * gravity_mult
	
	velocity.x = 0
	
	if attacking:
		return
	
	if target != null and !target.dead:
		var move_dir = global_position.direction_to(target.global_position)
		move_dir *= Vector3.RIGHT
		var d = abs(global_position.x - target.global_position.x)
		if d > 1.0:
			move_dir = move_dir.normalized()
			sprites.scale.x = -8 * move_dir.x
		else:
			move_dir = Vector2.ZERO
			animation.play("idle")
		
		 
		if global_position.distance_to(target.global_position) < 3:
			attacking = true
			attack_cooldown.start()
			animation.play("LONG_RESET", 0)
			await animation.animation_finished
			animation.play("attack", 0)
			
			
			await animation.animation_finished 
			for i in hitbox.get_overlapping_bodies():
				if i is Player:
					i.take_damage(1)
					#if i.health <= 0:
						#target = null
			animation.play("idle")
			
			return
			
		
		velocity.x = move_dir.x * speed
		animation.play("walk")
	
	move_and_slide()


func die():
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
