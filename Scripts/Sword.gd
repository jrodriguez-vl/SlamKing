extends Node2D

@export var rotationPoint: Node2D
@export var maximumRotation: float = 110
@export var windupSpeed: float = 100
@export var swingSpeed: float = 500

signal Launch

var collider: CollisionShape2D
var swordBody: Node2D

var chargedRotation: float
var swinging: bool

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
		chargedRotation = clampf(chargedRotation - amountToRotate, 0, maximumRotation)
		swordBody.global_rotation_degrees += amountToRotate

		if (chargedRotation <= 0):
			swinging = false

	elif Input.is_action_pressed("swing"):
		chargedRotation += delta * windupSpeed
		chargedRotation = clampf(chargedRotation, 0, maximumRotation) 
		var point = rotationPoint.get_angle_to(get_global_mouse_position())
		var degrees = rad_to_deg(point)
		degrees -= chargedRotation
		swordBody.global_rotation_degrees = degrees

	elif chargedRotation != 0:
		swinging = true

	else:
		swordBody.look_at(get_global_mouse_position())

func _on_area_2d_body_entered(body):
	chargedRotation = 0
	swinging = false
	collider.set_deferred("disabled", true)
	# maybe kick up some animation at the trigger point
	Launch.emit()