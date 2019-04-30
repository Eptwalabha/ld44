extends Node

onready var screen_transition: ScreenTransition = $ScreenTransition as ScreenTransition
onready var bounty := $Control/VBoxContainer/MarginContainer2/CenterContainer/HBoxContainer/Bounty
onready var timer := $Timer as Timer
onready var player := $Node2D/AnimationPlayer as AnimationPlayer
onready var ui := $Control as Control

func _ready() -> void:
	ui.hide()
	$Node2D/Poster.hide()
	set_process_input(false)
	screen_transition.fade_in()
	yield(screen_transition, "faded_in")
	player.play("display_bounty")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event is InputEventMouse and event.is_pressed():
		set_process_input(false)
		screen_transition.fade_out()

func _on_ScreenTransition_faded_out() -> void:
	get_tree().change_scene(GameData.next_fight_scene())

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	bounty.text = "$ " + str(GameData.bounty)
	ui.show()
	timer.start(1)
	yield(timer, "timeout")
	set_process_input(true)
