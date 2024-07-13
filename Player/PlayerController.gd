extends CharacterBody3D

# Variables
var move_speed: float = 5.0 # Speed of movement (time in seconds for each grid step)
var direction: Vector3 = Vector3.ZERO # Most recent direction input
var target_position: Vector3 # Target position for the character
var is_moving: bool = false # Check if currently moving
var move_timer: float = 0.0 # Timer to track movement intervals
var move_interval: float = 1.0 / move_speed # Interval between movements (derived from move_speed)
var grid_size: Vector3 = Vector3(1, 1, 1) # Size of the grid cells
var lastTile: Vector3 # The last tile the character was on
var nextTile: Vector3 # The next tile the character is moving to
@onready var area: Area3D = $Collision_Detection

# Called when the node enters the scene tree for the first time
func _ready():
	# Snap to the initial grid position
	global_transform.origin = global_transform.origin.snapped(grid_size)
	lastTile = global_transform.origin  # Replace with the actual path to your Area3D node
	
# Called every frame
func _process(delta):
	handle_input() # Handle player input
	update_movement(delta) # Update character movement

# Handle player input
func handle_input():
	var new_direction = Vector3() # Variable to store new direction input

	# Check for input actions and set the new direction
	if Input.is_action_pressed("move_up"):
		new_direction.z += 1
	if Input.is_action_pressed("move_down"):
		new_direction.z -= 1
	if Input.is_action_pressed("move_left"):
		new_direction.x += 1
	if Input.is_action_pressed("move_right"):
		new_direction.x -= 1

	# Normalize direction to ensure diagonal movement is not faster
	if new_direction != Vector3.ZERO:
		direction = new_direction
		print(direction)
		if area.is_movement_allowed(direction) and not is_moving:
			move_timer = 0.0 # Reset move timer
			is_moving = true # Set moving flag to true
			nextTile = (global_transform.origin + direction * grid_size).snapped(grid_size) # Calculate the next tile

# Update the movement
func update_movement(delta):
	if is_moving: 
		if move_timer >= move_interval:
			# Movement completed, update lastTile and stop moving
			lastTile = global_transform.origin.snapped(grid_size)
			direction = Vector3.ZERO
			is_moving = false
			return

		if move_timer >= move_interval or move_timer == 0:
			# Set the next tile at the start of a new movement interval
			if area.is_movement_allowed(direction):
				nextTile = (global_transform.origin + direction * grid_size).snapped(grid_size)
			
		# Calculate the inverse lerp factor
		var inverseLerp = inverse_lerp(0, move_interval, move_timer)
		
		# Interpolate between lastTile and nextTile based on the inverse lerp factor
		var new_position = lastTile.lerp(nextTile, inverseLerp)
		
		# Update the character's position
		global_transform.origin = new_position
		
		# Increment the move timer
		move_timer += delta

# Inverse lerp function to calculate the interpolation factor
func inverse_lerp(a: float, b: float, value: float) -> float:
	if a != b:
		return (value - a) / (b - a)
	else:
		return 0.0

