extends KinematicBody2D

onready var Doughnut = preload("res://src/Objects/Doughnut/Doughnut.tscn")

export (int) var DOUGHNUT_SPEED = 200
export (float) var TIME_STRIKE = 1.2
export (float) var denay = 0.0
export (Vector2) var DIRECTION = Vector2.DOWN

onready var timer = $StrikeTimer
onready var doughnut_position = $Position2D

func _ready() -> void:
    timer.wait_time = TIME_STRIKE
    yield(get_tree().create_timer(denay), "timeout")
    timer.start()

func _on_StrikeTimer_timeout() -> void:
    Utils.instance_scene_on_main(Doughnut, doughnut_position.global_position, DIRECTION)
    
