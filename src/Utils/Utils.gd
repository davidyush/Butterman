extends Node

func instance_scene_on_main(scene, position, direction = Vector2.ZERO):
    var main = get_tree().current_scene
    var instance = scene.instance()
    if direction != Vector2.ZERO:
        instance.set_direction(direction)
    main.add_child(instance)
    instance.global_position = position
    return instance
