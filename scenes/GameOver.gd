extends Node

onready var screen_transition: ScreenTransition = $ScreenTransition as ScreenTransition
onready var label: Label = $Control/VBoxContainer/MarginContainer2/Label as Label
onready var click_to_exit: Label = $Control/VBoxContainer/MarginContainer4/Label as Label
onready var sprite: Sprite = $Node2D/Sprite as Sprite
onready var timer: Timer = $Timer as Timer

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
	var text = click_to_exit.text
	click_to_exit.text = ""
	set_process_input(false)
	random_game_over()
	screen_transition.fade_in()
	yield(screen_transition, "faded_in")
	timer.start(1)
	yield(timer, "timeout")
	click_to_exit.text = text
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event is InputEventMouse and event.is_pressed():
		set_process_input(false)
		screen_transition.fade_out()
	
func _on_ColorRect_faded_out() -> void:
	get_tree().change_scene("res://scenes/MainMenu.tscn")

func random_game_over(i = -1) -> void:
	randomize()
	if i == -1:
		i = randi() % screens.size()
	var elem = screens[i]
	sprite.texture = load(elem.texture) as Texture
	label.text = elem.text