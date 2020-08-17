extends Area2D

export var next_scene: PackedScene

onready var end_timer = $EndTimer

var MainInstances = ResourceLoader.MainInstances

# warning-ignore:unused_argument
func _on_Toast_body_entered(body: Node) -> void:
    if body.name == 'Player':
        MainInstances.MainCamera.set_default_limits()
        MainInstances.MainCamera.set_smoothing(false)
        get_tree().paused = true
        var animPlayer = MainInstances.MainCamera.find_node('AnimationPlayer')
        animPlayer.play("zoom")
        yield(animPlayer, "animation_finished")
        end_timer.start()


func _on_EndTimer_timeout() -> void:
     if next_scene:
        get_tree().change_scene_to(next_scene)
