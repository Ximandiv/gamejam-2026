extends StaticBody2D

@export var fuerza_rebote: float = -250.0  # negativo = hacia arriba
@export var area_2d: Area2D
@export var limit_area: Area2D

@export var bounce_quantity: int = 4
var current_bounce_quantity := 0

func _ready():
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)

func _on_body_exited(body: Node):
	if body is CharacterBody2D \
	and body.velocity.y == 0:
		current_bounce_quantity = 0

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D \
	and body.velocity.y > 0 \
	and current_bounce_quantity < bounce_quantity:
		await get_tree().create_timer(0.1).timeout
		body.velocity.y = fuerza_rebote
		current_bounce_quantity += 1
