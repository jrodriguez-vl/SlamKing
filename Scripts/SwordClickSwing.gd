extends Node2D

@export var rotationPoint: Node2D
@export var swingSpeed: float = 1000
@export var maxSwingRotation: float = 150
@export var windbackOffset: float = 20


signal Launch

var baseCollider: CollisionShape2D
var swordBody: Node2D
var player: CharacterBody2D


var swingTimer: Timer
var collisionTimer: Timer

var chargedRotation: float
var swinging: bool
var waitingForNextSwing: bool = true
var isSwingingRight: bool

var previousAxis: float = 1
var windbackDegrees: float = -90
var amountRotated: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	swingTimer = get_node("SwingTimer")
	collisionTimer = get_node("CollisionTimer")
	player = get_parent()
	swordBody = get_node("SwordBody")
	baseCollider = get_node("SwordBody/BaseArea2D/CollisionShape2D")
	swinging = false

func _process(delta):
	rotationPoint.global_rotation_degrees = 0
	clickSwing(delta)

func clickSwing(delta):
	if swinging:
		var amountToRotate = delta * swingSpeed * previousAxis
		amountRotated += abs(amountToRotate)

		swordBody.global_rotation_degrees += amountToRotate

		if amountRotated >= maxSwingRotation:
			swinging = false
		
		
	elif (Input.is_action_just_pressed("swing") || Input.is_action_just_pressed("swing_l")) && !swinging && waitingForNextSwing:
		swinging = true
		# isSwingingRight = Input.is_action_just_pressed("swing")
		enableColliders(true)
		isSwingingRight = previousAxis == 1
		waitingForNextSwing = false
		amountRotated = 0
		swingTimer.start()

	else:
		finishSwing()
		var axis = 0
		if Input.is_action_pressed("walk_left"):
			axis = -1
		elif Input.is_action_pressed("walk_right"):
			axis = 1

		if axis != 0:
			previousAxis = axis

		swordBody.global_rotation_degrees = windbackDegrees + (-previousAxis * windbackOffset)

func _on_click_timer_timeout():
	# enableColliders(true)
	waitingForNextSwing = true
	# swordBody.global_rotation_degrees = windbackDegrees + (previousAxis * windbackOffset)

func disableColliders(isDeferred: bool = false):
	if isDeferred:
		baseCollider.set_deferred("disabled", true)
	else:
		baseCollider.disabled = true
	
func enableColliders(isDeferred: bool = false):
	if isDeferred:
		baseCollider.set_deferred("disabled", false)
	else:
		baseCollider.disabled = false
	
func finishSwing():
	swinging = false
	disableColliders(true)

func _on_base_area_2d_body_entered(body):
	if !collisionTimer.is_stopped():
		return

	collisionTimer.start()
	finishSwing()
	Launch.emit(swordBody.global_rotation, false)
	# maybe kick up some animation at the trigger point
