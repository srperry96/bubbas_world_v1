extends Area3D

#custom signal for broadcasting new score - used below
signal peanut_collected

var collected_flag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if collected_flag:
		$CollisionShape3D/AnimationPlayer.play("peanut_collected")

#func _on_peanut_area_body_entered(body):
#	if body.name == "hamster_player":
#		score += 1
#		print("PEANUT SCORE:", score)


func _on_peanut_body_entered(body):
	if collected_flag == false:
		if body.name == "hamster_player":
			#custom signal to tell the score_counter that the score has changed
			emit_signal("peanut_collected")

			#start delete instance timer
			$timer_picked_up.start()
			collected_flag = true

#when the timer runs out
func _on_timer_picked_up_timeout():
	#queue_free deletes the instance
	queue_free()
