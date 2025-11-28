extends KinematicBody2D

var health:=100.0
var atk_power:=10.0

const ACCEL=10.0
const SPEED=500.0
const FRICTION=7.0

const DASH_DIRS={"ui_left":Vector2.LEFT,"ui_right":Vector2.RIGHT,"ui_up":Vector2.UP,
"ui_down":Vector2.DOWN}
var dash_key:=''
var dash_time:=0.15
var is_dashing:=false
const DASH_SPEED=1000

var target:Node2D
var is_safe:=false
var dir:Vector2
var motion:Vector2
onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var punch_check = $PunchCheck
onready var health_bar = $HealthBar
onready var dash_key_timer = $DashKeyTimer

func hit(dmg,from):
	if !is_safe:
		health-=dmg
		if health<=0:
			queue_free()
			get_tree().paused=true
		else:
			is_safe=true
			motion=from*500
			health_bar.update_value(health)
			var tween=create_tween()
			tween.tween_property(sprite.material,"shader_param/fade",1.0,0.25)
			tween.tween_property(sprite.material,"shader_param/fade",0.0,0.25)
			yield(tween,"finished")
			is_safe=false

func handle_movement(delta):
	dir=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if dir==Vector2.ZERO:
		motion=lerp(motion,Vector2.ZERO,FRICTION*delta)
	else:
		motion=lerp(motion,dir*SPEED,ACCEL*delta)

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
				is_dashing=true
				var timer=create_tween().tween_interval(dash_time)
				yield(timer,"finished")
				is_dashing=false

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
		handle_dashing()
		
	motion=move_and_slide(motion)

func _on_HurtBox_body_entered(body):
	body.hit(atk_power,Vector2.RIGHT.rotated(sprite.rotation))
