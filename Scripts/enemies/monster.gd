extends CharacterBody2D

@export var speed := 400.0
@export var area_2d : Area2D
@export var collision: CollisionShape2D

var is_go := false

func _ready():
	toggle_monster(false)
	area_2d.body_entered.connect(_on_monster_kill_player)

func _on_monster_kill_player(body: Node):
	if body is CharacterBody2D:
		print("alcanzó al jugador")

func _physics_process(delta):
	if visible and is_go:
		position.x += speed * delta
	
func show_monster():
	await get_tree().create_timer(3.0).timeout
	toggle_monster(true)
	await get_tree().create_timer(4.0).timeout
	is_go = true
	# temporal
	await get_tree().create_timer(9.0).timeout
	toggle_monster(false)
	
func toggle_monster(value : bool):
	visible = value
	collision.set_deferred("disabled", !value)
	area_2d.set_deferred("monitoring", value)
	area_2d.set_deferred("monitorable", value)
