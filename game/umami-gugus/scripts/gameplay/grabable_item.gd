class_name GrabbableItem
extends CollisionObject3D

var raycast: RayCast3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raycast = $RayCast3D

func _physics_process(delta: float) -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
