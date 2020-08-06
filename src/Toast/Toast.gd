extends Area2D

export var next_scene: PackedScene

onready var end_timer = $EndTimer

# warning-ignore:unused_argument
func _on_Toast_body_entered(body: Node) -> void:
    if body.name == 'Player':
        var parent_node = get_parent()
        var camera = parent_node.find_node('Camera')
        set_default_limits(camera)
        camera.smoothing_enabled = false
        get_tree().paused = true
        var animPlayer = camera.find_node('AnimationPlayer')
        animPlayer.play("zoom")
        yield(animPlayer, "animation_finished")
        end_timer.start()


func set_default_limits(camera: Camera2D):
    camera.limit_bottom = 9999
    camera.limit_top = -9999
    camera.limit_right = 9999
    camera.limit_left = -9999


func _on_EndTimer_timeout() -> void:
     if next_scene:
        get_tree().change_scene_to(next_scene)
