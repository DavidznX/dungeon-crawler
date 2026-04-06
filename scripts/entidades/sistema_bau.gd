extends Node3D
@onready var item_interativo: ItemInterativo = $Item_interativo
@onready var modelo_bau: Node3D = $modelo_bau

@export var item_data: Item
@export var quantidade: int

func _ready() -> void:
	item_interativo.visible = false



func _on_area_3d_body_entered(body:Player) -> void:
	if Input.is_action_just_pressed("acao"):
		modelo_bau.visible = false
		item_interativo.item_data = item_data
		item_interativo.quantidade = quantidade
		item_interativo.visible = true
