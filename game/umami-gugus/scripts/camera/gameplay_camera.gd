extends Camera3D

@export var target_path: NodePath
@export var smoothness: float = 5.0

var target: Node3D
var camera_offset: Vector3

func _ready() -> void:
	# Get the target node from the exported NodePath
	if target_path:
		target = get_node(target_path)
		# Store the initial offset from target if it exists
		if target:
			camera_offset = global_position - target.global_position
	
	# Ensure we're using orthographic projection for isometric view
	projection = Camera3D.PROJECTION_ORTHOGONAL

func _physics_process(delta: float) -> void:
	if not target:
		return
	
	# Calculate desired position using the initial offset
	var desired_pos = target.global_position + camera_offset
	
	# Smoothly interpolate current position to desired position
	global_position = global_position.lerp(desired_pos, smoothness * delta)
