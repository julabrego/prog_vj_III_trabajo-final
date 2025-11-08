@tool
class_name GrabArea
extends Area3D

var grabbing_item: Node3D
var items_in_area_not_being_grabbed: Array[Node3D]
var can_grab_item: bool

const YELLOW_SEMITRANSPARENT_MATERIAL = preload(DomainTypes.DEBUG_MATERIALS.YELLOW_SEMITRANSPARENT)
const TRANSPARENT_MATERIAL = preload(DomainTypes.DEBUG_MATERIALS.TRANSPARENT)

func _ready() -> void:
	if Engine.is_editor_hint():
		$MeshInstance3D.material_override = YELLOW_SEMITRANSPARENT_MATERIAL
		$MeshInstance3D.visible = true
		
	else:
		$MeshInstance3D.queue_free()
		
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	self.check_if_grabbable_item_is_in_area()

func check_if_grabbable_item_is_in_area():
	if not self.grabbing_item:
		var _grabbable_item_in_area: Node3D = null
		var _items_in_area_not_being_grabbed: Array[Node3D] = []
		var _can_grab: bool = false
		var i: int = 0
		
		for overlapping_body in self.get_overlapping_bodies():
			if(overlapping_body.is_in_group(GRABBABLE_ITEM)):
				_grabbable_item_in_area = overlapping_body
				_items_in_area_not_being_grabbed.push_back(_grabbable_item_in_area)
				_can_grab = true
				break
		
		self.can_grab_item = _can_grab
		self.items_in_area_not_being_grabbed = _items_in_area_not_being_grabbed
	
	print(self.items_in_area_not_being_grabbed, self.can_grab_item)
	

const GRABBABLE_ITEM = DomainTypes.NODE_GROUPS.GRABBABLE_ITEM
