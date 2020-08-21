extends Area2D


func _on_NoFrictionArea_body_entered(body: Node) -> void:
    if body.name == 'Player':
        body.set_friction(0.000)


func _on_NoFrictionArea_body_exited(body: Node) -> void:
    if body.name == 'Player':
        body.set_friction(0.15)
