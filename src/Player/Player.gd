extends KinematicBody2D

onready var PlayerExplosion = preload("res://src/Player/PlayerExplosion.tscn")

var MainInstances = ResourceLoader.MainInstances

const JumpEffect = preload("res://src/Player/JumpEffect.tscn")
const DustEffect = preload("res://src/Player/DustEffect.tscn")

#todo -> full refactor with pure functions
#pomoyka
export (int) var ACCELERATION = 1500
export (int) var MAX_SPEED = 350
export (float) var FRICTION = 0.15
export (int) var GRAVITY = 1000
export (int) var WALL_SLIDE_SPEED = 150
export (int) var MAX_WALL_SLIDE_SPEED = 250
export (int) var JUMP_FORCE = 500
export (int) var MAX_SLOPE_ANGLE = 50
export (int) var PHYS_PUSH = 100

enum {
    MOVE,
    WALL_SLIDE
}

var state = MOVE
var motion = Vector2.ZERO
var snap_vector = Vector2.ZERO
var just_jumped = false
var can_control = true

onready var label = $Label
onready var sprite = $Sprite
onready var ray_cast_left = $RayCastLeft
onready var ray_cast_right = $RayCastRight
onready var cayote_timer = $CayoteTimer
onready var anim_player = $AnimationPlayer

func set_friction(value: float) -> void:
    FRICTION = value

func set_gravity(value: int) -> void:
    GRAVITY = value


func _ready() -> void:
    MainInstances.Player = self
    
func queue_free() -> void:
    MainInstances.Player = null
    .queue_free()


func _physics_process(delta: float) -> void:
    just_jumped = false
    
    if can_control:
        apply_speed_up()
        var wall_ax = get_wall_axis()
        if not is_on_floor() and (wall_ax == 1 or wall_ax == -1):
            state = WALL_SLIDE
        if not is_on_floor() and (check_valid_wall(ray_cast_left) or check_valid_wall(ray_cast_right)):
            state = WALL_SLIDE 
        match state:
            MOVE:
                label.text = 'M'
                var input_vector = get_input_vector()
                apply_horizontal_force(input_vector, delta)
                apply_friction(input_vector)
                update_snap_vector()
                jump_check()
                apply_gravity(delta)
                update_animation(input_vector)
                move()
                wall_slide_check()
                
            WALL_SLIDE:
                label.text = 'W'
                createDustEffect()
                var wall_axis = get_wall_axis()
                if wall_axis != 0:
                    sprite.scale.x = wall_axis
                wall_slide_jump_check(wall_axis)
                wall_slide_drop(delta)
                move()
                wall_detach(delta, wall_axis)

func apply_speed_up():
    if Input.is_action_pressed("speed_up"):
        if is_on_floor():
            MAX_SPEED = 450
        else:
            MAX_SPEED = 500
    if Input.is_action_just_released("speed_up"):
        MAX_SPEED = 350
    

func get_input_vector():
    var input_vector = Vector2.ZERO
    input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    var current_sign = sign(input_vector.x)
    if current_sign != 0:
        sprite.scale.x = current_sign * -1
    if input_vector.x != 0 and (is_on_floor() or is_on_wall()):
        if MAX_SPEED > 350:
            createDustEffect()
            createDustEffect()
        else:
            createDustEffect()
    return input_vector
    
func apply_horizontal_force(input_vector, delta):
    if input_vector.x != 0:
        motion.x += input_vector.x * ACCELERATION * delta
        motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
        
func apply_friction(input_vector):
    if input_vector.x == 0 and is_on_floor():
        motion.x = lerp(motion.x, 0, FRICTION)

func update_snap_vector():
    if is_on_floor():
        snap_vector = Vector2.DOWN
        
func jump_check():
    if is_on_floor() or cayote_timer.time_left > 0:
        if Input.is_action_just_pressed("jump") or Input.is_joy_button_pressed(0, JOY_XBOX_A):
            jump(JUMP_FORCE)
            just_jumped = true
    else:
        if (Input.is_action_just_released("jump") or Input.is_joy_button_pressed(0, JOY_XBOX_A)) and motion.y < 0:
            motion.y = 0.0
            
func jump(force):
    Utils.instance_scene_on_main(JumpEffect, global_position)
    motion.y = -force
    snap_vector = Vector2.ZERO
    

func apply_gravity(delta):
    if not is_on_floor():
        motion.y += GRAVITY * delta
        motion.y = min(motion.y, JUMP_FORCE)


func update_animation(input_vec):
    if input_vec.x != 0:
        anim_player.play("go")
        if input_vec.x > 0:
            sprite.rotation_degrees = 1 if MAX_SPEED == 250 else 2
        else:
            sprite.rotation_degrees = -1 if MAX_SPEED == 250 else -2
    else:
        anim_player.play("init")
        sprite.rotation_degrees = 0
    
    if not is_on_floor():
        if motion.y < 0:
            anim_player.play("jump_up")
        else:
            anim_player.play("jump_down")
        if input_vec.x > 0:
            sprite.rotation_degrees = 2 if MAX_SPEED == 250 else 3
        elif input_vec.x < 0:
            sprite.rotation_degrees = -2 if MAX_SPEED == 250 else -3
        else:
            sprite.rotation_degrees = 0

func move():
    var was_on_air = not is_on_floor()
    var was_on_floor = is_on_floor()
    var last_motion = motion
    var last_position = position
    
    motion = move_and_slide_with_snap(motion, snap_vector * 4, Vector2.UP, true, 4, deg2rad(MAX_SLOPE_ANGLE), false)
    
    for index in get_slide_count():
        var collision = get_slide_collision(index)
        if collision.collider.is_in_group("bodies"):
            collision.collider.apply_central_impulse(-collision.normal * PHYS_PUSH)
    
    #Landing
    if was_on_air and is_on_floor():
        motion.x = last_motion.x
        Utils.instance_scene_on_main(JumpEffect, global_position)
    
    # Just left ground
    if was_on_floor and not is_on_floor() and not just_jumped:
        motion.y = 0
        position.y = last_position.y
        cayote_timer.start()
        
    #Prevent 
    if is_on_floor() and get_floor_velocity().length() == 0 and abs(motion.x) < 1:
        position.x = last_position.x
        
func createDustEffect() -> void:
    var dust_position = global_position
    #if is_on_wall():
    #    dust_position.x += rand_range(40, -40)
    #else:
    #    dust_position.x += rand_range(4, -4)
    Utils.instance_scene_on_main(DustEffect, dust_position)



func wall_slide_check() -> void:
    if not is_on_floor() and is_on_wall():
        state = WALL_SLIDE
        createDustEffect()

func get_wall_axis() -> int:
    var is_right_wall = test_move(transform, Vector2.RIGHT)
    var is_left_wall = test_move(transform, Vector2.LEFT)
    return int(is_left_wall) - int(is_right_wall)
    
#i think here can be rid of some lines
#todo -> refactor
func wall_slide_jump_check(wall_axis):
    #here should be wall jump
    # IDIA
    # when wall is on left then
    # 1. shift + jump + move_right = large jump from the wall on the right direction
    # 2. jump + move_left + [shift] = small jump to wall
    #wall_axis = 1 wall is left
    #wall_axis = -1 walls is right
    if Input.is_action_just_pressed("jump") or Input.is_joy_button_pressed(0, JOY_XBOX_A):
        var left_dir = wall_axis > 0 and Input.is_action_pressed("move_left")
        var right_dir = wall_axis < 0 and Input.is_action_pressed("move_right")
        var left_wall_jump = wall_axis > 0 and Input.is_action_pressed("move_right")
        var right_wall_jump = wall_axis < 0 and Input.is_action_pressed("move_left")
        if left_dir or right_dir:
            motion.x = wall_axis * MAX_SPEED/1.2
            motion.y = -JUMP_FORCE * 1.1
            state = MOVE
        elif left_wall_jump or right_wall_jump:
            print('here')
            motion.x = wall_axis * MAX_SPEED * 2
            motion.y = -JUMP_FORCE
            state = MOVE
        else:
            motion.x = wall_axis * MAX_SPEED
            motion.y = -JUMP_FORCE
            state = MOVE
    
func wall_slide_drop(delta):
    var max_slide_speed = WALL_SLIDE_SPEED
    if Input.is_action_pressed("down"):
        max_slide_speed = JUMP_FORCE
    motion.y = min(motion.y + GRAVITY * delta, max_slide_speed)

func wall_detach(delta, wall_axis):
    if Input.is_action_just_pressed("move_right"):
        motion.x = ACCELERATION * delta
        state = MOVE
        
    if Input.is_action_just_pressed("move_left"):
        motion.x = -ACCELERATION * delta
        state = MOVE
        
    if wall_axis == 0 or is_on_floor():
        state = MOVE

func check_valid_wall(wall_raycast):
    if wall_raycast.is_colliding():
        var dot = acos(Vector2.UP.dot(wall_raycast.get_collision_normal()))
        if dot > PI * 0.35 && dot < PI * 0.55:
            return true
    return false


#this method is looks like shit
func die(with_explosion: bool = true) -> void:
    print('player is dead')
    var player_exlosion = PlayerExplosion.instance()
    sprite.visible = false
    can_control = false
    motion = Vector2.ZERO
    if MainInstances.MainCamera != null:
        MainInstances.MainCamera.set_smoothing_speed(0)
    if with_explosion:
        add_child(player_exlosion)
        yield(player_exlosion,"tree_exited")
    var parent = get_parent()
    var respoune = parent.get_node("Respoune")
    global_position = respoune.global_position
    sprite.visible = true
    can_control = true
    MainInstances.MainCamera.set_smoothing_speed(5)
    if MainInstances.UI != null:
        MainInstances.UI.reset_timer()
