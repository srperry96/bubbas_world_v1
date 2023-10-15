extends Label

var score := 0
const total_peanuts := 15
signal sgnl_end_level

func update_label():
	text = "Score: " + str(score)

# Called when the node enters the scene tree for the first time.
func _ready():
	update_label()

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_peanut_collected():
	score += 1
	update_label()

	if score >= total_peanuts:
		emit_signal("sgnl_end_level")
