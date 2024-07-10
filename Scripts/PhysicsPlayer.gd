extends RigidBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var axis = Input.get_axis("walk_left", "walk_right")
	apply_central_impulse(Vector2.RIGHT * 50 * axis)
