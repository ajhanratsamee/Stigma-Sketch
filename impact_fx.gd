class_name ImpactFx
extends Node2D
## เอฟเฟกเส้นวาดมือตอนชนกับตอนกระแทกพื้น
## ram = เส้นแตกกระจายเป็นดาวตรงจุดที่ชน  slam = รอยแตกบนพื้น เศษหินกระเด็น และวงฝุ่น
## pillar = คลื่นไฟฟ้าทรงกระบอกงัดขึ้น  gate = ประตูวาปรูปรี  warp = ประกายวาปสีขาวชมพู  circle_sky = วงเวทบนฟ้า  bolt = สายฟ้าเล็กๆ ผ่าลงตัวมอน  circle_ground = วงเวทบนพื้นใต้ตัว  circle_tip = วงเวทตั้งตรงที่หัวคทา
## พิกัด pos เป็นหน่วยโลก y คือความสูงจากพื้น

const U := CombatData.UNIT
const RAM_LIFE := 0.28
const SLAM_LIFE := 0.65
const RAM_R := 95.0
const RAM_SPIKES := 11
const CRACK_LONG := 215.0
const CRACK_STEPS := 7
const ROCKS := 7
const ROCK_SPEED := 420.0
const ROCK_FALL := 950.0
const DUST := 3
const CIRCLE_LIFE := 0.5
const PILLAR_LIFE := 0.45
const PILLAR_RX := 50.0
const PILLAR_RY := 13.0
const PILLAR_HIGH := 190.0
const PILLAR_RINGS := 5
const GATE_LIFE := 0.45
const GATE_RX := 30.0
const GATE_RY := 92.0
const WARP_LIFE := 0.32
const WARP_R := 70.0
const WARP_DOTS := 14
const SKY_LIFE := 1.0
const WIDE_R := 3.6             # วงเวทตรึงตั้งตรง ตัวเราอยู่กลางวง
const WIDE_LIFE := 0.8
const WIDE_EDGE := 12.0
const SKY_RX := 1.7
const SKY_RY := 0.3
const BOLT_LIFE := 0.18
const BOLT_HIGH := 190.0
const BOLT_STEPS := 6
const BOLT_COLOR := Color(0.96, 0.78, 0.22)
const GROUND_RX := 1.25         # เท่าระยะโดนจริง กว้างเลยตัวไปนิดเดียว หน่วยโลก
const GROUND_RY := 0.2
const TIP_RX := 0.3
const TIP_RY := 1.05
const CIRCLE_MARKS := 8
const CIRCLE_RAYS := 5
const CIRCLE_COLOR := Color(0.5, 0.32, 0.82)
const RUBBLE_LIFE := 2.2
const RUBBLE_ROCKS := 16
const RUBBLE_SPREAD := 300.0
const PURPLE_LIFE := 0.5
const PURPLE_R := 2.4
const PURPLE := Color(0.56, 0.28, 0.86)

var pos := Vector2.ZERO
var kind := "ram"
var tint := Sketch.INK         # สีของรอยแตกกับเศษหินในเอฟเฟกกระแทก
var _u := 0.0

func _ready() -> void:
	z_index = 2
	position = Vector2(pos.x, -pos.y) * U

func _process(delta: float) -> void:
	_grand_tick(delta)
	var life := CIRCLE_LIFE
	match kind:
		"ram": life = RAM_LIFE
		"slam": life = SLAM_LIFE
		"bolt": life = BOLT_LIFE
		"circle_sky": life = SKY_LIFE
		"circle_wide": life = WIDE_LIFE
		"warp": life = WARP_LIFE
		"pillar": life = PILLAR_LIFE
		"gate": life = GATE_LIFE
		"rubble": life = RUBBLE_LIFE
		"purple_boom": life = PURPLE_LIFE
	_u += delta / life
	if _u >= 1.0:
		queue_free()
		return
	queue_redraw()

func _draw() -> void:
	match kind:
		"ram": _draw_ram()
		"slam": _draw_slam()
		"bolt": _draw_bolt()
		"warp": _draw_warp()
		"pillar": _draw_pillar()
		"gate": _draw_gate()
		"rubble": _draw_rubble()
		"purple_boom": _draw_purple_boom()
		"circle_ground": _draw_circle(GROUND_RX, GROUND_RY, true)
		"circle_tip": _draw_circle(TIP_RX, TIP_RY, false)
		"circle_sky": _draw_circle(SKY_RX, SKY_RY, false)
		"circle_wide": _draw_wide()
	_cat_touch()

## ลายแมวเพิ่มบนเอฟเฟกแต่ละแบบ
func _cat_touch() -> void:
	var fade := clampf((1.0 - _u) * 2.0, 0.0, 1.0)
	match kind:
		"ram":
			var head := 1.0 - pow(1.0 - _u, 3.0)
			_cat_paw(Vector2.ZERO, RAM_R * 0.22 * head + 2.0, Color(1.0, 0.97, 0.92, fade), Color(1.0, 0.62, 0.74, fade))
		"slam":
			# รอยเท้าแมวยักษ์ประทับลงพื้น แบนตามมุมกล้อง
			var grow := minf(_u * 5.0, 1.0)
			for side in [-1.0, 1.0]:
				_cat_paw(Vector2(side * 90.0 * grow, -4.0), 15.0 * grow, Color(tint, 0.6 * fade), Color(1.0, 0.62, 0.74, 0.8 * fade))
		"circle_ground", "circle_tip", "circle_sky":
			var r := 22.0 if kind != "circle_sky" else 30.0
			_cat_paw(Vector2.ZERO, r * minf(_u * 4.0, 1.0), Color(CIRCLE_COLOR, 0.8 * fade), Color(1.0, 0.75, 0.9, fade), _u * 2.0)
		"circle_wide":
			var r := WIDE_R * U * minf(_u * 4.0, 1.0)
			for n in 5:
				var a := _u * 2.4 + TAU * float(n) / 5.0
				_cat_paw(Vector2(cos(a), sin(a)) * r * 0.62, 18.0, Color(CIRCLE_COLOR, 0.75 * fade), Color(1.0, 0.75, 0.9, fade), a + PI * 0.5)
			_cat_ears(Vector2(0.0, -r - 4.0), r * 0.5, r * 0.32, r * 0.36, Color(CIRCLE_COLOR, 0.8 * fade), Color(1.0, 0.75, 0.9, fade))
		"gate":
			var open := sin(_u * PI)
			_cat_ears(Vector2(0.0, -GATE_RY + 8.0), GATE_RX * 0.55 * open, GATE_RX * 0.7 * open, GATE_RX * 0.9, ElecWave.ARC)
		"warp":
			var r := WARP_R * (1.0 - pow(1.0 - _u, 2.0))
			for n in 3:
				var a := TAU * float(n) / 3.0 + 0.5
				_cat_paw(Vector2(cos(a), sin(a) * 1.3) * r * 0.55, 7.0, Color(1.0, 1.0, 1.0, 1.0 - _u), Color(DimDust.PINK, 1.0 - _u), a)
		"purple_boom":
			_cat_paw(Vector2.ZERO, 26.0 * minf(_u * 3.0, 1.0), Color(PURPLE, 1.0 - _u), Color(1.0, 0.8, 1.0, 1.0 - _u))

## หินกองรอบจุดกระทบ ผุดขึ้นจากดินแล้วค่อยๆ จาง
func _draw_rubble() -> void:
	var fade := clampf((1.0 - _u) * 3.0, 0.0, 1.0)
	var grow := minf(_u * 9.0, 1.0)
	for k in RUBBLE_ROCKS:
		var side := -1.0 if k % 2 == 0 else 1.0
		var x := side * (40.0 + RUBBLE_SPREAD * float(k / 2) / (RUBBLE_ROCKS / 2) * (0.8 + 0.2 * absf(sin(float(k) * 4.3))))
		var size := (16.0 + 22.0 * absf(sin(float(k) * 2.9))) * grow
		if size < 2.0:
			continue
		var rock := PackedVector2Array([
			Vector2(x - size, 0.0), Vector2(x - size * 0.8, -size * 0.7), Vector2(x - size * 0.1, -size * 1.15),
			Vector2(x + size * 0.7, -size * 0.8), Vector2(x + size, 0.0),
		])
		SoftDraw.poly(self, rock, Sketch.PAPER)
		Sketch.hatch(self, rock, Color(tint, fade), 2280 + k % 8, 8.0)
		rock.append(rock[0])
		SoftDraw.sketch_line(self, rock, 2290 + k % 8, 3.0, 0.5, Color(Sketch.INK, fade))

## ระเบิดวงกลมม่วงบนตัวมอน ระบายม่วง ขอบหมึก
func _draw_purple_boom() -> void:
	var fade := 1.0 - _u
	var r := PURPLE_R * U * minf(_u * 2.2, 1.0)
	if r < 4.0:
		return
	var circle := Sketch.oval(Vector2.ZERO, r, r, 36)
	Sketch.hatch(self, circle, Color(PURPLE, fade), 2298, 15.0)
	circle.append(circle[0])
	SoftDraw.sketch_line(self, circle, 2299, 4.0, 1.0, Color(Sketch.INK, fade))

## วงคลื่นไฟฟ้าซ้อนกันเป็นกระบอก วิ่งจากพื้นขึ้นไป
func _draw_pillar() -> void:
	var fade := 1.0 - _u * _u
	for n in PILLAR_RINGS:
		var t := fposmod(_u * 1.6 + float(n) / PILLAR_RINGS, 1.0)
		var ring := Sketch.oval(Vector2(0.0, -PILLAR_HIGH * t), PILLAR_RX, PILLAR_RY, 22)
		ring.append(ring[0])
		SoftDraw.sketch_line(self, ring, 2360 + n, 3.0, 0.5, Color(ElecWave.ARC, fade))
	for side in [-1.0, 1.0]:
		SoftDraw.sketch_line(self, PackedVector2Array([Vector2(side * PILLAR_RX, 0.0), Vector2(side * PILLAR_RX, -PILLAR_HIGH)]), 2368, 2.2, 0.9, Color(ElecWave.COLOR, fade))

## ประตูวาปรูปรีตั้งตรง กางออกแล้วหุบ
func _draw_gate() -> void:
	var open := sin(_u * PI)
	var w := GATE_RX * open
	if w < 1.0:
		return
	var gate := Sketch.oval(Vector2.ZERO, w, GATE_RY, 26)
	Sketch.hatch(self, gate, Color(ElecWave.CORE, 0.8))
	gate.append(gate[0])
	SoftDraw.sketch_line(self, gate, 2370, 4.0, 0.6, ElecWave.ARC)
	var inner := Sketch.oval(Vector2.ZERO, w * 0.6, GATE_RY * 0.8, 22)
	inner.append(inner[0])
	SoftDraw.sketch_line(self, inner, 2371, 2.6, 0.4, ElecWave.COLOR)

## ประกายวาป จุดเล็กๆ แผ่ออกแล้วจาง
func _draw_warp() -> void:
	var r := WARP_R * (1.0 - pow(1.0 - _u, 2.0))
	var fade := 1.0 - _u
	for n in WARP_DOTS:
		var a := TAU * n / WARP_DOTS
		var at := Vector2(cos(a), sin(a) * 1.3) * r * (0.7 + 0.3 * absf(sin(float(n) * 2.1)))
		draw_circle(at, 4.5 * fade + 1.0, Color(DimDust.PINK if n % 2 == 0 else Color.WHITE, fade))
		draw_arc(at, 4.5 * fade + 1.0, 0.0, TAU, 8, Color(DimDust.EDGE, fade), 1.0, true)

## สายฟ้าเส้นเล็ก หยักซ้ายขวาจากบนลงล่าง
func _draw_bolt() -> void:
	var pts := PackedVector2Array()
	for n in BOLT_STEPS + 1:
		var t := float(n) / BOLT_STEPS
		var side := (10.0 + 6.0 * absf(sin(position.x + float(n) * 2.1))) * (1.0 if n % 2 == 0 else -1.0)
		pts.append(Vector2(side * (1.0 - t * 0.5), -BOLT_HIGH * (1.0 - t)))
	var fade := 1.0 - _u * _u
	SoftDraw.pline(self, pts, Color(BOLT_COLOR, fade), 6.0, true)
	SoftDraw.sketch_line(self, pts, 2290, 2.2, 0.2, Color(Sketch.INK, fade))

## วงเวทวงกลมตั้งตรง ขอบหนาใหญ่ ตัวละครอยู่ตรงกลาง
func _draw_wide() -> void:
	var grow := minf(_u * 4.0, 1.0)
	var fade := clampf((1.0 - _u) * 2.5, 0.0, 1.0)
	var r := WIDE_R * U * grow
	draw_arc(Vector2.ZERO, r, 0.0, TAU, 72, Color(CIRCLE_COLOR, fade * 0.8), WIDE_EDGE, true)
	var ring := Sketch.oval(Vector2.ZERO, r + WIDE_EDGE * 0.5, r + WIDE_EDGE * 0.5, 54)
	ring.append(ring[0])
	SoftDraw.sketch_line(self, ring, 2250, 3.4, 0.7, Color(Sketch.INK, fade))
	var inner := Sketch.oval(Vector2.ZERO, r - WIDE_EDGE * 0.5, r - WIDE_EDGE * 0.5, 54)
	inner.append(inner[0])
	SoftDraw.sketch_line(self, inner, 2251, 2.8, 0.7, Color(Sketch.INK, fade))
	var turn := _u * 2.4
	# วงจุดกลมหมุนแทนดาวห้าแฉก
	for n in 10:
		var a := -turn + TAU * float(n) / 10.0
		draw_circle(Vector2(cos(a), sin(a)) * r * 0.86, 7.0, Color(CIRCLE_COLOR, fade))
	for n in 16:
		var a := turn + TAU * n / 16.0
		var d := Vector2(cos(a), sin(a))
		SoftDraw.sketch_line(self, PackedVector2Array([d * r * 0.8, d * r * 0.92]), 2272 + n, 3.0, 0.2, Color(CIRCLE_COLOR, fade))

## วงเวทสองชั้นหมุนสวนกัน มีขีดอักขระรอบวง แบบบนพื้นมีเส้นแสงพุ่งขึ้น
func _draw_circle(rx: float, ry: float, rays: bool) -> void:
	var grow := minf(_u * 4.0, 1.0)
	var fade := clampf((1.0 - _u) * 2.5, 0.0, 1.0)
	var color := Color(CIRCLE_COLOR, fade)
	var ink := Color(Sketch.INK, fade)
	var w := rx * U * grow
	var h := ry * U * grow
	for layer in [[1.0, ink, 3.6], [0.72, color, 3.2]]:
		var k: float = layer[0]
		var ring := Sketch.oval(Vector2.ZERO, w * k, h * k, 40)
		ring.append(ring[0])
		SoftDraw.sketch_line(self, ring, 2250 + int(k * 10.0), float(layer[2]), 0.6, layer[1])
	var turn := _u * 3.0
	for n in CIRCLE_MARKS:
		var a := turn + TAU * n / CIRCLE_MARKS
		var d := Vector2(cos(a) * w, sin(a) * h)
		SoftDraw.sketch_line(self, PackedVector2Array([d * 0.72, d]), 2260 + n, 2.6, 0.2, color)
	for n in 10:
		var a := -turn + TAU * float(n) / 10.0
		draw_circle(Vector2(cos(a) * w * 0.6, sin(a) * h * 0.6), 5.0, color)
	if rays:
		for n in CIRCLE_RAYS:
			var x := lerpf(-0.75, 0.75, float(n) / (CIRCLE_RAYS - 1)) * w
			var high := (80.0 + 50.0 * absf(sin(float(n) * 2.3))) * minf(_u * 3.0, 1.0)
			var low := high * maxf(_u * 2.0 - 0.6, 0.0)
			SoftDraw.sketch_line(self, PackedVector2Array([Vector2(x, -low), Vector2(x, -high)]), 2275 + n, 3.0, 0.3, color)

## ปลายพุ่งออกเร็ว โคนตามไปทีหลัง เส้นจึงวิ่งออกแล้วหายไป
func _draw_ram() -> void:
	var head := 1.0 - pow(1.0 - _u, 3.0)
	var tail := _u * _u
	for k in RAM_SPIKES:
		var a := TAU * k / RAM_SPIKES + 0.3
		var long := RAM_R * (1.25 if k % 2 == 0 else 0.8)
		var d := Vector2(cos(a), sin(a))
		SoftDraw.sketch_line(self, PackedVector2Array([d * long * tail, d * long * head]), 2200 + k, 4.5 if k % 2 == 0 else 3.0, 0.5)
	var r := RAM_R * 0.55 * head
	if r > 2.0:
		var ring := Sketch.oval(Vector2.ZERO, r, r, 20)
		ring.append(ring[0])
		SoftDraw.sketch_line(self, ring, 2215, 3.0, 1.2, Color(Sketch.INK, 1.0 - _u))

func _draw_slam() -> void:
	var fade := clampf((1.0 - _u) * 2.0, 0.0, 1.0)
	var grow := minf(_u * 5.0, 1.0)
	# รอยแตกวิ่งออกสองข้างตามพื้น
	for side in [-1.0, 1.0]:
		var crack := PackedVector2Array([Vector2.ZERO])
		for n in CRACK_STEPS:
			var t := float(n + 1) / CRACK_STEPS
			var jag := (10.0 if n % 2 == 0 else -4.0) + 7.0 * sin(float(n) * 3.7 + side)
			crack.append(Vector2(side * CRACK_LONG * t * grow, (3.0 + jag) * (1.0 - t * 0.5)))
		if tint != Sketch.INK:
			SoftDraw.sketch_line(self, crack, 2220 + int(side), 7.0, 0.5, Color(Sketch.INK, fade))
		SoftDraw.sketch_line(self, crack, 2220 + int(side), 3.6, 0.5, Color(tint, fade))
	# เศษหินกระเด็นเป็นวิถีโค้ง
	var t_rock := _u * SLAM_LIFE
	for k in ROCKS:
		var a := lerpf(-2.75, -0.39, float(k) / (ROCKS - 1))
		var speed := ROCK_SPEED * (0.7 + 0.4 * absf(sin(float(k) * 5.1)))
		var at := Vector2(cos(a), sin(a)) * speed * t_rock + Vector2(0.0, ROCK_FALL * t_rock * t_rock)
		if at.y > 0.0:
			continue
		var size := 7.0 + 5.0 * absf(sin(float(k) * 2.9))
		var rock := PackedVector2Array([at + Vector2(-size, size * 0.5), at + Vector2(0.0, -size), at + Vector2(size, size * 0.6)])
		SoftDraw.poly(self, rock, Sketch.PAPER)
		rock.append(rock[0])
		SoftDraw.sketch_line(self, rock, 2225 + k, 2.4, 0.3, Color(tint, fade))
	# ฝุ่นม้วนเป็นครึ่งวงเตี้ยๆ แผ่ออกข้าง
	for side in [-1.0, 1.0]:
		for n in DUST:
			var x: float = side * (55.0 + n * 58.0) * (0.45 + 0.75 * _u)
			var r := (24.0 - n * 4.0) * (0.6 + 0.6 * _u)
			var puff := PackedVector2Array()
			for j in 9:
				var a := PI + PI * float(j) / 8.0
				puff.append(Vector2(x + cos(a) * r, sin(a) * r * 0.85))
			SoftDraw.sketch_line(self, puff, 2235 + n, 2.6, 0.4, Color(Sketch.INK, fade))


# ---------------------------------------------------------------- ลายแมว
const CAT_BEAN := Color(1.0, 0.62, 0.74)

## รอยเท้าแมว อุ้งใหญ่ นิ้วสี่นิ้ว มีถั่วชมพูข้างใน หมุนได้
func _cat_paw(at: Vector2, r: float, base: Color, bean: Color = CAT_BEAN, spin: float = 0.0) -> void:
	# รอยเท้าแมวเป็นเม็ดกลมนุ่มแทน
	if r < 1.0 or base.a <= 0.01:
		return
	draw_circle(at, r * 0.75, Color(base, base.a * 0.35))
	draw_circle(at, r * 0.45, Color(base, base.a * 0.7))

## หูแมวคู่ ฐานอยู่ที่ center ห่างกัน gap ชี้ไปทาง up
func _cat_ears(center: Vector2, gap: float, w: float, h: float, color: Color, inner: Color = CAT_BEAN, up: Vector2 = Vector2.UP) -> void:
	# ลายแมวตกแต่งเอาออก ให้เอฟเฟกต์ดูนุ่มเรียบ
	pass

## หน้าแมว ตายิ้ม ^ ^ ปาก ω แก้มชมพู
func _cat_face(c: Vector2, r: float, ink: Color) -> void:
	# ลายแมวตกแต่งเอาออก ให้เอฟเฟกต์ดูนุ่มเรียบ
	pass

## หนวดแมวสามเส้นออกจากจุด ไปทาง dir
func _cat_whiskers(at: Vector2, dir_x: float, long: float, color: Color, width: float = 3.0) -> void:
	for n in 3:
		var tilt := (float(n) - 1.0) * 0.22
		var d := Vector2(dir_x * cos(tilt), sin(tilt))
		draw_line(at + d * long * 0.15, at + d * long, color, width, true)

## ก้างปลา หัวสามเหลี่ยม หางสองแฉก
func _fishbone(at: Vector2, long: float, color: Color, spin: float = 0.0) -> void:
	var a := at + Vector2(-long * 0.5, 0.0).rotated(spin)
	var b := at + Vector2(long * 0.32, 0.0).rotated(spin)
	draw_line(a, b, color, maxf(2.0, long * 0.07), true)
	for n in 3:
		var x := -long * 0.3 + float(n) * long * 0.18
		draw_line(at + Vector2(x, -long * 0.16).rotated(spin), at + Vector2(x, long * 0.16).rotated(spin), color, maxf(1.5, long * 0.05), true)
	SoftDraw.poly(self, PackedVector2Array([b + Vector2(0.0, -long * 0.14).rotated(spin), at + Vector2(long * 0.55, 0.0).rotated(spin), b + Vector2(0.0, long * 0.14).rotated(spin)]), color)
	SoftDraw.poly(self, PackedVector2Array([a, a + Vector2(-long * 0.16, -long * 0.16).rotated(spin), a + Vector2(-long * 0.16, long * 0.16).rotated(spin)]), color)


# ---------------------------------------------------------------- ความอลังการ (ภาพล้วน ไม่ยุ่งกับการโดน)
## โหนดขยายใหญ่ขึ้นพร้อมเด้งตอนเกิด มีแสงฟุ้งด้านหลัง วงช็อก ลำแสง และประกายรอยเท้าแมวด้านหน้า
const GRAND_K := 1.40
var _g_t := 0.0
var _g_base := Vector2.ZERO

func _grand_tick(delta: float) -> void:
	if _g_base == Vector2.ZERO:
		_g_base = scale
		if false:  # ไม่ใส่แสงฟุ้ง วงช็อก ลำแสงตกแต่ง (ผู้เล่นบอกว่าเวอร์แปลก)
			var back := _GrandAura.new()
			back.front = false
			back.show_behind_parent = true
			add_child(back)
			var top := _GrandAura.new()
			top.front = true
			add_child(top)
	_g_t += delta
	if GRAND_K != 1.0:
		var k := minf(_g_t / 0.16, 1.0)
		var pop := lerpf(0.78, 1.0, k) + 0.12 * sin(minf(_g_t / 0.32, 1.0) * PI)
		scale = _g_base * GRAND_K * pop

class _GrandAura extends Node2D:
	var front := true
	var _t := 0.0
	const R := 100.0
	const AT := Vector2.ZERO
	const LIFE := 0.55
	const RAYS := false
	const SPARK := false
	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()
	func _color() -> Color:
		return Color(1.0, 0.85, 0.55)
	func _radius() -> float:
		return R
	func _at() -> Vector2:
		var p := get_parent()
		var d = p.get("dir")
		var s := 1.0
		if d is float and AT.x != 0.0:
			s = signf(d) if d != 0.0 else 1.0
			# โหนดที่พลิกด้วย scale.x แล้ว ไม่ต้องคูณทิศซ้ำ
			if (p as Node2D).scale.x < 0.0:
				s = 1.0
		return Vector2(AT.x * s, AT.y)
	func _draw() -> void:
		var c := _color()
		var r := _radius()
		if r <= 1.0:
			return
		var at := _at()
		var fade := clampf(1.0 - (_t - LIFE * 0.6) / (LIFE * 0.4), 0.0, 1.0) if LIFE < 50.0 else 1.0
		if not front:
			# แสงฟุ้งนุ่มๆ หลายชั้นด้านหลัง เต้นเบาๆ
			var pulse := 1.0 + 0.06 * sin(_t * 9.0)
			for i in 5:
				var k := float(i) / 4.0
				draw_circle(at, r * (1.75 - k * 0.95) * pulse, Color(c, (0.05 + 0.07 * k) * fade))
			draw_circle(at, r * 0.45, Color(1.0, 1.0, 1.0, 0.16 * fade))
			return
		# วงช็อกสองชั้นตอนเกิด
		if RAYS:
			for n in 2:
				var tt := _t - float(n) * 0.09
				if tt > 0.0 and tt < 0.45:
					var k := tt / 0.45
					draw_arc(at, r * (0.5 + 1.5 * k), 0.0, TAU, 40, Color(c.lightened(0.45), (1.0 - k) * 0.85), 12.0 * (1.0 - k) + 2.0, true)
			# ลำแสงพุ่งออกรอบจุดกลาง
			if _t < 0.5:
				var k := _t / 0.5
				for i in 10:
					var ang := float(i) / 10.0 * TAU + _t * 1.5
					var u := Vector2(cos(ang), sin(ang))
					var w := u.orthogonal() * r * 0.07 * (1.0 - k)
					var tip := at + u * r * (1.1 + 1.4 * k)
					draw_circle(tip, r * 0.07 * (1.0 - k) + 1.5, Color(1.0, 0.98, 0.85, 0.55 * (1.0 - k)))
		# ประกายดาวและรอยเท้าแมววนลอยขึ้น
		if SPARK:
			for i in 8:
				var ph := fmod(_t * 0.9 + float(i) * 0.125, 1.0)
				var ang := float(i) * 0.785 + _t * 2.2
				var p := at + Vector2(cos(ang) * r * (0.7 + 0.5 * ph), sin(ang) * r * 0.45 - ph * r * 0.9)
				var a := sin(ph * PI) * 0.9 * fade
				var s := r * 0.07 + 3.0
				if i % 2 == 0:
					var pts := PackedVector2Array()
					for j in 8:
						var aa := -PI * 0.5 + float(j) * PI / 4.0 + _t * 3.0
						pts.append(p + Vector2(cos(aa), sin(aa)) * (s if j % 2 == 0 else s * 0.4))
					SoftDraw.sparkle(self, p, s, Color(1.0, 0.97, 0.7, a))
				else:
					draw_circle(p + Vector2(0.0, s * 0.25), s * 0.55, Color(c.lightened(0.3), a))
					for t in 3:
						draw_circle(p + Vector2((float(t) - 1.0) * s * 0.55, -s * 0.45 - (s * 0.12 if t == 1 else 0.0)), s * 0.24, Color(c.lightened(0.3), a))
