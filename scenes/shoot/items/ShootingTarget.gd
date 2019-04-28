extends Node2D
class_name ShootingTarget

signal hit(ShootingTarget)
signal destroyed(ShootingTarget)

export(int) var point = 100

func is_hit(gun: GunReticle) -> bool:
	return $Area2D.overlaps_area(gun.get_node("Area2D"))

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.get_parent() is GunReticle:
		emit_signal("hit", self)
		destroyed()

func destroyed() -> void:
	$Area2D.queue_free()

func get_point() -> int:
	return point
