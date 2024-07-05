extends CharacterBody2D

@export var moveSpeed: float = 200
@export var gravity: float = 1500
@export var launchForce: float = 1000

var sprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $AnimatedSprite2D
	pass # Replace with function body.


func captureInput():
	velocity.x = 0
	var direction = Input.get_axis("walk_left", "walk_right") * moveSpeed
	if direction != 0:
		sprite.flip_h = direction < 0
		sprite.play()
	else:
		sprite.stop()

	velocity.x += direction

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta

	captureInput()
	move_and_slide()


func _on_sword_launch():
	print_debug("launching")
	velocity.y = -launchForce


func _on_sword_2_launch():
	print_debug("launching")
	velocity.y = -launchForce
