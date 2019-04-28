extends Control
class_name ShooterUI

var score := 0
onready var score_label: Label = $HBoxContainer/Score as Label

func _ready() -> void:
	update_score_label()

func update_score(add_score: int) -> void:
	score += add_score
	update_score_label()

func update_score_label() -> void:
	score_label.set_text("$" + str(score))