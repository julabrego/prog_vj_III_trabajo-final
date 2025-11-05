extends Node

@export var target: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_parent()

func _physics_process(delta: float) -> void:
	if target:
		for col_idx in target.get_slide_collision_count():
			var col := target.get_slide_collision(col_idx)
			if col.get_collider() is RigidBody3D:
				col.get_collider().apply_central_impulse(-col.get_normal() * 0.3)
				col.get_collider().apply_impulse(-col.get_normal() * 0.01, col.get_position())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
