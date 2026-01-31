extends Control

@export var display_duration: float = 3.0
@export var fade_in_duration: float = 0.3
@export var fade_out_duration: float = 0.3
@onready var label: Label = $Panel/MarginContainer/Label

var _tween: Tween

func _ready() -> void:
	modulate.a = 0
	visible = false

func show_dialog(text: String, font_size: int = 20) -> void:
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)

	visible = true

	# Cancelar tween anterior si existe
	if _tween:
		_tween.kill()

	# Fade in
	_tween = create_tween()
	_tween.tween_property(self, "modulate:a", 1.0, fade_in_duration)

	# Esperar
	_tween.tween_interval(display_duration)

	# Fade out
	_tween.tween_property(self, "modulate:a", 0.0, fade_out_duration)
	_tween.tween_callback(func(): visible = false)

func hide_dialog() -> void:
	if _tween:
		_tween.kill()

	_tween = create_tween()
	_tween.tween_property(self, "modulate:a", 0.0, fade_out_duration)
	_tween.tween_callback(func(): visible = false)
