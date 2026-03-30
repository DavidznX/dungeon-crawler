extends Control

func settings():
	get_tree().change_scene_to_file("uid://bqqrqla2icr76")

func changed():
	#mudar para a cutscene
	get_tree().change_scene_to_file("uid://bsc2bofie5ise")

func quit():
	get_tree().quit()
