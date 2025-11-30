extends Area2D

signal popped

var type:String
onready var col = $Col
onready var label = $Label
onready var sprite = $Sprite
onready var particleScn = preload("res://Objects/Deco/HitParticles.tscn")

const HELP={
	'dash':'Dash into your target to deal 50% extra damage.',
	'regen':'Stand still to slowly regain health.',
	'shield':'Activates a shield that nullifies all attacks but only for 1 second.',
	'defence':"Halves the damage from enemies' attack.",
	'strength':"Increases your attack power by 50%.",
	'speed':"Doubles your punch speed and increases movement speed by 50%."
}

func _ready():
	label.text=HELP[type]
	sprite.texture=load("res://Sprites/Powerups/"+type+".png")
	sprite.scale=Vector2.ZERO
	label.modulate.a=0
	var tween=create_tween()
	tween.tween_property(sprite,'scale',Vector2.ONE,0.5).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(label,"modulate:a",1.0,0.5)
	tween.tween_callback(col,"set_deferred",['disabled',false])

func pop():
	var particles=particleScn.instance()
	particles.position=position
	particles.spread=180
	get_parent().add_child(particles)
	emit_signal("popped",type)
	queue_free()

func close():
	col.set_deferred("disabled",true)
	var tween=create_tween()
	tween.tween_property(sprite,'scale',Vector2.ZERO,0.5).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(label,"modulate:a",0.0,0.5)
	tween.tween_callback(self,'queue_free')
