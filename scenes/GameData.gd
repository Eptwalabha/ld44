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