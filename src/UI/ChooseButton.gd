extends Button

export (String, FILE, "*.tscn") var target_level 

func _on_Button_pressed() -> void:
    get_tree().change_scene(target_level)
