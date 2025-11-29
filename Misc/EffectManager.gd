extends Node2D

var current:String
onready var sprite = $"../Sprite"
onready var effect_timer = $EffectTimer
onready var punch_col = $"../PunchCheck/CollisionShape2D"

func receive_effect(type:String):
	if type=='' or type==current:
		return
	current=type
	match type:
		'weaken':
			get_parent().dmg_multiplier=2.0
			effect_timer.start()
		'freeze':
			get_parent().spd_multiplier=0.5
			effect_timer.start()
		'cuff':
			punch_col.set_deferred('disabled',true)
			effect_timer.start()
		'stopDash':
			get_parent().can_dash=false
			effect_timer.start()
		'push':
			get_parent().stm_multiplier=5.0
			effect_timer.start()

func end_effect():
	match current:
		'weaken':
			get_parent().dmg_multiplier=1.0
		'freeze':
			get_parent().spd_multiplier=1.0
		'push':
			get_parent().stm_multiplier=1.0
		'stopDash':
			get_parent().can_dash=true
		'cuff':
			punch_col.set_deferred('disabled',false)
	current=''

func _physics_process(_delta):
	update()

func _draw():
	if !effect_timer.is_stopped():
		var angle=(effect_timer.time_left / effect_timer.wait_time)
		draw_arc(Vector2.ZERO,40,0,angle*TAU,32,Color.white,4,true)
