extends GPCAction

var spine_sprite:SpineSprite
var animation_state:SpineAnimationState
var actor:CharacterBody2D

func init():
	actor = property_sensor.actor
	spine_sprite = actor.spine_sprite
	animation_state = spine_sprite.get_animation_state()

func t():
	return false

func enter():
	animation_state.set_animation("attack", true, 0)
	var track_entry = animation_state.get_current(0)
	track_entry.set_loop(false)


func perform_physics(delta) ->int:
	var is_animation_complete = animation_state.get_current(0).is_complete()
	
	if is_animation_complete:
		return STATE.ACTION_STATE.SUCCEED
	else:
		return STATE.ACTION_STATE.RUNNING
