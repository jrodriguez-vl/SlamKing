extends Node2D

@export var rotationPoint: Node2D
@export var windupSpeed: float = 100
@export var swingSpeed: float = 1000
@export var maxSwingRotation: float = 110
@export var windbackOffset: float = 20


signal Launch

var collider: CollisionShape2D
var swordBody: Node2D
var player: CharacterBody2D


var swingTimer: Timer
var chargedRotation: float
var swinging: bool
var isLeftOfMouse: bool

var windbackDegrees: float = -90
var maxReverseSwingRotation: float = 70

# Called when the node enters the scene tree for the first time.
func _ready():
	swingTimer = get_node("ClickTimer")
	player = get_parent()
	swordBody = get_node("SwordBody")
	collider = get_node("SwordBody/Area2D/CollisionShape2D")
	swinging = false

func _process(delta):
	rotationPoint.global_rotation_degrees = 0
	collider.disabled = !swinging
	swing(delta)

func swing(delta):
	if swinging:
		var amountToRotate = delta * swingSpeed

		if isLeftOfMouse:
			swordBody.global_rotation_degrees += amountToRotate

			if swordBody.global_rotation_degrees >= maxSwingRotation:
				swinging = false
		else:
			swordBody.global_rotation_degrees -= amountToRotate

			if swordBody.global_rotation_degrees <= maxReverseSwingRotation && swordBody.global_rotation_degrees > 0:
				swinging = false

	elif Input.is_action_just_pressed("swing") && !swinging:
		swinging = true

	else:
		var mousePos = get_global_mouse_position()
		isLeftOfMouse = player.global_position.x < mousePos.x

		var point = rotationPoint.get_angle_to(mousePos)
		var degrees = rad_to_deg(point)
		
		var direction = 90
		if isLeftOfMouse:
			direction *= -1

		swordBody.global_rotation_degrees = degrees + direction

# func _on_area_2d_body_entered(body):
# 	if !swinging:
# 		return

# 	print("collided")
# 	swinging = false
# 	collider.set_deferred("disabled", true)
# 	print(swordBody.rotation)
# 	Launch.emit(swordBody.global_rotation)
# 	# maybe kick up some animation at the trigger point

func _on_area_2d_body_entered(body):
	if !swinging:
		return

	print("collided")
	swinging = false
	collider.set_deferred("disabled", true)
	print(swordBody.rotation)
	Launch.emit(swordBody.global_rotation)
	# maybe kick up some animation at the trigger point
