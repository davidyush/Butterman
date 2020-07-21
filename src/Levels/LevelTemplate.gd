extends Node2D

onready var tile_map: = $TileMap
onready var camera: = $Camera
onready var respoune: = $Respoune
onready var player: = $Player 
const CELL_SIZE: = 16

var map_limits: Dictionary

func _ready() -> void:
    get_tree().paused = false
    respoune.global_position = player.global_position
    map_limits = get_lims(tile_map)
    camera.limit_bottom = map_limits.bottom
    camera.limit_left = map_limits.left
    camera.limit_right = map_limits.right
    camera.limit_top = map_limits.top
    camera.smoothing_enabled = true
    

func get_lims(tile_map_node: TileMap) -> Dictionary:
    var tile_rect = tile_map_node.get_used_rect()
    var tile_size = tile_rect.size * CELL_SIZE
    var tile_positon = tile_rect.position * CELL_SIZE
    return {
        'top': tile_positon.y,
        'left': tile_positon.x,
        'bottom': tile_size.y,
        'right': tile_size.x
       }

func _physics_process(delta: float) -> void:
    if player.global_position.y > map_limits.bottom * 1.5:
        player.die()
