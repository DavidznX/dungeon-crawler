extends ItemList

signal character_selected(character_path: String)

var characters: Array[PlayerResource] = []

func _ready():
	load_characters_from_folder()
	refresh_list()
	item_selected.connect(_on_item_selected)

func load_characters_from_folder():
	characters.clear()
	var dir = DirAccess.open("res://resources/entities/player/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var path = "res://resources/entities/player/" + file_name
				var res = load(path)
				if res is PlayerResource:
					characters.append(res)
			file_name = dir.get_next()
		dir.list_dir_end()

func refresh_list():
	clear()
	for c in characters:
		if not c:
			continue
		var icon = c.sprite if c.sprite else null
		var idx = add_item(c.name, icon, true)
		set_item_metadata(idx, c)

func _on_item_selected(index: int):
	var c: PlayerResource = get_item_metadata(index)
	if c:
		character_selected.emit(c.resource_path)

func set_characters(new_chars: Array[PlayerResource]):
	characters = new_chars
	refresh_list()
