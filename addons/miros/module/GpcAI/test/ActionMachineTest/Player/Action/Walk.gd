extends GPCAction

var spine_sprite:SpineSprite
var animation_state:SpineAnimationState
var actor:CharacterBody2D


func init():
	actor = property_sensor.actor
	spine_sprite = actor.spine_sprite
	animation_state = spine_sprite.get_animation_state()


func enter():
	animation_state.set_animation("run", true, 0)


func perform_physics(delta) ->int:
	actor.velocity = property_sensor.move_dir * property_sensor.move_speed
	spine_sprite.scale = Vector2(-1,1) if actor.velocity.x < 0 else Vector2(1,1)
	actor.move_and_slide()
	
	return STATE.ACTION_STATE.SUCCEED
