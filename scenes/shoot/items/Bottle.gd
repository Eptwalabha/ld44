extends ShootingTarget

var t : float = 0.0
export(float) var velocity_angle = 3.0
export(Vector2) var velocity = Vector2()
onready var particle : CPUParticles2D = $Paticle as CPUParticles2D


func _process(delta: float) -> void:
	t += delta
	self.rotation += delta * velocity_angle

func destroyed() -> void:
	.destroyed()
	particle.emitting = true
	$Sprite.hide()