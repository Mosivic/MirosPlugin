extends AudioStreamPlayer
class_name SoundManager

var sounds:Dictionary = {}
var sounds_list:Dictionary = {}

func add_sound(name:String,path:String):
	sounds[name] = path
	
func add_sound_list(name:String,sounds:Dictionary):
	sounds_list[name] = sounds
	
func play_sound(name:String):
	if sounds.has(name):
		stream = load(sounds[name])
		play()
	else:
		print("SoundManager:input name can't find in sounds")
