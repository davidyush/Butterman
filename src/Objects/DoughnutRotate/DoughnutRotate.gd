extends Area2D

func _on_DoughnutRotate_body_entered(body: Node) -> void:
    body.die()
