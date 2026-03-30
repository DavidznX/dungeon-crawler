extends Control

@onready var text_edit: TextEdit = $VBoxContainer/TextEdit


func _on_b_enter_pressed() -> void:
	get_tree().change_scene_to_file("uid://behqi7nmvsmxh")


func _on_b_back_pressed() -> void:
	get_tree().change_scene_to_file("uid://b1j86k1k6bc2x")



func _on_text_edit_text_changed() -> void:
	NetWorkManager.ip_selected = text_edit.text
