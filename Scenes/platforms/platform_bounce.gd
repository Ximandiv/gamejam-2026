extends StaticBody2D

@export var fuerza_rebote: float = -100.0  # negativo = hacia arriba
@export var area_2d: Area2D
@export var limit_area: Area2D

@onready var tween = create_tween()
@export var bounce_quantity: int = 3
var current_bounce_quantity := 0

func _ready():
	area_2d.body_entered.connect(_on_body_entered)
	limit_area.body_exited.connect(_on_body_exited)
	limit_area.body_entered.connect(_on_limit_area)
		
func _on_limit_area(body: Node):
	if body is CharacterBody2D \
	and body.velocity.y == 0:
		current_bounce_quantity = 0

func _on_body_exited(body: Node):
	print("body exited")
	pass

func _on_body_entered(body: Node) -> void:
	print("entra")
	if body is CharacterBody2D \
	and current_bounce_quantity < bounce_quantity:
		body.velocity.y = fuerza_rebote
		current_bounce_quantity += 1
		
