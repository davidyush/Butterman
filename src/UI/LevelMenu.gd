extends Control

var main_menu = "res://src/UI/MainMenu.tscn"

func _on_Button_pressed() -> void:
    get_tree().paused = false
    visible = false


func _on_Button2_pressed() -> void:
    get_tree().paused = false
    get_tree().change_scene(main_menu)


func _on_Button3_pressed() -> void:
    get_tree().reload_current_scene()
