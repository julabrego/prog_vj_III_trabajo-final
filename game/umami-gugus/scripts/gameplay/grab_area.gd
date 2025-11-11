@tool
class_name GrabArea extends Area3D

var grabbing_item: Node3D
var items_in_area_not_being_grabbed: Array[Node3D]
var can_grab_item: bool

@onready var DEBUG_MESH_INSTANCE := $ToolAreaShape
var parent: Node3D

func _ready() -> void:
	if Engine.is_editor_hint():
		if(DEBUG_MESH_INSTANCE):
			DEBUG_MESH_INSTANCE.material_override = YELLOW_SEMITRANSPARENT_MATERIAL
			DEBUG_MESH_INSTANCE.visible = true
		return
	
	if(DEBUG_MESH_INSTANCE):
		DEBUG_MESH_INSTANCE.queue_free()
		
	parent = get_parent()
		
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if(grabbing_item and parent):
		self.lock_grabbed_item_to_front()
	else:
		self.check_if_grabbable_item_is_in_area()
	self.handle_grab_or_drop_item()

func check_if_grabbable_item_is_in_area():
	if not self.grabbing_item:
		var _grabbable_item_in_area: Node3D = null
		var _items_in_area_not_being_grabbed: Array[Node3D] = []
		var _can_grab: bool = false
		
		for overlapping_body in self.get_overlapping_bodies():
			if(overlapping_body.is_in_group(GRABBABLE_ITEM)):
				_grabbable_item_in_area = overlapping_body
				_items_in_area_not_being_grabbed.push_back(_grabbable_item_in_area)
				_can_grab = true
				break
		
		self.can_grab_item = _can_grab
		self.items_in_area_not_being_grabbed = _items_in_area_not_being_grabbed
		
func handle_grab_or_drop_item():
	if(Input.is_action_just_pressed("action_grab")):
		if(self.can_grab_item and not self.grabbing_item):
			var closest_item_distance: float = 100.0
			var closest_item: Node3D
			for item_to_grab in self.items_in_area_not_being_grabbed:
				var distance_to_item = parent.position.distance_to(item_to_grab.position)
				if(distance_to_item < closest_item_distance):
					closest_item = item_to_grab
					closest_item_distance = distance_to_item
				
				self.grab_item(closest_item)
		else:
			if(self.grabbing_item):
				self.drop_item()

func lock_grabbed_item_to_front() -> void:
	# Define how far in front of the character the item should be held
	var hold_distance: float = 1.2 
	
	# Get the character's global forward direction vector
	# In Godot 3D, the local -Z axis is typically "forward"
	var forward_direction: Vector3 = parent.global_transform.basis.z.normalized()
	
	# Calculate the target position: Character's position + (forward direction * distance)
	var target_position: Vector3 = parent.global_transform.origin + (forward_direction * hold_distance)
	
	# Set the grabbed item's global position
	grabbing_item.global_position = target_position
	
	# Optional: Keep the grabbed item oriented relative to the player (e.g., preventing it from rotating wildly)
	# grabbing_item.global_rotation = parent_character.global_rotation 

func grab_item(item_to_grab: Node3D) -> void:
	if not item_to_grab: return
	
	self.grabbing_item = item_to_grab
	self.can_grab_item = false
	
	set_item_layer_to_grabbed_collision_layer(item_to_grab, false)
	
	print("Grabbing item: ", grabbing_item.name)

func drop_item() -> void:
	if not grabbing_item: return

	set_item_layer_to_grabbed_collision_layer(grabbing_item, true)
	
	# Optional: Apply a small force when dropping
	if self.grabbing_item is RigidBody3D:
		var rb = self.grabbing_item
		var character_speed: Vector3 = parent.velocity
		rb.apply_central_impulse(character_speed * 2.0)
	
	self.grabbing_item = null
	self.can_grab_item = true

func set_item_layer_to_grabbed_collision_layer(item: Node3D, enable: bool) -> void:
	if grabbing_item is RigidBody3D:
		var rb: RigidBody3D = grabbing_item as RigidBody3D
		rb.freeze = not enable # Stops all physics forces/movement

	item.set_collision_layer_value(GRABBABLE_ITEM_COLLISION_LAYER, enable)
	item.set_collision_layer_value(GRABBED_ITEM_COLLISION_LAYER, not enable)
	
const GRABBABLE_ITEM = DomainTypes.NODE_GROUPS.GRABBABLE_ITEM
const GRABBABLE_ITEM_COLLISION_LAYER = DomainTypes.COLLISION_LAYERS.GRABBABLE_ITEM
const GRABBED_ITEM_COLLISION_LAYER = DomainTypes.COLLISION_LAYERS.GRABBED_ITEM
const YELLOW_SEMITRANSPARENT_MATERIAL = preload(DomainTypes.DEBUG_MATERIALS.YELLOW_SEMITRANSPARENT)
const TRANSPARENT_MATERIAL = preload(DomainTypes.DEBUG_MATERIALS.TRANSPARENT)
