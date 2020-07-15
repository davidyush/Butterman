extends StaticBody2D

onready var animPlayer = $AnimationPlayer

func _on_Area2D_body_entered(body: Node) -> void:
    animPlayer.play("vanish")
