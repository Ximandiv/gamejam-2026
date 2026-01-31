extends CharacterBody2D

@export var speed := 100.0
@export var area_2d : Area2D

func _ready():
	visible = false
	area_2d.body_entered.connect(_on_monster_kill_player)

func _on_monster_kill_player(body: Node):
	if body is CharacterBody2D:
		print("alcanzó al jugador")

func _physics_process(delta):
	if visible:
		position.x += speed * delta
	
func show_monster():
	await get_tree().create_timer(3.0).timeout
	visible = true
	# temporal
	await get_tree().create_timer(9.0).timeout
	visible = false
	
