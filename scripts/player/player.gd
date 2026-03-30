extends CharacterBody3D

# Velocidades
@export var walk_speed := 5.0
@export var sprint_multiplier := 2.0   # segurar Shift multiplica a velocidade
@export var dash_force := 20.0         # força do dash

# Controles de suavidade
@export var acceleration := 10.0       # aceleração (m/s²)
@export var friction := 10.0           # desaceleração (m/s²)

# Dash
var can_dash := true
var dash_cooldown := 0.5               # segundos entre dashes
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

	# Direção do movimento (relativa à rotação do personagem)
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Dash
	if Input.is_action_just_pressed("dash") and can_dash:
		# Se não há direção, usa a direção para onde o corpo está olhando
		var dash_dir = direction if direction != Vector3.ZERO else -transform.basis.z
		velocity = dash_dir * dash_force
		can_dash = false
		dash_timer = dash_cooldown
		print("dash")

	# Movimento horizontal (XZ)
	if direction:
		# Acelera até a velocidade desejada
		var target_vel = direction * current_speed
		velocity.x = move_toward(velocity.x, target_vel.x, acceleration * delta)
		velocity.z = move_toward(velocity.z, target_vel.z, acceleration * delta)
	else:
		# Desacelera (atrito) quando não há entrada
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		velocity.z = move_toward(velocity.z, 0.0, friction * delta)

	move_and_slide()


func captar_item(dados_itens_coletados):
	inventario.guardar_item(dados_itens_coletados)
