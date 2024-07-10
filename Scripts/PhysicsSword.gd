extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("swing"):
		print("do something polz")
		apply_force(Vector2.UP * 1000 , Vector2.ZERO)
