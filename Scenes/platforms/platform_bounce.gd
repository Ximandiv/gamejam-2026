extends StaticBody2D

@export var fuerza_rebote: float = -100.0  # negativo = hacia arriba
@export var area_2d: Area2D

func _ready():
	area_2d.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	# Solo afecta al jugador
	if body is CharacterBody2D:
		body.velocity.y += fuerza_rebote
