extends GPCAction

var spine_sprite:SpineSprite
var animation_state:SpineAnimationState
var actor:CharacterBody2D

func init():
	actor = property_sensor.actor
	spine_sprite = actor.spine_sprite
	animation_state = spine_sprite.get_animation_state()


func enter():
	animation_state.set_animation("idle", true, 0)


