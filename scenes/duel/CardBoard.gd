extends Node2D
class_name CardBoard

signal first_distribution_over
signal river_distributed
signal cards_picked

onready var deck : Node2D = $Deck as Node2D
onready var player : Node2D = $Player as Node2D
onready var opponent : Node2D = $Opponent as Node2D
onready var river : Node2D = $River as Node2D
onready var timer : Timer = $Timer as Timer
onready var token : Sprite = $Token as Sprite

var CardScene := load("res://scenes/duel/Card.tscn") as PackedScene
var player_turn : bool = true

func first_distribution(the_player: Duelist, the_opponent: Duelist) -> void:
	_distribute_card_to(the_player)
	_distribute_card_to(the_opponent)
	_distribute_card_to(the_player)
	_distribute_card_to(the_opponent)
	timer.start(1)
	yield(timer, "timeout")
	for card in player.get_children():
		card.flip()
	timer.start(1)
	yield(timer, "timeout")
	emit_signal("first_distribution_over")

func distribute_river() -> void:
	for i in range(0, 3):
		var card = _spawn_card_in_river()
		timer.start(.6)
		yield(timer, "timeout")
		card.flip()
	emit_signal("river_distributed")

func pick_a_card():
	for card in river.get_children():
		card.selectable = true
	timer.start(.2)
	yield(timer, "timeout")
	player_turn = not player_turn
	emit_signal("cards_picked")

func _spawn_new_card() -> Card:
	var card : Card = CardScene.instance() as Card
	card.shuffle()
	return card

func _distribute_card_to(duelist: Duelist) -> void:
	var card: Card = _spawn_new_card()
	#duelist.add_card(card)
	var node := _get_node(duelist)
	var pos: Vector2 = _get_card_position_in_duelist_deck(node)
	node.add_child(card)
	card.position = deck.position - node.position
	card.slide_to(pos)

func _spawn_card_in_river() -> Card:
	var card: Card = _spawn_new_card()
	var pos: Vector2 = _get_card_position_in_river()
	river.add_child(card)
	card.position = deck.position - river.position
	card.slide_to(pos)
	return card

func _get_card_position_in_duelist_deck(node: Node2D) -> Vector2:
	var nbr_card: int = node.get_child_count()
	return Vector2(0, (nbr_card - 1) * 150)

func _get_card_position_in_river() -> Vector2:
	var nbr_card: int = river.get_child_count()
	return Vector2((nbr_card - 1) * 110, 0)

func _get_node(duelist: Duelist) -> Node2D:
	return player if duelist.is_player() else opponent

func _move_card_from_river_to_duelist(card: Card, duelist: Duelist) -> void:
	pass