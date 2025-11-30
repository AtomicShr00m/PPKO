extends Area2D

var type:String
onready var col = $Col
onready var sprite = $Sprite
onready var particleScn=preload("res://Objects/Deco/HitParticles.tscn")
signal popped

func _ready():
	sprite.texture=load("res://Sprites/Powerups/"+type+".png")
	sprite.scale=Vector2.ZERO
	var tween=create_tween()
	tween.tween_property(sprite,'scale',Vector2.ONE,0.5).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(col,"set_deferred",['disabled',false])

func pop():
	var particles=particleScn.instance()
	particles.position=position
	particles.spread=180
	get_parent().add_child(particles)
	emit_signal("popped")
	queue_free()

func close():
	col.set_deferred("disabled",true)
	var tween=create_tween()
	tween.tween_property(sprite,'scale',Vector2.ZERO,0.5).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(self,'queue_free')
