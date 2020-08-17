extends Camera2D

var MainInstances = ResourceLoader.MainInstances


func _ready() -> void:
    MainInstances.MainCamera = self
    
    
func queue_free() -> void:
    MainInstances.MainCamera = null
    .queue_free()    


func set_smoothing_speed(val: int) -> bool:
    smoothing_speed = val
    return true


func set_limits(limits: Dictionary) -> bool:
    limit_bottom = limits.bottom
    limit_left = limits.left
    limit_right = limits.right
    limit_top = limits.top
    return true


func set_smoothing(val: bool) -> bool:
    smoothing_enabled = val
    return true


func set_default_limits() -> void:
    limit_bottom = 9999
    limit_top = -9999
    limit_right = 9999
    limit_left = -9999

