extends Area2D

var velocity: Vector2 = Vector2.ZERO

var current_speed: = 100

func set_speed(speed: int):
    current_speed = speed

func _physics_process(delta):
    velocity = Vector2(current_speed * delta, 0)
    translate(velocity)


func _on_Knife_body_entered(body: Node) -> void:
    if body.name == 'Player':
        body.die()
    queue_free()
