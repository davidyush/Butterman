extends Area2D

var velocity: Vector2 = Vector2.ZERO

var current_speed: = 300

func set_speed(speed: int):
    current_speed = speed

func _physics_process(delta):
    var velocity: = Vector2(current_speed * delta, 0)
    translate(velocity)


func _on_Doughnut_body_entered(body: Node) -> void:
    queue_free()
