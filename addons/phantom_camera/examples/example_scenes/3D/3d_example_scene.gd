extends Node3D

@onready var ap = $AnimationPlayer

func _ready():
	ap.play("new_animation")
