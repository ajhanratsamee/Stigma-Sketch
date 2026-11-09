class_name CatGlow
extends Node2D
## GUARDIAN KNIGHT 45.2 โล่ด้านหลังเรืองแสงทองระหว่างบัพมานา เดินตามตัวละคร หายเองเมื่อบัพหมด

var target: Hero
var _t := 0.0

func _process(delta: float) -> void:
	_t += delta
	if not is_instance_valid(target) or target.plain_mana_t <= 0.0:
		queue_free()
		return
	position = target.position + Vector2(-target.facing * 34.0, -78.0)
	queue_redraw()

func _draw() -> void:
	var pulse := 0.75 + 0.25 * sin(_t * 6.0)
	var grow := pop(_t, 0.3)
	halo(self, Vector2.ZERO, 150.0 * pulse * grow, Color(1.0, 0.85, 0.4, 1.0), 4)
	rays(self, Vector2.ZERO, 30.0, 170.0 * grow, 12, Color(1.0, 0.95, 0.65, 0.3 * pulse), _t * 0.8, 0.06)
	ring(self, Vector2.ZERO, 90.0 + 30.0 * fposmod(_t, 1.0), 90.0 + 30.0 * fposmod(_t, 1.0), Color(1.0, 0.92, 0.6, 0.5 * (1.0 - fposmod(_t, 1.0))), 4.0)
	sparkles(self, Vector2.ZERO, 120.0, 100.0, 10, _t, Color(1.0, 0.97, 0.75, 0.9), 18.0, 10.0)
	draw_circle(Vector2.ZERO, 70.0 * pulse, Color(1.0, 0.85, 0.35, 0.18))
	draw_circle(Vector2.ZERO, 44.0 * pulse, Color(1.0, 0.9, 0.5, 0.25))
	draw_arc(Vector2.ZERO, 40.0, 0.0, TAU, 32, Color(1.0, 0.92, 0.6, 0.7 * pulse), 4.0, true)
	# รอยเท้าแมวทองกลางแสง กระดิ่งห้อยใต้ รอยเท้าเล็กลอยวน
	bean_paw(self, Vector2(0.0, -4.0), 20.0, Color(1.0, 0.85, 0.4, 0.85), 0.0, pulse)
	bell(self, Vector2(0.0, 48.0), 9.0, 0.9)
	for i in 3:
		var a := _t * 1.6 + TAU * float(i) / 3.0
		paw(self, Vector2(cos(a) * 62.0, sin(a) * 30.0), 8.0, Color(1.0, 0.9, 0.5, 0.6 * pulse), a)

# ---------------------------------------------------------------- ลายแมวที่เอฟเฟกต์อื่นเรียกใช้ร่วมกัน
const BEAN := Color(1.0, 0.62, 0.72)
const PAW_INK := Color(0.35, 0.12, 0.12)

static func _tf(p: Vector2, at: Vector2, rot: float, flat: float) -> Vector2:
	var q := p.rotated(rot)
	return at + Vector2(q.x, q.y * flat)

## รอยเท้าแมว อุ้งใหญ่หนึ่ง นิ้วสี่ flat < 1 คือแบนลงพื้น
static func paw(c: CanvasItem, at: Vector2, r: float, pad: Color, rot := 0.0, flat := 1.0) -> void:
	var main := PackedVector2Array()
	for i in 16:
		var a := TAU * float(i) / 16.0
		main.append(_tf(Vector2(cos(a) * r * 0.62, r * 0.25 + sin(a) * r * 0.5), at, rot, flat))
	SoftDraw.poly(c, main, pad)
	for i in 4:
		var ang := deg_to_rad(-140.0 + 33.3 * float(i))
		var toe := Vector2(cos(ang), sin(ang)) * r * 0.78 + Vector2(0.0, r * 0.1)
		var pts := PackedVector2Array()
		for j in 10:
			var a := TAU * float(j) / 10.0
			pts.append(_tf(toe + Vector2(cos(a), sin(a)) * r * 0.24, at, rot, flat))
		SoftDraw.poly(c, pts, pad)

## รอยเท้าแมวมีถั่วชมพูกลาง สำหรับลอยกลางอากาศ
static func bean_paw(c: CanvasItem, at: Vector2, r: float, pad: Color, rot := 0.0, alpha := 1.0) -> void:
	paw(c, at, r, Color(pad, pad.a * alpha), rot)
	paw(c, at, r * 0.55, Color(BEAN, alpha), rot)

## หูแมวคู่บนวงกลมรัศมี r ที่ center
static func ears(c: CanvasItem, center: Vector2, r: float, col: Color, inner: Color) -> void:
	for side in [-1.0, 1.0]:
		var base := center + Vector2(side * r * 0.55, -r * 0.62)
		var tri := PackedVector2Array([base + Vector2(-side * r * 0.32, r * 0.1), base + Vector2(side * r * 0.12, -r * 0.6), base + Vector2(side * r * 0.36, r * 0.2)])
		SoftDraw.poly(c, tri, col)
		var mid := (tri[0] + tri[1] + tri[2]) / 3.0
		SoftDraw.poly(c, PackedVector2Array([tri[0].lerp(mid, 0.45), tri[1].lerp(mid, 0.45), tri[2].lerp(mid, 0.45)]), inner)

## หน้าแมว ตา ^ ^ ปาก ω แก้มชมพู
static func face(c: CanvasItem, at: Vector2, r: float, ink: Color) -> void:
	var w := maxf(2.0, r * 0.08)
	for side in [-1.0, 1.0]:
		var e := at + Vector2(side * r * 0.3, -r * 0.08)
		SoftDraw.pline(c, PackedVector2Array([e + Vector2(-r * 0.12, r * 0.06), e + Vector2(0.0, -r * 0.06), e + Vector2(r * 0.12, r * 0.06)]), ink, w, true)
		c.draw_circle(at + Vector2(side * r * 0.48, r * 0.12), r * 0.1, Color(1.0, 0.55, 0.6, 0.6 * ink.a))
	var m := at + Vector2(0.0, r * 0.2)
	c.draw_arc(m + Vector2(-r * 0.08, 0.0), r * 0.08, 0.0, PI, 8, ink, w * 0.8, true)
	c.draw_arc(m + Vector2(r * 0.08, 0.0), r * 0.08, 0.0, PI, 8, ink, w * 0.8, true)

## หนวดแมวสามเส้นต่อข้าง
static func whiskers(c: CanvasItem, at: Vector2, r: float, col: Color, width := 2.0) -> void:
	for side in [-1.0, 1.0]:
		for i in 3:
			var y := (float(i) - 1.0) * r * 0.14
			c.draw_line(at + Vector2(side * r * 0.45, r * 0.15 + y * 0.4), at + Vector2(side * r * 1.05, r * 0.08 + y), col, width, true)

## ก้างปลา
static func fish(c: CanvasItem, at: Vector2, sz: float, col: Color, rot := 0.0) -> void:
	var a := at + Vector2(-sz, 0.0).rotated(rot)
	var b := at + Vector2(sz * 0.7, 0.0).rotated(rot)
	c.draw_line(a, b, col, maxf(2.0, sz * 0.12), true)
	for i in 3:
		var x := -sz * 0.5 + float(i) * sz * 0.4
		c.draw_line(at + Vector2(x, -sz * 0.35).rotated(rot), at + Vector2(x, sz * 0.35).rotated(rot), col, maxf(1.5, sz * 0.09), true)
	SoftDraw.poly(c, PackedVector2Array([b, at + Vector2(sz * 1.2, -sz * 0.4).rotated(rot), at + Vector2(sz * 1.2, sz * 0.4).rotated(rot)]), col)
	SoftDraw.poly(c, PackedVector2Array([a, at + Vector2(-sz * 1.4, -sz * 0.35).rotated(rot), at + Vector2(-sz * 1.4, sz * 0.35).rotated(rot)]), col)

## ไหมพรมกลม มีเส้นพันรอบ
static func yarn(c: CanvasItem, at: Vector2, r: float, col: Color, spin := 0.0) -> void:
	c.draw_circle(at, r, col)
	var line := col.lightened(0.45)
	for i in 3:
		var a := spin + float(i) * PI / 3.0
		c.draw_arc(at, r * 0.75, a, a + PI * 0.9, 10, line, maxf(1.5, r * 0.12), true)

## กระดิ่งทองเล็ก
static func bell(c: CanvasItem, at: Vector2, r: float, alpha := 1.0) -> void:
	c.draw_circle(at, r, Color(1.0, 0.82, 0.3, alpha))
	c.draw_line(at + Vector2(-r, -r * 0.2), at + Vector2(r, -r * 0.2), Color(0.75, 0.5, 0.15, alpha), maxf(1.5, r * 0.2))
	c.draw_circle(at + Vector2(0.0, r * 0.45), r * 0.22, Color(0.3, 0.2, 0.1, alpha))

# ---------------------------------------------------------------- ความอลังการที่เอฟเฟกต์อื่นเรียกใช้ร่วมกัน
## เด้งตอนเกิด 0 ถึงใหญ่เกินนิดหน่อยแล้วกลับ 1
static func pop(t: float, dur := 0.2) -> float:
	if t >= dur:
		return 1.0
	var k := clampf(t / dur, 0.0, 1.0)
	return 1.0 + 0.22 * sin(k * PI) - (1.0 - k) * (1.0 - k) * 0.6

## แสงฟุ้งนุ่มหลายชั้นรอบจุด
static func halo(c: CanvasItem, at: Vector2, r: float, col: Color, _layers := 4) -> void:
	# แสงฟุ้งไล่จางเนียน หลายชั้นบางๆ ไม่ให้เห็นเป็นวงซ้อน และเล็กลงไม่ให้เวอร์
	var n := 12
	for i in n:
		var k := 1.0 - float(i) / float(n)
		c.draw_circle(at, r * 0.75 * (0.3 + 0.7 * k), Color(col, col.a * 0.05))

## แสงฟุ้งวงรี (เช่นพื้นเรืองแสง)
static func glow_oval(c: CanvasItem, at: Vector2, rx: float, ry: float, col: Color, layers := 3) -> void:
	if rx < 2.0 or ry < 2.0:
		return
	for i in layers:
		var k := 1.0 - float(i) / float(layers)
		var pts := PackedVector2Array()
		for j in 28:
			var a := TAU * float(j) / 28.0
			pts.append(at + Vector2(cos(a) * rx * (0.4 + 0.6 * k), sin(a) * ry * (0.4 + 0.6 * k)))
		SoftDraw.poly(c, pts, Color(col, col.a * 0.3 * (1.0 - k * 0.55)))

## ลำแสงพุ่งออกจากจุด n เส้น หมุนตาม rot
static func rays(c: CanvasItem, at: Vector2, r0: float, r1: float, n: int, col: Color, rot := 0.0, width := 0.08) -> void:
	if r1 <= r0 + 2.0:
		return
	# เม็ดกลมกระจายออกเป็นวง แทนรังสีแฉกแหลม
	for i in n:
		var a := rot + TAU * float(i) / float(n)
		var u := Vector2(cos(a), sin(a))
		var far := r1 * (0.85 if i % 2 == 0 else 0.65)
		var dr := r1 * width * (0.9 if i % 2 == 0 else 0.6)
		c.draw_circle(at + u * lerpf(r0, far, 0.55), dr, Color(col, col.a * 0.6))
		c.draw_circle(at + u * far, dr * 0.7, col)

## วงคลื่นกระแทก (วงรี) เส้นหนา
static func ring(c: CanvasItem, at: Vector2, rx: float, ry: float, col: Color, width := 6.0) -> void:
	var pts := PackedVector2Array()
	for j in 41:
		var a := TAU * float(j) / 40.0
		pts.append(at + Vector2(cos(a) * rx, sin(a) * ry))
	SoftDraw.pline(c, pts, col, width, true)

## ดาวประกายสี่แฉก
static func star4(c: CanvasItem, at: Vector2, r: float, col: Color) -> void:
	if r < 1.0:
		return
	# ประกายกลมแทนดาวสี่แฉก
	SoftDraw.sparkle(c, at, r * 0.7, col)

static func _h(n: float) -> float:
	return fposmod(sin(n * 12.9898) * 43758.5453, 1.0)

## ประกายระยิบกระจายในวงรี กะพริบตามเวลา (ไม่ต้องเก็บสถานะ)
static func sparkles(c: CanvasItem, at: Vector2, rx: float, ry: float, n: int, t: float, col: Color, seed_f := 0.0, size := 9.0) -> void:
	for i in n:
		var f := float(i) + seed_f * 17.0
		var a := _h(f) * TAU
		var d := sqrt(_h(f + 3.1))
		var tw := 0.5 + 0.5 * sin(t * (6.0 + _h(f + 7.7) * 8.0) + f)
		if tw < 0.15 or size * tw < 2.0:
			continue
		var p := at + Vector2(cos(a) * rx * d, sin(a) * ry * d)
		if i % 5 == 0:
			paw(c, p, size * 0.8 * tw, Color(col, col.a * tw))
		else:
			star4(c, p, size * tw, Color(col, col.a * tw))

## ประกายไฟลอยขึ้นจากแนวกว้าง spread สูง rise
static func embers(c: CanvasItem, at: Vector2, spread: float, rise: float, n: int, t: float, col: Color, seed_f := 0.0, size := 6.0) -> void:
	for i in n:
		var f := float(i) + seed_f * 13.0
		var speed := 0.6 + _h(f + 1.3) * 0.8
		var k := fposmod(t * speed + _h(f), 1.0)
		var x := (_h(f + 5.5) - 0.5) * 2.0 * spread + sin(k * 6.0 + f) * 12.0
		var p := at + Vector2(x, -k * rise)
		var a := sin(k * PI)
		c.draw_circle(p, size * (1.0 - k * 0.6), Color(col, col.a * a))
