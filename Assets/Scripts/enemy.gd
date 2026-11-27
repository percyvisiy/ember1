
extends CharacterBody3D

@export var move_speed: float = 3.0
@export var rotation_speed: float = 5.0
@export var attack_range: float = 1.5
@export var max_health: float = 50.0 

@onready var detection_area: Area3D = $DetectionArea

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var player: CharacterBody3D = null
var current_health: float = 50.0


func _ready() -> void:
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and body.name == "player":
		player = body
		print("Enemy detected the player")


func _on_body_exited(body: Node3D) -> void:
	if body == player:
		player = null
		print("Enemy lost sight of player.")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	if player != null:
		var distance := global_position.distance_to(player.global_position)

		if distance > attack_range:
			var direction := player.global_position - global_position
			direction.y = 0.0
			direction = direction.normalized()

			velocity.x = direction.x * move_speed
			velocity.z = direction.z * move_speed

			var target_angle := atan2(-direction.x, -direction.z)

			rotation.y = lerp_angle(
				rotation.y,
				target_angle,
				rotation_speed * delta
			)

		else:
			velocity.x = 0.0
			velocity.z = 0.0
			print("Shade is within attack range!")

	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)
		velocity.z = move_toward(velocity.z, 0.0, move_speed)

	move_and_slide()
	
func take_damage(amount: float) -> void:
	current_health -= amount
	print("enemy health: ", current_health)
	
	if current_health <= 0:
		die()
		
func die() -> void:
	print("enemy defeated")
	queue_free()
