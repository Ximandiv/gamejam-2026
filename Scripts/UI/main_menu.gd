extends Control

@export var start_scene_path : String = "res://scenes/Levels/level_tutorial.tscn"
@export var options_popup_scene : PackedScene = preload("res://Scenes/UI/options_popup.tscn")

@onready var play_button: TextureButton = $VBoxContainer/PlayButton

var _options_popup : Control = null

func _ready() -> void:
	# Conectar botones
	play_button.pressed.connect(_on_start_pressed)
	$VBoxContainer/InstructionsButton.pressed.connect(_on_options_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	print("Starting game...")
	get_tree().change_scene_to_file(start_scene_path)

func _on_options_pressed() -> void:
	if _options_popup == null:
		_options_popup = options_popup_scene.instantiate()
		add_child(_options_popup)
		_options_popup.get_node("ColorRect").gui_input.connect(_on_popup_background_clicked)

func _on_popup_background_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _options_popup != null:
			_options_popup.queue_free()
			_options_popup = null

func _on_quit_pressed() -> void:
	print("Quitting game...")
	get_tree().quit()
