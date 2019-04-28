extends Node2D
class_name Duelist

export(bool) var flip: bool = false

func _ready() -> void:
	update_flip()

func update_flip() -> void:
	if flip:
		scale.x = -1
