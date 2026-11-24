extends CanvasLayer

@onready var wood_counter: Label = $woodCounter

func update_wood_count(amount: int) -> void:
	wood_counter.text = "wood: " + str(amount)
