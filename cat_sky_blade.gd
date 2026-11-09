class_name CatSkyBlade
extends Node2D
## ดาบยักษ์ตกจากฟ้าปักลงพื้น วางที่พื้น y 0
## แบบดาบเวท FLAME KNIGHT 45.2 ปักแล้วแตกกระจายเป็นเศษ ทำดาเมจรอบจุด
## แบบดาบเลือด CRIMSON KNIGHT 50.2 ปักแล้วเกิดลำเลือดทรงกระบอกพุ่งขึ้น ทำดาเมจต่อเนื่อง

const FALL := 0.28
const START_Y := -1500.0
const LENGTH := 560.0
const WIDTH := 120.0

var blood := false
var hitter: Callable
var impact_dmg := 30.0
var shatter_dmg := 22.0
var pillar_time := 2.5
var pillar_half := 130.0
var _t := 0.0
var _landed := false
var _shards: Array = []        # [ตำแหน่ง ความเร็ว มุม หมุน ขนาด]
var _pillar_hit := 0.0
var _hit := {}

func _life() -> float:
	return FALL + (pillar_time + 0.4 if blood else 0.9)

func _process(delta: float) -> void:
	_grand_tick(delta)
	_t += delta
	if _t >= _life():
		queue_free()
		return
	if not _landed and _t >= FALL:
		_landed = true
		if hitter.is_valid():
			hitter.call(position.x, 150.0, impact_dmg, 1.0, null, {"kb": 1.0, "stun": 0.6})
		if not blood:
			for i in 16:
				var a := randf_range(PI * 0.05, PI * 0.95)
				_shards.append([Vector2(randf_range(-30.0, 30.0), -randf_range(60.0, LENGTH * 0.8)), Vector2(cos(a) * randf_range(300.0, 700.0), -sin(a) * randf_range(200.0, 600.0)), randf() * TAU, randf_range(-12.0, 12.0), randf_range(14.0, 34.0)])
			if hitter.is_valid():
				hitter.call(position.x, 280.0, shatter_dmg, 1.0, _hit, {"type": "launch", "vy": 6.0, "magic": true, "burn": "fire"})
	if blood and _landed and _t < FALL + pillar_time:
		_pillar_hit -= delta
		if _pillar_hit <= 0.0 and hitter.is_valid():
			_pillar_hit = 0.2
			hitter.call(position.x, pillar_half, 6.0, 1.0, null, {"kb": 0.0, "stun": 0.3})
	for s in _shards:
		s[1] = (s[1] as Vector2) + Vector2(0.0, 1200.0) * delta
		s[0] = (s[0] as Vector2) + (s[1] as Vector2) * delta
		s[2] += float(s[3]) * delta
	queue_redraw()

func _draw() -> void:
	var fall := clampf(_t / FALL, 0.0, 1.0)
	# ด้ามอยู่บน ปลายดาบปักลงดินนิดเดียว
	var base_y := lerpf(START_Y, -LENGTH * 0.93, fall * fall)
	var show_blade := blood or not _landed or _t < FALL + 0.12
	if show_blade:
		draw_set_transform(Vector2(0.0, base_y), PI)
		if blood:
			_blood_blade()
		else:
			MagicBlade.draw_sword(self, LENGTH, WIDTH, WIDTH * 0.9)
		draw_set_transform(Vector2.ZERO)
		# หูแมวสองข้างโคนดาบ (ด้านบนของดาบที่ปักหัวลง)
		var ear_c := Color(0.95, 0.25, 0.3) if blood else Color(1.0, 0.7, 0.35)
		_cat_ears(Vector2(0.0, base_y - 30.0), WIDTH * 0.5, WIDTH * 0.55, WIDTH * 0.6, ear_c)
	if not _landed:
		return
	var after := _t - FALL
	# จุดปักมีแสงวาบและฝุ่น
	var flash := clampf(1.0 - after / 0.25, 0.0, 1.0)
	draw_circle(Vector2(0.0, -20.0), 200.0 * (1.0 - flash * 0.5), Color(1.0, 0.6, 0.3, 0.35 * flash) if not blood else Color(0.9, 0.1, 0.12, 0.35 * flash))
	# รอยเท้าแมววงรอบจุดปัก
	var stamp := clampf(1.0 - after / 0.7, 0.0, 1.0)
	for i in 6:
		var ang := PI + PI * float(i) / 5.0
		_cat_paw(Vector2(cos(ang) * 190.0, -12.0 + sin(ang) * 26.0), 14.0, Color(1.0, 0.55, 0.3, 0.75 * stamp) if not blood else Color(0.85, 0.1, 0.15, 0.75 * stamp))
	if blood and after < pillar_time + 0.3:
		var k := clampf(after / 0.15, 0.0, 1.0) * clampf((pillar_time + 0.3 - after) / 0.3, 0.0, 1.0)
		var h := 900.0 * k
		var w := pillar_half * (0.9 + 0.08 * sin(_t * 30.0))
		SoftDraw.poly(self, PackedVector2Array([Vector2(-w, 0.0), Vector2(-w * 0.9, -h), Vector2(w * 0.9, -h), Vector2(w, 0.0)]), Color(0.55, 0.0, 0.06, 0.55 * k))
		SoftDraw.poly(self, PackedVector2Array([Vector2(-w * 0.55, 0.0), Vector2(-w * 0.45, -h), Vector2(w * 0.45, -h), Vector2(w * 0.55, 0.0)]), Color(0.9, 0.12, 0.15, 0.7 * k))
		SoftDraw.poly(self, PackedVector2Array([Vector2(-w * 0.18, 0.0), Vector2(-w * 0.12, -h), Vector2(w * 0.12, -h), Vector2(w * 0.18, 0.0)]), Color(1.0, 0.75, 0.75, 0.8 * k))
		for i in 8:
			var y := -fmod(_t * 700.0 + float(i) * 120.0, h)
			draw_line(Vector2(-w * 0.8, y), Vector2(w * 0.8, y - 20.0), Color(1.0, 0.5, 0.5, 0.35 * k), 4.0, true)
		# รอยเท้าแมวลอยขึ้นในลำเลือด
		for i in 5:
			var py := -fmod(_t * 420.0 + float(i) * 180.0, maxf(h, 1.0))
			_cat_paw(Vector2(sin(float(i) * 2.3) * w * 0.4, py), 14.0, Color(1.0, 0.7, 0.72, 0.7 * k), Color(0.9, 0.2, 0.3, 0.9))
		SoftDraw.poly(self, _oval(w * 1.3, 26.0), Color(0.4, 0.0, 0.04, 0.8 * k))
	for s in _shards:
		var c: Vector2 = s[0]
		var r: float = s[4]
		var a: float = s[2]
		var pts := PackedVector2Array([c + Vector2(cos(a), sin(a)) * r, c + Vector2(cos(a + 2.4), sin(a + 2.4)) * r * 0.5, c + Vector2(cos(a + 3.8), sin(a + 3.8)) * r * 0.7])
		# เศษบางชิ้นเป็นรอยเท้าแมว บางชิ้นเป็นก้างปลา
		var idx := _shards.find(s)
		if idx % 3 == 0:
			_cat_paw(c, r * 0.6, Color(1.0, 0.85, 0.6), Color(1.0, 0.55, 0.15), a)
		elif idx % 5 == 1:
			_fishbone(c, r * 1.6, Color(1.0, 0.75, 0.4), a)
		else:
			SoftDraw.poly(self, pts, Color(0.95, 0.93, 0.95))
			SoftDraw.pline(self, pts + PackedVector2Array([pts[0]]), Color(1.0, 0.55, 0.15), 2.5, true)

func _oval(rx: float, ry: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 24:
		var a := TAU * float(i) / 24.0
		pts.append(Vector2(cos(a) * rx, sin(a) * ry))
	return pts

## ดาบเลือดยักษ์ ใบแดงคล้ำ ขอบแดงสด แกนชมพูอ่อน
func _blood_blade() -> void:
	var h := WIDTH * 0.5
	var outline := PackedVector2Array([Vector2(-h, 0.0), Vector2(-h, -LENGTH + WIDTH), Vector2(0.0, -LENGTH), Vector2(h, -LENGTH + WIDTH), Vector2(h, 0.0)])
	var glow := PackedVector2Array()
	for p in outline:
		glow.append(Vector2(p.x * 1.3, p.y * 1.03))
	SoftDraw.poly(self, glow, Color(0.8, 0.0, 0.08, 0.3))
	SoftDraw.poly(self, outline, Color(0.45, 0.0, 0.05))
	SoftDraw.poly(self, PackedVector2Array([Vector2(-h * 0.3, 0.0), Vector2(-h * 0.3, -LENGTH + WIDTH * 1.2), Vector2(0.0, -LENGTH + WIDTH * 0.5), Vector2(h * 0.3, -LENGTH + WIDTH * 1.2), Vector2(h * 0.3, 0.0)]), Color(0.95, 0.25, 0.3))
	SoftDraw.pline(self, outline, Color(1.0, 0.3, 0.3), 4.0, true)
	SoftDraw.poly(self, PackedVector2Array([Vector2(-h * 1.8, 0.0), Vector2(h * 1.8, 0.0), Vector2(h * 1.6, 26.0), Vector2(-h * 1.6, 26.0)]), Color(0.25, 0.0, 0.03))
	draw_rect(Rect2(-h * 0.3, 26.0, h * 0.6, WIDTH * 1.1), Color(0.2, 0.05, 0.05))


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
const GRAND_K := 1.30
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
	const R := 170.0
	const AT := Vector2(0.0, -110.0)
	const LIFE := 1.20
	const RAYS := true
	const SPARK := true
	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()
	func _color() -> Color:
		return Color(1.0, 0.45, 0.25)
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
