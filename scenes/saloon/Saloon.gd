extends Node2D


func _on_Area2D_mouse_entered() -> void:
	$Node2D/BottleWine.set_modulate(Color(1, 1, 1))


func _on_Area2D_mouse_exited() -> void:
	$Node2D/BottleWine.set_modulate(Color(.5, .1, .1))
