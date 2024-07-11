extends RigidBody2D

signal Launch


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("swing"):
		apply_torque_impulse(-100000)
	elif Input.is_action_just_pressed("swing_l"):
		apply_torque_impulse(100000)



func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(body_rid, body, body_shape_index, local_shape_index)


func _on_body_entered(body):
	print(body)
	pass # Replace with function body.
