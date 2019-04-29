extends ColorRect
class_name ScreenTransition

signal faded_in
signal faded_out

onready var animation_player : AnimationPlayer = $AnimationPlayer as AnimationPlayer

func fade_in() -> void:
	show()
	animation_player.play("fade_in")

func fade_out() -> void:
	show()
	animation_player.play("fade_out")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		emit_signal("faded_in")
	else:
		emit_signal("faded_out")
