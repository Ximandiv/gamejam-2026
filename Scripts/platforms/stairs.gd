extends Node2D
@export var offset_time := 3.0

func fall():
	await get_tree().create_timer(offset_time).timeout
	# var children = get_children()
	#for child in children:
		# child.freeze = false
