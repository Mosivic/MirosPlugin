extends GPCActionMachine


func _init() -> void:
	_actions_setting = GPCActionsSetting.new({
		Idle = {
			_layer = 'animation',
			_priority = 6,
			_conditions = {has_dir_input = false},
		},
		Walk = {
			_layer = 'animation',
			_priority = 1,
			_conditions = {has_dir_input = true},
		},
		Attack = {
			layer = 'animation',
			_priority = 10,
			_conditions = {"attack_keydown_input" : true},
		},
		ClimbStair = {
			_layer = 'animation',
			_priority = 3,
			_conditions ={is_climb_stair = true}
		}
	})
