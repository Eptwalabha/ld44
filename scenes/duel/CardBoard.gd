extends Node2D
class_name CardBoard

signal game_started
signal river_distributed(turn_number)
signal new_cards_picked_up(turn_number)
signal cards_to_play_selected(turn_number)

onready var deck : Node2D = $Deck as Node2D
onready var player : Node2D = $Player as Node2D
onready var opponent : Node2D = $Opponent as Node2D
onready var river : Node2D = $River as Node2D
onready var timer : Timer = $Timer as Timer
onready var _token : Sprite = $Token as Sprite

export(float) var slide_speed := 0.5

var CardScene := load("res://scenes/duel/Card.tscn") as PackedScene
var player_turn : bool = true
var opponent_pickedup_card : Card = null
var turn_number : int = 0

var the_opponent: Duelist
var the_player: Duelist

func reset_game() -> void:
	the_player.reset()
	the_opponent.reset()
	turn_number = 0

func stop_game() -> void:
	_spread_cards(true)
	
func start_game(p: Duelist, o: Duelist) -> void:
	_spread_cards(false)
	the_player = p
	the_opponent = o
	_distribute_card_to(the_player)
	timer.start(slide_speed / 2)
	yield(timer, "timeout")
	_distribute_card_to(the_opponent)
	timer.start(slide_speed / 2)
	yield(timer, "timeout")
	_distribute_card_to(the_player)
	timer.start(slide_speed / 2)
	yield(timer, "timeout")
	_distribute_card_to(the_opponent)
	timer.start(slide_speed)
	yield(timer, "timeout")
	for card in player.get_children():
		card.flip()
	timer.start(1)
	yield(timer, "timeout")
	emit_signal("game_started")

func distribute_river() -> void:
	turn_number += 1
	_spread_cards(false)
	_empty_played_cards()
	_empty_card_from_node(river)
	for i in range(0, 3):
		var card = _spawn_card_in_river()
		timer.start(slide_speed)
		yield(timer, "timeout")
		card.flip(true)
	timer.start(.5)
	yield(timer, "timeout")
	emit_signal("river_distributed", turn_number)

func pick_a_new_card() -> void:
	#_move_chip()
	if player_turn:
		_let_player_pickup_a_card()
	else:
		_let_opponent_pickup_a_card()
		_let_player_pickup_a_card()

func select_card_to_play() -> void:
	_empty_card_from_node(river)
	timer.start(.1)
	yield(timer, "timeout")
	the_opponent.select_card_to_play()
	_set_cards_in_player_deck_selectable(true)

func _end_of_pickup_phase() -> void:
	timer.start(1)
	yield(timer, "timeout")
	opponent_pickedup_card.flip(false)
	player_turn = not player_turn
	emit_signal("new_cards_picked_up", turn_number)

func _end_of_card_selection_phase() -> void:
	_set_cards_in_player_deck_selectable(false)
	_move_cards_to_play_out_of_decks()
	_spread_cards(true)
	timer.start(1)
	yield(timer, "timeout")
	_reveal_cards_played()
	timer.start(.5)
	yield(timer, "timeout")
	emit_signal("cards_to_play_selected", turn_number)
	
func _spawn_new_card() -> Card:
	var card : Card = CardScene.instance() as Card
	card.slide_speed = slide_speed
	card.shuffle()
	deck.add_child(card)
	return card

func _distribute_card_to(duelist: Duelist) -> void:
	var card: Card = _spawn_new_card()
	var node := _get_node(duelist)
	duelist.add_card_to_hand(card)
	_move_card_to(card, node)

func _spawn_card_in_river() -> Card:
	var card: Card = _spawn_new_card()
	_move_card_to(card, river)
	return card

func _get_card_position_in_node(node: Node2D) -> Vector2:
	var card_index: int = node.get_child_count() - 1
	return _get_card_index_position_in_node(card_index, node)

func _get_card_index_position_in_node(card_index: int, node: Node2D) -> Vector2:
	if node == player || node == opponent:
		return Vector2(0, card_index * 150 - 150)
	elif node == river:
		return Vector2(card_index * 110 - 110, 0)
	return Vector2()

func _get_node(duelist: Duelist) -> Node2D:
	return player if duelist.is_player() else opponent

func _empty_played_cards() -> void:
	_empty_card_from_node($Played/Player)
	the_player.card_to_play = null
	_empty_card_from_node($Played/Opponent)
	the_opponent.card_to_play = null
	
func _empty_card_from_node(node: Node2D) -> void:
	for card in node.get_children():
		if card is Card:
			node.remove_child(card)
			card.queue_free()

func _move_cards_to_play_out_of_decks() -> void:
	_move_card_to(the_player.card_to_play, $Played/Player)
	_move_card_to(the_opponent.card_to_play, $Played/Opponent)
	the_player.update_hand(player.get_children())
	the_opponent.update_hand(opponent.get_children())
	_reorganize_decks()

func _move_card_to(card: Card, node: Node2D) -> void:
	var a = card.get_global_position()
	card.position = a - node.get_global_position()
	if card.get_parent() != node:
		card.get_parent().remove_child(card)
		node.add_child(card)
	card.slide_to(_get_card_position_in_node(node))

func _reorganize_decks() -> void:
	_reorganize_deck(player)
	_reorganize_deck(opponent)

func _reorganize_deck(node: Node2D) -> void:
	var index = 0
	for card in node.get_children():
		card.slide_to(_get_card_index_position_in_node(index, node))
		index += 1

func _let_player_pickup_a_card() -> void:
	_set_cards_in_river_selectable(true)

func _let_opponent_pickup_a_card() -> void:
	opponent_pickedup_card = the_opponent.pick_a_card(river.get_children())
	_move_card_to(opponent_pickedup_card, opponent)
	if player_turn:
		_end_of_pickup_phase()
	else:
		_let_player_pickup_a_card()

func _set_cards_in_river_selectable(active: bool) -> void:
	for card in river.get_children():
		card.selectable = active
		if active:
			if not card.is_connected("card_selected", self, "_on_player_pickedup_a_card_in_river"):
				card.connect("card_selected", self, "_on_player_pickedup_a_card_in_river")
		else:
			card.disconnect("card_selected", self, "_on_player_pickedup_a_card_in_river")

func _set_cards_in_player_deck_selectable(active: bool) -> void:
	for card in player.get_children():
		card.selectable = active
		if active:
			card.connect("card_selected", self, "_on_player_pickedup_a_card_in_is_deck")
		else:
			card.disconnect("card_selected", self, "_on_player_pickedup_a_card_in_is_deck")

func _on_player_pickedup_a_card_in_river(card: Card) -> void:
	if card is Card and card != opponent_pickedup_card:
		the_player.add_card_to_hand(card)
		the_opponent.opponent_picked(card)
		_set_cards_in_river_selectable(false)
		_move_card_to(card, player)
		if player_turn:
			_let_opponent_pickup_a_card()
		else:
			_end_of_pickup_phase()

func _spread_cards(_spread_away: bool) -> void:
	_reorganize_decks()

func _reveal_cards_played() -> void:
	the_opponent.reveal_card_to_play()

func _on_player_pickedup_a_card_in_is_deck(card: Card) -> void:
	the_player.card_to_play = card
	_end_of_card_selection_phase()
