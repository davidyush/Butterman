extends StaticBody2D

export (float) var delay = 0.0

onready var animPlayer: = $AnimationPlayer

func _ready() -> void:
    yield(get_tree().create_timer(delay), "timeout")
    animPlayer.play("blink")
