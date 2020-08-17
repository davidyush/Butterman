extends Node2D

onready var tile_map_simple = $TileMap
onready var tile_map_grass = $TileMapGrass
onready var respoune: = $Respoune
onready var player: = $Player

const CELL_SIZE: = 16
var time_passed: = 0.0
var map_limits: Dictionary

var MainInstances = ResourceLoader.MainInstances

func _ready() -> void:
    VisualServer.set_default_clear_color(Color.darksalmon)
    get_tree().paused = false
    respoune.global_position = player.global_position
    if tile_map_grass:
        map_limits = get_lims(tile_map_grass)
    else:
        map_limits = get_lims(tile_map_simple)
    MainInstances.MainCamera.set_limits(map_limits)
    MainInstances.MainCamera.set_smoothing(true)


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
    if player.global_position.y > map_limits.bottom * 1.1:
        player.die(false)
    
