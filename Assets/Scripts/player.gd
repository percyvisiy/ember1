extends CharacterBody3D

@export var speed: float = 5.0
@export var rotation_speed: float = 10.0

@onready var visuals: Node3D = $visuals
@onready var camera: Camera3D = $CameraPivot/SpringArm3D/Camera3D
@onready var interaction_area: Area3D = $InteractionArea

var nearby_objects: Array[Node3D] = []
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	interaction_area.area_entered.connect(_on_area_entered)
	interaction_area.area_exited.connect(_on_area_exited)
	print("PLAYER INTERACTION READY")

func _physics_process(delta: float) -> void:
	#get player input
	var input_dir := Input.get_vector(
	"move_left",
	"move_right",
	"move_foward",
	"move_backward"
	)
	var forward := -camera.global_basis.z
	var right := camera.global_basis.x
	
	forward.y = 0
	right.y = 0
	
	forward = forward.normalized()
	right = right.normalized()
	
	var direction := right * input_dir.x - forward * input_dir.y
	
	direction = direction.normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if direction.length() > 0.1:
		var target_angle := atan2(-direction.x, -direction.z)
		visuals.rotation.y = lerp_angle(
			visuals.rotation.y,
			target_angle,
			rotation_speed * delta
		)
		
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not event.is_echo():
		interact()

func _on_area_entered(area: Area3D) -> void:
	print("AREA DETECTED: ", area.name)

	var target := area.get_parent() as Node3D

	if target != null and target.has_method("interact"):
		if not nearby_objects.has(target):
			nearby_objects.append(target)

		print("INTERACTABLE OBJECT FOUND: ", target.name)

func _on_area_exited(area: Area3D) -> void:
	var target := area.get_parent() as Node3D

	if target != null:
		nearby_objects.erase(target)

func interact() -> void:
	print("OPTION PRESSED")

	if nearby_objects.is_empty():
		print("NO OBJECTS IN RANGE!")
		return

	var target := nearby_objects[0]

	if is_instance_valid(target):
		print("INTERACTING WITH: ", target.name)
		target.interact(self)
	else:
		nearby_objects.erase(target)
