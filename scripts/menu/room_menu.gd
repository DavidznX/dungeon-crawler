extends Control
class_name RoomControl

@onready var c_players: VBoxContainer = $C_players

@onready var il_level_selector: ItemList = $Il_level_selector
@onready var il_character_selector: ItemList = $Il_character_selector

@onready var pop_up_loading: ColorRect = $pop_up_loading
@onready var album_cover: TextureRect = $album_cover

@onready var map_manager: MapManager = $Map_Manager


const PLAYER_CONTAINER_NODE = preload("uid://dgow68wxogjh")

var timet: float = 0
var was_disconnected: bool = false

##colocar o caminho do resource de album
@export var current_album: String = "res://resources/albums/zona_teste.tres":
	set(value):
		current_album = value
		update_cover()


func _ready() -> void:
	for i in c_players.get_children():
		i.queue_free()
	pop_up_loading.show()
	
	NetWorkManager.connection_succeeded.connect(_close_pop_up)
	NetWorkManager.connection_failed.connect(_on_connection_failed)
	
	if NetWorkManager.is_host:
		NetWorkManager.host()
	else:
		NetWorkManager.enter(NetWorkManager.ip_selected)
	
	if not is_multiplayer_authority(): return
	$C_buttons/B_start_ready.text = "Começar"
	NetWorkManager.player_connected.connect(add_player)
	add_player(NetWorkManager.player_id)
	_close_pop_up()
	$C_buttons/B_map_selector.show()
	update_cover()


func _process(delta: float) -> void:
	timet += delta
	if timet > 1: 
		#print(NetWorkManager.ConnectionState)
		timet = 0
	else: return
	
	
	
	match NetWorkManager.connection_state:
		NetWorkManager.ConnectionState.DISCONNECTED:
			if not was_disconnected:
				was_disconnected = true
				_on_b_back_pressed()
		NetWorkManager.ConnectionState.CONNECTING:
			# mostrar tela carregando
			#show_loading_screen()
			pass
		_:
			# outros estados: talvez esconder tela carregando
			#hide_loading_screen()
			pass

func _on_b_back_pressed() -> void:
	NetWorkManager.stop_current_connection()
	get_tree().change_scene_to_file("uid://pcwxft3n2dd1")

func add_player(_id:int):
	var new_player:MultiplayerConteiner = PLAYER_CONTAINER_NODE.instantiate()
	new_player.name = str(_id)
	c_players.add_child(new_player)
	new_player.set_character_from_path.rpc("uid://cp4s28l5uvioq")

func _on_connection_failed():
	get_tree().change_scene_to_file("uid://b1j86k1k6bc2x")

func _close_pop_up():
	pop_up_loading.hide()

func _on_b_character_selector_pressed() -> void:
	il_character_selector.visible = not il_character_selector.visible
	il_level_selector.hide()

func _on_b_map_selector_pressed() -> void:
	il_level_selector.visible = not il_level_selector.visible
	il_character_selector.hide()

func _character_selected(character_path: String):
	var container = $C_players
	var peer_id = multiplayer.get_unique_id()
	var nodePlayer = container.get_node(str(peer_id)) as MultiplayerConteiner
	nodePlayer.set_character_from_path.rpc(character_path)

func _album_selected(album:String):
	current_album = album

func update_cover():
	if current_album == "":
		album_cover.texture = null
		return
	var level_res = load(current_album) as LevelRes
	if level_res:
		album_cover.texture = level_res.album_cover

@rpc("call_local", "reliable")
func _reset_visibility():
	$C_players.show()
	$Il_level_selector.hide()
	$Il_character_selector.hide()
	$C_buttons.hide()
	$pop_up_loading.hide()
	$album_cover.show()

@rpc("call_local", "reliable")
func _hide_all_ui():
	$C_players.hide()
	$Il_level_selector.hide()
	$Il_character_selector.hide()
	$C_buttons.hide()
	$pop_up_loading.hide()
	$album_cover.hide()

func _on_b_start_ready_pressed() -> void:
	
	var container = $C_players
	var peer_id = multiplayer.get_unique_id()
	var nodePlayer:MultiplayerConteiner = container.get_node(str(peer_id)) as MultiplayerConteiner
	
	var is_ready:bool = nodePlayer.is_ready
	nodePlayer._set_ready(not is_ready)
	
	if not is_multiplayer_authority(): return
	#força um começar a partida
	
	var players_res_path:Array[String]
	var players_names:Array[String]
	var multiplayer_container:MultiplayerConteiner
	for i in c_players.get_children():
		if i is MultiplayerConteiner:
			multiplayer_container = i
			players_res_path.append(multiplayer_container.res_path)
			players_names.append(multiplayer_container.name)
	#return
	
	map_manager.rpc("_set_player_res", players_res_path,players_names)
	map_manager.play_map("uid://6qker0urj7at")
	rpc("_hide_all_ui")
