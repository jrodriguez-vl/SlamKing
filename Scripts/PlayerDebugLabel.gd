extends RichTextLabel

var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_debug_stats_timer_timeout():
	var stats = {
		"Velocity": [player.velocity.x, player.velocity.y],
		"Position": [player.global_position.x, player.global_position.y]
	}
	var newText = ""
	# stats.append(stringify(player.velocity))
	# stats.append(stringify(player.global_position))
	# for key in stats:
	# 	newText += key + ": " + stats[key]

	# text = newText
	text = var_to_str(stats).replace("{", "").replace("}", "")

func stringify(item: Vector2):
	return var_to_str(item.x)

