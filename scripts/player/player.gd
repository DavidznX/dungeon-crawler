extends Entity

# Velocidades
@export var walk_speed := 5.0
@export var sprint_multiplier := 2.0   # segurar Shift multiplica a velocidade
@export var dash_force := 20.0         # força do dash

# Controles de suavidade


# Dash
var can_dash := true
var dash_cooldown := 0.5
var dash_timer := 0.0

@onready var inventario: Node = $controlador_inventario


func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

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
	var direction := (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if Input.is_action_just_pressed("dash") and can_dash:
		var dash_dir = direction if direction != Vector3.ZERO else -global_transform.basis.z
		velocity = dash_dir * dash_force
		can_dash = false
		dash_timer = dash_cooldown

	if direction:
		var target_vel = direction * current_speed
		# Trocamos move_toward por lerp. Isso suaviza a transição de direção e tira o "passo em falso"
		velocity.x = lerp(velocity.x, target_vel.x, acceleration * delta)
		velocity.z = lerp(velocity.z, target_vel.z, acceleration * delta)
	else:
		# Desacelera (atrito) usando lerp também
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		velocity.z = lerp(velocity.z, 0.0, friction * delta)

	move_and_slide()
	

func captar_item(dados_itens_coletados):
	inventario.guardar_item(dados_itens_coletados)
