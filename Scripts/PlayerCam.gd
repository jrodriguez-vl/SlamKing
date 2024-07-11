extends Camera2D

var player: Node2D

@export var shouldLockX: bool
@export var lockCamX: float

func _ready():
	player = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var setPos = player.global_position
	if shouldLockX:
		setPos.x = lockCamX

	global_position = setPos
