extends KinematicBody2D

export (int) var ACCELERATION = 100
export (int) var MAX_SPEED = 200
var motion = Vector2.ZERO

var MainInstances = ResourceLoader.MainInstances

onready var animPlayer := $AnimationPlayer

func _ready() -> void:
    set_physics_process(false)

func _physics_process(delta: float) -> void:
    var player = MainInstances.Player
    if player != null:
        chase_player(player, delta)

func chase_player(player, delta):
    var direction = (player.global_position - global_position).normalized()
    motion += direction * ACCELERATION * delta
    motion = motion.clamped(MAX_SPEED)
    motion = move_and_slide(motion)
    animPlayer.playback_speed = 3.5


func _on_VisibilityNotifier2D_screen_entered() -> void:
    set_physics_process(true)


func _on_Hitbox_body_entered(body: Node) -> void:
    if body.name == 'Player':
        body.die()
