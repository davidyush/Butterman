extends StaticBody2D

onready var Knife = preload("res://src/Objects/Knife/Knife.tscn")

export (int) var KNIFE_SPEED = 200
export (float) var TIME_STRIKE = 1.2

onready var timer = $StrikeTimer
onready var knife_position = $Position2D

func _ready() -> void:
    timer.wait_time = TIME_STRIKE

func _on_StrikeTimer_timeout() -> void:
    var knife = Knife.instance()
    knife.set_speed(KNIFE_SPEED)
    knife_position.add_child(knife)
    
