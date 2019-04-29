extends Node2D
class_name Life

var BottleTexture := load("res://assets/img/bottle-wine-full.png") as Texture
var BrokenBottleTexture := load("res://assets/img/broken-bottle-wine.png") as Texture

var max_life : int = 3
var life: int = 2

func _ready() -> void:
	setup(max_life)

func setup(l: int) -> void:
	max_life = l
	life = l
	for sprite in get_children():
		remove_child(sprite)
		sprite.queue_free()
	for index in range(0, max_life):
		var sprite = Sprite.new()
		sprite.scale = Vector2(0.6, 0.6)
		add_child(sprite)
		sprite.position.x = index * 32
	update_life(life)

func update_life(new_life: int) -> void:
	var index = 0
	for sprite in get_children():
		sprite.texture = BottleTexture if index < new_life else BrokenBottleTexture
		index += 1