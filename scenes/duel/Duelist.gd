extends Node2D
class_name Duelist

signal end_card_animation(duelist)

onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer
onready var gun: GunCylinder = $GunCylinder as GunCylinder

export(bool) var flip: bool = false setget set_flip
export(bool) var player: bool = false
export(int, 1, 5) var life: int = 3
var current_life := 3

var opponent: Duelist setget set_opponent
var card_to_play: Card = null
var hand: Array = []

var is_hurt := false
var is_shooting := false
var is_evading := false
var is_healing := false
var is_reloading := false

func _ready() -> void:
	reset()

func slide_in() -> void:
	$Tween.interpolate_property($Position2D, "position", Vector2(-500, 0), Vector2(), 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	idle()

func reset() -> void:
	current_life = life
	$GunCylinder.hide()
	update_flip()

func idle() -> void:
	animation_player.play("idle")

func _reset_states() -> void:
	is_hurt = false
	is_shooting = false
	is_evading = false
	is_healing = false
	is_reloading = false
	
func update_flip() -> void:
	if flip:
		scale.x = -1
		gun.scale.x = -1

func set_flip(is_flip: bool) -> void:
	flip = is_flip
	if Engine.is_editor_hint():
		update_flip()

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

func update_player_state() -> void:
	_reset_states()
	if card_to_play.type == GameData.CardType.SHOOT:
		is_shooting = gun.can_shoot()
	elif card_to_play.type == GameData.CardType.RELOAD:
		is_reloading = true
	elif card_to_play.type == GameData.CardType.HEAL:
		is_healing = true
	elif card_to_play.type == GameData.CardType.EVADE:
		is_evading = true

func update_player_state_whit_opponent(opponent: Duelist) -> void:
	if opponent.is_shooting:
		if not is_evading:
			is_hurt = true
	
func _update_current_life() -> void:
	var life_change := 0
	if is_hurt:
		life_change -= 1
	if is_healing:
		life_change += 1
	current_life = clamp(current_life + life_change, 0, life) as int
	
func play_state() -> void:
	_update_current_life()
	if current_life == 0:
		animation_player.play("die")
	else:
		if is_shooting:
			gun.shoot()
			if is_shooting:
				animation_player.play("action_shoot")
			else:
				animation_player.play("action_shoot_empty")
		
		if is_reloading:
			gun.reload()
			animation_player.play("action_reload")
		
		if is_healing:
			animation_player.play("action_heal")
		
		if is_evading:
			var evade = ["action_jump", "action_swing", "action_crouch"]
			animation_player.play(evade[randi() % evade.size()])
		
		if is_hurt:
			print("is hurt")

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

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	emit_signal("end_card_animation", self)
