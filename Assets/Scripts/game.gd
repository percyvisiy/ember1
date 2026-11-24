extends Node3D

@onready var player = $player
@onready var hud = $HUD

func _ready() -> void:
	player.inventory_changed.connect(hud.update_wood_count)
	hud.update_wood_count(player.wood_count)
