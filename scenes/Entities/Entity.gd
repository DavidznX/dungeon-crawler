extends CharacterBody3D
class_name Entity

@export var life:int

@export var is_dead:bool = false

@export var acceleration := 10.0       # aceleração (m/s²)
@export var friction := 10.0           # desaceleração (m/s²)

func _movement(input:Vector2):
	pass
