extends StaticBody3D
func interact(_player: Node3D) -> void:
	if _player.has_method("add_wood"):
		_player.add_wood(1)
		print("collected 1 wood!")
	queue_free()
