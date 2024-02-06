extends CharacterBody2D

class_name Player

signal died

@onready var animator = $AnimationPlayer
@onready var cshape = $CollisionShape2D
@onready var sprite = $Sprite2D

var speed = 300.0

var accelerometer_speed = 130.0

var gravity = 15.0

var max_fall_velocity = 1000.0

var jump_velocity = -800.0

var viewport_size 

var use_accelerometer = false

var dead = false

var fall_anim_name = "fall"

var jump_anim_name = "jump"

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_size = get_viewport_rect().size
	
	var os_name = OS.get_name()
	
	if os_name == "Android" || os_name == "iOS":
		use_accelerometer = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if velocity.y > 0:
		if animator.current_animation != fall_anim_name:
			animator.play(fall_anim_name)
	elif velocity.y < 0:
		if animator.current_animation != jump_anim_name:
			animator.play(jump_anim_name)

func _physics_process(_delta):
	
	velocity.y += gravity
	
	if velocity.y > max_fall_velocity:
		velocity.y = max_fall_velocity
	
	if !dead:	
		if use_accelerometer:
			var mobile_input = Input.get_accelerometer()
			velocity.x = mobile_input.x * accelerometer_speed
		else:
			var direction = Input.get_axis("move_left", "move_right")
			if direction:
				velocity.x = direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
	
	var margin = 20
	
	if global_position.x > viewport_size.x + margin:
		global_position.x = -margin
		
	if global_position.x < -margin:
		global_position.x = viewport_size.x + margin
		
func jump():
	velocity.y = jump_velocity
	SoundFx.play("Jump")
	MyUtility.addLogMessage("Player jumped!")


func _on_visible_on_screen_notifier_2d_screen_exited():
	die()

func die():
	if !dead:
		dead = true
		cshape.set_deferred("disabled", true)
		died.emit()
		SoundFx.play("Fall")

func use_new_skin():
	fall_anim_name = "fall_red"
	jump_anim_name = "jump_red"
	if sprite:
		sprite.texture = preload("res://assets/textures/character/Skin2Idle.png")
