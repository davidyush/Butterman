extends Camera2D

var MainInstances = ResourceLoader.MainInstances


func _ready() -> void:
    MainInstances.MainCamera = self
    
func queue_free() -> void:
    MainInstances.MainCamera = null
    .queue_free()    
