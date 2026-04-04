extends Entity
class_name Player

# Velocidades
@export var walk_speed := 5.0
@export var sprint_multiplier := 2.0
@export var dash_force := 20.0


@onready var inventario: Node = $controlador_inventario
@onready var hud: HUD = $HUD
@onready var hand_item: PlayerHand = $hand_item

@onready var ray_attack: RayCast3D = $camera_pivot/Camera3D/ray_attack


# Dash
var can_dash := true
var dash_cooldown := 0.5
var dash_timer := 0.0

var can_attack:bool = true

var array_equiped_item_slots:Array[Item] = [null,null,null,null]

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		_attack()
	
	# Sprint (segurar Shift)
	var current_speed = walk_speed
	if Input.is_action_pressed("shift"):
		current_speed *= sprint_multiplier

	# Cooldown do dash
	if not can_dash:
		dash_timer -= delta
		if dash_timer <= 0:
			can_dash = true

	var input_dir := Input.get_vector("left", "right", "up", "down")
	
	# Usar global_transform.basis é mais seguro para evitar conflitos de rotação de nós pais
	direction = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if Input.is_action_just_pressed("dash") and can_dash:
		var dash_dir = direction if direction != Vector3.ZERO else -global_transform.basis.z
		velocity = dash_dir * dash_force
		can_dash = false
		dash_timer = dash_cooldown
	
	# Logica de aplicacao de movimento la no apply_movement no Entity
	apply_movement(direction, current_speed, delta)


func _equip(item:Item):
	
	
	match item.slot_type:
		0: #attack
			array_equiped_item_slots[0] = item
			hand_item._equip(item)
		1: #consume
			array_equiped_item_slots[1] = item
		2: #debug
			array_equiped_item_slots[2] = item
		3: #debug
			array_equiped_item_slots[3] = item
	
	
	hud.update_equiped_item()

#usar item do slot esquerda
func _attack():
	if (not array_equiped_item_slots[0] 
	or not array_equiped_item_slots[0] is ItemAttack):
		return
	
	if not can_attack: return
	can_attack = false
	
	var item:ItemAttack = array_equiped_item_slots[0]
	var damage:int = item.damage
	#fazer a mecanica de causar dano e rodar o user de item
	
	var enemy:Entity = ray_attack.get_collider()
	if enemy:
		enemy.get_damage(item.damage)
	
	_animate_hand_item_attack()
	
	await get_tree().create_timer(0.5).timeout
	can_attack = true


#usar item do slot direita
func consume_item():
	if (not array_equiped_item_slots[0] 
	or not array_equiped_item_slots[0] is ItemConsume):
		return
	var item:ItemConsume = array_equiped_item_slots[0]
	var healing:int = item.healing
	#apenas rodar a mecanica de itemConsume

func _drop_item():
	pass

func captar_item(dados_itens_coletados):
	inventario.guardar_item(dados_itens_coletados)
	

func _die():
	die.emit()
	pass

func _on_die() -> void:
	get_tree().reload_current_scene()


func _animate_hand_item_attack():
	var tween = create_tween()
	var target_rotation = deg_to_rad(-65.0)
	tween.tween_property(hand_item, "rotation:x", target_rotation, 0.1)
	tween.tween_property(hand_item, "rotation:x", 0.0, 0.1)
