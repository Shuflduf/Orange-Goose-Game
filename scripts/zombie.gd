extends CharacterBody3D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprites: Node3D = $Sprites
@onready var attack_cooldown: Timer = $AttackCooldown

@export var speed = 5.0

var target: Player

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_mult = 1.5

var attacking = false

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
	if not is_on_floor():
		velocity.y -= gravity * delta * gravity_mult
	
	velocity.x = 0
	
	if attacking:
		return
	
	if target != null: 
		if global_position.distance_to(target.global_position) < 4:
			print("AH")
			animation.play("RESET", 0)
			animation.queue("attack")
			animation.queue("idle")
			attacking = true
			attack_cooldown.start()
			return
			
		var move_dir = global_position.direction_to(target.global_position)
		move_dir *= Vector3.RIGHT
		move_dir = move_dir.normalized()
		sprites.scale.x = -8 * move_dir.x
		velocity.x = move_dir.x * speed
	
	move_and_slide()


#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "attack":
		#attacking = false
		#animation.play("idle")


func _on_attack_cooldown_timeout() -> void:
	attacking = false
	#animation.pla
