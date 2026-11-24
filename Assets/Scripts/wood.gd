extends StaticBody3D
func interact(_player: Node3D) -> void:
	print("wood collected!")
	queue_free()
