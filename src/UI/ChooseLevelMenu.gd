extends Control

onready var first_btn = $VBoxContainer/Row1/Button

func _ready() -> void:
    first_btn.grab_focus()

