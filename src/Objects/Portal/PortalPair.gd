extends Node2D

onready var portal_1 = $Portal
onready var portal_2 = $Portal2

var portal_1_active: = true
var portal_2_active: = true

    
func set_portal_active(p1: bool, p2: bool) -> void:
    portal_1_active = p1
    portal_2_active = p2


func _on_Portal_body_entered(body: Node) -> void:
    if portal_1_active:
        body.global_position = portal_2.global_position
        set_portal_active(true, false)


func _on_Portal2_body_entered(body: Node) -> void:
    if portal_2_active:
        body.global_position = portal_1.global_position
        set_portal_active(false, true)

    
func _on_Portal_body_exited(body: Node) -> void:
    set_portal_active(true, true)


func _on_Portal2_body_exited(body: Node) -> void:
    set_portal_active(true, true)
