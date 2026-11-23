extends Node3D

@export var mouse_sensitivity: float = 0.003
@export var min_pitch: float = -45
@export var max_pitch: float = 35

var pitch: float = -15.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	rotation_degrees.x = pitch
	
func _unhandled_input(event:InputEvent) -> void:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * mouse_sensitivity)
			
			pitch -= event.relative.y * mouse_sensitivity * 180.0 / PI 
			pitch -= clampf(pitch, min_pitch, max_pitch)
			
			rotation_degrees.x = pitch
			
		if event.is_action_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
		if event is InputEventMouseButton and event.pressed:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
