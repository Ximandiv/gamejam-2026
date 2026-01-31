extends CharacterBody2D

signal personaje_muerto

# @export var animation: AnimatedSprite2D
@export var area_2d: Area2D

var _velocidad: float = 100.0
var _velocidad_salto: float = -300.0
var _muerto: bool = false

func _ready() -> void:
	add_to_group("personajes")
	_muerto = false
	area_2d.body_entered.connect(_on_area_2d_body_entered)

func _physics_process(delta: float) -> void:
	if _muerto:
		return
		
	# gravedad
	velocity += get_gravity() * delta
	
	# slalto
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = _velocidad_salto
	
	#movimiento lateral
	if Input.is_action_pressed("derecha"):
		velocity.x = _velocidad
		# animation.flip_h = true
	elif Input.is_action_pressed("izquierda"):
		velocity.x = -_velocidad
		# animation.flip_h = false
	else:
		velocity.x = 0

	move_and_slide()
	
	# if !is_on_floor():
		# animation.play("saltar")
	# elif velocity.x != 0:
		# animation.play("correr")
	# else:
		# animation.play("idle")
		
func _on_area_2d_body_entered(_body: Node2D):
	_muerto = true
	# animation.stop()
	await get_tree().create_timer(0.5).timeout
	personaje_muerto.emit()
