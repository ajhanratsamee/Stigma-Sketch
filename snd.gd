class_name Snd
extends RefCounted
## ทางเรียกเสียงจากทุกที่ (ส่งต่อไปที่ autoload "Sfx")  ไม่มี autoload (เช่นเทสต์บางแบบ) ก็เงียบเฉยๆ ไม่ error

static func _node() -> Node:
	var ml := Engine.get_main_loop() as SceneTree
	if ml == null or ml.root == null:
		return null
	return ml.root.get_node_or_null("Sfx")

## เล่นเสียงสั้น  vol_db ปรับดังเบา  pitch สุ่มเพี้ยนเสียงเท่านี้ (0.05 = ±5%)
static func play(name: String, vol_db := 0.0, pitch := 0.0) -> void:
	var n := _node()
	if n != null:
		n.call("play", name, vol_db, pitch)

## เสียงตีโดน มีกันรัว
static func hit(heavy := false) -> void:
	var n := _node()
	if n != null:
		n.call("hit", heavy)

## สั่นเบาๆ (มิลลิวินาที) ตามค่าตั้ง มีกันรัว
static func buzz(ms := 20) -> void:
	var n := _node()
	if n != null:
		n.call("buzz", ms)

static func apply_volumes() -> void:
	var n := _node()
	if n != null:
		n.call("apply_volumes")
