extends Control

export (String, FILE, "*.tscn") var target_stage 

onready var play = $MainButtons/Play
onready var main_btns = $MainButtons
onready var choose_lvls = $ChooseLevelMenu
onready var btn_back = $ChooseLevelMenu/VBoxContainer/Row0/BackBtn
onready var first_lvl = $ChooseLevelMenu/VBoxContainer/Row1/Button

func _ready() -> void:
    VisualServer.set_default_clear_color(Color.black)
    play.grab_focus()

func _on_Play_pressed() -> void:
# warning-ignore:return_value_discarded
    get_tree().change_scene(target_stage)


func _on_Exit_pressed() -> void:
    get_tree().quit()


func _on_Choose_pressed() -> void:
    $MainButtons.visible = false
    $ChooseLevelMenu.visible = true
    first_lvl.grab_focus()


func _on_BackBtn_pressed() -> void:
    $MainButtons.visible = true
    $ChooseLevelMenu.visible = false
    play.grab_focus()
