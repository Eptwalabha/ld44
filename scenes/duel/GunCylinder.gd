extends Node2D
class_name GunCylinder

onready var tween : Tween = $Tween as Tween
onready var pivot : Sprite = $Pivot as Sprite

var Ammunition := load("res://scenes/duel/Bullet.tscn") as PackedScene

export(int, 5, 8) var chambers := 5 setget set_chamber_size
export(int, 2, 5) var bullets_in_chamber := 2

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
		bullet.rotation = angle_of_chamber(chamber_index)
		bullet.used = chamber_index >= bullets_in_chamber
		$Pivot.add_child(bullet)
		bullets.push_back(bullet)

func can_shoot() -> bool:
	return _index_of_first_chamber(false) > -1

func shoot() -> bool:
	var bullet: Bullet = bullets[current_chamber] as Bullet
	var was_bullet_used: bool = bullet.used
	bullet.use_bullet()
	_rotate_to_next_chamber()
	return not was_bullet_used

func reload() -> void:
	var first_empty_chamber_index = _index_of_first_chamber()
	if first_empty_chamber_index != -1:
		bullets[first_empty_chamber_index].used = false
		if first_empty_chamber_index <= current_chamber:
			_rotate_to_chamber(first_empty_chamber_index)

func _index_of_first_chamber(used = true) -> int:
	var index := 0
	for bullet in bullets:
		if bullet.used == used:
			return index
		index += 1
	return 0

func _rotate_to_chamber(index: int) -> void:
	current_chamber = index
	var new_angle: float = angle_of_chamber(index)
	tween.interpolate_property(pivot, "rotation", rotation, new_angle, .1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

func _rotate_to_next_chamber() -> void:
	current_chamber = (current_chamber + 1) % chambers
	tween.interpolate_property(pivot, "rotation", rotation, rotation - angle, .1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

func angle_of_chamber(chamber: int) -> float:
	return chamber * angle - PI / 2

func set_chamber_size(nbr_of_chamber) -> void:
	chambers = nbr_of_chamber