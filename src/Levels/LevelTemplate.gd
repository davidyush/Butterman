extends Node2D

onready var tile_map = $TileMap
onready var camera = $Camera

const CELL_SIZE = 16

func _ready() -> void:
    var all_cells = tile_map.get_used_cells()
    var limits = get_limits(all_cells)
    camera.limit_bottom = limits.bottom
    camera.limit_left = limits.left
    camera.limit_right = limits.right
    camera.limit_top = limits.top
    

func get_limits(arr: Array) -> Dictionary:
    var bottom = 0
    var right = 0
    var top = 9999
    var left = 9999
    for val in arr:
        if val.y > bottom:
            bottom = val.y
        if val.y < top:
            top = val.y
        if val.x > right:
            right = val.x
        if val.x < left:
            left = val.x
    return {
        'top': top * CELL_SIZE,
        'bottom': bottom * CELL_SIZE + CELL_SIZE,
        'left': left * CELL_SIZE,
        'right': right * CELL_SIZE + CELL_SIZE
    }
