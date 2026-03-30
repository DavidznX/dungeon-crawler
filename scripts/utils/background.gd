extends Node

var default_background_color:Color = Color(0.063, 0.078, 0.122, 1.0)

func _ready() -> void:
	RenderingServer.set_default_clear_color(default_background_color)

func flash_background(color: Color, duration: float = 0.4):
	var tween = create_tween()
	tween.tween_method(func(c): 
		RenderingServer.set_default_clear_color(c)
	, default_background_color, color, duration * 0.5)
	tween.tween_method(func(c): 
		RenderingServer.set_default_clear_color(c)
	, color, default_background_color, duration * 0.5)
