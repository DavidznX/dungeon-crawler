extends CharacterBody3D


var SPEED = 5.0

@onready var inventario: Node = $controlador_inventario


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("shift"): 
		SPEED = SPEED*5
	
	if Input.is_action_just_pressed("dash"): 
		SPEED =SPEED*50
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()




#INVENTARIOOOOOOOOOOOOO


	
func captar_item(dados_itens_coletados):
	inventario.guardar_item(dados_itens_coletados)
