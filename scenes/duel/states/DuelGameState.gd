extends Object
class_name DuelGameState

var duel_game setget set_duel_game

signal state_ended(state)
signal state_leaved(state)

func input(_event: InputEvent) -> void:
	pass

func process_state(_delta: float) -> void:
	pass

func enter_state() -> void:
	emit_signal("state_ended", self)

func leave_state() -> void:
	emit_signal("state_leaved", self)

func get_next_state_name() -> String:
	return "river"

func set_duel_game(dg) -> void:
	duel_game = dg