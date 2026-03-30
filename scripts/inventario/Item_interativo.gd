extends Node3D

@export var item_data: Item
@export var quantidade: int

@onready var render_modelo_item: Node3D = $modelo_item


var player_na_area = false
var player = null

func _ready() -> void:
	if item_data and item_data.caminho_modelo:
		var instancia = item_data.caminho_modelo.instantiate()
		render_modelo_item.add_child(instancia)
	

func _physics_process(_delta: float) -> void:
	if player_na_area == true:
		print('player_entrou_na_area_item')
		if Input.is_action_just_pressed('acao'):
			var dados_itens_coletados = [item_data,quantidade]
			player.captar_item(dados_itens_coletados)
			player = null
			player_na_area =  false
			queue_free()
			


func _on_area_interacao_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		player_na_area = true
		player = body
		


func _on_area_interacao_body_exited(_body: Node3D) -> void:
		player_na_area = false
		player = null
