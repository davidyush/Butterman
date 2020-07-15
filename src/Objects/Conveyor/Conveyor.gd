extends StaticBody2D

export var speed = 100
export var cells = 16

const cell_width = 32

onready var sprite = $Sprite
onready var collider = $CollisionShape2D

func _ready():
    constant_linear_velocity.x = speed
    #var width = cells * cell_width
    #sprite.texture.region.size.x = width
    #collider.shape.extents.x = width/4
    
func _process(delta):
    sprite.texture.region.position.x -= speed * delta
