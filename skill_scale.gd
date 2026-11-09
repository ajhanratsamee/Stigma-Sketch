class_name SkillScale
extends RefCounted
## ตัวคูณขนาดสกิลทั้งเกม (ภาพและระยะโดนเท่ากัน) กล้องซูมใกล้ขึ้นแล้ว สกิลเล็กลงให้เห็นขอบเขตชัด
## ใช้กับสกิลทุกสาย ไม่ใช้กับคอมโบธรรมดา HYPER และ UI  โค้ดสกิลใหม่ให้คูณขนาดด้วย K

const K := 0.7

## ห่อ hitter ของเอฟเฟกต์ที่ถูกย่อ/ขยายด้วย scale ให้ระยะโดนเท่ากับภาพ (ย่อรอบจุดกำเนิดของโหนด)
static func wrap_hitter(node: Node2D) -> void:
	if not ("hitter" in node):
		return
	var inner = node.get("hitter")
	if not (inner is Callable) or not (inner as Callable).is_valid():
		return
	var h := Hitter.new()
	h.node = node
	h.inner = inner
	node.set_meta("skill_scale_hitter", h)
	node.set("hitter", Callable(h, "hit"))

class Hitter extends RefCounted:
	var node: Node2D
	var inner: Callable

	func hit(center: float, half: float, dmg: float, side: float, once = null, extra := {}, y_span := Vector2.ZERO) -> bool:
		if not is_instance_valid(node):
			return false
		var s := absf(node.scale.x)
		var c := node.position.x + (center - node.position.x) * s
		var ys := y_span
		if y_span != Vector2.ZERO:
			var oy := node.position.y
			ys = Vector2(oy + (y_span.x - oy) * s, oy + (y_span.y - oy) * s)
		return bool(inner.call(c, half * s, dmg, side, once, extra, ys))
