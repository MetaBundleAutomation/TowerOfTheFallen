extends Area3D

var detectionVector: Vector4 = Vector4.ZERO  # Initialize the vector to (0, 0, 0, 0)
var diagnalVector: Vector4 = Vector4.ZERO  

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the body_shape_entered signal to the _on_body_shape_entered function
	connect("body_shape_entered", _on_body_shape_entered)
	# Connect the body_shape_exited signal to the _on_body_shape_exited function
	connect("body_shape_exited", _on_body_shape_exited)

# Function to handle the body shape entered signal
func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	# Print the identity of the collider
	print("Collision entered with: ", local_shape_index)
	
	# Update the detection vector based on the local shape index
	update_detection_vector(local_shape_index, true)

# Function to handle the body shape exited signal
func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	# Print the identity of the collider
	print("Collision exited with: ", local_shape_index)
	
	# Update the detection vector based on the local shape index
	update_detection_vector(local_shape_index, false)

# Function to update the detection vector
func update_detection_vector(local_shape_index, entered):
	match local_shape_index:
		0:
			detectionVector.x = 1 if entered else 0
		1:
			detectionVector.y = 1 if entered else 0
		2:
			detectionVector.z = 1 if entered else 0
		3:
			detectionVector.w = 1 if entered else 0
		4:
			diagnalVector.x = 1 if entered else 0
		5:
			diagnalVector.y = 1 if entered else 0
		6:
			diagnalVector.z = 1 if entered else 0
		7:
			diagnalVector.w = 1 if entered else 0
				
		_:
			print("Unknown local shape index: ", local_shape_index)
	
	print("Updated detectionVector: ", diagnalVector)
	
# Function to check if movement in the given direction is allowed
func is_movement_allowed(direction: Vector3) -> bool:
	if direction == Vector3(1, 0, 0):  # Right
		return detectionVector.z == 0
	elif direction == Vector3(-1, 0, 0):  # Left
		return detectionVector.w == 0
	elif direction == Vector3(0, 0, 1):  # Forward
		return detectionVector.x == 0
	elif direction == Vector3(0, 0, -1):  # Backward
		return detectionVector.y == 0
	elif direction == Vector3(1, 0, 1):  # Forward-Left
		return diagnalVector.x == 0
	elif direction == Vector3(-1, 0, 1):  # Forward-Right
		return diagnalVector.y == 0
	elif direction == Vector3(-1, 0, -1):
		return diagnalVector.z == 0
	elif direction == Vector3(1, 0, -1):  # Backward-Left
		return diagnalVector.w == 0
	else:
		return false 
