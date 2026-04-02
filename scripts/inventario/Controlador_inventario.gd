extends Node


@onready var item_list: ItemList = $inventario/ItemList
@onready var player: CharacterBody3D = $".."
@onready var inventario_control: Control = $inventario
@onready var item_to_equip_container: item_equipetor = $inventario/Item_to_equip


var inventario = []

var current_item_selected:Item

func _ready() -> void:
	inventario_control.hide()

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
		player.hud.hide()
	else:
		inventario_control.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player.hud.show()

func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	#print(inventario[index-1])
	var slot:Array = inventario[index-1]
	var item:Item  = slot[0]
	
	current_item_selected = item
	
	item_to_equip_container.visible = true
	item_to_equip_container.update_image(item.textura_item)
	


func _on_b_equip_pressed() -> void:
	player._equip(current_item_selected)
