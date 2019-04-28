extends Node
class_name Dialog

signal dialog_start
signal dialog_waiting
signal dialog_end

onready var node2D : Node2D = $Node2D as Node2D
onready var player : AnimationPlayer = $Node2D/AnimationPlayer as AnimationPlayer
onready var dialog : Label = $Control/MarginContainer/CenterContainer/Label as Label

export(String) var text : String = "tuto"

var state: int = 0

func _ready() -> void:
	dialog.text = text

func _input(event: InputEvent) -> void:
	if state != 1:
		return
	if event.is_action("ui_accept"):
		end_dialog()
	elif event is InputEventMouseButton:
		if event.is_pressed():
			end_dialog()

func set_dialog(text: String) -> void:
	text = text
	dialog.text = text

func start() -> void:
	node2D.show()
	player.play("come_in")
	state = 0
	emit_signal("dialog_start")

func end_dialog() -> void:
	state = 2
	player.play("come_out")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	print(anim_name)
	if anim_name == "come_in":
		state = 1
		emit_signal("dialog_waiting")
	if anim_name == "come_out":
		emit_signal("dialog_end")
