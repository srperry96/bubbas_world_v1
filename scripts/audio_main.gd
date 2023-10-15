extends AudioStreamPlayer

var snd_burp = load("res://assets/sounds/FX/burp.wav")
var snd_chewing = load("res://assets/sounds/FX/chewing.wav")
var snd_mmm = load("res://assets/sounds/FX/mmm.wav")
var snd_nomnomnom = load("res://assets/sounds/FX/nomnomnom.wav")
var snd_oowee = load("res://assets/sounds/FX/oooooweeethatspeng.wav")
var snd_munch = load("res://assets/sounds/FX/munch.wav")

var snds_peanut_collected = [snd_burp, snd_chewing, snd_mmm, snd_nomnomnom, snd_oowee]

var playing_munch := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_peanut_collected():
	#play the munching sound
	set_stream(snd_munch)
	play()
	playing_munch = true



func _on_finished():
	#playing a randomly selected sound after the munch sound has finished
	if playing_munch:
		playing_munch = false
		var idx = randi_range(0, snds_peanut_collected.size()-1)
		set_stream(snds_peanut_collected[idx])
		play()
