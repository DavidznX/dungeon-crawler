extends CharacterBody3D
class_name Entity

@export var life:int = 10
@export var armor:int = 0
@export var current_life = life
@export var is_dead:bool = false

@export var acceleration: float = 10.0       # aceleração (m/s²)
@export var friction: float = 10.0           # desaceleração (m/s²)
@export var speed: float = 25.0

var direction: Vector3

signal block
signal die

@export var drop:Array[PackedScene]

func apply_movement(direction: Vector3, target_speed: float, delta: float):
	if direction != Vector3.ZERO:
		var target_vel = direction * target_speed
		velocity.x = lerp(velocity.x, target_vel.x, acceleration * delta)
		velocity.z = lerp(velocity.z, target_vel.z, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		velocity.z = lerp(velocity.z, 0.0, friction * delta)
	
	# Gravidade (comum a todos os seres físicos)
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()


func get_damage(value:int):
	var damage:int = value - armor
	if damage <=0:
		block.emit()
	else:
		life-=damage
	
	if life <= 0:
		_die()

func _die():
	die.emit()
	
	
	for node in drop:
		var i = node.instantiate()
		i.global_position = global_position
		get_parent().add_child(i)  
	
	queue_free()
	print("die: ", name)
