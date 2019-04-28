tool
extends Node2D
class_name Card

signal card_end_sliding(card)

onready var player : AnimationPlayer = $AnimationPlayer as AnimationPlayer
onready var tween : Tween = $Tween as Tween

enum CardType { EVADE, RELOAD, SHOOT, HEAL }
export(CardType) var type = CardType.EVADE setget set_type

export(bool) var selectable: bool = false

var card_type : Dictionary = {
	"evade": {
		"drop_rate": 1
	},
	"reload": {
		"drop_rate": 1
	},
	"shoot": {
		"drop_rate": 1
	},
	"heal": {
		"drop_rate": .2
	}
}

func set_type(card_type: int) -> void:
	type = card_type
	if type == CardType.EVADE:
		$CardBackground/Type.texture = load("res://assets/img/card/card-evade.png") as Texture
	elif type == CardType.RELOAD:
		$CardBackground/Type.texture = load("res://assets/img/card/card-reload.png") as Texture
	elif type == CardType.SHOOT:
		$CardBackground/Type.texture = load("res://assets/img/card/card-shoot.png") as Texture
	else:
		$CardBackground/Type.texture = load("res://assets/img/card/card-heal.png") as Texture

func shuffle() -> void:
	set_type(randi() % CardType.values().size())

func flip() -> void:
	player.play("flip_card")
	yield(player, "animation_finished")

func _on_Area2D_mouse_entered() -> void:
	if selectable:
		$CardBackground.scale = Vector2(1.1, 1.1)

func _on_Area2D_mouse_exited() -> void:
	$CardBackground.scale = Vector2(1, 1)

func slide_to(position: Vector2) -> void:
	tween.interpolate_property(self, "position", self.position, position, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("card_end_sliding", self)