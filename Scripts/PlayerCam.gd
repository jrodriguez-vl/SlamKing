extends Camera2D

var player: Node2D

func _ready():
	player = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = player.global_position
