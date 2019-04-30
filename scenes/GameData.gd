extends Node

var bounty := 0

var tutos: Dictionary = {}
var saloons: Dictionary = {
	"daisy_town": {
		"unlock": true
	},
	"sweet_storm": {
		"unlock": false
	},
	"red_rope": {
		"unlock": false
	}
}

var current_fight = 0
var fights = [
	"Saloon1.tscn",
	"Saloon2.tscn",
	"Town1.tscn",
	"Desert1.tscn",
]

enum CardType { EVADE, RELOAD, SHOOT, HEAL }

func _ready() -> void:
	randomize()

func has_played_tuto(tuto_name: String) -> bool:
	if tutos.has(tuto_name):
		return tutos[tuto_name].played
	return false

func tuto_played(dialog: Dialog) -> void:
	if dialog.is_tutorial:
		var tuto_name := dialog.get_name()
		tutos[tuto_name] = {
			"played": true
		}

func get_unlocked_saloons() -> Array:
	var unlocked_saloons: Array = []
	for saloon_name in saloons.keys():
		if saloons[saloon_name].unlock:
			unlocked_saloons.push_back(saloon_name)
	return unlocked_saloons

func get_bounty() -> int:
	return bounty

func should_play_tutorial(dialog: Dialog) -> bool:
	return not has_played_tuto(dialog.get_name())

func first_fight_scene() -> String:
	current_fight = 0
	return "res://scenes/duel/fight/" + fights[0]
	
func next_fight_scene() -> String:
	current_fight += 1
	if current_fight >= fights.size():
		return "res://scenes/GameOver.tscn"
	return "res://scenes/duel/fight/" + fights[current_fight]