extends Node2D

@export var rotationPoint: Node2D
@export var windupSpeed: float = 100
@export var swingSpeed: float = 1000
@export var maxSwingRotation: float = 110
@export var windbackOffset: float = 20


signal Launch

var collider: CollisionShape2D
var swordBody: Node2D

var chargedRotation: float
var swinging: bool
var isLeftOfMouse: bool

var windbackDegrees: float = -90
var maxReverseSwingRotation: float = 70

# Called when the node enters the scene tree for the first time.
func _ready():
	swordBody = get_node("SwordBody")
	collider = get_node("SwordBody/Area2D/CollisionShape2D")
	swinging = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotationPoint.global_rotation_degrees = 0
	swing(delta)
	collider.disabled = !swinging

func swing(delta):
	if swinging:
		var amountToRotate = delta * swingSpeed

		if isLeftOfMouse:
			swordBody.global_rotation_degrees += amountToRotate

			if swordBody.global_rotation_degrees >= maxSwingRotation:
				swinging = false
		else:
			swordBody.global_rotation_degrees -= amountToRotate
			print(swordBody.global_rotation_degrees)
			print(amountToRotate)

			if swordBody.global_rotation_degrees <= maxReverseSwingRotation && swordBody.global_rotation_degrees > 0:
				swinging = false

	elif Input.is_action_pressed("swing") && !swinging:
		chargedRotation += delta * windupSpeed
		chargedRotation = clampf(chargedRotation, 0, -windbackDegrees) 

		var mousePos = get_global_mouse_position()
		isLeftOfMouse = rotationPoint.global_position.x < mousePos.x

		var point = rotationPoint.get_angle_to(mousePos)
		var degrees = rad_to_deg(point)
		if isLeftOfMouse:
			degrees -= chargedRotation
			swordBody.global_rotation_degrees = max(windbackDegrees - windbackOffset, degrees)
		else:
			degrees += chargedRotation
			swordBody.global_rotation_degrees = min(windbackDegrees + windbackOffset, degrees)

	elif chargedRotation != 0:
		chargedRotation = 0
		swinging = true

	else:
		var mousePos = get_global_mouse_position()
		swordBody.look_at(mousePos)

func _on_area_2d_body_entered(body):
	print(body.name)
	chargedRotation = 0
	swinging = false
	Launch.emit()
	collider.set_deferred("disabled", true)
	# maybe kick up some animation at the trigger point
