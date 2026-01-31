extends CharacterBody2D

@export var push_force := 500.0
@export var area_2d: Area2D

@export var _playerSpeed: float = 100.0
@export var _currentPlayerSpeed: float = 100.0
@export var _playerJumpForce: float = -350.0

var _input_velocity_x := 0.0
var _push_velocity_x := 0.0
var _push_velocity_y := 0.0

func _enter_tree() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# gravity
	velocity += get_gravity() * delta

	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = _playerJumpForce

	# input
	if Input.is_action_pressed("right"):
		_input_velocity_x = _currentPlayerSpeed
	elif Input.is_action_pressed("left"):
		_input_velocity_x = -_currentPlayerSpeed
	else:
		_input_velocity_x = 0

	#combine
	velocity.x = _input_velocity_x + _push_velocity_x

	# Solo aplicar empuje vertical si existe, no sumar
	if abs(_push_velocity_y) > 0:
		velocity.y = _push_velocity_y

	# decay push over time (important)
	_push_velocity_x = move_toward(_push_velocity_x, 0.0, 1200 * delta)
	_push_velocity_y = move_toward(_push_velocity_y, 0.0, 2400 * delta)

	move_and_slide()

func stop_movement() -> void:
	_currentPlayerSpeed = 0

func resume_movement() -> void:
	_currentPlayerSpeed = _playerSpeed

func stop_push() -> void:
	_push_velocity_x = 0
	_push_velocity_y = 0

func apply_push(direction: int, strength: float = 1.0) -> void:
	_push_velocity_x += direction * push_force * strength

func apply_push_2d(direction_x: int, direction_y: int, strength: float = 1.0) -> void:
	_push_velocity_x += direction_x * push_force * strength
	_push_velocity_y += direction_y * push_force * strength
