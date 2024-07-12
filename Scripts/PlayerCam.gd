extends Camera2D

var player: Node2D

var shouldLockX: bool

func _ready():
	shouldLockX = false
	player = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if !shouldLockX:
	# 	shouldLockX = player.global_position.x > -192

	if !shouldLockX:
		if player.global_position.x > 225:
			shouldLockX = true
			limit_left = -1
			limit_right = 455
			offset = Vector2(208, 0)

	var setPos = player.global_position
	# if shouldLockX:
	# 	setPos.x = 0

	global_position = setPos
