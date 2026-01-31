extends Control

@export var start_scene_path : String = "res://scenes/Levels/level_tutorial.tscn"

func _ready() -> void:
	# Conectar botones
	$VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
	$VBoxContainer/InstructionsButton.pressed.connect(_on_instructions_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	print("Starting game...")
	get_tree().change_scene_to_file(start_scene_path)

func _on_instructions_pressed() -> void:
	print("Opening instructions...")
	get_tree().change_scene_to_file("res://scenes/UI/instructions.tscn")

func _on_quit_pressed() -> void:
	print("Quitting game...")
	get_tree().quit()
