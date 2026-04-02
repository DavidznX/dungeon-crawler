extends MeshInstance3D
class_name PlayerHand

@onready var render_modelo_item: Node3D = $"."


func _process(_delta: float) -> void:
	position.y = 0.6 + 0.1 * sin(Time.get_ticks_msec() / 200.0)

func _equip(item: Item):
	mesh = item.mesh
	
	##=========SOFRIMENTO ALHEIO==============##
	##==============NÃO MEXA!=================##
	
	var material_original = mesh.surface_get_material(0)
	
	if material_original:
		var material_mao = material_original.duplicate()
		material_mao.no_depth_test = true
		material_override = material_mao
	##=========================================##
