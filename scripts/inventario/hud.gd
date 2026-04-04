extends CanvasLayer
class_name HUD

@onready var tr_up: TextureRect = $Cr_slot_item/Tr_up
@onready var tr_left: TextureRect = $Cr_slot_item/Tr_left
@onready var tr_right: TextureRect = $Cr_slot_item/Tr_right
@onready var tr_down: TextureRect = $Cr_slot_item/Tr_down

@onready var player: Player = $".."

func update_equiped_item():
	for item in player.array_equiped_item_slots:
		if not item: continue
		match item.slot_type:
			0: #attack
				tr_left.texture = item.textura_item
			1: #consume
				tr_right.texture = item.textura_item
			2: #debug
				pass
			3: #debug
				pass
