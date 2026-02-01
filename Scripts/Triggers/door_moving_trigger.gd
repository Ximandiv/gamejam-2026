extends Area2D

var started := false

func _ready() -> void:
	body_entered.connect(start_animation)

func start_animation(body : Node2D) -> void:
	if not body.is_in_group("player") \
		or started:
		return
	
	print("start animation")
	$AnimationPlayer.play("moving")
	started = true
	$AnimationPlayer.animation_finished.connect(kill_process)

func kill_process() -> void:
	print("finished animation")
	queue_free()
