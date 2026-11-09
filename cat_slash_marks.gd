class_name CatSlashMarks
extends Node2D
## รอยฟันเลือดสลับไปมาด้านหน้า เกิดทีละรอยเร็วๆ เป็นเส้นเฉียงคมสีแดงแกนขาว วางที่พื้น y 0
## ใช้กับ CRIMSON KNIGHT 35.2 และ HYPER ของ CRIMSON แต่ละรอยตีมอนตรงจุดนั้น

var dir := 1.0
var width := 1400.0             # ช่วงด้านหน้าที่รอยเกิด
var count := 14
var gap := 0.045
var dmg := 9.0
var high := 260.0
var hitter: Callable
var extra := {"kb": 0.4, "stun": 0.35}
var _t := 0.0
var _marks: Array = []         # [ตรงกลาง มุม ยาว เกิดตอน]
var _made := 0

func _process(delta: float) -> void:
	_grand_tick(delta)
	_t += delta
	while _made < count and _t >= float(_made) * gap:
		var x := dir * randf_range(80.0, width)
		var ang := deg_to_rad(randf_range(25.0, 65.0)) * (1.0 if _made % 2 == 0 else -1.0)
		_marks.append([Vector2(x, -randf_range(40.0, high)), ang, randf_range(220.0, 360.0), _t])
		if hitter.is_valid():
			hitter.call(position.x + x, 110.0, dmg, dir, null, extra)
		_made += 1
	if _made >= count and _t > float(count) * gap + 0.4:
		queue_free()
		return
	queue_redraw()

func _draw() -> void:
	for m in _marks:
		var age: float = _t - float(m[3])
		var k := clampf(1.0 - age / 0.35, 0.0, 1.0)
		if k <= 0.0:
			continue
		var grow := clampf(age / 0.06, 0.0, 1.0)
		var c: Vector2 = m[0]
		var d := Vector2(cos(m[1]), sin(m[1]))
		var half: float = float(m[2]) * 0.72 * grow
		# รอยฟันทรงเลนส์อ้วนมน ไม่เป็นเข็มแหลม
		var side := Vector2(-d.y, d.x) * 40.0 * k
		SoftDraw.poly(self, PackedVector2Array([c - d * half * 1.15, c + side * 1.9, c + d * half * 1.15, c - side * 1.9]), Color(1.0, 0.2, 0.3, 0.25 * k))
		SoftDraw.poly(self, PackedVector2Array([c - d * half, c + side, c + d * half, c - side]), Color(0.75, 0.0, 0.08, 0.8 * k))
		draw_circle(c, half * 0.35 * k, Color(1.0, 0.6, 0.65, 0.25 * k))
		draw_line(c - d * half * 0.7, c + d * half * 0.7, Color(1.0, 0.9, 0.9, k), 6.0, true)
		draw_circle(c - d * half * 0.7, 3.0, Color(1.0, 0.9, 0.9, k))
		draw_circle(c + d * half * 0.7, 3.0, Color(1.0, 0.9, 0.9, k))
		# รอยเท้าแมวประทับตรงกลางรอยฟัน
		_cat_paw(c, 24.0 * grow, Color(0.85, 0.05, 0.12, 0.9 * k), Color(1.0, 0.75, 0.8), float(m[1]) * 0.3)


# ---------------------------------------------------------------- ลายแมว
const CAT_BEAN := Color(1.0, 0.62, 0.74)

## รอยเท้าแมว อุ้งใหญ่ นิ้วสี่นิ้ว มีถั่วชมพูข้างใน หมุนได้
func _cat_paw(at: Vector2, r: float, base: Color, bean: Color = CAT_BEAN, spin: float = 0.0) -> void:
	if r < 1.0 or base.a <= 0.01:
		return
	var pad := PackedVector2Array()
	var inner := PackedVector2Array()
	for i in 14:
		var a := TAU * float(i) / 14.0
		pad.append(at + Vector2(cos(a) * r, sin(a) * r * 0.8 + r * 0.3).rotated(spin))
		inner.append(at + Vector2(cos(a) * r * 0.58, sin(a) * r * 0.45 + r * 0.36).rotated(spin))
	SoftDraw.poly(self, pad, base)
	SoftDraw.poly(self, inner, Color(bean, bean.a * base.a))
	for t in 4:
		var ang := -PI * 0.5 + (float(t) - 1.5) * 0.52
		var toe := at + (Vector2(cos(ang), sin(ang)) * r * 1.15).rotated(spin)
		draw_circle(toe, r * 0.34, base)
		draw_circle(toe, r * 0.2, Color(bean, bean.a * base.a))

## หูแมวคู่ ฐานอยู่ที่ center ห่างกัน gap ชี้ไปทาง up
func _cat_ears(center: Vector2, gap: float, w: float, h: float, color: Color, inner: Color = CAT_BEAN, up: Vector2 = Vector2.UP) -> void:
	if color.a <= 0.01 or h < 1.0:
		return
	var side_v := Vector2(-up.y, up.x)
	for s in [-1.0, 1.0]:
		var base: Vector2 = center + side_v * gap * s
		var tri := PackedVector2Array([base - side_v * w * 0.5, base + up * h + side_v * w * 0.12 * s, base + side_v * w * 0.5])
		SoftDraw.poly(self, tri, color)
		var mid := (tri[0] + tri[1] + tri[2]) / 3.0
		SoftDraw.poly(self, PackedVector2Array([tri[0].lerp(mid, 0.5), tri[1].lerp(mid, 0.4), tri[2].lerp(mid, 0.5)]), Color(inner, inner.a * color.a))

## หน้าแมว ตายิ้ม ^ ^ ปาก ω แก้มชมพู
func _cat_face(c: Vector2, r: float, ink: Color) -> void:
	if ink.a <= 0.01 or r < 4.0:
		return
	var w := maxf(1.5, r * 0.09)
	for s in [-1.0, 1.0]:
		var e: Vector2 = c + Vector2(s * r * 0.36, -r * 0.1)
		SoftDraw.pline(self, PackedVector2Array([e + Vector2(-r * 0.13, r * 0.07), e + Vector2(0.0, -r * 0.07), e + Vector2(r * 0.13, r * 0.07)]), ink, w, true)
		draw_circle(c + Vector2(s * r * 0.58, r * 0.14), r * 0.11, Color(1.0, 0.55, 0.62, 0.55 * ink.a))
	var m := c + Vector2(0.0, r * 0.18)
	draw_arc(m + Vector2(-r * 0.09, 0.0), r * 0.09, 0.0, PI, 8, ink, w * 0.85, true)
	draw_arc(m + Vector2(r * 0.09, 0.0), r * 0.09, 0.0, PI, 8, ink, w * 0.85, true)

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
const GRAND_K := 1.00
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
	const R := 150.0
	const AT := Vector2(180.0, -90.0)
	const LIFE := 0.80
	const RAYS := true
	const SPARK := true
	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()
	func _color() -> Color:
		return Color(1.0, 0.15, 0.25)
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
