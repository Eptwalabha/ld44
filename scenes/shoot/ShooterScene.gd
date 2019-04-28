extends Node2D

var cursor : Resource = load("res://assets/img/gun_cursor.png")
onready var gun : GunReticle = $GunReticle as GunReticle

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor, 0, Vector2(16, 16))
	for item in $Group/Items.get_children():
		if item is ShootingTarget:
			item.connect("hit", self, "target_hit")
	$Dialog.start()

func _process(_delta: float) -> void:
	pass
                                                                                    
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			var shoot_at := get_viewport().get_mouse_position()
			gun.shoot(shoot_at)

func target_hit(item: ShootingTarget) -> void:
	$UI/ShooterUI.update_score(item.point)