extends Node2D
class_name Bullet

var used: bool = false setget set_state

func use_bullet() -> void:
	set_state(true)

func set_state(u: bool) -> void:
	if used != u:
		used = u
		_update_animation()

func _update_animation():
	if used:
		$Sprite.play("empty")
	else:
		$Sprite.play("loaded")