extends Node

@onready var lista_de_itens: VBoxContainer = $lista_de_itens
@onready var item_list: ItemList = $inventario/ItemList
@onready var player: CharacterBody3D = $".."
@onready var inventario_control: Control = $inventario


var inventario = []

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('inventario'):
		abrir_inventario()
	
func guardar_item(dados_itens_coletados):
	var novo_item_coletado = dados_itens_coletados[0]
	var quantidade_novo_item = dados_itens_coletados[1]
	if novo_item_coletado.amontuavel == true:
		for slot in inventario:
			if slot[0] == novo_item_coletado:
				slot[1]+=quantidade_novo_item
				return
	inventario.append(dados_itens_coletados)
	listar_os_itens_no_invetario()
	render_inventario(novo_item_coletado.nome ,novo_item_coletado.textura_item )
	print(dados_itens_coletados[0].nome, dados_itens_coletados[1])	

func listar_os_itens_no_invetario():
	pass
	#print(inventario)


func render_inventario(text, icon):
	item_list.add_item(text,icon)
	
func jogar_item_fora(_item):
	pass
	
	
func abrir_inventario():
	if inventario_control.visible == false:
		inventario_control.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		inventario_control.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
