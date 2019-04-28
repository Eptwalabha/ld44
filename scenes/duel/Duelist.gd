tool
extends Node2D
class_name Duelist

export(bool) var flip: bool = false setget set_flip
export(bool) var player: bool = false
export(int, 2, 5) var life: int = 3
var current_life = 3

var opponent: Duelist setget set_opponent

func _ready() -> void:
	reset()

func reset() -> void:
	current_life = life
	$GunCylinder.hide()
	update_flip()

func update_flip() -> void:
	if flip:
		scale.x = -1

func set_flip(is_flip: bool) -> void:
	flip = is_flip
	if Engine.is_editor_hint():
		if is_flip:
			scale.x = -1
		else:
			scale.x = 1

func set_opponent(duelist: Duelist) -> void:
	opponent = duelist

func show_info() -> void:
	$GunCylinder.show()

func hit() -> void:
	current_life -= 1

func is_dead() -> bool:
	return current_life <= 0

func is_player() -> bool:
	return player