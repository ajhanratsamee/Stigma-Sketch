class_name CatFireball
extends Node2D
## ลูกไฟของ MAGIC KNIGHT ทรงหยดน้ำ เปลวไฟพลิ้วไปทางหาง ชั้นแดง ส้ม เหลือง แกนขาว มีลูกไฟเล็กปลิวตามหลัง
## หน้าฝึกซ้อมเป็นคนขยับและเช็กว่าโดนมอน ตัวนี้แค่วาด และวาดตอนระเบิด

const OUTER := Color(0.92, 0.2, 0.06, 0.85)
const MID := Color(1.0, 0.48, 0.1, 0.92)
const INNER := Color(1.0, 0.8, 0.28)
const CORE := Color(1.0, 0.97, 0.82)
const BURST_TIME := 0.42
const POINTS := 32
const EMBER_LIFE := 0.45

var radius := 34.0
var charge := 0.0               # ลูกไฟที่ชาร์จ 0 ถึง 1 ใหญ่ขึ้นตามนี้
var tail := Vector2(0.0, -1.0)  # ทิศที่เปลวไฟพลิ้วไป ลูกที่พุ่งอยู่หางชี้ไปด้านหลัง ลูกที่ลอยนิ่งไฟลุกขึ้นบน
var bursting := false
var spark := false             # ประกายแดงเล็กๆ ของ SWORD KNIGHT
var blood := false             # ลูกเลือดของ DARK KNIGHT ใช้สีเลือดแทนสีไฟ
const BLOOD_OUTER := Color(0.42, 0.02, 0.05, 0.9)
const BLOOD_MID := Color(0.72, 0.05, 0.08, 0.95)
const BLOOD_INNER := Color(0.95, 0.2, 0.22)
const BLOOD_CORE := Color(1.0, 0.65, 0.65)
var _t := 0.0
var _burst_t := 0.0
var _embers: Array = []         # [ตำแหน่ง ความเร็ว อายุ ขนาด]
var _spawn := 0.0

func _process(delta: float) -> void:
	_grand_tick(delta)
	_t += delta
	if bursting:
		_burst_t += delta
		if _burst_t >= BURST_TIME:
			queue_free()
	_tick_embers(delta)
	queue_redraw()

## ขนาดที่เห็นจริง รวมการชาร์จ
func size() -> float:
	return radius * (1.0 + charge * 0.5)

func burst() -> void:
	bursting = true
	_burst_t = 0.0
	for i in 18:
		var a := TAU * float(i) / 18.0 + randf() * 0.3
		_embers.append([Vector2.ZERO, Vector2(cos(a), sin(a)) * randf_range(220.0, 420.0), 0.0, randf_range(3.0, 7.0)])

func _tick_embers(delta: float) -> void:
	if not bursting:
		_spawn -= delta
		while _spawn <= 0.0:
			_spawn += 0.025
			var r := size()
			var side := Vector2(-tail.y, tail.x) * randf_range(-0.6, 0.6) * r
			_embers.append([tail * r * 0.6 + side, tail * randf_range(80.0, 180.0) + side * 0.8, 0.0, randf_range(2.0, 5.0)])
	for e in _embers.duplicate():
		e[2] += delta
		e[0] += (e[1] as Vector2) * delta
		e[1] = (e[1] as Vector2) * 0.94 + Vector2(0.0, -60.0) * delta
		if e[2] >= EMBER_LIFE:
			_embers.erase(e)

## ขอบเปลวไฟ รัศมีพลิ้วตามเวลา ยืดออกทางหางเป็นหยดน้ำ
func _flame(r: float, stretch: float, phase: float, shift: Vector2) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var tail_a := tail.angle()
	for i in POINTS:
		var a := TAU * float(i) / float(POINTS)
		var toward := cos(a - tail_a)
		var tongue := 1.0 + 0.14 * sin(a * 5.0 + _t * 15.0 + phase) + 0.09 * sin(a * 9.0 - _t * 23.0 + phase * 2.0)
		var lick := pow(maxf(toward, 0.0), 2.0) * stretch * (1.0 + 0.25 * sin(_t * 19.0 + a * 3.0 + phase))
		pts.append(shift + Vector2(cos(a), sin(a)) * r * tongue * (1.0 + lick))
	return pts

## หน้าแมวบนลูกไฟ หูสองข้างชี้ขึ้นเสมอ ตายิ้ม ^ ^ ปาก ω
func cat_face(r: float, ear: Color, inner_ear: Color, ink: Color) -> void:
	for side in [-1.0, 1.0]:
		var base := Vector2(side * r * 0.55, -r * 0.62)
		var tri := PackedVector2Array([base + Vector2(-side * r * 0.32, r * 0.08), base + Vector2(side * r * 0.12, -r * 0.62), base + Vector2(side * r * 0.36, r * 0.18)])
		draw_colored_polygon(tri, ear)
		var c := (tri[0] + tri[1] + tri[2]) / 3.0
		draw_colored_polygon(PackedVector2Array([tri[0].lerp(c, 0.45), tri[1].lerp(c, 0.45), tri[2].lerp(c, 0.45)]), inner_ear)
	if r < 14.0:
		return
	var w := maxf(2.0, r * 0.08)
	for side in [-1.0, 1.0]:
		var e := Vector2(side * r * 0.3, -r * 0.08)
		draw_polyline(PackedVector2Array([e + Vector2(-r * 0.12, r * 0.06), e + Vector2(0.0, -r * 0.06), e + Vector2(r * 0.12, r * 0.06)]), ink, w, true)
	var m := Vector2(0.0, r * 0.2)
	draw_arc(m + Vector2(-r * 0.08, 0.0), r * 0.08, 0.0, PI, 8, ink, w * 0.8, true)
	draw_arc(m + Vector2(r * 0.08, 0.0), r * 0.08, 0.0, PI, 8, ink, w * 0.8, true)
	draw_circle(Vector2(-r * 0.48, r * 0.12), r * 0.1, Color(1.0, 0.55, 0.6, 0.6))
	draw_circle(Vector2(r * 0.48, r * 0.12), r * 0.1, Color(1.0, 0.55, 0.6, 0.6))

func _draw() -> void:
	var r := size()
	var outer := BLOOD_OUTER if blood else OUTER
	var mid := BLOOD_MID if blood else MID
	var inner := BLOOD_INNER if blood else INNER
	var core := BLOOD_CORE if blood else CORE
	if spark:
		outer = Color(1.0, 0.22, 0.08, 0.8)
		mid = Color(1.0, 0.45, 0.15)
		inner = Color(1.0, 0.75, 0.4)
		core = Color(1.0, 0.95, 0.8)
	for e in _embers:
		var k: float = float(e[2]) / EMBER_LIFE
		draw_circle(e[0], float(e[3]) * (1.0 - k * 0.5), inner.lerp(outer, k) * Color(1.0, 1.0, 1.0, 1.0 - k))
	# ลูกไฟของ MAGIC และ FLAME เป็นลูกบอลไฟกลมหมุน แบบเดียวกับ MAGIC 35.1 ไม่มีเปลวไฟรอบลูก
	if not blood and not spark:
		var k := _burst_t / BURST_TIME if bursting else 0.0
		_sphere(r * (1.0 + k * 1.6), 1.0 - k)
		if not bursting:
			cat_face(r, MID, INNER, Color(0.55, 0.15, 0.05))
		return
	if bursting:
		var k := _burst_t / BURST_TIME
		var grow := r * (1.0 + k * 2.2)
		var fade := 1.0 - k
		tail = Vector2(0.0, -1.0)
		draw_colored_polygon(_flame(grow, 0.6, 0.0, Vector2.ZERO), Color(outer, 0.7 * fade))
		draw_colored_polygon(_flame(grow * 0.72, 0.5, 1.3, Vector2(0.0, grow * 0.05)), Color(mid, 0.8 * fade))
		draw_colored_polygon(_flame(grow * 0.42, 0.4, 2.6, Vector2(0.0, grow * 0.08)), Color(inner, 0.9 * fade))
		return
	draw_colored_polygon(_flame(r, 1.3, 0.0, Vector2.ZERO), outer)
	draw_colored_polygon(_flame(r * 0.76, 1.1, 1.7, -tail * r * 0.06), mid)
	draw_colored_polygon(_flame(r * 0.5, 0.8, 3.1, -tail * r * 0.1), inner)
	draw_circle(-tail * r * 0.12, r * 0.24, core)
	if blood:
		cat_face(r * 0.8, mid, inner, Color(0.3, 0.0, 0.02))

func _oval(rx: float, ry: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 40:
		var a := TAU * float(i) / 40.0
		pts.append(Vector2(cos(a) * rx, sin(a) * ry))
	return pts

## ลูกบอลไฟกลม ไล่สีจากขอบแดงถึงแกนขาว มีเส้นไฟวิ่งวนรอบแกนตั้ง ด้านหน้าสว่าง ด้านหลังจาง
func _sphere(r: float, fade: float) -> void:
	draw_colored_polygon(_oval(r * 1.08, r * 1.08), Color(OUTER, 0.3 * fade))
	draw_colored_polygon(_oval(r, r), Color(OUTER, 0.85 * fade))
	draw_colored_polygon(_oval(r * 0.78, r * 0.78), Color(MID, 0.9 * fade))
	draw_colored_polygon(_oval(r * 0.5, r * 0.5), Color(INNER, 0.92 * fade))
	draw_circle(Vector2.ZERO, r * 0.22, Color(CORE, fade))
	var spin := _t * 5.0
	var width := maxf(r * 0.05, 1.5)
	for band in 7:
		var k := float(band) / 6.0 * 1.6 - 0.8
		var ry := r * k
		var rx := r * sqrt(maxf(1.0 - k * k, 0.05)) * 0.98
		for streak in 3:
			var start := spin * (1.4 - absf(k) * 0.3) + float(streak) * TAU / 3.0 + float(band)
			var arc := PackedVector2Array()
			for n in 10:
				var a := start + float(n) * 0.12
				arc.append(Vector2(sin(a) * rx, ry + cos(a) * r * 0.12))
			var front := 0.5 + 0.5 * cos(start + 0.6)
			draw_polyline(arc, Color(INNER, (0.25 + 0.6 * front) * fade), width * (1.0 + front), true)


# ---------------------------------------------------------------- ความอลังการ (ภาพล้วน ไม่ยุ่งกับการโดน)
## โหนดขยายใหญ่ขึ้นพร้อมเด้งตอนเกิด มีแสงฟุ้งด้านหลัง วงช็อก ลำแสง และประกายรอยเท้าแมวด้านหน้า
const GRAND_K := 1.25
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
	const R := 1.0
	const AT := Vector2.ZERO
	const LIFE := 999.00
	const RAYS := false
	const SPARK := true
	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()
	func _color() -> Color:
		var p := get_parent()
		if p.get("blood"):
			return Color(0.9, 0.1, 0.2)
		if p.get_script() != null and str(p.get_script().get_global_name()) == "MageOrb":
			return Color(1.0, 0.45, 0.8)
		if p.get_script() != null and str(p.get_script().get_global_name()) == "CatArrow":
			return Color(0.55, 0.95, 0.45)
		return Color(1.0, 0.55, 0.15)
	func _radius() -> float:
		var p := get_parent()
		var s = p.call("size") if p.has_method("size") else 30.0
		return float(s) * 1.25 if not p.get("bursting") else float(s) * 2.0
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
					draw_colored_polygon(PackedVector2Array([at + u * r * 0.3 + w, tip, at + u * r * 0.3 - w]), Color(1.0, 0.98, 0.85, 0.55 * (1.0 - k)))
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
					draw_colored_polygon(pts, Color(1.0, 0.97, 0.7, a))
				else:
					draw_circle(p + Vector2(0.0, s * 0.25), s * 0.55, Color(c.lightened(0.3), a))
					for t in 3:
						draw_circle(p + Vector2((float(t) - 1.0) * s * 0.55, -s * 0.45 - (s * 0.12 if t == 1 else 0.0)), s * 0.24, Color(c.lightened(0.3), a))
