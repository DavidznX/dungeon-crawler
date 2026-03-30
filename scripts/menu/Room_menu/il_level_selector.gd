extends ItemList

signal level_selected(level_path: String)

var levels: Array[LevelRes] = []

func _ready():
	load_levels_from_folder()
	refresh_list()
	item_selected.connect(_on_item_selected)

func load_levels_from_folder():
	levels.clear()
	var dir = DirAccess.open("res://resources/albums/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var path = "res://resources/albums/" + file_name
				var res = load(path)
				if res is LevelRes:
					levels.append(res)
			file_name = dir.get_next()
		dir.list_dir_end()

func refresh_list():
	clear()
	for l in levels:
		if not l:
			continue
		var icon = l.album_cover if l.album_cover else null
		var idx = add_item(l.name, icon, true)
		set_item_metadata(idx, l)

func _on_item_selected(index: int):
	var l: LevelRes = get_item_metadata(index)
	if l:
		level_selected.emit(l.resource_path)

func set_levels(new_levels: Array[LevelRes]):
	levels = new_levels
	refresh_list()
