class_name CatAuraSlash
extends Node2D
## GRAND KNIGHT 50.2 ออร่าดาบยักษ์สีแดงอ่อนฟาดเป็นครึ่งวงกลม เริ่มจากพื้นด้านหลังข้ามหัวไปถึงพื้นด้านหน้า
## รัศมีราวครึ่งจอ จึงกินพื้นที่ 1 จอ ทิ้งรอยโค้งจางๆ ตามหลัง วางที่ตำแหน่งตัวละครบนพื้น y 0

const SWEEP := 0.38
const LIFE := 0.9
const DMG := 70.0
const BODY := Color(1.0, 0.35, 0.32, 0.5)
const EDGE := Color(1.0, 0.92, 0.9)

var dir := 1.0
var radius := 1400.0
var hitter: Callable
var _t := 0.0
var _hit := {}

## มุมใบดาบตอนนี้ 0 คือชี้ไปข้างหลังตามพื้น PI คือชี้ไปข้างหน้าตามพื้น
func _angle() -> float:
	var k := clampf(_t / SWEEP, 0.0, 1.0)
	return PI * (1.0 - pow(1.0 - k, 2.5))

func _point(a: float, r: float) -> Vector2:
	return Vector2(-dir * cos(a) * r, -sin(a) * r)

func _process(delta: float) -> void:
	_t += delta
	if _t >= LIFE:
		queue_free()
		return
	if hitter.is_valid() and _t >= SWEEP * 0.5 and _t < SWEEP + 0.1:
		hitter.call(position.x, radius, DMG, dir, _hit, {"kb": 3.0, "stun": 0.8})
	queue_redraw()

func _draw() -> void:
	var a := _angle()
	var fade := clampf((LIFE - _t) / 0.4, 0.0, 1.0)
	# พื้นเรืองแดงใต้วงฟาด และลำแสงพุ่งจากจุดหมุน
	CatGlow.glow_oval(self, Vector2.ZERO, radius * 1.05, radius * 0.12, Color(1.0, 0.45, 0.45, 0.6 * fade))
	CatGlow.rays(self, Vector2(0.0, -20.0), 60.0, radius * 0.55 * CatGlow.pop(_t, 0.25), 10, Color(1.0, 0.85, 0.8, 0.22 * fade), _t * 0.8)
	# รอยโค้งที่ฟาดผ่าน จางลงตามระยะจากใบดาบ
	var steps := 28
	for n in (steps if a > 0.01 else 0):
		var a0 := a * float(n) / float(steps)
		var a1 := a * float(n + 1) / float(steps)
		var k := float(n + 1) / float(steps)
		var band := PackedVector2Array([_point(a0, radius * 0.25), _point(a0, radius), _point(a1, radius), _point(a1, radius * 0.25)])
		draw_colored_polygon(band, Color(BODY, BODY.a * k * k * fade))
	# ภาพติดตาของใบดาบ 3 ชั้นตามหลัง
	for g in 3:
		var ga := maxf(a - 0.12 * float(g + 1), 0.0)
		var gt := _point(ga, radius * 1.04)
		draw_line(Vector2.ZERO, gt, Color(1.0, 0.7, 0.7, 0.25 * fade * (1.0 - float(g) * 0.3)), 30.0 - float(g) * 8.0, true)
	# ใบออร่าดาบที่กำลังฟาด
	var tip := _point(a, radius)
	var side := Vector2(-tip.y, tip.x).normalized() * 120.0
	draw_colored_polygon(PackedVector2Array([side * 0.4, tip * 0.9 + side, tip, tip * 0.9 - side, -side * 0.4]), Color(1.0, 0.5, 0.48, 0.45 * fade))
	draw_line(Vector2.ZERO, tip, Color(EDGE, 0.9 * fade), 8.0, true)
	var rim := PackedVector2Array()
	for n in steps + 1:
		rim.append(_point(a * float(n) / float(steps), radius))
	draw_polyline(rim, Color(1.0, 0.5, 0.5, 0.18 * fade), 60.0, true)
	draw_polyline(rim, Color(1.0, 0.7, 0.7, 0.3 * fade), 26.0, true)
	draw_polyline(rim, Color(EDGE, 0.85 * fade), 7.0, true)
	# ประกายระยิบตามขอบวงฟาด
	for n in 18:
		var sa := a * (float(n) + 0.5) / 18.0
		var tw := 0.5 + 0.5 * sin(_t * 18.0 + float(n) * 1.7)
		CatGlow.star4(self, _point(sa, radius * (0.95 + 0.08 * sin(float(n) * 2.3))), 22.0 * tw, Color(1.0, 0.95, 0.85, 0.9 * fade * tw))
	CatGlow.halo(self, tip, 220.0, Color(1.0, 0.6, 0.55, fade))
	CatGlow.rays(self, tip, 40.0, 260.0, 8, Color(1.0, 0.95, 0.9, 0.5 * fade), _t * 3.0)
	# รอยเท้าแมวเดินตามรอยฟาด
	for n in 7:
		var pa := a * (float(n) + 0.5) / 7.0
		var pp := _point(pa, radius * (0.62 if n % 2 == 0 else 0.74))
		CatGlow.bean_paw(self, pp, 34.0, Color(1.0, 0.85, 0.85, 0.8 * fade), pa * -dir + PI * 0.5 * dir, fade)
	# ปลายดาบมีหูแมวกับหน้าเหมียว
	CatGlow.ears(self, tip * 0.93, 66.0, Color(1.0, 0.55, 0.52, 0.85 * fade), Color(1.0, 0.85, 0.88, fade))
	draw_circle(tip * 0.93, 60.0, Color(1.0, 0.6, 0.58, 0.85 * fade))
	CatGlow.face(self, tip * 0.93, 60.0, Color(0.5, 0.1, 0.12, fade))
