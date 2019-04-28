tool
extends Node
class_name duel

onready var game: DuelGame = $DuelGame as DuelGame
onready var player: Duelist = $Game/Ground/Player as Duelist

var opponent: Duelist
var tutorial: Dialog

export(PackedScene) var Enemy setget set_enemy
export(PackedScene) var TutorialScene = null

func _ready() -> void:
	spawn_opponent()
	reset_game()

	if TutorialScene is PackedScene:
		tutorial = TutorialScene.instance() as Dialog
		if GameData.should_play_tutorial(tutorial):
			add_child(tutorial)
			_start_tutorial()
		else:
			tutorial.queue_free()
			start_game()
	else:
		start_game()

func spawn_opponent() -> void:
	opponent = Enemy.instance() as Duelist
	opponent.flip = true
	if $Game/Ground/OpponentPosition is Position2D:
		$Game/Ground/OpponentPosition.add_child(opponent)
	
func set_enemy(packed_scene: PackedScene) -> void:
	Enemy = packed_scene
	if Engine.is_editor_hint():
		spawn_opponent()

func _start_tutorial() -> void:
	var _err = tutorial.connect("dialog_end", self, "_on_tuto_end")
	_err = tutorial.connect("dialog_line_end", self, "_on_tuto_line_end") 
	tutorial.start_dialog()

func _on_tuto_line_end(_line_id: String) -> void:
	pass

func _on_tuto_end() -> void:
	GameData.tuto_played(tutorial)
	tutorial.queue_free()
	start_game()

func reset_game() -> void:
	player.reset()
	opponent.reset()

func start_game() -> void:
	player.show_info()
	opponent.show_info()
	game.start_new_game(player, opponent)