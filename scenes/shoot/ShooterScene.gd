extends Node2D

var cursor : Resource = load("res://assets/img/gun_cursor.png")
onready var gun : GunReticle = $GunReticle as GunReticle
var playing := false
onready var dialog : Dialog = $Dialog as Dialog

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor, 0, Vector2(16, 16))
	for item in $Group/Items.get_children():
		if item is ShootingTarget:
			item.connect("hit", self, "target_hit")
	if GameData.should_play_tutorial(dialog):
		var _err = dialog.connect("dialog_line_end", self, "_on_dialog_line_end")
		_err = dialog.connect("dialog_end", self, "_on_dialog_end")
		$Group/Items.visible = false
		playing = false
		dialog.start_dialog()
	else:
		playing = true

func _process(_delta: float) -> void:
	pass
                                                                                    
func _input(event: InputEvent) -> void:
	if not playing:
		return
	if event is InputEventMouseButton:
		if event.is_pressed():
			var shoot_at := get_viewport().get_mouse_position()
			gun.shoot(shoot_at)

func target_hit(item: ShootingTarget) -> void:
	$UI/ShooterUI.update_score(item.get_point())

func _on_dialog_line_end(dialog_id: String) -> void:
	if dialog_id == "clope":
		$Group/Items.visible = true

func _on_dialog_end() -> void:
	playing = true
	$Group/Items.visible = true
	GameData.tuto_played(dialog)
	dialog.queue_free()