extends Node
class_name duel

onready var player: Duelist = $Game/Ground/Player as Duelist
onready var card_game: CardBoard = $CardBoard as CardBoard
onready var ui: Control = $Control as Control
onready var label: Label = $Control/CenterContainer/Label as Label
onready var timer: Timer = $Timer as Timer
onready var screen_transition := $ScreenTransition as ScreenTransition
onready var phase_label: Label = $Control2/MarginContainer/Phase as Label

var opponent: Duelist
var tutorial: Dialog
var duelist_end_animation := 0
var playing := false
var player_victory := false

export(PackedScene) var Enemy setget set_enemy
export(PackedScene) var TutorialScene = null
export(int) var bounty := 100
export(bool) var skip_dialog := false

func _ready() -> void:
	phase_label.text = ""
	screen_transition.fade_in()

func _prepare_game() -> void:
	spawn_opponent()
	reset_game()
	_connect_signal()

	if TutorialScene is PackedScene and not skip_dialog:
		tutorial = TutorialScene.instance() as Dialog
		add_child(tutorial)
		_start_tutorial()
	else:
		start_game()

func spawn_opponent() -> void:
	opponent = Enemy.instance() as Duelist
	opponent.flip = true
	opponent.opponent = player
	if $Game/Ground/OpponentPosition is Position2D:
		$Game/Ground/OpponentPosition.add_child(opponent)
	
func set_enemy(packed_scene: PackedScene) -> void:
	Enemy = packed_scene

func is_someone_dead() -> bool:
	return player.is_dead() or opponent.is_dead()

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
	player.slide_in()
	opponent.slide_in()
	timer.start(.5)
	yield(timer, "timeout")
	label.text = "READY ?"
	ui.show()
	timer.start(1.5)
	yield(timer, "timeout")
	player.show_info()
	opponent.show_info()
	label.text = "FIGHT !"
	timer.start(1.5)
	yield(timer, "timeout")
	ui.hide()
	playing = true
	card_game.start_game(player, opponent)

func game_over() -> void:
	playing = false
	player_victory = not player.is_dead()
	card_game.stop_game()
	card_game.hide()
	if player_victory:
		player.animation_player.play("cheer")
		label.text = "VICTORY!"
	else:
		opponent.animation_player.play("cheer")
		label.text = "YOU DIED!"
	
	ui.show()
	timer.start(3)
	yield(timer, "timeout")
	ui.hide()
	next_stage()

func next_stage() -> void:
	screen_transition.fade_out()
	yield(screen_transition, "faded_out")
	if player_victory:
		GameData.bounty += bounty
		get_tree().change_scene("res://scenes/BountyRaised.tscn")
	else:
		get_tree().change_scene("res://scenes/GameOver.tscn")

func _connect_signal() -> void:
	player.connect("end_card_animation", self, "_on_duelist_end_card_animation")
	opponent.connect("end_card_animation", self, "_on_duelist_end_card_animation")
	card_game.connect("game_started", self, "_card_game_game_started")
	card_game.connect("river_distributed", self, "_card_game_river_distributed")
	card_game.connect("new_cards_picked_up", self, "_card_game_new_cards_picked_up")
	card_game.connect("cards_to_play_selected", self, "_card_game_cards_to_play_selected")

func _card_game_game_started() -> void:
	phase_label.text = ""
	card_game.distribute_river()

func _card_game_river_distributed(_turn_number: int) -> void:
	phase_label.text = "pick a card"
	card_game.pick_a_new_card()

func _card_game_new_cards_picked_up(_turn_number: int) -> void:
	phase_label.text = "select the card to play"
	card_game.select_card_to_play()

func _card_game_cards_to_play_selected(_turn_number: int) -> void:
	phase_label.text = ""
	duelist_end_animation = 0
	player.update_player_state()
	opponent.update_player_state()
	player.update_player_state_whit_opponent(opponent)
	opponent.update_player_state_whit_opponent(player)
	player.play_state()
	opponent.play_state()
	if is_someone_dead():
		game_over()

func _on_duelist_end_card_animation(duelist: Duelist) -> void:
	if not duelist.is_dead():
		duelist.idle()
	duelist_end_animation += 1
	if playing and duelist_end_animation == 2:
		card_game.distribute_river()

func _on_ScreenTransition_faded_in() -> void:
	_prepare_game()
