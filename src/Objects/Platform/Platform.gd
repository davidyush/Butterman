extends Node2D

onready var animPlayer := $AnimationPlayer

export (float) var delay = 0.0

func _ready() -> void:
    yield(get_tree().create_timer(delay), "timeout")
    animPlayer.play("init")
