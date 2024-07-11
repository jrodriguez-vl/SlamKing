extends RichTextLabel

var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_debug_stats_timer_timeout():
	text = var_to_str( player.velocity)
