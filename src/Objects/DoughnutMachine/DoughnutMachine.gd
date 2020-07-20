extends Node2D

func _on_DoughnutBig_body_entered(body: Node) -> void:
    if body.name == 'Player':
        body.die()
