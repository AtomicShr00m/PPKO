extends Node

#HeartRegen(2),AtkSpd,Power(2),Shield,DefenceUp(2),DashAtk
var powers:=[]
onready var anim = $"../AnimationPlayer"
onready var dash_box = $"../DashBox"
onready var shield = $"../Shield"

func pick_power(type):
	powers.append(type)
	match type:
		'regen':
			get_parent().hp_regen=true
		'speed':
			anim.playback_speed=2.0
			get_parent().spd_multiplier=2.0
		'strength':
			get_parent().str_multiplier=1.5
		'shield':
			var tween=create_tween().set_loops()
			tween.tween_callback(shield,'set',["visible",true]).set_delay(1.0)
			tween.tween_callback(shield,'set',["visible",false]).set_delay(1.0)
		'defence':
			get_parent().dmg_multiplier=0.5
		'dash':
			get_parent().dash_time*=2
			dash_box.set_collision_mask_bit(1,true)
