extends Node3D

const train_move_speed := 10.0
const carriage_mid_ratio_offset := 0.036
const carriage_rear_ratio_offset := 0.066

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/btn_continue.hide()
	$Control/lbl_you_win.hide()

func _process(delta):
	#moving the train front around
	$map/path_train_track_with_peanuts/path_follower_front.progress += train_move_speed * delta
	#making the next two carriages follow along by setting their path progress ratio slightly behind the front
	$map/path_train_track_with_peanuts/path_follower_mid.progress_ratio = $map/path_train_track_with_peanuts/path_follower_front.progress_ratio - carriage_mid_ratio_offset
	$map/path_train_track_with_peanuts/path_follower_rear.progress_ratio = $map/path_train_track_with_peanuts/path_follower_front.progress_ratio - carriage_rear_ratio_offset


func _on_sgnl_end_level():
	$Control/btn_continue.show()
	$Control/lbl_you_win.show()


func _on_btn_continue_pressed():
		get_tree().change_scene_to_file("res://scenes/menus/title_screen.tscn")
