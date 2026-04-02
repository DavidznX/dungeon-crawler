extends ColorRect
class_name item_equipetor

@onready var texture_rect: TextureRect = $TextureRect
@onready var b_equip: Button = $B_equip



func update_image(img:Texture2D):
	texture_rect.texture = img
	pass
