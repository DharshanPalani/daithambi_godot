extends RayCast3D

var interaction_distance: float = 3.0

func _ready():
	target_position = Vector3(0, 0, -interaction_distance)
	enabled = true

func _input(event: InputEvent):
	if event.is_action_pressed("interact") and is_colliding():
		var target = get_collider()
		if target and target.is_in_group("interactible"):
			print("Interacted with:", target.name)
			target.queue_free()
		else:
			print("No interaction to hit daw")
