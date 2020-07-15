extends Area2D

# warning-ignore:unused_argument
func _on_Toast_body_entered(body: Node) -> void:
    var parent_node = get_parent()
    var camera = parent_node.find_node('Camera')
    camera.zoom = camera.zoom / 2
