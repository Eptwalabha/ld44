extends Node
class_name Dialog

signal dialog_start
signal dialog_waiting
signal dialog_line_end(signal_id)
signal dialog_end

onready var actor : Sprite = $Node2D/Sprite as Sprite
onready var player : AnimationPlayer = $Node2D/AnimationPlayer as AnimationPlayer
onready var dialog_label : Label = $Control/MarginContainer/VBoxContainer/CenterContainer/Label as Label
onready var click_to_continue : Label = $Control/MarginContainer/VBoxContainer/Continue as Label

enum DialogState { BEGIN_LINE, WAITING_FOR_ACCEPT_INPUT, END }
var state = DialogState.BEGIN_LINE

var current_dialog_index := 0
var current_dialog : DialogLine

func _ready() -> void:
	dialog_label.visible = false
	click_to_continue.visible = false
	actor.visible = false

func _input(event: InputEvent) -> void:
	if state != DialogState.WAITING_FOR_ACCEPT_INPUT:
		return
	if event.is_action("ui_accept"):
		_end_line_of_dialog()
	elif event is InputEventMouseButton:
		if event.is_pressed():
			_end_line_of_dialog()

func _fetch_dialog_line(index: int) -> DialogLine:
	var i := 0
	for line in $Lines.get_children():
		if line is DialogLine:
			if i == index:
				return line
			i += 1
	return null

func _next_line() -> void:
	_setup_next_line(current_dialog_index + 1)

func _setup_next_line(index: int) -> void:
	var dialog_line: DialogLine = _fetch_dialog_line(index)
	if dialog_line == null:
		end_dialog()
	else:
		current_dialog_index = index
		current_dialog = dialog_line
		actor.texture = dialog_line.get_actor_texture()
		dialog_label.text = dialog_line.get_dialog_line()
		_start_line_of_dialog()

func _start_line_of_dialog() -> void:
	state = DialogState.BEGIN_LINE
	_play_animation(current_dialog.get_start_animation(), "visible")

func _end_line_of_dialog() -> void:
	dialog_label.text = ""
	click_to_continue.visible = false
	state = DialogState.END
	_play_animation(current_dialog.get_end_animation(), "hidden")

func _play_animation(animation_name: String, fallback: String) -> void:
	if player.has_animation(animation_name):
		player.play(animation_name)
	else:
		player.play(fallback)

func start_dialog() -> void:
	emit_signal("dialog_start")
	_setup_next_line(0)

func end_dialog() -> void:
	emit_signal("dialog_end")

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	if state == DialogState.BEGIN_LINE:
		dialog_label.visible = true
		state = DialogState.WAITING_FOR_ACCEPT_INPUT
		click_to_continue.visible = true
		emit_signal("dialog_waiting")
	elif state == DialogState.END:
		if current_dialog.does_signal_on_dialog_end():
			emit_signal("dialog_line_end", current_dialog.get_signal_id())
		_next_line()