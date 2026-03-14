extends Node3D

@export var sensibilidade := 0.2
@export var limite_vertical := 80.0

var rotacao_x := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		
		# Rotação horizontal (player)
		get_parent().rotate_y(deg_to_rad(-event.relative.x * sensibilidade))
		
		# Rotação vertical (câmera)
		rotacao_x -= event.relative.y * sensibilidade
		rotacao_x = clamp(rotacao_x, -limite_vertical, limite_vertical)
		
		rotation_degrees.x = rotacao_x
