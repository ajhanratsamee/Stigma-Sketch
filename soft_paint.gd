class_name SoftPaint
extends RefCounted
## วาดรูปขอบฟุ้งโดยซ้อนรูปโปร่งหลายชั้น ใช้ทำฉากหลังเบลอ ไม่ต้องใช้เชเดอร์ จึงเบาบนมือถือ

const STEPS := 6

static func oval(c: CanvasItem, at: Vector2, rx: float, ry: float, color: Color, spread := 0.3) -> void:
	for i in STEPS:
		var k := 1.0 + spread * (1.0 - float(i) / float(STEPS - 1)) - spread * 0.5
		c.draw_colored_polygon(Sketch.oval(at, rx * k, ry * k, 28), Color(color, color.a / float(STEPS) * 1.6))

static func box(c: CanvasItem, area: Rect2, color: Color, spread := 14.0) -> void:
	for i in STEPS:
		var grow := spread * (1.0 - 2.0 * float(i) / float(STEPS - 1))
		c.draw_rect(area.grow(grow), Color(color, color.a / float(STEPS) * 1.6))

## รูปหลายเหลี่ยมขอบฟุ้ง ขยายออกจากจุดกึ่งกลาง
static func shape(c: CanvasItem, pts: PackedVector2Array, color: Color, spread := 0.1) -> void:
	var mid := Vector2.ZERO
	for p in pts:
		mid += p
	mid /= float(pts.size())
	for i in STEPS:
		var k := 1.0 + spread * (1.0 - 2.0 * float(i) / float(STEPS - 1))
		var grown := PackedVector2Array()
		for p in pts:
			grown.append(mid + (p - mid) * k)
		c.draw_colored_polygon(grown, Color(color, color.a / float(STEPS) * 1.6))
