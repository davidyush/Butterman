extends KinematicBody2D

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 256
export (float) var FRICTION = 0.25
export (float) var GRAVITY = 200
export (int) var JUMP_FORCE = 128
export (int) var MAX_SLOPE_ANGLE = 46

var motion = Vector2.ZERO

func _physics_process(delta: float) -> void:
    var input_vector = get_input_vector()
    motion = apply_for_motion(input_vector, motion)
    motion = move_and_slide(motion, Vector2.UP)

func get_input_vector() -> Vector2:
    var input_vector = Vector2.ZERO
    input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    return input_vector


func apply_for_motion(input_vector: Vector2, motion: Vector2) -> Vector2:
    var horizontled = apply_horizontal_force(input_vector, motion)
    var frictioned = apply_friction(input_vector, horizontled)
    var jumped = apply_jump_check(frictioned)
    var gravitied = apply_gravity(jumped)
    return gravitied;


func apply_horizontal_force(input_vector: Vector2, motion: Vector2) -> Vector2:
    var applied_vector = motion
    if input_vector != Vector2.ZERO:
        applied_vector.x += input_vector.x * ACCELERATION * get_physics_process_delta_time()
        applied_vector.x = clamp(applied_vector.x, -MAX_SPEED, MAX_SPEED)
    return applied_vector


func apply_friction(input_vector: Vector2, motion: Vector2) -> Vector2:
    var applied_vector = motion
    if input_vector.x == 0:
        applied_vector.x  = lerp(applied_vector.x, 0, FRICTION)
    return applied_vector


func apply_jump_check(motion: Vector2) -> Vector2:
    var applied_vector = motion
    if is_on_floor():
        if Input.is_action_just_pressed("ui_up"):
            applied_vector.y = -JUMP_FORCE
    else:
        if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
            applied_vector.y = -JUMP_FORCE/2
    return applied_vector


func apply_gravity(motion: Vector2) -> Vector2:
    var applied_vector = motion
    #if not is_on_floor():
    applied_vector.y += GRAVITY * get_physics_process_delta_time()
    #prevent to fall too fast
    applied_vector.y = min(applied_vector.y, JUMP_FORCE)
    return applied_vector
