extends Control

export (String, FILE, "*.tscn") var target_stage 

func _ready() -> void:
    VisualServer.set_default_clear_color(Color.black)


func _on_Play_pressed() -> void:
# warning-ignore:return_value_discarded
    get_tree().change_scene(target_stage)


func _on_Exit_pressed() -> void:
    get_tree().quit()
