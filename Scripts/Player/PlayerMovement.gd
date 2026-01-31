extends CharacterBody2D

signal personaje_muerto

@export var area_2d: Area2D

var _velocidad: float = 100.0
var _velocidad_salto: float = -350.0
var _muerto: bool = false

func _ready() -> void:
	add_to_group("personajes")
	_muerto = false
	area_2d.body_entered.connect(_on_area_2d_body_entered)

func _physics_process(delta: float) -> void:		
	# gravedad
	velocity += get_gravity() * delta
	
	# slalto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = _velocidad_salto
	
	#movimiento lateral
	if Input.is_action_pressed("right"):
		velocity.x = _velocidad
	elif Input.is_action_pressed("left"):
		velocity.x = -_velocidad
	else:
		velocity.x = 0

	move_and_slide()

		
func _on_area_2d_body_entered(_body: Node2D):
	_muerto = true
	await get_tree().create_timer(0.5).timeout
	personaje_muerto.emit()
