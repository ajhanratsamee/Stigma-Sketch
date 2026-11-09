class_name AnimeBurst
extends Node2D
## แสงกระแทกแบบอนิเมะ ดาวขอบแข็ง วงแหวน และเส้นความเร็วพุ่งออก อยู่สั้นๆ

const U := CombatData.UNIT
const LIFE := 0.26
const SPIKES := 10
const SPEED_LINES := 14
const WHITE := Color(1.0, 0.98, 0.9)
const INK := Color(0.16, 0.15, 0.14)

var pos := Vector2.ZERO
var color := Color(0.98, 0.62, 0.14)
var size_k := 1.0
var _u := 0.0

func _ready() -> void:
	z_index = 4
	position = Vector2(pos.x, -pos.y) * U
	rotation = randf() * TAU

func _process(delta: float) -> void:
	_grand_tick(delta)
	_u += delta / LIFE
	if _u >= 1.0:
		queue_free()
		return
	queue_redraw()

## แสงกระแทกทรงกลมมน ขอบเป็นลอนนุ่มๆ ไม่มีแฉกแหลม
func _star(r_out: float, r_in: float, tone: Color) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var mid := (r_out + r_in) * 0.5
	var wave := (r_out - r_in) * 0.03
	for i in 48:
		var a := TAU * float(i) / 48.0
		pts.append(Vector2(cos(a), sin(a)) * (mid + wave * cos(a * float(SPIKES))))
	draw_colored_polygon(pts, tone)
	return pts

func _draw() -> void:
	var grow := 1.0 - pow(1.0 - _u, 3.0)
	var fade := 1.0 - _u * _u
	var r := 110.0 * size_k * grow
	if _u < 0.55:
		var edge := _star(r, r * 0.42, Color(color, fade))
		edge.append(edge[0])
		draw_polyline(edge, Color(INK, fade), 3.0, true)
		_star(r * 0.62, r * 0.26, Color(WHITE, fade))
		# ใจกลางเป็นรอยเท้าแมว ตั้งตรงเสมอแม้โหนดหมุน
		_cat_paw(Vector2.ZERO, r * 0.2, Color(color, fade), Color(1.0, 0.62, 0.74, fade), -rotation)
	draw_arc(Vector2.ZERO, r * 1.2, 0.0, TAU, 28, Color(color, fade), 7.0 * size_k * (1.0 - _u), true)
	for n in SPEED_LINES:
		var a := TAU * n / SPEED_LINES + float(n) * 0.37
		var d := Vector2(cos(a), sin(a))
		var from := r * (1.25 + 0.2 * absf(sin(float(n) * 2.1)))
		var to := from + 90.0 * size_k * (1.0 - _u) * (0.5 + 0.5 * absf(sin(float(n) * 3.7)))
		# จุดกลมกระจายออก แทนเส้นแหลม
		draw_circle(d * (from + to) * 0.5, 4.5 * size_k * (1.0 - _u) + 1.5, Color(INK if n % 3 == 0 else color, fade))


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
	draw_colored_polygon(PackedVector2Array([b + Vector2(0.0, -long * 0.14).rotated(spin), at + Vector2(long * 0.55, 0.0).rotated(spin), b + Vector2(0.0, long * 0.14).rotated(spin)]), color)
	draw_colored_polygon(PackedVector2Array([a, a + Vector2(-long * 0.16, -long * 0.16).rotated(spin), a + Vector2(-long * 0.16, long * 0.16).rotated(spin)]), color)


# ---------------------------------------------------------------- ความอลังการ (ภาพล้วน ไม่ยุ่งกับการโดน)
## โหนดขยายใหญ่ขึ้นพร้อมเด้งตอนเกิด มีแสงฟุ้งด้านหลัง วงช็อก ลำแสง และประกายรอยเท้าแมวด้านหน้า
const GRAND_K := 1.50
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
	const R := 120.0
	const AT := Vector2.ZERO
	const LIFE := 0.30
	const RAYS := true
	const SPARK := false
	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()
	func _color() -> Color:
		var v = get_parent().get("color")
		return v if v is Color else Color(1.0, 0.5, 0.4)
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
					# แสงพุ่งเป็นแคปซูลปลายมน ไม่ใช่แฉกแหลม
					var rc := Color(1.0, 0.98, 0.85, 0.55 * (1.0 - k))
					draw_line(at + u * r * 0.3, tip, rc, maxf(2.0, w.length() * 2.0), true)
					draw_circle(tip, maxf(1.0, w.length()), rc)
		# ประกายดาวและรอยเท้าแมววนลอยขึ้น
		if SPARK:
			for i in 8:
				var ph := fmod(_t * 0.9 + float(i) * 0.125, 1.0)
				var ang := float(i) * 0.785 + _t * 2.2
				var p := at + Vector2(cos(ang) * r * (0.7 + 0.5 * ph), sin(ang) * r * 0.45 - ph * r * 0.9)
				var a := sin(ph * PI) * 0.9 * fade
				var s := r * 0.07 + 3.0
				if i % 2 == 0:
					# ประกายกลมฟุ้ง ไม่มีดาวแฉก
					draw_circle(p, s * 0.9, Color(1.0, 0.97, 0.7, a * 0.35))
					draw_circle(p, s * 0.5, Color(1.0, 0.97, 0.7, a))
				else:
					draw_circle(p + Vector2(0.0, s * 0.25), s * 0.55, Color(c.lightened(0.3), a))
					for t in 3:
						draw_circle(p + Vector2((float(t) - 1.0) * s * 0.55, -s * 0.45 - (s * 0.12 if t == 1 else 0.0)), s * 0.24, Color(c.lightened(0.3), a))
