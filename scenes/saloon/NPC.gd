extends Node2D
class_name npc

onready var sprite : Sprite = $Sprite as Sprite
onready var player : AnimationPlayer = $AnimationPlayer as AnimationPlayer

export(bool) var active : bool = true

func _ready() -> void:
	darken()

func _on_Area2D_mouse_entered() -> void:
	if active:
		brighten()

func _on_Area2D_mouse_exited() -> void:
	if active:
		darken()


func darken() -> void:
	sprite.set_modulate(Color(0.7, 0.7, 0.7))
	
func brighten() -> void:
	sprite.set_modulate(Color(1, 1, 1))

func flash() -> void:
	player.play("flash")
