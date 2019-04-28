extends ShootingTarget

var t : float = 0.0
export(float) var velocity_angle = 3.0
export(Vector2) var velocity = Vector2()
onready var particle : CPUParticles2D = $Particle as CPUParticles2D

func _process(delta: float) -> void:
	t += delta
	self.rotation += delta * velocity_angle
	#self.position += sin(t * 10) * Vector2(30, 30)

func destroyed() -> void:
	.destroyed()
	queue_free()