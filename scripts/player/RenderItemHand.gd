extends Node3D
class_name PlayerHand

@export var item_data: Item

@onready var render_modelo_item: Node3D = $"."


func _ready() -> void:
	render_item_hand()

func _process(_delta: float) -> void:
	position.y = 0.6 + 0.1 * sin(Time.get_ticks_msec() / 200.0)

func render_item_hand():
	if item_data and item_data.caminho_modelo:
		var instancia = item_data.caminho_modelo.instantiate()
		render_modelo_item.add_child(instancia)
