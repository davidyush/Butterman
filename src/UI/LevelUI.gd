extends CanvasLayer

export (String) var level_name := 'Level name'

var MainInstances = ResourceLoader.MainInstances

onready var label_timer := $Control/LabelTimer
onready var level_timer := $LevelTimer
onready var label_name := $Control/LabelName

var time_passed = 0.0

func _ready() -> void:
    MainInstances.UI = self
    label_name.text = level_name

func reset_timer() -> void:
    time_passed = 0.0
    level_timer.stop()
    level_timer.start()
    
func _physics_process(delta: float) -> void:
    label_timer.text = "%.2f" % (time_passed + (1 - level_timer.time_left))


func _on_LevelTimer_timeout() -> void:
    time_passed += 1

func queue_free() -> void:
    MainInstances.UI = null
    .queue_free()
