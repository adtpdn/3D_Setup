extends Node

@onready var ap = $bob_anim2/AnimationPlayer
@onready var root_ap = $AnimationPlayer
@onready var asp = $AnimatedSprite3D

func _ready():
	ap.play("Running")
	root_ap.play("new_animation")
	asp.play("default")
