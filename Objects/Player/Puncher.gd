extends KinematicBody2D

signal popped
signal just_hit

var can_dash:=true
var is_dazed:=false
var hp_regen:=false
var health:=100.0
var atk_power:=7.5
var str_multiplier:=1.0
var dmg_multiplier:=1.0
var spd_multiplier:=1.0
var stm_multiplier:=1.0

const ACCEL=5.0
const SPEED=500.0
const FRICTION=3.0
const DASH_SPEED=1000
const DASH_DIRS={"ui_left":Vector2.LEFT,"ui_right":Vector2.RIGHT,"ui_up":Vector2.UP,"ui_down":Vector2.DOWN}
var dir:Vector2
var motion:Vector2

var dash_key:=''
var dash_time:=0.15
var is_dashing:=false

var target:Node2D
var is_safe:=false

onready var anim := $AnimationPlayer
onready var trail := $Trail
onready var shield := $Shield
onready var sprite := $Sprite
onready var dash_box := $DashBox
onready var dash_col := $DashBox/CollisionShape2D
onready var health_bar := $HealthBar
onready var punch_check := $PunchCheck
onready var dash_key_timer := $DashKeyTimer
onready var effect_manager := $EffectManager
onready var powerup_manager := $PowerupManager

func pop():
	emit_signal("popped")
	queue_free()

func _ready():
	trail.enabled=false

func hit(dmg,from,effect:String):
	if !is_safe:
		AudioManager.play_sound("Hit")
		health-=dmg*dmg_multiplier*int(!shield.visible)
		emit_signal("just_hit")
		if health<=0:
			pop()
		else:
			is_safe=true
			if !is_dashing and !trail.enabled:
				motion=from*1000*stm_multiplier*int(!shield.visible)
			var tween=create_tween()
			tween.tween_property(sprite.material,"shader_param/fade",1.0,0.1)
			tween.tween_property(sprite.material,"shader_param/fade",0.0,0.1)
			yield(tween,"finished")
			is_safe=false
		if !shield.visible:
			effect_manager.receive_effect(effect)

func handle_movement(delta):
	dir=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if is_dazed:
		dir*=-1
	if dir==Vector2.ZERO:
		motion=lerp(motion,Vector2.ZERO,FRICTION*delta)
	else:
		motion=lerp(motion,dir*SPEED*spd_multiplier,ACCEL*delta)

func handle_dashing():
	for key in DASH_DIRS:
		if Input.is_action_just_pressed(key):
			if dash_key_timer.is_stopped():
				dash_key=key
				dash_key_timer.start()
			elif dash_key==key:
				dash_key_timer.stop()
				dash_key=''
				motion=DASH_DIRS[key]*DASH_SPEED
				trail.enabled=true
				is_dashing=true
				health_bar.scale=Vector2(0.5,0.5)
				AudioManager.play_sound("Dash")
				dash_col.set_deferred("disabled",false)
				var timer=create_tween().tween_interval(dash_time)
				yield(timer,"finished")
				is_dashing=false
				yield(create_tween().tween_property(trail,"length",0,0.25),"finished")
				dash_col.set_deferred("disabled",true)
				trail.enabled=false
				health_bar.scale=Vector2.ONE
				trail.clear_points()
				trail.length=32

func handle_aiming():
	if is_instance_valid(target):
		if punch_check.overlaps_body(target):
			anim.play("Punch")
		sprite.look_at(target.position)
	elif dir!=Vector2.ZERO:
		sprite.rotation=dir.angle()

func _physics_process(delta):
	if !is_dashing:
		handle_movement(delta)
		handle_aiming()
		if !trail.enabled and can_dash:
			handle_dashing()
		if motion.length()<10 and hp_regen and health<100:
			health=move_toward(health,100.0,2.5*delta)
	motion=move_and_slide(motion)

func _on_HurtBox_body_entered(body):
	var aim:=Vector2.RIGHT.rotated(sprite.rotation)
	body.hit(atk_power*str_multiplier,aim)
	motion=-aim*SPEED*2*stm_multiplier

func _on_DashBox_area_entered(area):
	AudioManager.play_sound("Powerup")
	powerup_manager.pick_power(area.type)
	area.pop()

func _on_DashBox_body_entered(body):
	var aim:=Vector2.RIGHT.rotated(sprite.rotation)
	body.hit(atk_power*str_multiplier*1.5,aim*2)
	motion=-aim*SPEED*stm_multiplier
