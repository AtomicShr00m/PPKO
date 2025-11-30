extends Node2D

var current:String
onready var sprite = $"../Sprite"
onready var effect_timer = $EffectTimer
onready var punch_col = $"../PunchCheck/CollisionShape2D"
onready var health_bar = $"../HealthBar"
onready var fists = $"../Sprite/Fists"
const EFFECT_CODES={'weaken':Color.magenta,'freeze':Color.blue,'cuff':Color.green,
'daze':Color.aqua,'push':Color.yellow}

func receive_effect(type:String):
	if type=='' or type==current:
		return
	current=type
	modulate=EFFECT_CODES[current]
	match type:
		'weaken':
			health_bar.modulate.a=0.5
			get_parent().dmg_multiplier*=1.5
			effect_timer.start()
		'freeze':
			health_bar.scale=Vector2(0.5,0.5)
			get_parent().spd_multiplier/=2
			get_parent().can_dash=false
			effect_timer.start()
		'cuff':
			fists.hide()
			punch_col.set_deferred('disabled',true)
			effect_timer.start()
		'daze':
			sprite.flip_h=true
			get_parent().is_dazed=true
			effect_timer.start()
		'push':
			sprite.modulate.a=0.5
			get_parent().stm_multiplier=5.0
			effect_timer.start()

func end_effect():
	match current:
		'weaken':
			health_bar.modulate.a=1.0
			get_parent().dmg_multiplier/=1.5
		'freeze':
			health_bar.scale=Vector2.ONE
			get_parent().spd_multiplier*=2
			get_parent().can_dash=true
		'push':
			sprite.modulate.a=1.0
			get_parent().stm_multiplier=1.0
		'daze':
			sprite.flip_h=false
			get_parent().is_dazed=false
		'cuff':
			fists.show()
			punch_col.set_deferred('disabled',false)
	current=''

func _physics_process(_delta):
	update()

func _draw():
	if !effect_timer.is_stopped():
		var angle=(effect_timer.time_left / effect_timer.wait_time)
		draw_arc(Vector2.ZERO,40,0,angle*TAU,32,Color.white,4,true)
