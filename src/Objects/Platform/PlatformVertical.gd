extends Node2D

onready var anim_player = $AnimationPlayer

export (float) var delay = 0.0

func _ready() -> void:
    yield(get_tree().create_timer(delay), "timeout")
    anim_player.play("init")
