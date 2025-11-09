class_name GrabbableItem
extends CollisionObject3D

var grabber: CollisionObject3D
var grabArea: Area3D

var is_being_grabbed := false
var can_be_grabbed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grabArea = $Area3D

func _physics_process(delta: float) -> void:
	check_if_player_is_in_area()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func check_if_player_is_in_area():
	var is_player_in_grab_area := false
	var i := 0
	for col_body in grabArea.get_overlapping_bodies():
		if(col_body.is_in_group("Player")):
			is_player_in_grab_area = true
			break
	
	can_be_grabbed = is_player_in_grab_area
