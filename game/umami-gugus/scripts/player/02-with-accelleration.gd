extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

@export var acceleration = 5
@export var deceleration = 4

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO

	# If some direction input is pressed, its corresponding direction axis 
	# will be 1 or -1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_backwards"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	# The speed has to be normalized so if the player moves in two directions
	# at the same time, the speed wont be faster than desired
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# Using only the horizontal velocity, interpolate towards the input.
	var horizontal_velocity = velocity
	horizontal_velocity.y = 0

	# Calculate the target's speed
	var target = direction * speed
	
	# The dot product (direction.dot(hvel)) checks if the object is already 
	# moving in the same direction as the input.
	
	# Choose if accelerates or decelerates
	var accel
	if direction.dot(horizontal_velocity) > 0:
		accel = acceleration
	else:
		accel = deceleration

	# Uses linear interpolation (lerp) to smoothly transition hvel towards target velocity.
	# The interpolation factor is acceleration * delta, ensuring a gradual change over time.
	horizontal_velocity = horizontal_velocity.lerp(target, accel * delta)
	
	# Ground Velocity
	target_velocity.x = horizontal_velocity.x
	target_velocity.z = horizontal_velocity.z

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
