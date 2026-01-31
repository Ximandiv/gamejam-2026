extends Area2D

@export var monster : CharacterBody2D

func _on_body_entered(body: Node2D) -> void:
	monster.show_monster()
