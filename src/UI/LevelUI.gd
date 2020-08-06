extends CanvasLayer

onready var label_timer := $Control/LabelTimer
onready var level_timer := $LevelTimer

var time_passed = 0.0

func _physics_process(delta: float) -> void:
    label_timer.text = "%.2f" % (time_passed + (1 - level_timer.time_left))


func _on_LevelTimer_timeout() -> void:
    time_passed += 1
