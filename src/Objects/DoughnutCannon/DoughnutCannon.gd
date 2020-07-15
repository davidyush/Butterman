extends StaticBody2D

onready var Doughnut = preload("res://src/Objects/Doughnut/Doughnut.tscn")

export (int) var DOUGHNUT_SPEED = 200
export (float) var TIME_STRIKE = 1.2

onready var timer = $StrikeTimer
onready var doughnut_position = $Position2D

func _ready() -> void:
    timer.wait_time = TIME_STRIKE

func _on_StrikeTimer_timeout() -> void:
    var doughnut = Doughnut.instance()
    doughnut.set_speed(DOUGHNUT_SPEED)
    doughnut_position.add_child(doughnut)
