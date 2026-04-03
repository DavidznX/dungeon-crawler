extends Entity

@export var target: CharacterBody3D
@export var nav_agent: NavigationAgent3D

const CHASE_RANGE: float = 5.0

func _ready() -> void:
	if not target:
		print('Inimigo nao tem target!')


func _physics_process(delta: float) -> void:
	velocity = Vector3.ZERO
	direction = Vector3.ZERO
	# Se o alvo nao estiver sendo captado pelo raio de visao 
	if global_position.distance_to(target.global_position) < CHASE_RANGE:
		# Logica de seguir o target (que deve ser o player)
		nav_agent.set_target_position(target.global_transform.origin)
		
		if not nav_agent.is_navigation_finished():
			var next_step: Vector3 = nav_agent.get_next_path_position()
			direction = (next_step - global_transform.origin).normalized()
			look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP)
	
	apply_movement(direction, speed, delta)
