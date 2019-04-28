extends Node
class_name GameState

signal enter_state
signal leave_state

func state_enter() -> void:
	pass

func state_end() -> void:
	pass

func _state_process(delta: float) -> void:
	pass
