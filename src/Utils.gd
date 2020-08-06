extends Node

func instance_scene_on_main(scene, position, direction):
    var main = get_tree().current_scene
    var instance = scene.instance()
    instance.set_direction(direction)
    main.add_child(instance)
    instance.global_position = position
    return instance
