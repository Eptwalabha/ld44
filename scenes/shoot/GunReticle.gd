extends Node2D
class_name GunReticle

var shooting: bool = false
export(float) var cooldown : float = 0.2

onready var timer : Timer = $Timer as Timer
onready var cooldown_timer : Timer = $Cooldown as Timer
onready var area2D : Area2D = $Area2D as Area2D

func _ready() -> void:
	cooldown_timer.connect("timeout", self, "_cooldown_timeout")

func _process(delta: float) -> void:
	pass

func shoot(shoot_at: Vector2) -> void:
	if shooting:
		return
	shooting = true
	cooldown_timer.start(cooldown)
	area2D.set_position(shoot_at)
	timer.start(0.1)
	yield(timer, "timeout")
	area2D.set_position(Vector2(-100, -100))

func _cooldown_timeout() -> void:
	shooting = false