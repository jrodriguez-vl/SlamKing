extends CharacterBody2D

@export var moveSpeed: float = 150
@export var maxMoveSpeed: float = 250
@export var gravity: float = 1500
@export var launchForce: float = 500
@export var floorFriction: float  = .1
@export var airFriction: float  = .01

var sprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $AnimatedSprite2D


func captureInput():
	if is_on_floor():
		velocity.x = lerpf(velocity.x, 0, floorFriction)
	else:
		velocity.x = lerpf(velocity.x, 0, airFriction)

	var direction = Input.get_axis("walk_left", "walk_right") * moveSpeed
	if direction != 0:
		sprite.flip_h = direction < 0
		sprite.play()
	else:
		if is_on_floor():
			velocity.x = lerpf(velocity.x, 0, .5)
		sprite.stop()

	if (direction < 0 && velocity.x >=0) || (direction > 0 && velocity.x <= 0) || (!abs(velocity.x) > maxMoveSpeed):
		velocity.x += direction


func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta

	captureInput()
	move_and_slide()

func _on_sword_click_swing_launch(contactRad):
	var smackVelocity = Vector2(0, 0)
	contactRad = wrapf(contactRad,0,TAU)

	smackVelocity = Vector2.RIGHT.rotated(contactRad + (PI / 2))

	if contactRad > PI / 2 && contactRad < (2 * PI) - (PI / 2):
		smackVelocity *= -1

	velocity.y += -launchForce * smackVelocity.y
	velocity.x += -launchForce * smackVelocity.x
