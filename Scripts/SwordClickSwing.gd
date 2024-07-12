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
var isSwingingRight: bool

var previousDirection: float
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
	clickSwing(delta)

func clickSwing(delta):
	if swinging:
		var amountToRotate = delta * swingSpeed

		if !isSwingingRight:
			swordBody.global_rotation_degrees += amountToRotate

			if swordBody.global_rotation_degrees >= maxSwingRotation:
				swinging = false
		else:
			swordBody.global_rotation_degrees -= amountToRotate

			if swordBody.global_rotation_degrees <= maxReverseSwingRotation && swordBody.global_rotation_degrees > 0:
				swinging = false
		
		if !swinging:
			swordBody.global_rotation_degrees = windbackDegrees + (previousDirection * windbackOffset)



	elif (Input.is_action_just_pressed("swing") || Input.is_action_just_pressed("swing_l")) && !swinging && waitingForNextSwing:
		swinging = true
		# isSwingingRight = Input.is_action_just_pressed("swing")
		isSwingingRight = previousDirection == 1
		waitingForNextSwing = false
		swingTimer.start()

	else:
		var axis = 0
		if Input.is_action_pressed("walk_left"):
			axis = 1
		elif Input.is_action_pressed("walk_right"):
			axis = -1

		if axis != 0:
			previousDirection = axis
			swordBody.global_rotation_degrees = windbackDegrees + (axis * windbackOffset)
		print(previousDirection)

func _on_area_2d_body_entered(_body):
	if !swinging || !collisionTimer.is_stopped():
		return

	collisionTimer.start()
	swinging = false
	disableColliders(true)
	Launch.emit(swordBody.global_rotation, false)
	# maybe kick up some animation at the trigger point


func _on_click_timer_timeout():
	enableColliders(true)
	waitingForNextSwing = true
	swordBody.global_rotation_degrees = windbackDegrees + (previousDirection * windbackOffset)

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
	

func _on_base_area_2d_body_entered(body):
	print("asdf")
	if !swinging || !collisionTimer.is_stopped():
		return

	collisionTimer.start()
	swinging = false
	disableColliders(true)
	Launch.emit(swordBody.global_rotation, false)
	# maybe kick up some animation at the trigger point
