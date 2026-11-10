class_name IrisFx
extends RefCounted
## ทางเรียกวงกลมหดจากทุกที่ ถ้าไม่มี autoload "Iris" (เช่นตอนรันเทสต์) ก็เปลี่ยนหน้าตรงๆ ไม่ error

static func _node() -> Node:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null or tree.root == null:
		return null
	return tree.root.get_node_or_null("Iris")

## หดวงกลม เปลี่ยนหน้า แล้วขยายออก
static func go(path: String) -> void:
	var n := _node()
	if n != null:
		n.call("go", path)
	else:
		(Engine.get_main_loop() as SceneTree).change_scene_to_file(path)

## ปิดเอง 0 เปิดสุด 1 ปิดสุด
static func set_amount(k: float) -> void:
	var n := _node()
	if n != null:
		n.call("set_amount", k)

static func busy() -> bool:
	var n := _node()
	return n != null and bool(n.call("busy"))
