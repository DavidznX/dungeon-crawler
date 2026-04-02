extends CharacterBody3D
class_name Entity

@export var life:int = 10
@export var armor:int = 0

@export var is_dead:bool = false

@export var acceleration := 10.0       # aceleração (m/s²)
@export var friction := 10.0           # desaceleração (m/s²)

signal block

func _movement(_input:Vector2):
	pass

func get_damage(value:int):
	var damage:int = value - armor
	if damage <=0:
		block.emit()
	else:
		life-=damage
