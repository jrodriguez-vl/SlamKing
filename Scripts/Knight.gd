extends CharacterBody2D


@export var gravity: float = 1500

@export var floorFriction: float  = .1
@export var airFriction: float  = .01

@export var moveSpeed: float = 40
@export var maxMoveSpeed: float = 250

@export var launchForce: float = 500
@export var maxLaunchForce: float = 650

var sprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $AnimatedSprite2D


func captureInput(delta):
	if is_on_floor():
		velocity.x = lerpf(velocity.x, 0, floorFriction)
	else:
		velocity.x = lerpf(velocity.x, 0, airFriction)

	var currentMove = Input.get_axis("walk_left", "walk_right") * moveSpeed * delta
	if currentMove != 0:
		sprite.flip_h = currentMove < 0
		sprite.play("moving")
	else:
		if is_on_floor():
			velocity.x = lerpf(velocity.x, 0, .1)
		sprite.play("idle")


	var potentialMoveSpeed = currentMove + velocity.x

	if potentialMoveSpeed >= 0:
		velocity.x = clampf(potentialMoveSpeed, 0, maxMoveSpeed)
	else:
		velocity.x = clampf(potentialMoveSpeed, -maxMoveSpeed, 0)



func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta

	captureInput(delta)
	move_and_slide()

func _on_sword_click_swing_launch(contactRad: float, isTheTip: bool):
	print("ugghhh")
	var smackVelocity = Vector2(0, 0)
	contactRad = wrapf(contactRad,0,TAU)

	smackVelocity = Vector2.RIGHT.rotated(contactRad + (PI / 2))

	if contactRad > PI / 2 && contactRad < (2 * PI) - (PI / 2):
		smackVelocity *= -1

	if isTheTip:
		smackVelocity.y = 0

	velocity.y += -launchForce * smackVelocity.y
	velocity.x += -launchForce * smackVelocity.x

	if velocity.y > 0:
		velocity.y = min(velocity.y, maxLaunchForce)
	elif velocity.y < 0:
		velocity.y = max(velocity.y, -maxLaunchForce)

	if velocity.x > 0:
		velocity.x = min(velocity.x, maxLaunchForce)
	elif velocity.x < 0:
		velocity.x = max(velocity.x, -maxLaunchForce)

	print(velocity)
