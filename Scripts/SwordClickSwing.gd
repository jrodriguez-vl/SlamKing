extends Node2D

@export var rotationPoint: Node2D
@export var windupSpeed: float = 100
@export var swingSpeed: float = 1000
@export var maxSwingRotation: float = 110
@export var windbackOffset: float = 20


signal Launch

var baseCollider: CollisionShape2D
var tipCollider: CollisionShape2D
var swordBody: Node2D
var player: CharacterBody2D


var swingTimer: Timer
var collisionTimer: Timer

var chargedRotation: float
var swinging: bool
var waitingForNextSwing: bool = true
var isLeftOfMouse: bool

var windbackDegrees: float = -90
var maxReverseSwingRotation: float = 70

# Called when the node enters the scene tree for the first time.
func _ready():
	swingTimer = get_node("SwingTimer")
	collisionTimer = get_node("CollisionTimer")
	player = get_parent()
	swordBody = get_node("SwordBody")
	baseCollider = get_node("SwordBody/BaseArea2D/CollisionShape2D")
	tipCollider = get_node("SwordBody/TipArea2D/CollisionShape2D")
	swinging = false

func _process(delta):
	rotationPoint.global_rotation_degrees = 0
	swing(delta)

func swing(delta):
	if swinging:
		var amountToRotate = delta * swingSpeed

		if isLeftOfMouse:
			swordBody.global_rotation_degrees += amountToRotate

			if swordBody.global_rotation_degrees >= maxSwingRotation:
				# enableColliders()
				swinging = false
		else:
			swordBody.global_rotation_degrees -= amountToRotate

			if swordBody.global_rotation_degrees <= maxReverseSwingRotation && swordBody.global_rotation_degrees > 0:
				# enableColliders()
				swinging = false

	elif Input.is_action_just_pressed("swing") && !swinging && waitingForNextSwing:
		swinging = true
		waitingForNextSwing = false
		swingTimer.start()

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
# 	baseCollider.set_deferred("disabled", true)
# 	print(swordBody.rotation)
# 	Launch.emit(swordBody.global_rotation)
# 	# maybe kick up some animation at the trigger point

func _on_area_2d_body_entered(_body):
	if !swinging || !collisionTimer.is_stopped():
		return

	print("swordbody")
	collisionTimer.start()
	swinging = false
	disableColliders(true)
	print(swordBody.rotation)
	Launch.emit(swordBody.global_rotation, false)
	# maybe kick up some animation at the trigger point


func _on_click_timer_timeout():
	print("timeout")
	enableColliders(true)
	waitingForNextSwing = true

func _on_tip_area_2d_body_entered(_body:Node2D):
	if !swinging || !collisionTimer.is_stopped():
		return
	print("just the tip")
	collisionTimer.start()
	swinging = false
	disableColliders(true)
	print(swordBody.rotation)
	Launch.emit(swordBody.global_rotation, true)


func disableColliders(isDeferred: bool = false):
	if isDeferred:
		baseCollider.set_deferred("disabled", true)
		tipCollider.set_deferred("disabled", true)
	else:
		baseCollider.disabled = true
		tipCollider.disabled = true
	
func enableColliders(isDeferred: bool = false):
	if isDeferred:
		baseCollider.set_deferred("disabled", false)
		tipCollider.set_deferred("disabled", false)
	else:
		baseCollider.disabled = false
		tipCollider.disabled = false
	

func _on_collision_timer_timeout():
	pass # Replace with function body.


func _on_base_area_2d_body_entered(body):
	if !swinging || !collisionTimer.is_stopped():
		return

	print("swordbody")
	collisionTimer.start()
	swinging = false
	disableColliders(true)
	print(swordBody.rotation)
	Launch.emit(swordBody.global_rotation, false)
	# maybe kick up some animation at the trigger point
