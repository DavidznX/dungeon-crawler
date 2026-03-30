extends Node3D


@export var item_data: Item

@onready var render_modelo_item: Node3D = $"."


func _ready() -> void:
	render_item_hand()
func _process(_delta: float) -> void:
		pass

	
func render_item_hand():
	if item_data and item_data.caminho_modelo:
		var instancia = item_data.caminho_modelo.instantiate()
		render_modelo_item.add_child(instancia)
