tool
extends Node2D
class_name Duelist

export(bool) var flip: bool = false setget set_flip
export(bool) var player: bool = false
export(int, 2, 5) var life: int = 3
var current_life = 3

var opponent: Duelist setget set_opponent
var card_to_play: Card = null
var hand: Array = []

func _ready() -> void:
	reset()

func reset() -> void:
	current_life = life
	$GunCylinder.hide()
	update_flip()

func update_flip() -> void:
	if flip:
		scale.x = -1

func set_flip(is_flip: bool) -> void:
	flip = is_flip
	if Engine.is_editor_hint():
		if is_flip:
			scale.x = -1
		else:
			scale.x = 1

func set_opponent(duelist: Duelist) -> void:
	opponent = duelist

func show_info() -> void:
	$GunCylinder.show()

func hit() -> void:
	current_life -= 1

func is_dead() -> bool:
	return current_life <= 0

func is_player() -> bool:
	return player

func pick_a_card(cards: Array) -> Card:
	var best_card: Card = null
	for card in cards:
		best_card = card
	add_card_to_hand(best_card)
	return best_card

func add_card_to_hand(card: Card) -> void:
	hand.push_back(card)

func update_hand(cards: Array) -> void:
	hand = cards

func select_card_to_play() -> void:
	card_to_play = hand[0]
	print("selected", card_to_play)

func reveal_card_to_play() -> void:
	if not card_to_play.flipped:
		card_to_play.flip(true)

func opponent_picked(_card: Card) -> void:
	pass