extends Node

@export var push_force := 500.0
@export var area_2d: Area2D
@export var characterBody: CharacterBody2D
@export var playerStatus : PlayerStatus

@export var _playerSpeed: float = 100.0
@export var _currentPlayerSpeed: float = 100.0
@export var _playerJumpForce: float = -800.0

@export var coyoteTime := 0.12

@onready var character: AnimatedSprite2D = $"../AnimatedSprite2D"

var coyoteTimer := 0.0

var isJumping := false
var isMoving := false
var isLanding := false
var isBeingDamaged := false

var wasOnFloor := false
var isFalling := false
var landingQueued := false
var shouldLand := false

var _input_velocity_x := 0.0
var _push_velocity_x := 0.0

signal stopMoving
signal resumeMove
signal push(direction: int, strength: float)

func _ready() -> void:
	_currentPlayerSpeed = _playerSpeed
	stopMoving.connect(stop_movement)
	resumeMove.connect(resume_movement)
	push.connect(apply_push)
	character.play("Idle")
	character.animation_finished.connect(landed)

func _physics_process(delta: float) -> void:
	if characterBody.is_on_floor():
		coyoteTimer = coyoteTime
	else:
		coyoteTimer -= delta
	
	if characterBody.is_on_floor() and not wasOnFloor and shouldLand:
		isJumping = false
		landingQueued = true
		isLanding = true
		isFalling = false
		shouldLand = false
		if not playerStatus.currentMask == PlayerMaskEnum.Value.SILENCE:
			character.play("Land")
		elif playerStatus.currentMask == PlayerMaskEnum.Value.SILENCE:
			character.play("Land_Silence_Mask")
	elif characterBody.is_on_floor() and not wasOnFloor:
		isJumping = false
		landingQueued = false
		isLanding = false
		isFalling = false
		shouldLand = false
		
		if not playerStatus.currentMask == PlayerMaskEnum.Value.SILENCE:
			character.play("Idle")
		elif playerStatus.currentMask == PlayerMaskEnum.Value.SILENCE:
			character.play("Idle_Silence_Mask")

	wasOnFloor = characterBody.is_on_floor()
	
	if characterBody.velocity.y > 200 and not characterBody.is_on_floor():
		isFalling = true
	
	if (characterBody.velocity.y < -400 \
	or characterBody.velocity.y > 600) \
	and not characterBody.is_on_floor():
		shouldLand = true
	
	# jump
	if Input.is_action_just_pressed("jump") \
	and coyoteTimer > 0.0 \
	and not isBeingDamaged:
		coyoteTimer = 0.0
		characterBody.velocity.y = _playerJumpForce
		
		if not playerStatus.currentMask == PlayerMaskEnum.Value.SILENCE:
			character.play("Start_Jump")
		elif playerStatus.currentMask == PlayerMaskEnum.Value.SILENCE:
			character.play("Start_Jump_Silence_Mask")
		isJumping = true
	
	# gravity
	characterBody.velocity += characterBody.get_gravity() * delta
	
	# input
	if Input.is_action_pressed("right") \
	and not isBeingDamaged:
		_input_velocity_x = _currentPlayerSpeed
		character.flip_h = false
		isMoving = true
	elif Input.is_action_pressed("left") \
	and not isBeingDamaged:
		_input_velocity_x = -_currentPlayerSpeed
		character.flip_h = true
		isMoving = true
	else:
		_input_velocity_x = 0
		isMoving = false
	
	#combine
	characterBody.velocity.x = _input_velocity_x + _push_velocity_x
	
	if isJumping and not isLanding or isBeingDamaged:
		pass
	elif isMoving and not isLanding:
		if not playerStatus.currentMask == PlayerMaskEnum.Value.SILENCE:
			character.play("Walk")
		elif playerStatus.currentMask == PlayerMaskEnum.Value.SILENCE:
			character.play("Walk_Silence_Mask")
	elif not isLanding:
		if not playerStatus.currentMask == PlayerMaskEnum.Value.SILENCE:
			character.play("Idle")
		elif playerStatus.currentMask == PlayerMaskEnum.Value.SILENCE:
			character.play("Idle_Silence_Mask")
	
	# decay push over time (important)
	_push_velocity_x = move_toward(_push_velocity_x, 0.0, 1200 * delta)

	characterBody.move_and_slide()

func landed() -> void:
	if character.animation == "Land" \
	or character.animation == "Land_Silence_Mask":
		landingQueued = false
		isLanding = false
	elif character.animation == "Start_Jump" \
	or character.animation == "Start_Jump_Silence_Mask":
		if not playerStatus.currentMask == PlayerMaskEnum.Value.SILENCE:
			character.play("Jumping")
		elif playerStatus.currentMask == PlayerMaskEnum.Value.SILENCE:
			character.play("Jumping_Silence_Mask")
	elif character.animation == "Damaged":
		isBeingDamaged = false

func stop_movement() -> void:
	_currentPlayerSpeed = 0
	_input_velocity_x = 0
	characterBody.velocity.x = 0
	characterBody.velocity.y = 0

func resume_movement() -> void:
	_currentPlayerSpeed = _playerSpeed

func stop_push() -> void:
	_push_velocity_x = 0

func apply_push(direction: int, strength: float = 1.0) -> void:
	character.play("Damaged")
	isBeingDamaged = true
	_push_velocity_x = direction * push_force * strength

func apply_push_vertical(strength: float = 1.0) -> void:
	characterBody.velocity.y = _playerJumpForce * strength
