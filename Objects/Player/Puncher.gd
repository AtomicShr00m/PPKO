extends KinematicBody2D

var health:=100.0
var atk_power:=10.0

const ACCEL=10.0
const SPEED=400.0
const FRICTION=7.0

var target:Node2D
var motion:Vector2
onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var punch_check = $PunchCheck

func hit(dmg,from):
	health-=dmg
	if health<=0:
		queue_free()
		get_tree().paused=true
	motion=from*400

func _physics_process(delta):
	var dir=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if is_instance_valid(target):
		if punch_check.overlaps_body(target):
			anim.play("Punch")
		sprite.look_at(target.position)
	elif dir!=Vector2.ZERO:
		sprite.rotation=dir.angle()
	if dir==Vector2.ZERO:
		motion=lerp(motion,Vector2.ZERO,FRICTION*delta)
	else:
		motion=lerp(motion,dir*SPEED,ACCEL*delta)
	motion=move_and_slide(motion)

func _on_HurtBox_body_entered(body):
	body.hit(atk_power,Vector2.RIGHT.rotated(sprite.rotation))
