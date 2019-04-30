extends Node

onready var screen_transition: ScreenTransition = $ScreenTransition as ScreenTransition

func _ready() -> void:
	screen_transition.fade_in()

func _on_New_game_pressed() -> void:
	var scene: String = GameData.first_fight_scene()
	fade_then_load_scene(scene)

func _on_Tutorial_pressed() -> void:
	fade_then_load_scene("res://scenes/duel/Tutorial.tscn")

func _on_About_pressed() -> void:
	fade_then_load_scene("res://scenes/About.tscn")

func fade_then_load_scene(path) -> void:
	screen_transition.fade_out()
	yield(screen_transition, "faded_out")
	get_tree().change_scene(path)