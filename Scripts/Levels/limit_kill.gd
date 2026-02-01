extends Node2D

@export var area_2d : Area2D

func _ready() -> void:
	area_2d.body_entered.connect(_kill_player)
	
func _kill_player(body: Node):
	if body is CharacterBody2D:
		get_tree().reload_current_scene()
