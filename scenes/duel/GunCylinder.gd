tool
extends Node2D
class_name GunCylinder

var Ammunition := load("res://scenes/duel/Bullet.tscn") as PackedScene

export(int, 5, 8) var chambers := 6 setget set_chamber_size

var current_chamber := 0
var angle : float = .0
var bullets: Array = []

func _ready() -> void:
	_init_gun_cylinder()

func _init_gun_cylinder() -> void:
	bullets = []
	for child in $Pivot.get_children():
		child.queue_free()

	angle = (PI * 2) / chambers
	for chamber_index in range(0, chambers):
		var bullet : Bullet = Ammunition.instance() as Bullet
		bullet.rotation = chamber_index * angle
		$Pivot.add_child(bullet)
		bullets.push_back(bullet)

func shoot() -> bool:
	return true

func set_chamber_size(nbr_of_chamber) -> void:
	chambers = nbr_of_chamber
	if Engine.is_editor_hint():
		_init_gun_cylinder()