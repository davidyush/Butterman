extends KinematicBody2D

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 256
export (float) var FRICTION = 0.25
export (float) var GRAVITY = 200
export (int) var JUMP_FORCE = 128
export (int) var MAX_SLOPE_ANGLE = 46

onready var cayote_timer = $CayoteTimer

var motion = Vector2.ZERO
var just_jumped = false


func _physics_process(delta: float) -> void:
    var input_vector = get_input_vector()
    apply_horizontal_force(input_vector, delta)
    apply_friction(input_vector)
    jump_check()
    apply_gravity(delta)
    move()

func get_input_vector():
    var input_vector = Vector2.ZERO
    input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    return input_vector
    
func apply_horizontal_force(input_vector, delta):
    if input_vector != Vector2.ZERO:
        motion.x += input_vector.x * delta * ACCELERATION
        motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
        
func apply_friction(input_vector):
    if input_vector.x == 0 and is_on_floor():
        motion.x  = lerp(motion.x, 0, FRICTION)

func jump_check():
    if is_on_floor() or cayote_timer.time_left > 0:
        if Input.is_action_just_pressed("ui_up"):
            motion.y = -JUMP_FORCE
    else:
        if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
            motion.y = -JUMP_FORCE/2

func apply_gravity(delta):
    if not is_on_floor():
        motion.y += GRAVITY * delta
        motion.y = min(motion.y, JUMP_FORCE)

func move():
    var was_on_air = not is_on_floor()
    var was_on_floor = is_on_floor()
    var last_motion = motion
    var last_position = position
    
    motion = move_and_slide(motion, Vector2.UP)
    
    #Landing
    if was_on_air and is_on_floor():
        motion.x = last_motion.x
        
    # Just left ground
    if was_on_floor and not is_on_floor() and not just_jumped:
        motion.y = 0
        position.y = last_position.y
        cayote_timer.start()
