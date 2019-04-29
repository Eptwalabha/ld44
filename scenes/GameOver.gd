extends Node

onready var screen_transition: ScreenTransition = $ScreenTransition as ScreenTransition
onready var label: Label = $Control/VBoxContainer/MarginContainer2/Label as Label
onready var sprite: Sprite = $Node2D/Sprite as Sprite

var screens : Array = [
	{
		"texture" : "res://assets/img/npc-player.png",
		"text" : "Say Sheriff... can I have his boots?"
	},
	{
		"texture" : "res://assets/img/npc-player.png",
		"text" : "Better luck next time... wait...\nNo! Ha Ha Ha!"
	},
	{
		"texture" : "res://assets/img/bartender.png",
		"text" : "Oh well... one more unpaid slate!"
	},
	{
		"texture" : "res://assets/img/bartender.png",
		"text" : "Hey! Stop bleeding on my piano!"
	},
	{
		"texture" : "res://assets/img/sheriff.png",
		"text" : "I guess now you know how we deal with you scums!"
	},
	{
		"texture" : "res://assets/img/sheriff.png",
		"text" : "Did you realy think I was gonna let you riot my town?"
	}
]

func _ready() -> void:
	random_game_over()
	screen_transition.fade_in()

func _on_ColorRect_faded_out() -> void:
	print("load main menu")

func random_game_over(i = -1) -> void:
	randomize()
	if i == -1:
		i = randi() % screens.size()
	var elem = screens[i]
	print(elem.texture)
	sprite.texture = load(elem.texture) as Texture
	label.text = elem.text