extends Resource 
class_name Item

@export var textura_item: Texture
@export var nome: String
@export var descricao: String
@export var tipo: String
@export var amontuavel: bool
@export var quantidade_max: int
@export_enum("atack","consume","debug","debug") var slot_type:int = 0
@export var mesh:Mesh

##isso deve ser sobrescrito para mecanica propria de cada item
func _use(player:Player):
	pass
