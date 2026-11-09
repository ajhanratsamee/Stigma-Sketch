class_name CatSwordWave
extends Node2D
## คลื่นดาบรูปจันทร์เสี้ยวแนวตั้งพุ่งไปข้างหน้า วางที่พื้น y 0
## SWORD KNIGHT 35.1 ใช้แบบไหลช้า ทำดาเมจต่อเนื่องเป็นจังหวะ มีพลังซ้อนหลายชั้น เงาตามหลัง ประกายปลิว
## ตั้ง hit_every เป็น 0 จะโดนมอนแต่ละตัวครั้งเดียว

const HIGH := 330.0
const THICK := 70.0
const HIT_HALF := 60.0

var dir := 1.0
var high := HIGH
var thick_k := 1.0                # ความหนาของจันทร์เสี้ยวคูณเพิ่ม
var dmg := 30.0
var speed := 1000.0
var life := 0.9
var hit_every := 0.0
var edge := Color(1.0, 0.95, 0.92)
var body := Color(0.92, 0.12, 0.1, 0.7)
var glow := Color(0.7, 0.02, 0.04, 0.3)
var extra := {"kb": 2.5, "stun": 0.6}
var hitter: Callable
var _t := 0.0
var _hit := {}
var _hit_t := 0.0
var _sparks: Array = []   # [ตำแหน่งในพิกัดโหนด ความเร็ว อายุ]

func _process(delta: float) -> void:
	_grand_tick(delta)
	_t += delta
	if _t >= life:
		queue_free()
		return
	position.x += dir * speed * delta
	if hitter.is_valid():
		if hit_every <= 0.0:
			hitter.call(position.x, HIT_HALF, dmg, dir, _hit, extra)
		else:
			_hit_t -= delta
			if _hit_t <= 0.0:
				_hit_t = hit_every
				hitter.call(position.x, HIT_HALF + 20.0, dmg, dir, null, extra)
	for i in 2:
		var k := randf()
		_sparks.append([Vector2(dir * THICK * thick_k * sin(k * PI) * high / HIGH, -high * k), Vector2(-dir * randf_range(80.0, 200.0) - dir * speed * 0.3, randf_range(-60.0, 60.0)), 0.0])
	for s in _sparks.duplicate():
		s[2] += delta
		s[0] = (s[0] as Vector2) + ((s[1] as Vector2) - Vector2(dir * speed, 0.0)) * delta
		if s[2] > 0.4:
			_sparks.erase(s)
	queue_redraw()

## จันทร์เสี้ยวโค้งไปทางที่พุ่ง ขอบหน้าบาง ขอบหลังเว้า เนื้อพลังสั่นไหวเล็กน้อย
func _crescent(scale_k: float, inner: float, back: float, seed_f: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var steps := 22
	var thick := THICK * high / HIGH * thick_k
	for i in steps + 1:
		var k := float(i) / float(steps)
		var wob := 1.0 + 0.06 * sin(k * 20.0 + _t * 35.0 + seed_f)
		pts.append(Vector2(back + dir * thick * scale_k * sin(k * PI) * wob, -high * scale_k * k))
	for i in range(steps, -1, -1):
		var k := float(i) / float(steps)
		pts.append(Vector2(back + dir * thick * scale_k * sin(k * PI) * inner, -high * scale_k * k))
	return pts

func _draw() -> void:
	var fade := clampf((life - _t) / 0.35, 0.0, 1.0)
	var grow := clampf(_t / 0.15, 0.3, 1.0)
	var thick := THICK * high / HIGH * thick_k
	# เงาตามหลังจางลงเรื่อยๆ
	for n in range(3, 0, -1):
		var back := -dir * float(n) * 26.0
		SoftDraw.poly(self, _crescent(grow * (1.0 - float(n) * 0.04), 0.3, back, float(n)), Color(glow, glow.a * fade * (1.0 - float(n) * 0.25)))
	SoftDraw.poly(self, _crescent(grow * 1.12, 0.25, 0.0, 0.5), Color(glow, glow.a * 1.4 * fade))
	SoftDraw.poly(self, _crescent(grow, 0.35, 0.0, 1.7), Color(body, body.a * fade))
	SoftDraw.poly(self, _crescent(grow * 0.97, 0.7, dir * 4.0, 2.9), Color(edge.lerp(body, 0.4), 0.8 * fade))
	var line := PackedVector2Array()
	for i in 23:
		var k := float(i) / 22.0
		line.append(Vector2(dir * thick * grow * sin(k * PI), -high * grow * k))
	SoftDraw.pline(self, line, Color(edge, fade), 4.0, true)
	# ยอดจันทร์เสี้ยวมีหูแมวคู่ กลางคลื่นมีหน้าเหมียว
	var tip := Vector2(dir * thick * grow * 0.25, -high * grow)
	_cat_ears(tip + Vector2(0.0, 18.0), 20.0 * thick_k, 26.0 * thick_k, 30.0 * thick_k, Color(body, body.a * fade + 0.2 * fade), Color(edge, fade))
	_cat_face(Vector2(dir * thick * grow * 0.55, -high * grow * 0.5), thick * 0.55, Color(edge, 0.9 * fade))
	for s in _sparks:
		var k: float = 1.0 - float(s[2]) / 0.4
		if _sparks.find(s) % 5 == 0:
			_cat_paw(s[0], 6.0 * k + 2.0, Color(edge, k * fade), Color(body, k * fade))
		else:
			draw_line(s[0], (s[0] as Vector2) + Vector2(-dir * 14.0 * k, 0.0), Color(edge, k * fade), 2.5, true)


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
const GRAND_K := 1.35
var _g_t := 0.0
var _g_base := Vector2.ZERO

func _grand_tick(delta: float) -> void:
	if _g_base == Vector2.ZERO:
		_g_base = scale
		# ไม่ใส่แสงฟุ้ง วงช็อก ลำแสงตกแต่งซ้อนคลื่นดาบ (ผู้เล่นบอกว่าเวอร์เกิน)
		if false:
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
	const R := 130.0
	const AT := Vector2(0.0, -165.0)
	const LIFE := 1.00
	const RAYS := true
	const SPARK := true
	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()
	func _color() -> Color:
		return Color(1.0, 0.3, 0.25)
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
